import { Controller, Post, Inject, Body, Get, Headers } from '@midwayjs/decorator';
import { AdminService } from '../service/admin.service';
import { PermissionService } from '../service/permission.service';
import { JwtService } from '@midwayjs/jwt';

/**
 * 内存中的短信验证码存储
 * key: smsToken（UUID），value: { code, adminId, expiresAt }
 * 5 分钟自动过期，每分钟清理一次
 */
const smsStore = new Map<string, { code: string; adminId: number; expiresAt: number }>();
setInterval(() => {
  const now = Date.now();
  for (const [key, val] of smsStore) {
    if (val.expiresAt < now) smsStore.delete(key);
  }
}, 60_000);

/**
 * 管理员认证控制器
 * 处理管理员登录认证相关的 API 请求
 *
 * 登录流程（两步）：
 * 1. POST /api/auth/login       → 验证用户名+密码 → 发送短信 → 返回 masked 手机号 + smsToken
 * 2. POST /api/auth/verify-sms  → 验证短信验证码 → 返回 JWT token
 */
@Controller('/api/auth')
export class AuthController {
  @Inject()
  adminService: AdminService;

  @Inject()
  permissionService: PermissionService;

  @Inject()
  jwtService: JwtService;

  /**
   * 管理员登录（第一步：验证账号密码）
   * POST /api/auth/login
   * @param body - 包含 username（用户名）和 password（密码）
   * @returns 密码正确时返回 { needSms: true, phoneMask, smsToken }，引导前端弹出二次验证弹窗
   *          密码错误时返回 401
   */
  @Post('/login')
  async login(@Body() body: { username: string; password: string }) {
    const bcrypt = require('bcryptjs');
    const admin = await this.adminService.findByUsername(body.username);

    if (!admin) {
      return { code: 401, message: '用户名或密码错误', data: null };
    }
    if (admin.status === 0) {
      return { code: 403, message: '账号已被禁用', data: null };
    }

    // 检查账号是否被锁定
    if (admin.locked_until && new Date(admin.locked_until) > new Date()) {
      const remaining = Math.ceil((new Date(admin.locked_until).getTime() - Date.now()) / 60000);
      return { code: 423, message: `账号已被锁定，请${remaining}分钟后再试`, data: null };
    }

    const valid = bcrypt.compareSync(body.password, admin.password_hash);
    if (!valid) {
      // 密码错误 → 累计失败次数
      const failCount = (admin.login_fail_count || 0) + 1;
      const updates: Partial<{ login_fail_count: number; locked_until: Date | null }> = {
        login_fail_count: failCount,
      };
      if (failCount >= 5) {
        updates.locked_until = new Date(Date.now() + 30 * 60 * 1000); // 锁定30分钟
        await this.adminService.update(admin.id, updates);
        console.log(`[安全] 管理员 ${admin.username} 连续${failCount}次密码错误，已锁定30分钟`);
        return { code: 423, message: '密码错误次数过多，账号已锁定 30 分钟', data: null };
      }
      await this.adminService.update(admin.id, updates);
      return { code: 401, message: `用户名或密码错误，剩余 ${5 - failCount} 次机会`, data: null };
    }

    // 密码正确 → 清除锁定状态
    if (admin.login_fail_count > 0 || admin.locked_until) {
      await this.adminService.update(admin.id, { login_fail_count: 0, locked_until: null as any });
    }

    // 密码验证通过 → 检查是否绑定了手机号
    if (!admin.phone) {
      return { code: 400, message: '该管理员未绑定手机号，请联系超级管理员', data: null };
    }

    // 生成 6 位短信验证码
    const code = String(Math.floor(100000 + Math.random() * 900000));
    const crypto = require('crypto');
    const smsToken = crypto.randomUUID();

    // 存入内存（5 分钟有效）
    smsStore.set(smsToken, {
      code,
      adminId: admin.id,
      expiresAt: Date.now() + 5 * 60 * 1000,
    });

    // 模拟发送短信（打印到后端日志）
    console.log(`[SMS模拟] 手机号: ${admin.phone}, 验证码: ${code}`);

    // 掩码手机号（138****1234）
    const phoneMask = admin.phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');

    return {
      code: 200,
      message: '验证码已发送',
      data: { needSms: true, phoneMask, smsToken },
    };
  }

