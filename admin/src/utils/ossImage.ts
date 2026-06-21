/**
 * OSS 图片处理工具
 * 基于阿里云 OSS 图片处理（Image Processing）功能
 * 通过 URL 参数实现缩略图、压缩、裁剪等操作
 */

/** 缩略图尺寸预设 */
export const THUMB_SIZES = {
  sm: 200,   // 小缩略图
  md: 400,   // 中缩略图
  lg: 800,   // 大缩略图
} as const;

export type ThumbSize = keyof typeof THUMB_SIZES;

/**
 * 判断是否为 OSS 地址
 * @param url 图片地址
 * @returns 是否为 OSS 地址
 */
export function isOssUrl(url: string): boolean {
  if (!url) return false;
  return url.includes('aliyuncs.com') || url.includes('oss-');
}

/**
 * 生成缩略图 URL
 * @param url 原图地址
 * @param size 缩略图尺寸：sm(200px) / md(400px) / lg(800px) / 自定义数字
 * @returns 缩略图地址
 */
export function getThumbUrl(url: string, size: ThumbSize | number = 'sm'): string {
  if (!url || !isOssUrl(url)) return url;

  const width = typeof size === 'number' ? size : THUMB_SIZES[size];
  const separator = url.includes('?') ? '&' : '?';
  return `${url}${separator}x-oss-process=image/resize,w_${width}`;
}

/**
 * 生成压缩后的图片 URL
 * @param url 原图地址
 * @param quality 压缩质量 1-100，默认 80
 * @param maxSizeKB 最大文件大小（KB），默认 200
 * @returns 压缩后的图片地址
 */
export function getCompressedUrl(url: string, quality = 80, maxSizeKB = 200): string {
  if (!url || !isOssUrl(url)) return url;

  const separator = url.includes('?') ? '&' : '?';
  // 转为 WebP 格式 + 质量压缩，体积更小
  return `${url}${separator}x-oss-process=image/quality,q_${quality}/format,webp`;
}

/**
 * 生成裁剪后的图片 URL（头像等正方形场景）
 * @param url 原图地址
 * @param size 裁剪尺寸，默认 200
 * @returns 裁剪后的图片地址
 */
export function getCropUrl(url: string, size = 200): string {
  if (!url || !isOssUrl(url)) return url;

  const separator = url.includes('?') ? '&' : '?';
  // m_fill 模式：居中裁剪，保证填满指定尺寸
  return `${url}${separator}x-oss-process=image/resize,m_fill,w_${size},h_${size}`;
}

/**
 * 生成带懒加载的图片 URL（默认返回小缩略图）
 * @param url 原图地址
 * @param size 缩略图尺寸，默认 sm(200px)
 * @returns 缩略图地址
 */
export function getLazyThumbUrl(url: string, size: ThumbSize = 'sm'): string {
  return getThumbUrl(url, size);
}

/**
 * 组合多个 OSS 图片处理参数
 * @param url 原图地址
 * @param params 处理参数数组
 * @returns 处理后的图片地址
 */
export function buildOssUrl(url: string, ...params: string[]): string {
  if (!url || !isOssUrl(url)) return url;

  const separator = url.includes('?') ? '&' : '?';
  return `${url}${separator}x-oss-process=${params.join('/')}`;
}
