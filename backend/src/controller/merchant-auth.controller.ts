import { Controller, Post, Put, Inject, Body, Get, Headers } from '@midwayjs/decorator';
import { MerchantService } from '../service/merchant.service';
import { JwtService } from '@midwayjs/jwt';

/**
 * 商家认证控制器
 * 处理商家登录认证相关的 API 请求，包括登录和获取商家信息
 */
@Controller('/api/merchant-auth')
export class MerchantAuthController {
  @Inject()
  merchantService: MerchantService;

  @Inject()
  jwtService: JwtService;

  /**
   * 商家登录
   * POST /api/merchant-auth/login
   * @param body - 登录信息，包含 username、password
   * @returns 登录成功返回 JWT token 和商家基本信息
   */
  @Post('/login')
  async login(@Body() body: { username: string; password: string }) {
    const bcrypt = require('bcryptjs');
    const merchant = await this.merchantService.findByUsername(body.username);
    if (!merchant) {
      return { code: 401, message: '用户名或密码错误', data: null };
    }

    // 账号被禁用
    if (merchant.status === 0) {
      return { code: 403, message: '账号已被禁用', data: null };
    }

    // 账号被锁定
    if (merchant.locked_until && new Date(merchant.locked_until) > new Date()) {
      const lockTime = new Date(merchant.locked_until);
      const minutes = Math.ceil((lockTime.getTime() - Date.now()) / 60000);
      return { code: 423, message: `账号已锁定，请 ${minutes} 分钟后再试`, data: null };
    }

    // 验证密码
    const valid = bcrypt.compareSync(body.password, merchant.password_hash);
    if (!valid) {
      // 密码错误，增加失败次数
      const failCount = (merchant.login_fail_count || 0) + 1;
      const updateData: any = { login_fail_count: failCount };

      // 连续失败 5 次，锁定账号 30 分钟
      if (failCount >= 5) {
        const lockUntil = new Date(Date.now() + 30 * 60 * 1000);
        updateData.locked_until = lockUntil;
        await this.merchantService.update(merchant.id, updateData);
        return { code: 423, message: '密码错误次数过多，账号已锁定 30 分钟', data: null };
      }

      await this.merchantService.update(merchant.id, updateData);
      return { code: 401, message: `用户名或密码错误，剩余 ${5 - failCount} 次机会`, data: null };
    }

    // 登录成功，重置失败次数
    const token = await this.jwtService.sign({
      id: merchant.id,
      username: merchant.username,
      role: 'merchant'
    });
    await this.merchantService.update(merchant.id, {
      last_login_at: new Date(),
      login_fail_count: 0,
      locked_until: null,
    });
    return {
      code: 200,
      message: 'success',
      data: {
        token,
        merchant: { id: merchant.id, username: merchant.username, shop_name: merchant.shop_name, module_type: merchant.module_type }
      }
    };
  }

  /**
   * 获取当前登录商家信息
   * GET /api/merchant-auth/info
   * @param auth - 请求头中的 Authorization Bearer token
   * @returns 当前登录商家的完整信息（含店铺详情）
   */
  @Get('/info')
  async info(@Headers('authorization') auth: string) {
    try {
      const token = auth?.replace('Bearer ', '');
      const payload: any = await this.jwtService.verify(token);
      const merchant = await this.merchantService.findById(payload.id);
      if (!merchant) return { code: 401, message: '未登录', data: null };
      return {
        code: 200,
        message: 'success',
        data: {
          id: merchant.id,
          username: merchant.username,
          shop_name: merchant.shop_name,
          module_type: merchant.module_type,
          contact_name: merchant.contact_name,
          contact_phone: merchant.contact_phone,
          logo: merchant.logo,
          description: merchant.description,
          address: merchant.address,
          status: merchant.status,
          joined_at: merchant.joined_at,
          last_login_at: merchant.last_login_at,
        }
      };
    } catch {
      return { code: 401, message: 'token无效', data: null };
    }
  }

  /**
   * 更新当前登录商家的资料
   * PUT /api/merchant-auth/profile
   * 只允许修改安全字段：店铺名称、联系人、联系电话、地址、简介、Logo、密码
   * @param auth - 请求头中的 Authorization Bearer token
   * @param body - 更新内容
   * @returns 更新后的商家信息
   */
  @Put('/profile')
  async updateProfile(@Headers('authorization') auth: string, @Body() body: any) {
    try {
      const token = auth?.replace('Bearer ', '');
      const payload: any = await this.jwtService.verify(token);
      if (payload.role !== 'merchant') return { code: 403, message: '无权限', data: null };

      const merchant = await this.merchantService.findById(payload.id);
      if (!merchant) return { code: 401, message: '未登录', data: null };

      // 只允许修改安全字段
      const allowedFields = ['shop_name', 'contact_name', 'contact_phone', 'address', 'description', 'logo'];
      const updateData: any = {};
      for (const field of allowedFields) {
        if (body[field] !== undefined) {
          updateData[field] = body[field];
        }
      }

      // 处理密码修改
      if (body.password) {
        const bcrypt = require('bcryptjs');
        updateData.password_hash = bcrypt.hashSync(body.password, 12);
      }

      const item = await this.merchantService.update(payload.id, updateData);
      return {
        code: 200,
        message: '更新成功',
        data: {
          id: item.id,
          username: item.username,
          shop_name: item.shop_name,
          module_type: item.module_type,
          contact_name: item.contact_name,
          contact_phone: item.contact_phone,
          logo: item.logo,
          description: item.description,
          address: item.address,
        }
      };
    } catch {
      return { code: 401, message: 'token无效', data: null };
    }
  }
}
