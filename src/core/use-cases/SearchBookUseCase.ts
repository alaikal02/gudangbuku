import { ICacheService } from '../ports/ICacheService.js';
import { ISearchEngine, BookSearchParams } from '../ports/ISearchEngine.js';

export interface SearchBookInputDTO {
  query?: string;
  categoryId?: string;
  zoneId?: string;
  cursor?: string;
  limit?: number;
}

export interface SearchBookOutputDTO {
  data: any[];
  pagination: {
    limit: number;
    has_next_page: boolean;
    next_cursor: string | null;
  };
  cache_status: 'HIT' | 'MISS';
}

export class SearchBookUseCase {
  constructor(
    private readonly searchEngine: ISearchEngine,
    private readonly cacheService: ICacheService
  ) {}

  public async execute(input: SearchBookInputDTO): Promise<SearchBookOutputDTO> {
    const limit = Math.min(Math.max(input.limit || 20, 1), 100);
    const sanitizedQuery = (input.query || '').trim();

    const params: BookSearchParams = {
      query: sanitizedQuery,
      categoryId: input.categoryId,
      zoneId: input.zoneId,
      cursor: input.cursor,
      limit,
    };

    // 1. Generate L2 Cache Key
    const cacheKeyRaw = JSON.stringify({
      q: params.query,
      cat: params.categoryId || '',
      z: params.zoneId || '',
      c: params.cursor || '',
      l: params.limit,
    });
    const cacheKey = `wms:search:${Buffer.from(cacheKeyRaw).toString('base64')}`;

    // 2. Lookup in L2 Redis Cache
    try {
      const cached = await this.cacheService.get<SearchBookOutputDTO>(cacheKey);
      if (cached) {
        return {
          ...cached,
          cache_status: 'HIT',
        };
      }
    } catch (cacheErr) {
      console.warn('L2 Redis Cache read failed, falling back to Search Engine:', cacheErr);
    }

    // 3. Search Engine Execution (Elasticsearch)
    const searchResult = await this.searchEngine.searchBooks(params);

    const output: SearchBookOutputDTO = {
      data: searchResult.items,
      pagination: {
        limit: params.limit,
        has_next_page: searchResult.hasNextPage,
        next_cursor: searchResult.nextCursor,
      },
      cache_status: 'MISS',
    };

    // 4. Write to L2 Redis Cache (TTL 5 Minutes = 300 Seconds)
    try {
      await this.cacheService.set(cacheKey, output, 300);
    } catch (cacheErr) {
      console.warn('L2 Redis Cache write failed:', cacheErr);
    }

    return output;
  }
}
