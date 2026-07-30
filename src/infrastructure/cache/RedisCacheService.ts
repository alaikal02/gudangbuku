import { Redis } from 'ioredis';
import { ICacheService } from '../../core/ports/ICacheService.js';

export class RedisCacheService implements ICacheService {
  private client: Redis;

  constructor(redisUrl: string = process.env.REDIS_URL || 'redis://localhost:6379') {
    this.client = new Redis(redisUrl, {
      maxRetriesPerRequest: 3,
      enableReadyCheck: true,
      lazyConnect: false,
    });

    this.client.on('error', (err) => {
      console.error('Redis Connection Error:', err);
    });
  }

  public async get<T>(key: string): Promise<T | null> {
    const data = await this.client.get(key);
    if (!data) return null;
    return JSON.parse(data) as T;
  }

  public async set(key: string, value: any, ttlSeconds: number): Promise<void> {
    await this.client.setex(key, ttlSeconds, JSON.stringify(value));
  }

  public async del(key: string): Promise<void> {
    await this.client.del(key);
  }

  public getClient(): Redis {
    return this.client;
  }
}
