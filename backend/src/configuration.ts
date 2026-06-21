/**
 * Midway.js 应用配置
 * 配置中间件、静态文件服务、文件上传等
 */
import { Configuration, App } from '@midwayjs/core';
import * as koa from '@midwayjs/koa';
import * as typeorm from '@midwayjs/typeorm';
import * as jwt from '@midwayjs/jwt';
import * as validate from '@midwayjs/validate';
import * as cron from '@midwayjs/cron';
import { join } from 'path';

// eslint-disable-next-line @typescript-eslint/no-var-requires
const koaStatic = require('koa-static');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const koaCompress = require('koa-compress');
// eslint-disable-next-line @typescript-eslint/no-var-requires
const multer = require('multer');

@Configuration({
  imports: [
    koa,
    typeorm,
    jwt,
    validate,
    cron,
  ],
  importConfigs: [join(__dirname, 'config')],
  conflictCheck: false,
})
export class ContainerLifeCycle {
  @App()
  app: koa.Application;

  async onReady() {
    // 配置 gzip 响应压缩（减少网络传输数据量，提升接口响应速度）
    this.app.use(koaCompress({
      threshold: 1024,  // 仅对大于 1KB 的响应进行压缩
      gzip: { level: 6 },
      br: false,        // 不启用 Brotli（兼容性考虑）
    }));

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

    // ============================================================
    // RBAC 权限校验中间件（在认证中间件之后、操作日志中间件之前）
    // ============================================================

    /**
     * 路由前缀 → 所需权限码 映射表
     * 匹配规则：最长前缀匹配，路由不在映射表中的默认放行（fail-open）
     */
    const ROUTE_PERMISSION_MAP: Record<string, string> = {
      '/api/admin': 'admin:list',
      '/api/roles': 'admin:role',
      '/api/permissions': 'admin:role',
      '/api/users': 'user:list',
      '/api/merchant-applications': 'merchant:application',
      '/api/merchants': 'merchant:list',
      '/api/announcements': 'content:announcement',
      '/api/carousels': 'content:carousel',
      '/api/activity-banners': 'content:banner',
      '/api/recommendations': 'content:recommendation',
      '/api/orders': 'order:list',
      '/api/financial-records': 'finance:list',
      '/api/system-messages': 'message:list',
      '/api/message-templates': 'message:template',
      '/api/system-configs': 'system:config',
      '/api/sensitive-words': 'system:sensitive',
      '/api/operation-logs': 'system:log',
      '/api/dashboard': 'dashboard',
    };

    /** 不需要权限校验的路由前缀（白名单） */
    const RBAC_SKIP_PREFIXES = [
      '/api/auth',
      '/api/merchant-auth',
      '/api/merchant-dashboard',
      '/api/upload',
      '/api/test',
    ];

    /** 商家可访问的路由前缀白名单 */
    const MERCHANT_ALLOWED_PREFIXES = [
      '/api/merchant-auth',
      '/api/merchant-dashboard',
      '/api/upload',
    ];

    this.app.use(async (ctx: any, next: any) => {
      // 仅对 /api/ 路由生效
      if (!ctx.path.startsWith('/api/')) {
        await next();
        return;
      }

      // 白名单路由直接跳过
      if (RBAC_SKIP_PREFIXES.some(prefix => ctx.path.startsWith(prefix))) {
        await next();
        return;
      }

      // 商家请求：仅允许访问商家相关接口，禁止访问管理后台接口
      if (ctx.state.merchant && !ctx.state.admin) {
        const isMerchantAllowed = MERCHANT_ALLOWED_PREFIXES.some(prefix => ctx.path.startsWith(prefix));
        if (!isMerchantAllowed) {
          ctx.status = 403;
          ctx.body = {
            code: 403,
            message: '商家账号无权访问此接口',
            data: null,
          };
          return;
        }
        await next();
        return;
      }

      // 非管理员请求跳过（既不是管理员也不是商家，理论上不应到达此处）
      if (!ctx.state.admin) {
        await next();
        return;
      }

      // 最长前缀匹配查找所需权限码
      let bestMatch = '';
      let requiredPermission = '';
      for (const [prefix, permission] of Object.entries(ROUTE_PERMISSION_MAP)) {
        if (ctx.path.startsWith(prefix) && prefix.length > bestMatch.length) {
          bestMatch = prefix;
          requiredPermission = permission;
        }
      }

      // 路由不在映射表中，放行（fail-open）
      if (!requiredPermission) {
        await next();
        return;
      }

      const roleId = ctx.state.admin.role_id;
      const cacheKey = `rbac:permissions:${roleId}`;

      try {
        // 从 Redis 缓存获取角色权限码列表
        let permissionCodes: string[] = [];
        try {
          const redisService = await ctx.requestContext.getAsync('redisService');
          const cached = await redisService.get(cacheKey);
          if (cached) {
            permissionCodes = JSON.parse(cached);
          } else {
            const permissionService = await ctx.requestContext.getAsync('permissionService');
            const permissions = await permissionService.findByRoleId(roleId);
            permissionCodes = permissions.map((p: any) => p.code);
            await redisService.set(cacheKey, JSON.stringify(permissionCodes), 'EX', 300);
          }
        } catch {
          // Redis 不可用时降级为直接查 DB
          const permissionService = await ctx.requestContext.getAsync('permissionService');
          const permissions = await permissionService.findByRoleId(roleId);
          permissionCodes = permissions.map((p: any) => p.code);
        }

        if (!permissionCodes.includes(requiredPermission)) {
          ctx.status = 403;
          ctx.body = {
            code: 403,
            message: '权限不足，无法执行此操作',
            data: null,
          };
          return;
        }
      } catch (error) {
        // 权限查询异常：记录日志，但不阻断请求（避免因DB故障导致全部接口不可用）
        console.error('[RBAC] 权限查询异常，放行请求:', error.message);
      }

      await next();
    });

    // 操作日志中间件
    // 操作类型中文映射
    const ACTION_MAP: Record<string, string> = {
      create: '新增', update: '编辑', delete: '删除',
      approve: '审核通过', reject: '审核驳回',
      ban: '封禁', unban: '解封',
      'force-offline': '强制下线',
      'refund-approve': '退款通过', 'refund-reject': '退款驳回',
      close: '关闭', read: '标记已读',
    };
    // 业务对象中文映射
    const TARGET_MAP: Record<string, string> = {
      merchants: '商家', users: '用户', orders: '订单',
      'merchant-applications': '入驻申请', announcements: '公告',
      carousels: '轮播图', banners: '广告图', recommendations: '推荐内容',
      admins: '管理员账号', roles: '角色', 'system-configs': '系统设置',
      'sensitive-words': '敏感词', 'message-templates': '消息模板',
    };

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

              // 推断操作类型
              let action = 'other';
              if (method === 'DELETE') action = 'delete';
              else if (ctx.path.includes('/refund-approve')) action = 'refund-approve';
              else if (ctx.path.includes('/refund-reject')) action = 'refund-reject';
              else if (ctx.path.includes('/force-offline')) action = 'force-offline';
              else if (ctx.path.includes('/approve')) action = 'approve';
              else if (ctx.path.includes('/reject')) action = 'reject';
              else if (ctx.path.includes('/ban')) action = 'ban';
              else if (ctx.path.includes('/unban')) action = 'unban';
              else if (ctx.path.includes('/close')) action = 'close';
              else if (ctx.path.includes('/read')) action = 'read';
              else if (method === 'POST') action = 'create';
              else if (method === 'PUT') action = 'update';

              const actionLabel = ACTION_MAP[action] || action;

              // 获取操作对象
              const segments = ctx.path.split('/').filter(Boolean);
              const target = segments.length >= 2 ? segments[1] : ctx.path;
              const targetName = TARGET_MAP[target] || target;

              // 提取ID
              const idMatch = ctx.path.match(/\/(\d+)(?:\/|$)/);
              const id = idMatch ? idMatch[1] : null;

              // 获取请求体（排除敏感信息）
              const body = ctx.request.body ? JSON.parse(JSON.stringify(ctx.request.body)) : {};
              delete body.password;
              delete body.password_hash;
              delete body.token;

              // 生成友好的操作内容
              let content = '';
              if (ctx.path.includes('/refund-approve')) {
                content = `同意订单（ID: ${id}）的退款申请`;
              } else if (ctx.path.includes('/refund-reject')) {
                content = `拒绝订单（ID: ${id}）的退款申请，原因：${body.reason || '未说明'}`;
              } else if (ctx.path.includes('/force-offline')) {
                content = `强制商家（ID: ${id}）下线`;
              } else if (ctx.path.includes('/approve')) {
                content = `审核通过入驻申请（ID: ${id}），已自动创建商家账号`;
              } else if (ctx.path.includes('/reject')) {
                content = `驳回入驻申请（ID: ${id}），原因：${body.reject_reason || '未说明'}`;
              } else if (ctx.path.includes('/ban')) {
                content = `封禁${targetName}（ID: ${id}）`;
              } else if (ctx.path.includes('/unban')) {
                content = `解封${targetName}（ID: ${id}）`;
              } else if (ctx.path.includes('/close')) {
                content = `关闭订单（ID: ${id}）`;
              } else if (ctx.path.includes('/read')) {
                content = `标记消息（ID: ${id}）为已读`;
              } else if (method === 'DELETE') {
                content = `删除${targetName}（ID: ${id}）`;
              } else if (method === 'POST') {
                const name = body.shop_name || body.name || body.title || body.username || '';
                content = `新增${targetName}`;
                if (name) content += `：${name}`;
              } else if (method === 'PUT') {
                content = `编辑${targetName}（ID: ${id}）`;
              } else {
                content = `${actionLabel}${targetName}（ID: ${id}）`;
              }

              // 获取真实IP
              const forwarded = ctx.headers['x-forwarded-for'];
              const ip = Array.isArray(forwarded) ? forwarded[0] : forwarded?.split(',')[0]?.trim();
              const clientIp = ip || ctx.headers['x-real-ip'] || ctx.ip || ctx.req.socket.remoteAddress || 'unknown';

              await operationLogService.create({
                operator_id: admin.id,
                operator_name: admin.name,
                operator_type: 'admin',
                action: actionLabel,
                target: targetName,
                content,
                ip: clientIp,
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
