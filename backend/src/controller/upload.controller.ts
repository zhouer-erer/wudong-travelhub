import { Controller, Post, Get, Body, Param, Inject } from '@midwayjs/decorator';
import * as fs from 'fs';
import * as path from 'path';
import { Context } from '@midwayjs/koa';
import { OssService } from '../service/oss.service';
import { getOssConfig } from '../config/oss.config';

/**
 * 文件上传控制器
 * 处理文件上传相关的 API 请求，支持本地存储和 OSS 云存储两种方式
 */
@Controller('/api/upload')
export class UploadController {

  @Inject()
  ctx: Context;

  @Inject()
  ossService: OssService;

  /**
   * 上传单张图片（支持本地存储和 OSS）
   * POST /api/upload/image
   * @returns 上传成功后的文件信息（URL、文件名、大小等）
   */
  @Post('/image')
  async uploadImage() {
    const files = (this.ctx.req as any).files;
    if (!files || files.length === 0) {
      return { code: 400, message: '请选择文件', data: null };
    }

    const file = files[0];
    const fileBuffer = file.buffer;   // memoryStorage 直接提供 buffer，无需读磁盘

    // 开发环境(NODE_ENV=local)跳过 OSS，直接存本地，速度更快
    if (process.env.NODE_ENV !== 'local' && this.ossService.isConfigured()) {
      try {
        // 上传到 OSS
        const result = await this.ossService.uploadFile(
          fileBuffer,
          file.originalname,
          file.mimetype
        );

        return {
          code: 200,
          message: '上传成功',
          data: {
            url: result.url,
            name: result.name,
            originalName: result.originalName,
            size: result.size,
            storage: 'oss',
          },
        };
      } catch (error) {
        console.error('OSS 上传失败，回退到本地存储:', error);
      }
    }

    // 本地存储（备用方案）
    const ext = path.extname(file.originalname).toLowerCase();
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(2, 8)}${ext}`;
    const uploadDir = path.join(process.cwd(), 'uploads');

    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }

    const filePath = path.join(uploadDir, fileName);
    fs.writeFileSync(filePath, fileBuffer);

    return {
      code: 200,
      message: '上传成功',
      data: {
        url: `/api/upload/file/${fileName}`,
        name: fileName,
        originalName: file.originalname,
        size: file.size,
        storage: 'local',
      },
    };
  }

  /**
   * 批量上传图片
   * POST /api/upload/images
   * @returns 上传成功后的文件信息数组
   */
  @Post('/images')
  async uploadImages() {
    const files = (this.ctx.req as any).files;
    if (!files || files.length === 0) {
      return { code: 400, message: '请选择文件', data: null };
    }

    const results = [];

    for (const file of files) {
      const fileBuffer = file.buffer;   // memoryStorage

      // 开发环境跳过 OSS，直接本地存储
      if (process.env.NODE_ENV !== 'local' && this.ossService.isConfigured()) {
        try {
          const result = await this.ossService.uploadFile(
            fileBuffer,
            file.originalname,
            file.mimetype
          );

          results.push({
            url: result.url,
            name: result.name,
            originalName: result.originalName,
            size: result.size,
            storage: 'oss',
          });
          continue;
        } catch (error) {
          console.error('OSS 上传失败，回退到本地存储:', error);
        }
      }

      // 本地存储
      const ext = path.extname(file.originalname).toLowerCase();
      const fileName = `${Date.now()}-${Math.random().toString(36).substring(2, 8)}${ext}`;
      const uploadDir = path.join(process.cwd(), 'uploads');

      if (!fs.existsSync(uploadDir)) {
        fs.mkdirSync(uploadDir, { recursive: true });
      }

      const filePath = path.join(uploadDir, fileName);
      fs.writeFileSync(filePath, fileBuffer);

      results.push({
        url: `/api/upload/file/${fileName}`,
        name: fileName,
        originalName: file.originalname,
        size: file.size,
        storage: 'local',
      });
    }

    return { code: 200, message: '上传成功', data: results };
  }

  /**
   * 获取本地上传的文件
   * GET /api/upload/file/:filename
   * @param filename - 文件名
   * @returns 文件流（根据扩展名设置正确的 MIME 类型）
   */
  @Get('/file/:filename')
  async getFile(@Param('filename') filename: string) {
    const filePath = path.join(process.cwd(), 'uploads', filename);
    if (!fs.existsSync(filePath)) {
      this.ctx.status = 404;
      return { code: 404, message: '文件不存在', data: null };
    }

    const ext = path.extname(filename).toLowerCase();
    const mimeTypes: Record<string, string> = {
      '.jpg': 'image/jpeg',
      '.jpeg': 'image/jpeg',
      '.png': 'image/png',
      '.gif': 'image/gif',
      '.webp': 'image/webp',
      '.svg': 'image/svg+xml',
    };

    this.ctx.type = mimeTypes[ext] || 'application/octet-stream';
    return fs.createReadStream(filePath);
  }

  /**
   * 获取 OSS 上传签名（用于前端直传）
   * POST /api/upload/oss-token
   * @param body - 可选参数 dir（上传目录）
   * @returns OSS 上传签名信息
   */
  @Post('/oss-token')
  async getOssToken(@Body() body: { dir?: string }) {
    // 检查是否配置了 OSS
    if (!this.ossService.isConfigured()) {
      return {
        code: 500,
        message: 'OSS 未配置',
        data: null,
      };
    }

    try {
      const signature = await this.ossService.getUploadSignature(body.dir);
      return { code: 200, message: 'success', data: signature };
    } catch (error) {
      return {
        code: 500,
        message: `获取签名失败: ${error.message}`,
        data: null,
      };
    }
  }

  /**
   * 删除 OSS 文件
   * POST /api/upload/delete
   * @param body - 包含 name（文件名）
   * @returns 操作结果
   */
  @Post('/delete')
  async deleteFile(@Body() body: { name: string }) {
    if (!body.name) {
      return { code: 400, message: '文件名不能为空', data: null };
    }

    // 检查是否配置了 OSS
    if (!this.ossService.isConfigured()) {
      return {
        code: 500,
        message: 'OSS 未配置',
        data: null,
      };
    }

    try {
      await this.ossService.deleteFile(body.name);
      return { code: 200, message: '删除成功', data: null };
    } catch (error) {
      return {
        code: 500,
        message: `删除失败: ${error.message}`,
        data: null,
      };
    }
  }
}
