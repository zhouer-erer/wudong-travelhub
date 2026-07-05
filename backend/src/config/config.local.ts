import { MidwayConfig } from '@midwayjs/core';

export default {
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
        logging: true,
      },
    },
  },
} as MidwayConfig;
