import { Client } from '@elastic/elasticsearch';
import { ISearchEngine, BookSearchParams, SearchResult } from '../../core/ports/ISearchEngine.js';

export class ElasticsearchService implements ISearchEngine {
  private client: Client;
  private readonly indexName: string;

  constructor(nodeUrl: string = process.env.ELASTICSEARCH_URL || 'http://localhost:9200', indexName = 'wms_books_catalog') {
    this.client = new Client({ node: nodeUrl });
    this.indexName = indexName;
  }

  public async searchBooks(params: BookSearchParams): Promise<SearchResult<any>> {
    let searchAfter: any[] | undefined = undefined;
    if (params.cursor) {
      try {
        searchAfter = JSON.parse(Buffer.from(params.cursor, 'base64').toString('utf-8'));
      } catch {
        throw new Error('Invalid cursor token');
      }
    }

    const mustConditions: any[] = [];
    if (params.query) {
      mustConditions.push({
        multi_match: {
          query: params.query,
          fields: ['title^3', 'isbn^5', 'author^2', 'publisher'],
          fuzziness: 'AUTO',
        },
      });
    } else {
      mustConditions.push({ match_all: {} });
    }

    const filterConditions: any[] = [];
    if (params.categoryId) {
      filterConditions.push({ term: { category_id: params.categoryId } });
    }
    if (params.zoneId) {
      filterConditions.push({ term: { 'inventory.zone_id': params.zoneId } });
    }

    const response = await this.client.search({
      index: this.indexName,
      size: params.limit + 1, // Fetch N+1 to check next page availability
      body: {
        query: {
          bool: {
            must: mustConditions,
            filter: filterConditions,
          },
        },
        sort: [
          { _score: { order: 'desc' } },
          { id: { order: 'asc' } },
        ],
        ...(searchAfter ? { search_after: searchAfter } : {}),
      },
    });

    const hits = response.hits.hits;
    const hasNextPage = hits.length > params.limit;
    const itemsToReturn = hasNextPage ? hits.slice(0, params.limit) : hits;

    let nextCursor: string | null = null;
    if (hasNextPage && itemsToReturn.length > 0) {
      const lastItem = itemsToReturn[itemsToReturn.length - 1];
      if (lastItem.sort) {
        nextCursor = Buffer.from(JSON.stringify(lastItem.sort)).toString('base64');
      }
    }

    return {
      items: itemsToReturn.map((hit: any) => ({
        id: hit._id,
        ...hit._source,
      })),
      hasNextPage,
      nextCursor,
      totalHits: typeof response.hits.total === 'number' ? response.hits.total : response.hits.total?.value,
    };
  }
}
