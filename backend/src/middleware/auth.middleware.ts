/**
 * 认证中间件
 * 验证 JWT Token，将用户信息挂载到 ctx.state.admin
 */
import { Middleware, Inject } from '@midwayjs/decorator';
import { Context, NextFunction } from '@midwayjs/koa';
import { JwtService } from '@midwayjs/jwt';
import { AdminService } from '../service/admin.service';

@Middleware()
export class AuthMiddleware {
  @Inject()
  jwtService: JwtService;

  @Inject()
  adminService: AdminService;

  resolve() {
    return async (ctx: Context, next: NextFunction) => {
      // 白名单路由（不需要认证）
      const whiteList = [
        '/api/auth/login',
        '/api/auth/verify-sms',
        '/api/auth/resend-sms',
        '/api/merchant-auth/login',
        '/api/announcements/list',
        '/api/carousels/list',
        '/api/activity-banners/list',
        '/api/recommendations/list',
        '/api/upload/file',
        '/api/upload/oss-token',
      ];

      // 检查是否在白名单中
      if (whiteList.some(path => ctx.path.startsWith(path))) {
        await next();
        return;
      }

      // 获取 token
      const authHeader = ctx.headers.authorization;
      if (!authHeader || !authHeader.startsWith('Bearer ')) {
        ctx.status = 401;
        ctx.body = { code: 401, message: '未登录', data: null };
        return;
      }

      const token = authHeader.replace('Bearer ', '');

      try {
        // 验证 token
        const payload: any = await this.jwtService.verify(token);

        // 查询管理员信息
        const admin = await this.adminService.findById(payload.id);
        if (!admin || admin.status === 0) {
          ctx.status = 401;
          ctx.body = { code: 401, message: '账号已被禁用', data: null };
          return;
        }

        // 将管理员信息挂载到 ctx.state
        ctx.state.admin = {
          id: admin.id,
          username: admin.username,
          name: admin.name,
          role_id: admin.role_id,
        };
      } catch (error) {
        ctx.status = 401;
        ctx.body = { code: 401, message: 'token无效或已过期', data: null };
        return;
      }

      await next();
    };
  }

  static getName() {
    return 'auth';
  }
}
