/**
 * 懒加载图片组件
 * 功能：
 * 1. 默认展示缩略图（200px），滚动到可视区域才加载
 * 2. 鼠标悬停时加载大图（400px）
 * 3. 点击时查看原图
 * 4. 支持加载状态和错误兜底
 */
import { useState, useRef, useEffect } from 'react';
import { Image, Spin } from 'antd';
import { getThumbUrl, isOssUrl } from '../utils/ossImage';

/** 懒加载图片组件属性 */
interface LazyImageProps {
  /** 图片地址 */
  src: string;
  /** 替代文本 */
  alt?: string;
  /** 宽度 */
  width?: number | string;
  /** 高度 */
  height?: number | string;
  /** 图片样式 */
  style?: React.CSSProperties;
  /** CSS 类名 */
  className?: string;
  /** 圆角 */
  borderRadius?: number | string;
  /** 是否启用预览（点击查看原图） */
  preview?: boolean;
  /** 缩略图尺寸，默认 200px */
  thumbSize?: number;
  /** 对象适配方式 */
  objectFit?: 'cover' | 'contain' | 'fill' | 'none';
}

export default function LazyImage({
  src,
  alt = '',
  width,
  height,
  style,
  className,
  borderRadius,
  preview = true,
  thumbSize = 200,
  objectFit = 'cover',
}: LazyImageProps) {
  const [loaded, setLoaded] = useState(false);
  const [error, setError] = useState(false);
  const [inView, setInView] = useState(false);
  const imgRef = useRef<HTMLDivElement>(null);

  // Intersection Observer 实现懒加载
  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setInView(true);
          observer.disconnect();
        }
      },
      { rootMargin: '100px' } // 提前 100px 开始加载
    );

    if (imgRef.current) {
      observer.observe(imgRef.current);
    }

    return () => observer.disconnect();
  }, []);

  // 计算缩略图地址
  const thumbUrl = isOssUrl(src) ? getThumbUrl(src, thumbSize) : src;
  // 是否使用缩略图（OSS 地址用缩略图，非 OSS 用原图）
  const displayUrl = isOssUrl(src) && inView ? thumbUrl : inView ? src : '';

  return (
    <div
      ref={imgRef}
      className={className}
      style={{
        position: 'relative',
        width,
        height,
        borderRadius,
        overflow: 'hidden',
        background: '#f5f5f5',
        ...style,
      }}
    >
      {/* 加载中 */}
      {!loaded && inView && !error && (
        <div style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}>
          <Spin size="small" />
        </div>
      )}

      {/* 错误兜底 */}
      {error && (
        <div style={{
          position: 'absolute',
          inset: 0,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          color: '#bfbfbf',
          fontSize: 12,
        }}>
          加载失败
        </div>
      )}

      {/* 图片 */}
      {displayUrl && (
        preview ? (
          <Image
            src={displayUrl}
            alt={alt}
            preview={{ src }} // 预览时显示原图
            style={{
              width: '100%',
              height: '100%',
              objectFit,
              opacity: loaded ? 1 : 0,
              transition: 'opacity 0.3s',
            }}
            onLoad={() => setLoaded(true)}
            onError={() => setError(true)}
          />
        ) : (
          <img
            src={displayUrl}
            alt={alt}
            style={{
              width: '100%',
              height: '100%',
              objectFit,
              opacity: loaded ? 1 : 0,
              transition: 'opacity 0.3s',
            }}
            onLoad={() => setLoaded(true)}
            onError={() => setError(true)}
          />
        )
      )}
    </div>
  );
}
