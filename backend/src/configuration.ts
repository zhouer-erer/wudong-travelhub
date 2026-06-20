/**
 * Midway.js 应用配置
 * 配置中间件、静态文件服务、文件上传等
 */
import { Configuration, App } from '@midwayjs/core';
import * as koa from '@midwayjs/koa';
import * as typeorm from '@midwayjs/typeorm';
import * as jwt from '@midwayjs/jwt';
import * as validate from '@midwayjs/validate';
import { join } from 'path';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const koaStatic = require('koa-static');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const multer = require('multer');

@Configuration({
  imports: [
    koa,
    typeorm,
    jwt,
    validate,
  ],
  importConfigs: [join(__dirname, 'config')],
  conflictCheck: false,
})
export class ContainerLifeCycle {
  @App()
  app: koa.Application;

  async onReady() {
    // 配置静态文件服务（上传文件访问）
    const uploadsDir = join(process.cwd(), 'uploads');
    const fs = require('fs');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }

    this.app.use(koaStatic(uploadsDir, {
      prefix: '/uploads',
    }));

    // 配置 multer 文件上传（memoryStorage 避免磁盘 I/O，上传文件直接存在内存中）
    const upload = multer({
      storage: multer.memoryStorage(),
      limits: { fileSize: 5 * 1024 * 1024 },
      fileFilter: (req: any, file: any, cb: any) => {
        const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml'];
        if (allowedTypes.includes(file.mimetype)) {
          cb(null, true);
        } else {
          cb(new Error('不支持的文件格式'));
        }
      },
    });

    // 挂载 multer 中间件到上传路由
    this.app.use(async (ctx: any, next: any) => {
      if (ctx.path === '/api/upload/image' && ctx.method === 'POST') {
        await new Promise((resolve, reject) => {
          upload.array('files', 10)(ctx.req, ctx.res, (err: any) => {
            if (err) {
              ctx.status = 400;
              ctx.body = { code: 400, message: err.message, data: null };
              resolve(null);
            } else {
              resolve(null);
            }
          });
        });
      }
      await next();
    });

    // 认证中间件
    this.app.use(async (ctx: any, next: any) => {
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
        '/api/upload/image',
        '/api/upload/oss-token',
      ];

      // 检查是否在白名单中
      const isWhiteListed = whiteList.some(path => ctx.path.startsWith(path));

      if (!isWhiteListed && ctx.path.startsWith('/api/')) {
        // 获取 token
        const authHeader = ctx.headers.authorization;
        if (!authHeader || !authHeader.startsWith('Bearer ')) {
          ctx.status = 401;
          ctx.body = { code: 401, message: '未登录', data: null };
          return;
        }

        const token = authHeader.replace('Bearer ', '');

        try {
          // 使用 JwtService 验证 token
          const jwtService = await ctx.requestContext.getAsync('jwtService');
          const payload: any = await jwtService.verify(token);

          // 先获取管理员服务（两个分支可能都需要）
          const adminService = await ctx.requestContext.getAsync('adminService');

          // 根据 token 中的 role 区分管理员和商家认证
          if (payload.role === 'merchant') {
            // 商家 token —— 查询商家表验证
            const merchantService = await ctx.requestContext.getAsync('merchantService');
            const merchant = await merchantService.findById(payload.id);

            if (!merchant || merchant.status === 0) {
              ctx.status = 401;
              ctx.body = { code: 401, message: '商家账号已被禁用', data: null };
              return;
            }

            // 检查是否被强制下线：token 签发时间早于强制下线时间则拒绝
            try {
              const redisService = await ctx.requestContext.getAsync('redisService');
              const offlineTime = await redisService.get(`merchant:offline:${payload.id}`);
              if (offlineTime && payload.iat * 1000 < Number(offlineTime)) {
                ctx.status = 401;
                ctx.body = { code: 401, message: '账号已被强制下线，请重新登录', data: null };
                return;
              }
            } catch {
              // Redis 异常不影响正常业务
            }

            // 将商家信息挂载到 ctx.state
            ctx.state.merchant = {
              id: merchant.id,
              username: merchant.username,
              shop_name: merchant.shop_name,
              module_type: merchant.module_type,
            };
          } else {
            // 管理员 token —— 查询管理员表验证
            const admin = await adminService.findById(payload.id);

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
          }
        } catch (error) {
          ctx.status = 401;
          ctx.body = { code: 401, message: 'token无效或已过期', data: null };
          return;
        }
      }

      await next();
    });

    // 操作日志中间件
    this.app.use(async (ctx: any, next: any) => {
      const startTime = Date.now();
      const method = ctx.method.toUpperCase();

      await next();

      // 只记录写操作
      if (['POST', 'PUT', 'DELETE'].includes(method) && ctx.path.startsWith('/api/')) {
        // 跳过登录接口和文件上传
        if (!ctx.path.includes('/login') && !ctx.path.includes('/upload/file')) {
          try {
            const admin = ctx.state.admin;
            if (admin) {
              const operationLogService = await ctx.requestContext.getAsync('operationLogService');

              // 根据路径和方法推断操作类型
              let action = 'other';
              if (method === 'DELETE') action = 'delete';
              else if (ctx.path.includes('/approve')) action = 'approve';
              else if (ctx.path.includes('/reject')) action = 'reject';
              else if (ctx.path.includes('/ban')) action = 'ban';
              else if (ctx.path.includes('/unban')) action = 'unban';
              else if (method === 'POST') action = 'create';
              else if (method === 'PUT') action = 'update';

              // 获取操作对象
              const segments = ctx.path.split('/').filter(Boolean);
              const target = segments.length >= 2 ? segments[1] : ctx.path;

              // 获取请求体（排除敏感信息）
              const body = ctx.request.body ? JSON.parse(JSON.stringify(ctx.request.body)) : {};
              delete body.password;
              delete body.password_hash;
              delete body.token;

              await operationLogService.create({
                operator_id: admin.id,
                operator_name: admin.name,
                operator_type: 'admin',
                action,
                target,
                content: JSON.stringify({
                  method,
                  path: ctx.path,
                  body: Object.keys(body).length > 0 ? body : undefined,
                  status: ctx.status,
                  duration: Date.now() - startTime,
                }).substring(0, 1000),
                ip: ctx.ip || ctx.req.socket.remoteAddress,
                user_agent: (ctx.headers['user-agent'] || '').substring(0, 500),
              });
            }
          } catch (error) {
            // 日志记录失败不影响正常业务
            console.error('操作日志记录失败:', error);
          }
        }
      }
    });
  }
}
