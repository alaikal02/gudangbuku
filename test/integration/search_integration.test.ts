import { GenericContainer, StartedTestContainer } from 'testcontainers';
import { Client as ESClient } from '@elastic/elasticsearch';
import { Pool } from 'pg';

describe('WMS Search & Inventory Integration Tests (Testcontainers)', () => {
  let postgresContainer: StartedTestContainer;
  let elasticsearchContainer: StartedTestContainer;
  let pgPool: Pool;
  let esClient: ESClient;

  // Timeout dialokasikan 120s untuk memutar kontainer Docker di CI/CD
  jest.setTimeout(120000);

  beforeAll(async () => {
    // 1. Putar Kontainer PostgreSQL Temporer
    postgresContainer = await new GenericContainer('postgres:16-alpine')
      .withEnvironment({
        POSTGRES_USER: 'test_user',
        POSTGRES_PASSWORD: 'test_password',
        POSTGRES_DB: 'wms_test_db',
      })
      .withExposedPorts(5432)
      .start();

    const pgPort = postgresContainer.getMappedPort(5432);
    const pgHost = postgresContainer.getHost();

    pgPool = new Pool({
      host: pgHost,
      port: pgPort,
      user: 'test_user',
      password: 'test_password',
      database: 'wms_test_db',
    });

    // Skema DDL Sederhana untuk Pengujian
    await pgPool.query(`
      CREATE TABLE books (
        id UUID PRIMARY KEY,
        isbn VARCHAR(20) UNIQUE NOT NULL,
        title VARCHAR(255) NOT NULL,
        author VARCHAR(255) NOT NULL,
        publisher VARCHAR(255) NOT NULL
      );
      CREATE TABLE book_inventories (
        id UUID PRIMARY KEY,
        book_id UUID REFERENCES books(id),
        quantity INT NOT NULL DEFAULT 0
      );
    `);

    // 2. Putar Kontainer Elasticsearch Temporer
    elasticsearchContainer = await new GenericContainer('docker.elastic.co/elasticsearch/elasticsearch:8.13.4')
      .withEnvironment({
        'discovery.type': 'single-node',
        'ES_JAVA_OPTS': '-Xms512m -Xmx512m',
        'xpack.security.enabled': 'false',
      })
      .withExposedPorts(9200)
      .start();

    const esPort = elasticsearchContainer.getMappedPort(9200);
    const esHost = elasticsearchContainer.getHost();

    esClient = new ESClient({ node: `http://${esHost}:${esPort}` });

    // Buat Indeks Elasticsearch
    await esClient.indices.create({
      index: 'wms_books_catalog',
      body: {
        mappings: {
          properties: {
            title: { type: 'text' },
            isbn: { type: 'keyword' },
            author: { type: 'text' },
          },
        },
      },
    });
  });

  afterAll(async () => {
    if (pgPool) await pgPool.end();
    if (postgresContainer) await postgresContainer.stop();
    if (elasticsearchContainer) await elasticsearchContainer.stop();
  });

  test('Harus berhasil memasukkan buku ke Postgres dan menyinkronkan ke Elasticsearch', async () => {
    const bookId = 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11';
    const isbn = '9786020324121';
    const title = 'Clean Architecture Testing';

    // Insert ke PostgreSQL
    await pgPool.query(
      'INSERT INTO books (id, isbn, title, author, publisher) VALUES ($1, $2, $3, $4, $5)',
      [bookId, isbn, title, 'Robert C. Martin', 'Gramedia']
    );

    const pgResult = await pgPool.query('SELECT * FROM books WHERE id = $1', [bookId]);
    expect(pgResult.rows.length).toBe(1);
    expect(pgResult.rows[0].title).toBe(title);

    // Index ke Elasticsearch
    await esClient.index({
      index: 'wms_books_catalog',
      id: bookId,
      body: { title, isbn, author: 'Robert C. Martin' },
      refresh: true,
    });

    // Query ke Elasticsearch
    const esResult = await esClient.search({
      index: 'wms_books_catalog',
      query: { match: { isbn } },
    });

    expect(esResult.hits.hits.length).toBe(1);
    expect(esResult.hits.hits[0]._source).toHaveProperty('title', title);
  });
});
