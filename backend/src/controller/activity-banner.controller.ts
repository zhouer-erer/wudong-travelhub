import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { ApiOperation, ApiBody, ApiQuery, ApiParam, ApiTags, ApiResponse, ApiBearerAuth } from '@midwayjs/swagger';
import { Context } from '@midwayjs/koa';
import { ActivityBannerService } from '../service/activity-banner.service';
import { RedisService } from '../service/redis.service';

/**
 * 活动横幅控制器
 * 处理活动横幅相关的 API 请求，包括活动横幅的增删改查操作
 */
@ApiTags('ActivityBanner')
@ApiBearerAuth()
@Controller('/api/activity-banners')
export class ActivityBannerController {
  @Inject()
  ctx: Context;

  @Inject()
  activityBannerService: ActivityBannerService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取活动横幅列表（分页）
   * GET /api/activity-banners/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @param keyword - 搜索关键词（可选）
   * @returns 分页活动横幅列表
   */
  @Get('/list')
  @ApiOperation({ summary: '获取活动横幅列表（分页）' })
  @ApiQuery({ name: 'page', description: '页码', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', description: '每页数量', required: false, example: 20 })
  @ApiQuery({ name: 'keyword', description: '搜索关键词', required: false, example: '端午' })
  @ApiResponse({
    status: 200,
    description: '成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: {
          list: [
            {
              id: 1,
              title: '端午龙舟赛',
              image_url: 'https://example.com/banner1.jpg',
              link_url: 'https://example.com/activity/1',
              sort_order: 1,
              status: 1,
              start_time: '2026-06-01T00:00:00.000Z',
              end_time: '2026-06-30T23:59:59.000Z',
              created_at: '2026-05-20T10:00:00.000Z',
            },
          ],
          total: 1,
        },
      },
    },
  })
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20, @Query('keyword') keyword?: string) {
    const startTime = Date.now();
    const cacheKey = `list:activity-banner:${page}:${pageSize}:${keyword || ''}`;
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const result = await this.activityBannerService.findAll(Number(page), Number(pageSize), keyword);
    const response = { code: 200, message: 'success', data: result };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 300); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 获取活动横幅详情
   * GET /api/activity-banners/detail/:id
   * @param id - 活动横幅 ID
   * @returns 活动横幅详细信息
   */
  @Get('/detail/:id')
  @ApiOperation({ summary: '获取活动横幅详情' })
  @ApiParam({ name: 'id', description: '活动横幅ID', example: 1 })
  @ApiResponse({
    status: 200,
    description: '成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: {
          id: 1,
          title: '端午龙舟赛',
          image_url: 'https://example.com/banner1.jpg',
          link_url: 'https://example.com/activity/1',
          sort_order: 1,
          status: 1,
          start_time: '2026-06-01T00:00:00.000Z',
          end_time: '2026-06-30T23:59:59.000Z',
          created_at: '2026-05-20T10:00:00.000Z',
        },
      },
    },
  })
  async detail(@Param('id') id: number) {
    const item = await this.activityBannerService.findById(Number(id));
    if (!item) return { code: 404, message: '活动横幅不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建活动横幅
   * POST /api/activity-banners/create
   * @param body - 活动横幅信息
   * @returns 创建后的活动横幅信息
   */
  @Post('/create')
  @ApiOperation({ summary: '创建活动横幅' })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '活动横幅标题', example: '端午龙舟赛' },
        image_url: { type: 'string', description: '横幅图片URL', example: 'https://example.com/banner1.jpg' },
        link_url: { type: 'string', description: '跳转链接', example: 'https://example.com/activity/1' },
        sort_order: { type: 'number', description: '排序值，值越小越靠前', example: 1 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
        start_time: { type: 'string', description: '开始时间', example: '2026-06-01T00:00:00.000Z' },
        end_time: { type: 'string', description: '结束时间', example: '2026-06-30T23:59:59.000Z' },
      },
      example: {
        title: '端午龙舟赛',
        image_url: 'https://example.com/banner1.jpg',
        link_url: 'https://example.com/activity/1',
        sort_order: 1,
        status: 1,
        start_time: '2026-06-01T00:00:00.000Z',
        end_time: '2026-06-30T23:59:59.000Z',
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
        data: {
          id: 1,
          title: '端午龙舟赛',
          image_url: 'https://example.com/banner1.jpg',
          link_url: 'https://example.com/activity/1',
          sort_order: 1,
          status: 1,
          start_time: '2026-06-01T00:00:00.000Z',
          end_time: '2026-06-30T23:59:59.000Z',
          created_at: '2026-05-20T10:00:00.000Z',
        },
      },
    },
  })
  async create(@Body() body: any) {
    const item = await this.activityBannerService.create(body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新活动横幅信息
   * PUT /api/activity-banners/update/:id
   * @param id - 活动横幅 ID
   * @param body - 更新的活动横幅信息
   * @returns 更新后的活动横幅信息
   */
  @Put('/update/:id')
  @ApiOperation({ summary: '更新活动横幅' })
  @ApiParam({ name: 'id', description: '活动横幅ID', example: 1 })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '活动横幅标题', example: '端午龙舟赛（更新）' },
        image_url: { type: 'string', description: '横幅图片URL', example: 'https://example.com/banner1_new.jpg' },
        link_url: { type: 'string', description: '跳转链接', example: 'https://example.com/activity/1' },
        sort_order: { type: 'number', description: '排序值，值越小越靠前', example: 2 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
        start_time: { type: 'string', description: '开始时间', example: '2026-06-01T00:00:00.000Z' },
        end_time: { type: 'string', description: '结束时间', example: '2026-07-15T23:59:59.000Z' },
      },
      example: {
        title: '端午龙舟赛（更新）',
        image_url: 'https://example.com/banner1_new.jpg',
        link_url: 'https://example.com/activity/1',
        sort_order: 2,
        status: 1,
        start_time: '2026-06-01T00:00:00.000Z',
        end_time: '2026-07-15T23:59:59.000Z',
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
        data: {
          id: 1,
          title: '端午龙舟赛（更新）',
          image_url: 'https://example.com/banner1_new.jpg',
          link_url: 'https://example.com/activity/1',
          sort_order: 2,
          status: 1,
          start_time: '2026-06-01T00:00:00.000Z',
          end_time: '2026-07-15T23:59:59.000Z',
          created_at: '2026-05-20T10:00:00.000Z',
        },
      },
    },
  })
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    const item = await this.activityBannerService.update(Number(id), body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除活动横幅
   * DELETE /api/activity-banners/delete/:id
   * @param id - 活动横幅 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  @ApiOperation({ summary: '删除活动横幅' })
  @ApiParam({ name: 'id', description: '活动横幅ID', example: 1 })
  @ApiResponse({
    status: 200,
    description: '删除成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: null,
      },
    },
  })
  async remove(@Param('id') id: number) {
    await this.activityBannerService.delete(Number(id));
    await this.clearListCache();
    return { code: 200, message: 'success', data: null };
  }

  /** 清除活动横幅列表缓存 */
  private async clearListCache() {
    try { await this.redisService.del('list:activity-banner:1:20:'); } catch (e) { /* ignore */ }
  }
}
