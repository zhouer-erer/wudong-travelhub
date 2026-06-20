import { Controller, Post, Get, Put, Del, Inject, Query, Body, Param } from '@midwayjs/decorator';
import { MerchantService } from '../service/merchant.service';
import { RedisService } from '../service/redis.service';

/**
 * 商家控制器
 * 处理商家相关的 API 请求，包括商家的增删改查操作
 */
@Controller('/api/merchants')
export class MerchantController {
  @Inject()
  merchantService: MerchantService;

  @Inject()
  redisService: RedisService;

  /**
   * 获取商家列表（分页）
   * GET /api/merchants/list
   * @param page - 页码，默认 1
   * @param pageSize - 每页数量，默认 20
   * @param keyword - 搜索关键词（可选）
   * @returns 分页商家列表
   */
  @Get('/list')
  async list(@Query('page') page = 1, @Query('pageSize') pageSize = 20, @Query('keyword') keyword?: string) {
    const result = await this.merchantService.findAll(Number(page), Number(pageSize), keyword);
    return { code: 200, message: 'success', data: result };
  }

  /**
   * 获取商家详情
   * GET /api/merchants/detail/:id
   * @param id - 商家 ID
   * @returns 商家详细信息
   */
  @Get('/detail/:id')
  async detail(@Param('id') id: number) {
    const item = await this.merchantService.findById(Number(id));
    if (!item) return { code: 404, message: '不存在', data: null };
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 强制商家下线
   * POST /api/merchants/force-offline/:id
   * 将当前时间戳写入 Redis，使该时间点之前签发的所有 token 失效
   * @param id - 商家 ID
   */
  @Post('/force-offline/:id')
  async forceOffline(@Param('id') id: number) {
    const item = await this.merchantService.findById(Number(id));
    if (!item) return { code: 404, message: '商家不存在', data: null };
    // 记录强制下线时间戳，token 签发时间早于此时间的请求将被拒绝
    const offlineTime = Date.now();
    await this.redisService.set(`merchant:offline:${id}`, String(offlineTime), 86400 * 7);
    await this.merchantService.update(Number(id), { last_login_at: null } as any);
    console.log(`[强制下线] 商家 ID: ${id}, 店铺: ${item.shop_name}, 时间戳: ${offlineTime}`);
    return { code: 200, message: `已将「${item.shop_name}」强制下线`, data: null };
  }

  /**
   * 创建商家
   * POST /api/merchants/create
   * @param body - 商家信息（包含 password 字段会自动加密为 password_hash）
   * @returns 创建后的商家信息
   */
  @Post('/create')
  async create(@Body() body: any) {
    const bcrypt = require('bcryptjs');
    if (body.password) {
      body.password_hash = bcrypt.hashSync(body.password, 12);
      delete body.password;
    }
    const item = await this.merchantService.create(body);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 更新商家信息
   * PUT /api/merchants/update/:id
   * @param id - 商家 ID
   * @param body - 更新的商家信息（包含 password 字段会自动加密为 password_hash）
   * @returns 更新后的商家信息
   */
  @Put('/update/:id')
  async update(@Param('id') id: number, @Body() body: any) {
    const bcrypt = require('bcryptjs');
    if (body.password) {
      body.password_hash = bcrypt.hashSync(body.password, 12);
      delete body.password;
    }
    delete body.id;
    const item = await this.merchantService.update(Number(id), body);
    return { code: 200, message: 'success', data: item };
  }

  /**
   * 删除商家
   * DELETE /api/merchants/delete/:id
   * @param id - 商家 ID
   * @returns 操作结果
   */
  @Del('/delete/:id')
  async remove(@Param('id') id: number) {
    await this.merchantService.delete(Number(id));
    return { code: 200, message: 'success', data: null };
  }
}
