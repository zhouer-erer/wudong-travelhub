import { Controller, Post, Get, Put, Inject, Body, Param } from '@midwayjs/decorator';
import { ApiOperation, ApiBody, ApiTags, ApiResponse, ApiParam, ApiBearerAuth } from '@midwayjs/swagger';
import { Context } from '@midwayjs/koa';
import { SystemConfigService } from '../service/system-config.service';
import { RedisService } from '../service/redis.service';

/**
 * 系统配置控制器
 * 处理系统配置相关的 API 请求，包括配置的查询、创建和更新
 */
@ApiTags('SystemConfig')
@ApiBearerAuth()
@Controller('/api/system-configs')
export class SystemConfigController {
  @Inject()
  ctx: Context;

  @Inject()
  systemConfigService: SystemConfigService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取所有系统配置列表
   * GET /api/system-configs/list
   * @returns 全部系统配置列表
   */
  @Get('/list')
  @ApiOperation({ summary: '获取所有系统配置列表' })
  @ApiResponse({
    status: 200,
    description: '查询成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: [
          { id: 1, key: 'site_name', value: '乌东文旅平台', description: '站点名称', created_at: '2026-01-01T00:00:00.000Z', updated_at: '2026-01-01T00:00:00.000Z' },
          { id: 2, key: 'site_logo', value: 'https://example.com/logo.png', description: '站点Logo', created_at: '2026-01-01T00:00:00.000Z', updated_at: '2026-01-01T00:00:00.000Z' },
          { id: 3, key: 'contact_phone', value: '400-888-8888', description: '客服电话', created_at: '2026-01-01T00:00:00.000Z', updated_at: '2026-01-01T00:00:00.000Z' },
        ],
      },
    },
  })
  async list() {
    const startTime = Date.now();
    const cacheKey = 'system-config:list';
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const result = await this.systemConfigService.findAll();
    const response = { code: 200, message: 'success', data: result };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 600); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 根据 key 获取配置详情
   * GET /api/system-configs/detail/:key
   * @param key - 配置键名
   * @returns 配置详细信息
   */
  @Get('/detail/:key')
  @ApiOperation({ summary: '根据key获取配置详情' })
  @ApiParam({ name: 'key', description: '配置键名', example: 'site_name' })
  @ApiResponse({
    status: 200,
    description: '查询成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 1, key: 'site_name', value: '乌东文旅平台', description: '站点名称', created_at: '2026-01-01T00:00:00.000Z', updated_at: '2026-01-01T00:00:00.000Z' },
      },
    },
  })
  async detail(@Param('key') key: string) {
    const startTime = Date.now();
    const cacheKey = `system-config:detail:${key}`;
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const item = await this.systemConfigService.findByKey(key);
    if (!item) return { code: 404, message: '配置不存在', data: null };
    const response = { code: 200, message: 'success', data: item };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 600); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 根据 key 更新配置值
   * PUT /api/system-configs/update/:key
   * @param key - 配置键名
   * @param body - 包含 value（配置值）
   * @returns 更新后的配置信息
   */
  @Put('/update/:key')
  @ApiOperation({ summary: '根据key更新配置值' })
  @ApiParam({ name: 'key', description: '配置键名', example: 'site_name' })
  @ApiBody({
    schema: {
      properties: {
        value: { type: 'string', description: '配置值', example: '乌东文旅平台' },
      },
      example: {
        value: '乌东文旅平台',
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: '更新成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 1, key: 'site_name', value: '乌东文旅平台', description: '站点名称', created_at: '2026-01-01T00:00:00.000Z', updated_at: '2026-06-21T00:00:00.000Z' },
      },
    },
  })
  async update(@Param('key') key: string, @Body() body: { value: string }) {
    const item = await this.systemConfigService.updateByKey(key, body.value);
    if (!item) return { code: 404, message: '配置不存在', data: null };
    await this.clearCache(key);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建系统配置
   * POST /api/system-configs/create
   * @param body - 配置信息
   * @returns 创建后的配置信息
   */
  @Post('/create')
  @ApiOperation({ summary: '创建系统配置' })
  @ApiBody({
    schema: {
      properties: {
        key: { type: 'string', description: '配置键名', example: 'site_name' },
        value: { type: 'string', description: '配置值', example: '乌东文旅平台' },
        description: { type: 'string', description: '配置说明', example: '站点名称' },
      },
      example: {
        key: 'site_name',
        value: '乌东文旅平台',
        description: '站点名称',
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: '创建成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 5, key: 'site_name', value: '乌东文旅平台', description: '站点名称', created_at: '2026-06-21T00:00:00.000Z', updated_at: '2026-06-21T00:00:00.000Z' },
      },
    },
  })
  async create(@Body() body: any) {
    const item = await this.systemConfigService.create(body);
    await this.clearCache(body.key);
    return { code: 200, message: 'success', data: item };
  }

  /** 清除系统配置缓存 */
  private async clearCache(key?: string) {
    try {
      await this.redisService.del('system-config:list');
      if (key) await this.redisService.del(`system-config:detail:${key}`);
    } catch (e) { /* ignore */ }
  }
}
