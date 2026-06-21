/**
 * RBAC 权限校验中间件
 *
 * 职责：在认证中间件之后运行，检查当前管理员是否拥有访问目标 API 所需的权限码。
 *
 * 设计原则：
 * 1. 仅对管理员路由生效（商家路由、认证路由、公共路由自动跳过）
 * 2. 使用 Redis 缓存角色权限（TTL 5 分钟），减少 DB 查询
 * 3. 超级管理员（role.name='超级管理员' && type='system'）拥有全部权限，直接放行
 * 4. 路由不在映射表中的默认放行（fail-open），避免阻断未映射的新接口
 * 5. 权限不足返回 403，不暴露敏感信息
 */

import { Middleware } from '@midwayjs/decorator';
import { Context, NextFunction } from '@midwayjs/koa';
import { IMiddleware } from '@midwayjs/core';

/**
 * 路由前缀 → 所需权限码 映射表
 *
 * 匹配规则：ctx.path 以 key 开头即命中，取第一个命中的 key
 * 如果路由不在映射表中，默认放行（fail-open）
 */
const ROUTE_PERMISSION_MAP: Record<string, string> = {
  // ---- 管理员管理 ----
  '/api/admin': 'admin:list',
  '/api/roles': 'admin:role',
  '/api/permissions': 'admin:role',

  // ---- 用户管理 ----
  '/api/users': 'user:list',

  // ---- 商家管理 ----
  '/api/merchant-applications': 'merchant:application',
  '/api/merchants': 'merchant:list',

  // ---- 内容管理 ----
  '/api/announcements': 'content:announcement',
  '/api/carousels': 'content:carousel',
  '/api/activity-banners': 'content:banner',
  '/api/recommendations': 'content:recommendation',

  // ---- 订单管理 ----
  '/api/orders': 'order:list',

  // ---- 财务管理 ----
  '/api/financial-records': 'finance:list',

  // ---- 消息管理 ----
  '/api/system-messages': 'message:list',
  '/api/message-templates': 'message:template',

  // ---- 系统设置 ----
  '/api/system-configs': 'system:config',
  '/api/sensitive-words': 'system:sensitive',
  '/api/operation-logs': 'system:log',

  // ---- 数据看板 ----
  '/api/dashboard': 'dashboard',
};

/**
 * 不需要权限校验的路由前缀（白名单）
 * 这些路由由认证中间件处理，权限中间件直接跳过
 */
const SKIP_PREFIXES = [
  '/api/auth',           // 认证相关（登录、短信、权限查询）
  '/api/merchant-auth',  // 商家认证
  '/api/merchant-dashboard', // 商家仪表盘（商家自己的数据）
  '/api/upload',         // 文件上传（已由认证中间件控制）
  '/api/test',           // 健康检查
];

@Middleware()
export class PermissionGuard implements IMiddleware<Context, NextFunction> {
  resolve() {
    return async (ctx: Context, next: NextFunction) => {
      // 仅对 /api/ 路由生效
      if (!ctx.path.startsWith('/api/')) {
        await next();
        return;
      }

      // 白名单路由直接跳过
      if (SKIP_PREFIXES.some(prefix => ctx.path.startsWith(prefix))) {
        await next();
        return;
      }

      // 非管理员请求跳过（商家请求由认证中间件处理，此处不校验权限）
      if (!ctx.state.admin) {
        await next();
        return;
      }

      // 查找当前路由所需的权限码
      const requiredPermission = findRequiredPermission(ctx.path);
      if (!requiredPermission) {
        // 路由不在映射表中，放行（fail-open）
        await next();
        return;
      }

      const roleId = ctx.state.admin.role_id;

      try {
        // 从缓存或DB获取角色权限码列表
        const permissionCodes = await getPermissionCodes(ctx, roleId);

        // 超级管理员的 permissionCodes 包含全部权限，直接通过
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
        // 权限查询异常：记录日志，但不阻断请求（避免因缓存/DB故障导致全部接口不可用）
        console.error('[PermissionGuard] 权限查询异常，放行请求:', error.message);
      }

      await next();
    };
  }
}

/**
 * 根据请求路径查找所需的权限码
 * 匹配规则：最长前缀匹配（避免 /api/merchants 误匹配 /api/merchant-applications）
 */
function findRequiredPermission(path: string): string | null {
  let bestMatch = '';
  let bestPermission = '';

  for (const [prefix, permission] of Object.entries(ROUTE_PERMISSION_MAP)) {
    if (path.startsWith(prefix) && prefix.length > bestMatch.length) {
      bestMatch = prefix;
      bestPermission = permission;
    }
  }

  return bestPermission || null;
}

/**
 * 获取角色的权限码列表（带 Redis 缓存）
 * 缓存 key: rbac:permissions:{roleId}
 * 缓存 TTL: 300 秒（5 分钟）
 */
async function getPermissionCodes(ctx: Context, roleId: number): Promise<string[]> {
  const cacheKey = `rbac:permissions:${roleId}`;

  try {
    // 尝试从 Redis 缓存读取
    const redisService: any = await ctx.requestContext.getAsync('redisService');
    const cached = await redisService.get(cacheKey);
    if (cached) {
      return JSON.parse(cached);
    }

    // 缓存未命中，从 DB 查询
    const permissionService: any = await ctx.requestContext.getAsync('permissionService');
    const permissions = await permissionService.findByRoleId(roleId);
    const codes = permissions.map((p: any) => p.code);

    // 写入缓存（5 分钟 TTL）
    await redisService.set(cacheKey, JSON.stringify(codes), 'EX', 300);

    return codes;
  } catch (error: any) {
    // Redis 不可用时，降级为直接查 DB
    console.error('[PermissionGuard] Redis 缓存异常，降级查DB:', error.message);
    const permissionService: any = await ctx.requestContext.getAsync('permissionService');
    const permissions = await permissionService.findByRoleId(roleId);
    return permissions.map((p: any) => p.code);
  }
}
