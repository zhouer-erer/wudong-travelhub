import { Provide, Scope, ScopeEnum, Init, Destroy } from '@midwayjs/decorator';
import Redis from 'ioredis';

/**
 * Redis 服务
 * 提供 Redis 连接和基础操作，用于 token 黑名单等功能
 */
@Provide()
@Scope(ScopeEnum.Singleton)
export class RedisService {
  private client: Redis;

  @Init()
  async init() {
    this.client = new Redis({
      host: process.env.REDIS_HOST || '127.0.0.1',
      port: parseInt(process.env.REDIS_PORT || '6379', 10),
      password: process.env.REDIS_PASSWORD || undefined,
      db: parseInt(process.env.REDIS_DB || '0', 10),
      keyPrefix: 'wudong:',
    });

    this.client.on('error', (err) => {
      console.error('[Redis] 连接错误:', err.message);
    });

    this.client.on('connect', () => {
      console.log('[Redis] 已连接');
    });
  }

  @Destroy()
  async destroy() {
    if (this.client) {
      await this.client.quit();
    }
  }

  /**
   * 将 token 加入黑名单
   * @param token JWT token
   * @param ttlSeconds 过期时间（秒），默认 24 小时
   */
  async blacklistToken(token: string, ttlSeconds = 86400) {
    await this.client.set(`token:blacklist:${token}`, '1', 'EX', ttlSeconds);
  }

  /**
   * 检查 token 是否在黑名单中
   * @param token JWT token
   * @returns 是否已被拉黑
   */
  async isTokenBlacklisted(token: string): Promise<boolean> {
    const result = await this.client.get(`token:blacklist:${token}`);
    return result === '1';
  }

  /**
   * 通用 set 方法
   */
  async set(key: string, value: string, ttlSeconds?: number) {
    if (ttlSeconds) {
      await this.client.set(key, value, 'EX', ttlSeconds);
    } else {
      await this.client.set(key, value);
    }
  }

  /**
   * 通用 get 方法
   */
  async get(key: string): Promise<string | null> {
    return await this.client.get(key);
  }

  /**
   * 通用 delete 方法
   */
  async del(key: string) {
    await this.client.del(key);
  }
}
