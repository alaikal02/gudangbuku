import { Router } from 'express';
import { BookSearchController } from '../controllers/BookSearchController.js';
import { SearchBookUseCase } from '../../../core/use-cases/SearchBookUseCase.js';
import { ElasticsearchService } from '../../search/ElasticsearchService.js';
import { RedisCacheService } from '../../cache/RedisCacheService.js';

export function createBookRouter(
  searchService: ElasticsearchService,
  cacheService: RedisCacheService
): Router {
  const router = Router();
  const searchBookUseCase = new SearchBookUseCase(searchService, cacheService);
  const bookSearchController = new BookSearchController(searchBookUseCase);

  router.get('/search', bookSearchController.handleSearch);

  return router;
}
