import { Request, Response } from 'express';
import { SearchBookUseCase } from '../../../core/use-cases/SearchBookUseCase.js';

export class BookSearchController {
  constructor(private readonly searchBookUseCase: SearchBookUseCase) {}

  public handleSearch = async (req: Request, res: Response): Promise<void> => {
    try {
      const { query, category_id, zone_id, cursor, limit } = req.query;

      const input = {
        query: query ? String(query) : undefined,
        categoryId: category_id ? String(category_id) : undefined,
        zoneId: zone_id ? String(zone_id) : undefined,
        cursor: cursor ? String(cursor) : undefined,
        limit: limit ? parseInt(String(limit), 10) : undefined,
      };

      const result = await this.searchBookUseCase.execute(input);

      res.setHeader('X-Cache-Status', result.cache_status);
      res.setHeader('Content-Type', 'application/json');
      res.status(200).json({
        success: true,
        data: result.data,
        pagination: result.pagination,
      });
    } catch (error: any) {
      console.error('Error in BookSearchController:', error);
      if (error.message && error.message.includes('Invalid cursor')) {
        res.status(400).json({
          success: false,
          error: {
            code: 'INVALID_CURSOR',
            message: 'Tokens pagination cursor tidak valid.',
          },
        });
        return;
      }

      res.status(500).json({
        success: false,
        error: {
          code: 'INTERNAL_SERVER_ERROR',
          message: 'Terjadi kesalahan internal pada server.',
        },
      });
    }
  };
}
