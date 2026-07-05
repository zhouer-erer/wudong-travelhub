import { MidwayConfig } from '@midwayjs/core';

export default {
  keys: 'wudong-admin-session-key',

  koa: {
    port: parseInt(process.env.PORT || '3000', 10),
  },

  typeorm: {
    dataSource: {
      default: {
        type: 'mysql',
        host: process.env.DB_HOST || 'localhost',
        port: parseInt(process.env.DB_PORT || '3306', 10),
        database: process.env.DB_DATABASE || 'wudong_admin',
        username: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || 'zser',
        synchronize: false,
        logging: process.env.NODE_ENV !== 'production',
        entities: ['**/*.entity.ts', '**/*.entity.js'],
      },
    },
  },

  jwt: {
    secret: process.env.JWT_SECRET || 'wudong-admin-jwt-secret-2026',
    expiresIn: '7d',
  },

  // Swagger/OpenAPI 文档配置
  swagger: {
    title: '乌东文旅平台管理后台 API',
    description: '乌东文旅"衣食住行"综合服务平台管理后台 RESTful API 文档。包含管理后台、商家后台的全部接口。',
    version: '1.0.0',
    basePath: '/',
    tags: [
      { name: 'Auth', description: '管理员认证（登录/短信验证）' },
      { name: 'Admin', description: '管理员管理' },
      { name: 'Role', description: '角色管理' },
      { name: 'Permission', description: '权限管理（RBAC）' },
      { name: 'User', description: '用户管理' },
      { name: 'Merchant', description: '商家管理' },
      { name: 'MerchantApplication', description: '入驻审核' },
      { name: 'MerchantAuth', description: '商家认证' },
      { name: 'MerchantDashboard', description: '商家工作台' },
      { name: 'Announcement', description: '公告管理' },
      { name: 'Carousel', description: '轮播图管理' },
      { name: 'ActivityBanner', description: '活动横幅管理' },
      { name: 'Recommendation', description: '推荐位管理' },
      { name: 'Order', description: '订单管理' },
      { name: 'SystemMessage', description: '系统消息' },
      { name: 'MessageTemplate', description: '消息模板' },
      { name: 'FinancialRecord', description: '财务管理' },
      { name: 'SystemConfig', description: '系统配置' },
      { name: 'SensitiveWord', description: '敏感词管理' },
      { name: 'OperationLog', description: '操作日志' },
      { name: 'Dashboard', description: '数据看板' },
      { name: 'Upload', description: '文件上传' },
    ],
  },
} as MidwayConfig;
