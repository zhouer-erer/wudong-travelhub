/**
 * 操作日志中间件
 * 自动记录管理员的写操作（POST/PUT/DELETE）
 */
import { Middleware, Inject } from '@midwayjs/decorator';
import { Context, NextFunction } from '@midwayjs/koa';
import { OperationLogService } from '../service/operation-log.service';

/** 操作类型中文映射 - 通俗易懂 */
const ACTION_MAP: Record<string, string> = {
  create: '新增',
  update: '编辑',
  delete: '删除',
  approve: '审核通过',
  reject: '审核驳回',
  ban: '封禁',
  unban: '解封',
  read: '标记已读',
  'force-offline': '强制下线',
  'refund-approve': '退款通过',
  'refund-reject': '退款驳回',
  close: '关闭',
};

/** 路径对应的业务对象中文名 */
const TARGET_MAP: Record<string, string> = {
  merchants: '商家',
  users: '用户',
  orders: '订单',
  'merchant-applications': '入驻申请',
  announcements: '公告',
  carousels: '轮播图',
  banners: '广告图',
  recommendations: '推荐内容',
  admins: '管理员账号',
  roles: '角色',
  'system-configs': '系统设置',
  'sensitive-words': '敏感词',
  'message-templates': '消息模板',
  'system-messages': '站内消息',
};

@Middleware()
export class OperationLogMiddleware {
  @Inject()
  operationLogService: OperationLogService;

  resolve() {
    return async (ctx: Context, next: NextFunction) => {
      const startTime = Date.now();

      // 只记录写操作
      const method = ctx.method.toUpperCase();
      if (!['POST', 'PUT', 'DELETE'].includes(method)) {
        await next();
        return;
      }

      // 跳过登录接口和文件上传
      if (ctx.path.includes('/login') || ctx.path.includes('/upload/file')) {
        await next();
        return;
      }

      await next();

      // 请求完成后记录日志
      try {
        const admin = ctx.state.admin;
        if (!admin) return;

        // 根据路径和方法推断操作类型和目标
        const { action, actionLabel } = this.getAction(method, ctx.path);
        const { target, targetName } = this.getTarget(ctx.path);

        // 获取操作内容描述
        const content = this.getContent(actionLabel, targetName, ctx.request.body, ctx.path, method);

        // 获取真实IP（支持反向代理）
        const ip = this.getClientIp(ctx);

        await this.operationLogService.create({
          operator_id: admin.id,
          operator_name: admin.name,
          operator_type: 'admin',
          action: actionLabel,
          target: targetName,
          content,
          ip,
          user_agent: ctx.headers['user-agent']?.substring(0, 500),
        } as any);
      } catch (error) {
        // 日志记录失败不影响正常业务
        console.error('操作日志记录失败:', error);
      }
    };
  }

  /**
   * 获取客户端真实IP
   */
  private getClientIp(ctx: Context): string {
    const forwarded = ctx.headers['x-forwarded-for'];
    const ip = Array.isArray(forwarded) ? forwarded[0] : forwarded?.split(',')[0]?.trim();
    return (
      ip ||
      ctx.headers['x-real-ip'] as string ||
      ctx.ip ||
      ctx.req.socket.remoteAddress ||
      'unknown'
    );
  }

  /**
   * 根据请求方法和路径推断操作类型
   */
  private getAction(method: string, path: string): { action: string; actionLabel: string } {
    let action = 'other';
    if (method === 'DELETE') action = 'delete';
    else if (path.includes('/refund-approve')) action = 'refund-approve';
    else if (path.includes('/refund-reject')) action = 'refund-reject';
    else if (path.includes('/force-offline')) action = 'force-offline';
    else if (path.includes('/approve')) action = 'approve';
    else if (path.includes('/reject')) action = 'reject';
    else if (path.includes('/ban')) action = 'ban';
    else if (path.includes('/unban')) action = 'unban';
    else if (path.includes('/close')) action = 'close';
    else if (path.includes('/read')) action = 'read';
    else if (method === 'POST') action = 'create';
    else if (method === 'PUT') action = 'update';

    return { action, actionLabel: ACTION_MAP[action] || action };
  }

  /**
   * 根据路径获取操作对象
   */
  private getTarget(path: string): { target: string; targetName: string } {
    const segments = path.split('/').filter(Boolean);
    // /api/xxx/... 中的 xxx
    const target = segments.length >= 2 ? segments[1] : path;
    return { target, targetName: TARGET_MAP[target] || target };
  }

  /**
   * 生成操作内容描述 - 通俗易懂
   */
  private getContent(actionLabel: string, targetName: string, body: any, path: string, method: string): string {
    // 尝试从请求体中提取关键信息
    const bodyInfo = body ? JSON.parse(JSON.stringify(body)) : {};
    delete bodyInfo.password;
    delete bodyInfo.password_hash;
    delete bodyInfo.token;

    // 提取ID
    const idMatch = path.match(/\/(\d+)(?:\/|$)/);
    const id = idMatch ? idMatch[1] : null;

    // 根据不同操作生成友好的描述
    let desc = '';

    // 特殊路径处理
    if (path.includes('/refund-approve')) {
      desc = `同意订单（ID: ${id}）的退款申请`;
    } else if (path.includes('/refund-reject')) {
      const reason = bodyInfo.reason || '未说明';
      desc = `拒绝订单（ID: ${id}）的退款申请，原因：${reason}`;
    } else if (path.includes('/force-offline')) {
      desc = `强制商家（ID: ${id}）下线`;
    } else if (path.includes('/approve')) {
      desc = `审核通过入驻申请（ID: ${id}），已自动创建商家账号`;
    } else if (path.includes('/reject')) {
      const reason = bodyInfo.reject_reason || '未说明';
      desc = `驳回入驻申请（ID: ${id}），原因：${reason}`;
    } else if (path.includes('/ban')) {
      desc = `封禁${targetName}（ID: ${id}）`;
    } else if (path.includes('/unban')) {
      desc = `解封${targetName}（ID: ${id}）`;
    } else if (path.includes('/close')) {
      desc = `关闭订单（ID: ${id}）`;
    } else if (path.includes('/read')) {
      desc = `标记消息（ID: ${id}）为已读`;
    } else if (method === 'DELETE') {
      desc = `删除${targetName}（ID: ${id}）`;
    } else if (method === 'POST') {
      // 新增操作，尝试提取关键字段
      const name = bodyInfo.shop_name || bodyInfo.name || bodyInfo.title || bodyInfo.username || '';
      desc = `新增${targetName}`;
      if (name) desc += `：${name}`;
      if (id) desc += `（ID: ${id}）`;
    } else if (method === 'PUT') {
      // 编辑操作，尝试提取修改的关键字段
      const changedFields = Object.keys(bodyInfo).filter(k => k !== 'id');
      desc = `编辑${targetName}（ID: ${id}）`;
      if (changedFields.length > 0 && changedFields.length <= 3) {
        desc += `，修改了：${changedFields.join('、')}`;
      }
    } else {
      desc = `${actionLabel}${targetName}`;
      if (id) desc += `（ID: ${id}）`;
    }

    return desc;
  }

  static getName() {
    return 'operationLog';
  }
}
