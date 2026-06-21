import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { RecommendationService } from '../service/recommendation.service';

/**
 * 推荐位控制器
 * 处理推荐位相关的 API 请求，包括推荐位的增删改查操作
 */
@Controller('/api/recommendations')
export class RecommendationController {
  @Inject()
  recommendationService: RecommendationService;

  /**
   * 获取推荐位列表（分页）
   * GET /api/recommendations/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @returns 分页推荐位列表
   */
  @Get('/list')
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20) {
    const result = await this.recommendationService.findAll(Number(page), Number(pageSize));
    return { code: 200, message: 'success', data: result };
  }

  /**
   * 获取推荐位详情
   * GET /api/recommendations/detail/:id
   * @param id - 推荐位 ID
   * @returns 推荐位详细信息
   */
  @Get('/detail/:id')
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
  async create(@Body() body: any) {
    // 兜底：数据库字段 NOT NULL 无默认值，前端不传时补默认值
    if (!body.content_type) body.content_type = '';
    if (body.content_id == null) body.content_id = 0;
    const item = await this.recommendationService.create(body);
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
  async update(@Param('id') id: number, @Body() body: any) {
    delete body.id;
    const item = await this.recommendationService.update(Number(id), body);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除推荐位
   * DELETE /api/recommendations/delete/:id
   * @param id - 推荐位 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  async remove(@Param('id') id: number) {
    await this.recommendationService.delete(Number(id));
    return { code: 200, message: 'success', data: null };
  }
}
