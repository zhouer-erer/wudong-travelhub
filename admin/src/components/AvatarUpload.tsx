/**
 * 头像上传组件
 * 功能：
 * 1. 仅支持 JPG、PNG 格式
 * 2. 文件大小限制 2MB
 * 3. 上传前自动居中裁剪为 200x200
 * 4. 展示圆形头像预览
 */
import { useState, useRef } from 'react';
import { Upload, message, Avatar } from 'antd';
import { UserOutlined, LoadingOutlined, CameraOutlined } from '@ant-design/icons';
import type { UploadFile, UploadProps } from 'antd';
import request from '../utils/request';
import { getCropUrl, isOssUrl } from '../utils/ossImage';

/** 头像上传组件属性 */
interface AvatarUploadProps {
  /** 当前头像 URL */
  value?: string;
  /** 头像 URL 变更回调 */
  onChange?: (url: string) => void;
  /** 头像尺寸，默认 100 */
  size?: number;
}

/** 裁剪尺寸 */
const CROP_SIZE = 200;

export default function AvatarUpload({
  value,
  onChange,
  size = 100,
}: AvatarUploadProps) {
  const [loading, setLoading] = useState(false);
  const [fileList, setFileList] = useState<UploadFile[]>([]);

  /**
   * 将相对路径转换为完整 URL
   */
  const getFullUrl = (url: string) => {
    if (!url) return '';
    if (url.startsWith('http')) return url;
    return `${window.location.origin}${url}`;
  };

  /**
   * 使用 Canvas 居中裁剪图片为正方形
   * @param file 原始文件
   * @returns 裁剪后的 Blob
   */
  const cropImage = (file: File): Promise<Blob> => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          const canvas = document.createElement('canvas');
          canvas.width = CROP_SIZE;
          canvas.height = CROP_SIZE;
          const ctx = canvas.getContext('2d');
          if (!ctx) {
            reject(new Error('Canvas 不支持'));
            return;
          }

          // 计算居中裁剪区域
          const minDim = Math.min(img.width, img.height);
          const sx = (img.width - minDim) / 2;
          const sy = (img.height - minDim) / 2;

          // 绘制裁剪后的图片
          ctx.drawImage(img, sx, sy, minDim, minDim, 0, 0, CROP_SIZE, CROP_SIZE);

          canvas.toBlob(
            (blob) => {
              if (blob) resolve(blob);
              else reject(new Error('裁剪失败'));
            },
            'image/jpeg',
            0.9
          );
        };
        img.onerror = () => reject(new Error('图片加载失败'));
        img.src = e.target?.result as string;
      };
      reader.onerror = () => reject(new Error('文件读取失败'));
      reader.readAsDataURL(file);
    });
  };

  /**
   * 自定义上传逻辑
   * 上传前自动裁剪为 200x200
   */
  const customUpload = async (options: any) => {
    const { file, onSuccess, onError } = options;

    setLoading(true);

    try {
      // 裁剪图片
      const croppedBlob = await cropImage(file);
      const croppedFile = new File([croppedBlob], file.name, { type: 'image/jpeg' });

      // 上传裁剪后的图片
      const formData = new FormData();
      formData.append('files', croppedFile);

      const res: any = await request.post('/upload/image', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
        timeout: 60000,
      });

      if (res.code === 200) {
        onSuccess(res);
        message.success('上传成功');
      } else {
        onError(new Error(res.message));
        message.error(res.message || '上传失败');
      }
    } catch (err: any) {
      onError(err);
      message.error(err.message || '上传失败');
    } finally {
      setLoading(false);
    }
  };

  /**
   * 上传状态变更处理
   */
  const handleChange: UploadProps['onChange'] = ({ file, fileList: newFileList }) => {
    setFileList(newFileList);

    if (file.status === 'done') {
      const url = file.response?.data?.url;
      if (url) {
        onChange?.(url);
      }
    }
  };

  /**
   * 上传前校验
   * 仅支持 JPG、PNG，最大 2MB
   */
  const beforeUpload = (file: File) => {
    const allowedTypes = ['image/jpeg', 'image/png'];
    if (!allowedTypes.includes(file.type)) {
      message.error('头像仅支持 JPG、PNG 格式');
      return false;
    }

    const isLt2M = file.size / 1024 / 1024 < 2;
    if (!isLt2M) {
      message.error('头像大小不能超过 2MB');
      return false;
    }

    return true;
  };

  // 计算头像显示地址（OSS 用裁剪地址，本地用原地址）
  const avatarUrl = value
    ? isOssUrl(value)
      ? getCropUrl(value, CROP_SIZE)
      : getFullUrl(value)
    : undefined;

  return (
    <Upload
      name="files"
      customRequest={customUpload}
      fileList={fileList}
      onChange={handleChange}
      beforeUpload={beforeUpload}
      accept=".jpg,.jpeg,.png"
      showUploadList={false}
    >
      <div
        style={{
          position: 'relative',
          width: size,
          height: size,
          borderRadius: '50%',
          overflow: 'hidden',
          cursor: 'pointer',
          border: '2px dashed #d9d9d9',
          transition: 'border-color 0.3s',
        }}
        onMouseEnter={(e) => {
          (e.currentTarget as HTMLDivElement).style.borderColor = '#1F5FA8';
        }}
        onMouseLeave={(e) => {
          (e.currentTarget as HTMLDivElement).style.borderColor = '#d9d9d9';
        }}
      >
        <Avatar
          size={size}
          src={avatarUrl}
          icon={<UserOutlined />}
          style={{ backgroundColor: '#f5f5f5' }}
        />
        {/* 悬浮遮罩 */}
        <div
          style={{
            position: 'absolute',
            inset: 0,
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            background: 'rgba(0,0,0,0.5)',
            opacity: 0,
            transition: 'opacity 0.3s',
            color: '#fff',
            fontSize: 12,
          }}
          onMouseEnter={(e) => {
            (e.currentTarget as HTMLDivElement).style.opacity = '1';
          }}
          onMouseLeave={(e) => {
            (e.currentTarget as HTMLDivElement).style.opacity = '0';
          }}
        >
          {loading ? <LoadingOutlined style={{ fontSize: 20 }} /> : <CameraOutlined style={{ fontSize: 20 }} />}
          <span style={{ marginTop: 4 }}>{loading ? '上传中' : '更换头像'}</span>
        </div>
      </div>
    </Upload>
  );
}
