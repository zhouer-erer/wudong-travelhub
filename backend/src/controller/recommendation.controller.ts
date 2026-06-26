import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { ApiOperation, ApiBody, ApiQuery, ApiParam, ApiTags, ApiResponse, ApiBearerAuth } from '@midwayjs/swagger';
import { Context } from '@midwayjs/koa';
import { RecommendationService } from '../service/recommendation.service';
import { RedisService } from '../service/redis.service';

/**
 * 推荐位控制器
 * 处理推荐位相关的 API 请求，包括推荐位的增删改查操作
 */
@ApiTags('Recommendation')
@ApiBearerAuth()
@Controller('/api/recommendations')
export class RecommendationController {
  @Inject()
  ctx: Context;

  @Inject()
  recommendationService: RecommendationService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取推荐位列表（分页）
   * GET /api/recommendations/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @returns 分页推荐位列表
   */
  @Get('/list')
  @ApiOperation({ summary: '获取推荐位列表（分页）' })
  @ApiQuery({ name: 'page', description: '页码', required: false, example: 1 })
  @ApiQuery({ name: 'pageSize', description: '每页数量', required: false, example: 20 })
  @ApiResponse({
    status: 200,
    description: '成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: {
          list: [
            { id: 1, title: '西江千户苗寨推荐', content_type: 'scenic', content_id: 1, sort: 1, status: 1, image: '/uploads/recommend/1.jpg' },
            { id: 2, title: '苗族长桌宴推荐', content_type: 'food', content_id: 5, sort: 2, status: 1, image: '/uploads/recommend/2.jpg' },
          ],
          total: 10,
          page: 1,
          pageSize: 20,
        },
      },
    },
  })
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20) {
    const startTime = Date.now();
    const cacheKey = `list:recommendation:${page}:${pageSize}`;
    try {
      const cached = await this.redisService.get(cacheKey);
      if (cached) {
        this.ctx.set('X-Cache', 'HIT');
        this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
        return JSON.parse(cached);
      }
    } catch (e) { /* Redis 异常降级查 DB */ }

    const result = await this.recommendationService.findAll(Number(page), Number(pageSize));
    const response = { code: 200, message: 'success', data: result };
    try { await this.redisService.set(cacheKey, JSON.stringify(response), 300); } catch (e) { /* ignore */ }
    this.ctx.set('X-Cache', 'MISS');
    this.ctx.set('X-Response-Time', `${Date.now() - startTime}ms`);
    return response;
  }

  /**
   * 获取推荐位详情
   * GET /api/recommendations/detail/:id
   * @param id - 推荐位 ID
   * @returns 推荐位详细信息
   */
  @Get('/detail/:id')
  @ApiOperation({ summary: '获取推荐位详情' })
  @ApiParam({ name: 'id', description: '推荐位ID', example: 1 })
  @ApiResponse({
    status: 200,
    description: '成功',
    schema: {
      example: {
        code: 200,
        message: 'success',
        data: { id: 1, title: '西江千户苗寨推荐', content_type: 'scenic', content_id: 1, sort: 1, status: 1, image: '/uploads/recommend/1.jpg', description: '感受苗族风情，体验千户苗寨的壮丽景色' },
      },
    },
  })
  async detail(@Param('id') id: number) {
    const item = await this.recommendationService.findById(Number(id));
    if (!item) return { code: 404, message: '推荐内容不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 创建推荐位
   * POST /api/recommendations/create
   * @param body - 推荐位信息
   * @returns 创建后的推荐位信息
   */
  @Post('/create')
  @ApiOperation({ summary: '创建推荐位' })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '推荐标题', example: '西江千户苗寨推荐' },
        content_type: { type: 'string', description: '内容类型', example: 'scenic' },
        content_id: { type: 'number', description: '关联内容ID', example: 1 },
        image: { type: 'string', description: '推荐图片', example: '/uploads/recommend/1.jpg' },
        sort: { type: 'number', description: '排序值', example: 1 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
        description: { type: 'string', description: '推荐描述', example: '感受苗族风情，体验千户苗寨的壮丽景色' },
      },
      example: {
        title: '西江千户苗寨推荐',
        content_type: 'scenic',
        content_id: 1,
        image: '/uploads/recommend/1.jpg',
        sort: 1,
        status: 1,
        description: '感受苗族风情，体验千户苗寨的壮丽景色',
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
        data: { id: 1, title: '西江千户苗寨推荐', content_type: 'scenic', content_id: 1, sort: 1, status: 1, image: '/uploads/recommend/1.jpg', description: '感受苗族风情，体验千户苗寨的壮丽景色' },
      },
    },
  })
  async create(@Body() body: any) {
    // 兜底：数据库字段 NOT NULL 无默认值，前端不传时补默认值
    if (!body.content_type) body.content_type = '';
    if (body.content_id == null) body.content_id = 0;
    const item = await this.recommendationService.create(body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新推荐位信息
   * PUT /api/recommendations/update/:id
   * @param id - 推荐位 ID
   * @param body - 更新的推荐位信息
   * @returns 更新后的推荐位信息
   */
  @Put('/update/:id')
  @ApiOperation({ summary: '更新推荐位信息' })
  @ApiParam({ name: 'id', description: '推荐位ID', example: 1 })
  @ApiBody({
    schema: {
      properties: {
        title: { type: 'string', description: '推荐标题', example: '西江千户苗寨推荐（更新）' },
        content_type: { type: 'string', description: '内容类型', example: 'scenic' },
        content_id: { type: 'number', description: '关联内容ID', example: 1 },
        image: { type: 'string', description: '推荐图片', example: '/uploads/recommend/1_v2.jpg' },
        sort: { type: 'number', description: '排序值', example: 2 },
        status: { type: 'number', description: '状态 1启用 0禁用', example: 1 },
        description: { type: 'string', description: '推荐描述', example: '全新升级，感受最地道的苗族风情' },
      },
      example: {
        title: '西江千户苗寨推荐（更新）',
        content_type: 'scenic',
        content_id: 1,
        image: '/uploads/recommend/1_v2.jpg',
        sort: 2,
        status: 1,
        description: '全新升级，感受最地道的苗族风情',
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
        data: { id: 1, title: '西江千户苗寨推荐（更新）', content_type: 'scenic', content_id: 1, sort: 2, status: 1, image: '/uploads/recommend/1_v2.jpg', description: '全新升级，感受最地道的苗族风情' },
      },
    },
  })
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    const item = await this.recommendationService.update(Number(id), body);
    await this.clearListCache();
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除推荐位
   * DELETE /api/recommendations/delete/:id
   * @param id - 推荐位 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  @ApiOperation({ summary: '删除推荐位' })
  @ApiParam({ name: 'id', description: '推荐位ID', example: 1 })
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
    await this.recommendationService.delete(Number(id));
    await this.clearListCache();
    return { code: 200, message: 'success', data: null };
  }

  /** 清除推荐位列表缓存 */
  private async clearListCache() {
    try { await this.redisService.del('list:recommendation:1:20'); } catch (e) { /* ignore */ }
  }
}
