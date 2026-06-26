import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { ApiOperation, ApiBody, ApiQuery, ApiParam, ApiTags, ApiResponse, ApiBearerAuth } from '@midwayjs/swagger';
import { Context } from '@midwayjs/koa';
import { AnnouncementService } from '../service/announcement.service';
import { RedisService } from '../service/redis.service';

/**
 * 公告控制器
 * 处理公告相关的 API 请求，包括公告的增删改查操作
 */
@ApiTags('Announcement')
@ApiBearerAuth()
@Controller('/api/announcements')
export class AnnouncementController {
  @Inject()
  ctx: Context;

  @Inject()
  announcementService: AnnouncementService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取公告列表（分页）
   * GET /api/announcements/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @param keyword - 搜索关键词（可选）
   * @returns 分页公告列表
   */
  @Get('/list')
  @ApiOperation({ summary: '获取公告列表（分页）' })
  @ApiQuery({ name: 'page', description: '页码', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', description: '每页数量', required: false, example: 20 })
  @ApiQuery({ name: 'keyword', description: '搜索关键词', required: false, example: '系统维护' })
  @ApiResponse({
    status: 200,
    description: '获取成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: {
          list: [
            { id: 1, title: '系统维护通知', content: '系统将于今晚22:00进行维护', status: 1, created_at: '2025-06-01 10:00:00' },
            { id: 2, title: '新功能上线公告', content: '新版本已上线，新增多项功能', status: 1, created_at: '2025-06-02 14:30:00' },
          ],
          total: 15,
        },
      },
    },
  })
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20, @Query('keyword') keyword?: string) {
    const startTime = Date.now();
    const cacheKey = `list:announcement:${page}:${pageSize}:${keyword || ''}`;
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const result = await this.announcementService.findAll(Number(page), Number(pageSize), keyword);
    const response = { code: 200, message: 'success', data: result };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 300); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 获取公告详情
   * GET /api/announcements/detail/:id
   * @param id - 公告 ID
   * @returns 公告详细信息
   */
  @Get('/detail/:id')
  @ApiOperation({ summary: '获取公告详情' })
  @ApiParam({ name: 'id', description: '公告ID', example: 1 })
  @ApiResponse({
    status: 200,
    description: '获取成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 1, title: '系统维护通知', content: '系统将于今晚22:00进行维护，请提前保存数据', status: 1, created_at: '2025-06-01 10:00:00' },
      },
    },
  })
  async detail(@Param('id') id: number) {
    const item = await this.announcementService.findById(Number(id));
    if (!item) return { code: 404, message: '不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建公告
   * POST /api/announcements/create
   * @param body - 公告信息
   * @returns 创建后的公告信息
   */
  @Post('/create')
  @ApiOperation({ summary: '创建公告' })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '公告标题', example: '端午节活动通知' },
        content: { type: 'string', description: '公告内容', example: '端午节期间景区将举办龙舟赛、包粽子等民俗活动，欢迎广大游客前来参与。' },
        status: { type: 'number', description: '状态 1发布 0草稿', example: 1 },
      },
      example: {
        title: '端午节活动通知',
        content: '端午节期间景区将举办龙舟赛、包粽子等民俗活动，欢迎广大游客前来参与。',
        status: 1,
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
        data: { id: 3, title: '端午节活动通知', content: '端午节期间景区将举办龙舟赛、包粽子等民俗活动，欢迎广大游客前来参与。', status: 1, created_at: '2025-06-03 09:00:00' },
      },
    },
  })
  async create(@Body() body: any) {
    const item = await this.announcementService.create(body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新公告信息
   * PUT /api/announcements/update/:id
   * @param id - 公告 ID
   * @param body - 更新的公告信息
   * @returns 更新后的公告信息
   */
  @Put('/update/:id')
  @ApiOperation({ summary: '更新公告信息' })
  @ApiParam({ name: 'id', description: '公告ID', example: 1 })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '公告标题', example: '系统维护通知（更新）' },
        content: { type: 'string', description: '公告内容', example: '维护时间调整为今晚23:00，请提前保存数据。' },
        status: { type: 'number', description: '状态 1发布 0草稿', example: 1 },
      },
      example: {
        title: '系统维护通知（更新）',
        content: '维护时间调整为今晚23:00，请提前保存数据。',
        status: 1,
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
        data: { id: 1, title: '系统维护通知（更新）', content: '维护时间调整为今晚23:00，请提前保存数据。', status: 1, updated_at: '2025-06-03 11:00:00' },
      },
    },
  })
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    const item = await this.announcementService.update(Number(id), body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除公告
   * DELETE /api/announcements/delete/:id
   * @param id - 公告 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  @ApiOperation({ summary: '删除公告' })
  @ApiParam({ name: 'id', description: '公告ID', example: 1 })
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
    await this.announcementService.delete(Number(id));
    await this.clearListCache();
    return { code: 200, message: 'success', data: null };
  }

  /** 清除公告列表缓存 */
  private async clearListCache() {
    try { await this.redisService.del('list:announcement:1:20:'); } catch (e) { /* ignore */ }
  }
}
