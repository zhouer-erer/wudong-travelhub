import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { CarouselService } from '../service/carousel.service';
import { RedisService } from '../service/redis.service';
import { Context } from '@midwayjs/koa';
import { ApiOperation, ApiBody, ApiQuery, ApiParam, ApiTags, ApiResponse } from '@midwayjs/swagger';

/**
 * 轮播图控制器
 * 处理轮播图相关的 API 请求，包括轮播图的增删改查操作
 */
@ApiTags('Carousel')
@Controller('/api/carousels')
export class CarouselController {
  @Inject()
  ctx: Context;

  @Inject()
  carouselService: CarouselService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取轮播图列表（分页）
   * GET /api/carousels/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @param keyword - 搜索关键词（可选）
   * @returns 分页轮播图列表
   */
  @Get('/list')
  @ApiOperation({ summary: '获取轮播图列表（分页）' })
  @ApiQuery({ name: 'page', description: '页码', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', description: '每页数量', required: false, example: 20 })
  @ApiQuery({ name: 'keyword', description: '搜索关键词', required: false, example: '首页' })
  @ApiResponse({
    status: 200,
    description: '获取成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: {
          list: [
            { id: 1, title: '首页轮播图', image: 'https://example.com/carousel1.jpg', url: 'https://example.com', sort: 1, status: 1, created_at: '2024-01-15 10:30:00' },
            { id: 2, title: '活动轮播图', image: 'https://example.com/carousel2.jpg', url: 'https://example.com/activity', sort: 2, status: 1, created_at: '2024-01-16 14:20:00' },
          ],
          total: 2,
        },
      },
    },
  })
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20, @Query('keyword') keyword?: string) {
    const startTime = Date.now();
    const cacheKey = `list:carousel:${page}:${pageSize}:${keyword || ''}`;
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const result = await this.carouselService.findAll(Number(page), Number(pageSize), keyword);
    const response = { code: 200, message: 'success', data: result };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 300); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 获取轮播图详情
   * GET /api/carousels/detail/:id
   * @param id - 轮播图 ID
   * @returns 轮播图详细信息
   */
  @Get('/detail/:id')
  @ApiOperation({ summary: '获取轮播图详情' })
  @ApiParam({ name: 'id', description: '轮播图ID', example: 1 })
  @ApiResponse({
    status: 200,
    description: '获取成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 1, title: '首页轮播图', image: 'https://example.com/carousel1.jpg', url: 'https://example.com', sort: 1, status: 1, created_at: '2024-01-15 10:30:00' },
      },
    },
  })
  async detail(@Param('id') id: number) {
    const item = await this.carouselService.findById(Number(id));
    if (!item) return { code: 404, message: '不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建轮播图
   * POST /api/carousels/create
   * @param body - 轮播图信息
   * @returns 创建后的轮播图信息
   */
  @Post('/create')
  @ApiOperation({ summary: '创建轮播图' })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '轮播图标题', example: '首页轮播图' },
        image: { type: 'string', description: '图片URL', example: 'https://example.com/carousel1.jpg' },
        url: { type: 'string', description: '跳转链接', example: 'https://example.com' },
        sort: { type: 'number', description: '排序号', example: 1 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
      },
      example: {
        title: '首页轮播图',
        image: 'https://example.com/carousel1.jpg',
        url: 'https://example.com',
        sort: 1,
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
        data: { id: 3, title: '首页轮播图', image: 'https://example.com/carousel1.jpg', url: 'https://example.com', sort: 1, status: 1, created_at: '2024-01-17 09:00:00' },
      },
    },
  })
  async create(@Body() body: any) {
    const item = await this.carouselService.create(body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新轮播图信息
   * PUT /api/carousels/update/:id
   * @param id - 轮播图 ID
   * @param body - 更新的轮播图信息
   * @returns 更新后的轮播图信息
   */
  @Put('/update/:id')
  @ApiOperation({ summary: '更新轮播图信息' })
  @ApiParam({ name: 'id', description: '轮播图ID', example: 1 })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '轮播图标题', example: '更新后的轮播图标题' },
        image: { type: 'string', description: '图片URL', example: 'https://example.com/new-carousel.jpg' },
        url: { type: 'string', description: '跳转链接', example: 'https://example.com/new' },
        sort: { type: 'number', description: '排序号', example: 2 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
      },
      example: {
        title: '更新后的轮播图标题',
        image: 'https://example.com/new-carousel.jpg',
        url: 'https://example.com/new',
        sort: 2,
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
        data: { id: 1, title: '更新后的轮播图标题', image: 'https://example.com/new-carousel.jpg', url: 'https://example.com/new', sort: 2, status: 1, created_at: '2024-01-15 10:30:00', updated_at: '2024-01-17 11:00:00' },
      },
    },
  })
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    const item = await this.carouselService.update(Number(id), body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除轮播图
   * DELETE /api/carousels/delete/:id
   * @param id - 轮播图 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  @ApiOperation({ summary: '删除轮播图' })
  @ApiParam({ name: 'id', description: '轮播图ID', example: 1 })
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
    await this.carouselService.delete(Number(id));
    await this.clearListCache();
    return { code: 200, message: 'success', data: null };
  }

  /** 清除轮播图列表缓存 */
  private async clearListCache() {
    try { await this.redisService.del('list:carousel:1:20:'); } catch (e) { /* ignore */ }
  }
}
