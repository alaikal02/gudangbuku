import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate, Trend } from 'k6/metrics';

// Custom Metrics Tracking
const searchLatency = new Trend('book_search_duration');
const errorRate = new Rate('book_search_error_rate');

export const options = {
  scenarios: {
    high_throughput_search: {
      executor: 'ramping-arrival-rate',
      startRate: 500,
      timeUnit: '1s',
      preAllocatedVUs: 1000,
      maxVUs: 5000,
      stages: [
        { duration: '1m', target: 2000 },   // 1. Ramp-up ke 2,000 RPS
        { duration: '3m', target: 10000 },  // 2. Peak Load ke 10,000 RPS
        { duration: '5m', target: 10000 },  // 3. Sustained Load di 10,000 RPS
        { duration: '1m', target: 0 },      // 4. Ramp-down ke 0
      ],
    },
  },
  thresholds: {
    // 95% request pencarian harus di bawah 200ms & error rate < 0.1%
    'book_search_duration': ['p(95)<200', 'p(99)<400'],
    'book_search_error_rate': ['rate<0.001'],
  },
};

const BASE_URL = __ENV.TARGET_URL || 'http://localhost:3000/api/v1/books/search';

// Datasets acak untuk mensimulasikan beragam variasi query dari pengguna
const SAMPLE_QUERIES = [
  'Algorithms',
  'Clean Architecture',
  '9786020324121',
  'Pemrograman Go',
  'Fisika Kuantum',
  'Gudang Logistik',
  'Database PostgreSQL',
  'Deep Learning',
  'Sistem Terdistribusi',
  'Robert C. Martin',
];

export default function () {
  const randomQuery = SAMPLE_QUERIES[Math.floor(Math.random() * SAMPLE_QUERIES.length)];
  const randomLimit = [10, 20, 50][Math.floor(Math.random() * 3)];
  const url = `${BASE_URL}?query=${encodeURIComponent(randomQuery)}&limit=${randomLimit}`;

  const params = {
    headers: {
      'Accept': 'application/json',
      'User-Agent': 'k6-performance-testing-agent',
    },
    tags: { name: 'BookSearchEndpoint' },
  };

  const res = http.get(url, params);

  // Catat durasi latensi
  searchLatency.add(res.timings.duration);

  // Assert respons
  const success = check(res, {
    'status is 200': (r) => r.status === 200,
    'cache header present': (r) => r.headers['X-Cache-Status'] === 'HIT' || r.headers['X-Cache-Status'] === 'MISS',
    'valid json structure': (r) => {
      try {
        const body = JSON.parse(r.body);
        return body.success === true && Array.isArray(body.data);
      } catch {
        return false;
      }
    },
  });

  errorRate.add(!success);
  sleep(0.05); // Pacing per VU
}
