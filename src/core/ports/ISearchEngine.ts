export interface BookSearchParams {
  query?: string;
  categoryId?: string;
  zoneId?: string;
  cursor?: string; // Base64 encoded sort array
  limit: number;
}

export interface SearchResult<T> {
  items: T[];
  hasNextPage: boolean;
  nextCursor: string | null;
  totalHits?: number;
}

export interface ISearchEngine {
  searchBooks(params: BookSearchParams): Promise<SearchResult<any>>;
}