  /**
   * 重新发送短信验证码
   * POST /api/auth/resend-sms
   * @param body - 包含 smsToken（第一步返回的临时令牌）
   * @returns 重新发送结果
   */
  @Post('/resend-sms')
  async resendSms(@Body() body: { smsToken: string }) {
    if (!body.smsToken) {
      return { code: 400, message: '参数不完整', data: null };
    }

    const stored = smsStore.get(body.smsToken);
    if (!stored || stored.expiresAt < Date.now()) {
      smsStore.delete(body.smsToken);
      return { code: 401, message: '验证码已过期，请重新登录', data: null };
    }

    // 生成新的验证码
    const code = String(Math.floor(100000 + Math.random() * 900000));
    stored.code = code;
    stored.expiresAt = Date.now() + 5 * 60 * 1000;

    const admin = await this.adminService.findById(stored.adminId);
    console.log(`[SMS模拟-重发] 手机号: ${admin?.phone}, 新验证码: ${code}`);

    return { code: 200, message: '验证码已重新发送', data: null };
  }

  /**
   * 短信验证码校验（第二步：完成登录）
   * POST /api/auth/verify-sms
   * @param body - 包含 smsToken（第一步返回的临时令牌）和 code（短信验证码）
   * @returns 验证通过后返回 JWT token 和管理员基本信息
   */
  @Post('/verify-sms')
  async verifySms(@Body() body: { smsToken: string; code: string }) {
    if (!body.smsToken || !body.code) {
      return { code: 400, message: '参数不完整', data: null };
    }
    if (!/^\d{6}$/.test(body.code)) {
      return { code: 400, message: '验证码格式错误，请输入6位数字', data: null };
    }

    const stored = smsStore.get(body.smsToken);
    if (!stored || stored.expiresAt < Date.now()) {
      smsStore.delete(body.smsToken);
      return { code: 401, message: '验证码已过期，请重新登录', data: null };
    }

    // 演示模式：任意6位数字均通过（生产环境改为 stored.code !== body.code 严格校验）
    console.log(`[SMS验证] smsToken: ${body.smsToken}, 输入: ${body.code}, 实际: ${stored.code} → 演示模式放行`);

    // 验证通过 → 清除暂存的验证码
    smsStore.delete(body.smsToken);

    // 生成 JWT token
    const admin = await this.adminService.findById(stored.adminId);
    if (!admin) {
      return { code: 401, message: '账号不存在', data: null };
    }

    const token = await this.jwtService.sign({
      id: admin.id,
      username: admin.username,
      role_id: admin.role_id,
    });

    // 登录成功 → 清除锁定状态 + 更新最后登录时间
    await this.adminService.update(admin.id, {
      login_fail_count: 0,
      locked_until: null as any,
      last_login_at: new Date(),
    });

    return {
      code: 200,
      message: 'success',
      data: {
        token,
        admin: {
          id: admin.id,
          username: admin.username,
          name: admin.name,
          role_id: admin.role_id,
        },
      },
    };
  }

  /**
   * 获取当前登录管理员信息
   * GET /api/auth/info
   * @param auth - 请求头中的 Authorization Bearer token
   * @returns 当前登录管理员的基本信息
   */
  @Get('/info')
  async info(@Headers('authorization') auth: string) {
    try {
      const token = auth?.replace('Bearer ', '');
      const payload: any = await this.jwtService.verify(token);
      const admin = await this.adminService.findById(payload.id);
      if (!admin) return { code: 401, message: '未登录', data: null };
      return { code: 200, message: 'success', data: { id: admin.id, username: admin.username, name: admin.name, role_id: admin.role_id } };
    } catch {
      return { code: 401, message: 'token无效', data: null };
    }
  }

  /**
   * 获取当前登录管理员的权限列表
   * GET /api/auth/permissions
   * @param auth - 请求头中的 Authorization Bearer token
   * @returns 当前管理员拥有的权限编码数组
   */
  @Get('/permissions')
  async permissions(@Headers('authorization') auth: string) {
    try {
      const token = auth?.replace('Bearer ', '');
      const payload: any = await this.jwtService.verify(token);
      const admin = await this.adminService.findById(payload.id);
      if (!admin) return { code: 401, message: '未登录', data: null };

      const permissions = await this.permissionService.findByRoleId(admin.role_id);
      return {
        code: 200,
        message: 'success',
        data: permissions.map(p => p.code),
      };
    } catch {
      return { code: 401, message: 'token无效', data: null };
    }
  }
}
