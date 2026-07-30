import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { createBookRouter } from './infrastructure/http/routes/bookRoutes.js';
import { ElasticsearchService } from './infrastructure/search/ElasticsearchService.js';
import { RedisCacheService } from './infrastructure/cache/RedisCacheService.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Initialize Infrastructure Adapters
const redisCacheService = new RedisCacheService();
const elasticsearchService = new ElasticsearchService();

// Register Healthcheck Endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP', timestamp: new Date().toISOString() });
});

// Register Domain API Routes
const bookRouter = createBookRouter(elasticsearchService, redisCacheService);
app.use('/api/v1/books', bookRouter);

app.listen(PORT, () => {
  console.log(`🚀 Server WMS Buku Backend running on port ${PORT}`);
  console.log(`🔍 Endpoint Search: GET http://localhost:${PORT}/api/v1/books/search`);
});
