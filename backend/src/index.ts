import { Bootstrap } from '@midwayjs/bootstrap';
import * as dotenv from 'dotenv';
import * as path from 'path';

// 加载 .env 文件
dotenv.config({ path: path.join(__dirname, '..', '.env') });

// dev 模式下由 midway-bin dev 内部调用 Bootstrap.run()，此处跳过避免端口冲突
// 生产模式下通过 npm start 启动 dist/index.js，需要主动调用
if (process.env.NODE_ENV !== 'local') {
  Bootstrap.run().then(() => {
    console.log('Wudong Admin Server started successfully');
  });
}
