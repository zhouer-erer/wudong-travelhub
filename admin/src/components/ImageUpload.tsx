/**
 * 图片上传组件
 * 支持本地上传和 OSS 直传两种方式，提供上传进度、文件类型和大小校验
 */
import { useState, useEffect, useRef } from 'react';
import { Upload, message, Modal } from 'antd';
import { PlusOutlined, LoadingOutlined, EyeOutlined } from '@ant-design/icons';
import type { UploadFile, UploadProps } from 'antd';
import request from '../utils/request';

/** 图片上传组件属性 */
interface ImageUploadProps {
  /** 当前图片 URL */
  value?: string;
  /** 图片 URL 变更回调 */
  onChange?: (url: string) => void;
  /** 最大文件大小（MB），默认 5 */
  maxSize?: number;
  /** 接受的文件类型，默认 .jpg,.jpeg,.png,.gif,.webp */
  accept?: string;
  /** 是否使用 OSS 直传，默认 false */
  useOss?: boolean;
}

/**
 * 图片上传组件
 * 支持本地上传和 OSS 直传两种方式
 */
export default function ImageUpload({
  value,
  onChange,
  maxSize = 5,
  accept = '.jpg,.jpeg,.png,.gif,.webp',
  useOss = false,
}: ImageUploadProps) {
  /** 上传加载状态 */
  const [loading, setLoading] = useState(false);
  /** OSS 签名凭证 */
  const [ossToken, setOssToken] = useState<any>(null);
  /** 内部文件列表，由 antd Upload 管理，父组件 value 变化时同步 */
  const [fileList, setFileList] = useState<UploadFile[]>([]);
  /** 预览弹窗图片 URL */
  const [previewUrl, setPreviewUrl] = useState('');
  /** 预览弹窗显隐 */
  const [previewOpen, setPreviewOpen] = useState(false);
  /** 跟踪上一次 value，避免重复同步 */
  const prevValueRef = useRef(value);

  // 父组件 value 变化时同步到内部 fileList（用于初始回显和外部重置）
  // 不覆盖 antd 内部已有的文件条目（保持展示一致性）
  useEffect(() => {
    if (value !== prevValueRef.current) {
      prevValueRef.current = value;
      if (value) {
        const fullUrl = getFullUrl(value);
        const alreadyShown = fileList.some(f => f.url === fullUrl || f.response?.data?.url === value);
        if (!alreadyShown) {
          setFileList([{ uid: '-1', name: 'image', status: 'done', url: fullUrl }]);
        }
      } else {
        setFileList([]);
      }
    }
  }, [value, fileList]);

  // 首次加载时从 value 初始化 fileList
  useEffect(() => {
    if (value && fileList.length === 0) {
      setFileList(
        [{ uid: '-1', name: 'image', status: 'done', url: getFullUrl(value) }]
      );
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  // 获取 OSS 签名
  useEffect(() => {
    if (useOss) {
      fetchOssToken();
    }
  }, [useOss]);

  /** 获取 OSS 上传签名凭证 */
  const fetchOssToken = async () => {
    try {
      const res: any = await request.post('/upload/oss-token', {});
      if (res.code === 200) {
        setOssToken(res.data);
      }
    } catch (err) {
      console.error('获取 OSS 签名失败:', err);
    }
  };

  /**
   * 将相对路径转换为完整 URL 用于预览
   */
  const getFullUrl = (url: string) => {
    if (!url) return '';
    if (url.startsWith('http')) return url;
    return `${window.location.origin}${url}`;
  };

  /**
   * 自定义上传逻辑
   * 根据 useOss 参数选择 OSS 直传或本地服务器上传
   */
  const customUpload = async (options: any) => {
    const { file, onSuccess, onError, onProgress } = options;

    setLoading(true);

    if (useOss && ossToken) {
      // OSS 直传
      try {
        const ext = file.name.split('.').pop();
        const key = `${ossToken.dir}${Date.now()}-${Math.random().toString(36).substring(2, 8)}.${ext}`;

        const formData = new FormData();
        formData.append('key', key);
        formData.append('OSSAccessKeyId', ossToken.accessKeyId);
        formData.append('policy', ossToken.policy);
        formData.append('signature', ossToken.signature);
        formData.append('file', file);

        const xhr = new XMLHttpRequest();
        xhr.open('POST', ossToken.host, true);

        /** OSS 上传进度回调 */
        xhr.upload.onprogress = (e) => {
          if (e.total > 0) {
            onProgress({ percent: Math.round((e.loaded / e.total) * 100) });
          }
        };

        xhr.onload = () => {
          if (xhr.status === 200 || xhr.status === 204) {
            const url = `${ossToken.host}/${key}`;
            onSuccess({ code: 200, data: { url } });
            message.success('上传成功');
          } else {
            onError(new Error('上传失败'));
            message.error('上传失败');
          }
          setLoading(false);
        };

        xhr.onerror = () => {
          onError(new Error('上传失败'));
          message.error('上传失败');
          setLoading(false);
        };

        xhr.send(formData);
      } catch (err) {
        onError(err);
        message.error('上传失败');
        setLoading(false);
      }
    } else {
      // 本地上传
      try {
        const formData = new FormData();
        formData.append('files', file);

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
        message.error('上传失败');
      }
      setLoading(false);
    }
  };

  /**
   * 上传状态变更处理
   * 上传成功时回调 onChange 返回图片 URL，移除时回调空字符串
   * 使用 antd 内部管理的 fileList 保持展示一致性
   */
  const handleChange: UploadProps['onChange'] = ({ file, fileList: newFileList }) => {
    setFileList(newFileList);

    if (file.status === 'done') {
      const url = file.response?.data?.url;
      if (url) {
        onChange?.(url);
      }
    }
    if (file.status === 'removed') {
      onChange?.('');
    }
  };

  /**
   * 上传前校验
   * 验证文件类型是否为图片、文件大小是否超限
   */
  const beforeUpload = (file: File) => {
    const isImage = file.type.startsWith('image/');
    if (!isImage) {
      message.error('只能上传图片文件');
      return false;
    }
    const isLtMaxSize = file.size / 1024 / 1024 < maxSize;
    if (!isLtMaxSize) {
      message.error(`图片大小不能超过${maxSize}MB`);
      return false;
    }
    return true;
  };

  /**
   * 点击预览图片 — 弹窗展示，不跳转下载
   */
  const handlePreview = async (file: UploadFile) => {
    const url = file.url || file.response?.data?.url || getFullUrl(value || '');
    if (url) {
      setPreviewUrl(url);
      setPreviewOpen(true);
    }
  };

  return (
    <>
      <Upload
        name="files"
        customRequest={customUpload}
        fileList={fileList}
        onChange={handleChange}
        beforeUpload={beforeUpload}
        accept={accept}
        listType="picture-card"
        maxCount={1}
        onPreview={handlePreview}
        onRemove={() => {
          setFileList([]);
          onChange?.('');
        }}
      >
        {fileList.length === 0 && (
          <div>
            {loading ? <LoadingOutlined /> : <PlusOutlined />}
            <div style={{ marginTop: 8 }}>{loading ? '上传中...' : '上传图片'}</div>
          </div>
        )}
      </Upload>
      <Modal
        open={previewOpen}
        footer={null}
        onCancel={() => setPreviewOpen(false)}
        centered
        width={640}
        styles={{ body: { textAlign: 'center', padding: 0 } }}
      >
        {previewUrl && (
          <img
            alt="预览"
            src={previewUrl}
            style={{ maxWidth: '100%', maxHeight: '70vh', display: 'block' }}
          />
        )}
      </Modal>
    </>
  );
}
