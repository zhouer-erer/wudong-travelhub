/**
 * HTTP 请求工具模块
 * 基于 axios 封装统一的请求实例，自动注入 token、处理 401 登录过期、格式化日期
 *
 * 安全特性：
 * - XSS 防护：请求体中自动转义 HTML 标签
 * - Token 自动注入：根据路由自动选择 admin / merchant token
 * - 401 统一处理：自动跳转登录页
 * - 日期格式化：自动将 ISO 日期转为本地格式
 */
import axios from 'axios';
import { message } from 'antd';

/** 创建 axios 实例，基础路径 /api，超时 10 秒 */
const request = axios.create({
  baseURL: '/api',
  timeout: 10000,
});

/**
 * XSS 转义：将字符串中的 HTML 特殊字符转义
 * 防止存储型 XSS 攻击（用户输入内容存入数据库后再渲染到页面）
 */
function escapeHtml(str: string): string {
  return str
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#x27;');
}

/**
 * 递归遍历请求体，对所有字符串值进行 XSS 转义
 * 排除密码、token 等不应被转义的字段
 */
const XSS_SKIP_KEYS = new Set(['password', 'token', 'smsToken', 'code', 'captcha']);
function sanitizeRequestData(data: any): any {
  if (data === null || data === undefined) return data;
  if (typeof data === 'string') return escapeHtml(data);
  if (Array.isArray(data)) return data.map(sanitizeRequestData);
  if (typeof data === 'object') {
    const result: Record<string, any> = {};
    for (const [key, value] of Object.entries(data)) {
      result[key] = XSS_SKIP_KEYS.has(key) ? value : sanitizeRequestData(value);
    }
    return result;
  }
  return data;
}

/**
 * 请求拦截器
 * - 根据当前路径自动注入对应 token（admin / merchant）
 * - 对 POST/PUT 请求体进行 XSS 转义
 */
request.interceptors.request.use((config) => {
  const isMerchant = window.location.pathname.startsWith('/merchant-portal');
  const token = isMerchant
    ? localStorage.getItem('merchant_token')
    : localStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  // 对写请求的 body 进行 XSS 转义（不转义 FormData / 文件上传）
  if (
    config.data &&
    typeof config.data === 'object' &&
    !(config.data instanceof FormData) &&
    ['post', 'put'].includes((config.method || '').toLowerCase())
  ) {
    config.data = sanitizeRequestData(config.data);
  }
  return config;
});

/**
 * 判断字符串是否为 ISO 8601 日期格式
 * 匹配：2026-06-20T12:16:48.000Z、2026-06-20T12:16:48Z 等
 */
const ISO_DATE_RE = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{1,6})?Z$/;

/** 将 ISO 日期字符串转为 yyyy-MM-dd HH:mm:ss */
function formatISODate(str: string): string {
  const d = new Date(str);
  if (isNaN(d.getTime())) return str;
  const pad = (n: number) => String(n).padStart(2, '0');
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}

/** 递归遍历对象/数组，将所有 ISO 日期字符串原地转换 */
function transformDates(obj: any): any {
  if (obj === null || obj === undefined) return obj;
  if (typeof obj === 'string') {
    return ISO_DATE_RE.test(obj) ? formatISODate(obj) : obj;
  }
  if (Array.isArray(obj)) {
    return obj.map(transformDates);
  }
  if (typeof obj === 'object') {
    for (const key of Object.keys(obj)) {
      obj[key] = transformDates(obj[key]);
    }
  }
  return obj;
}

/**
 * 响应拦截器
 * - 自动转换所有 ISO 日期字符串为 yyyy-MM-dd HH:mm:ss 格式
 * - 处理 401 登录过期自动跳转登录页，网络错误统一提示
 * - 根据当前路径判断跳转管理员登录还是商家登录
 */
request.interceptors.response.use(
  (response) => {
    const { data, config } = response;
    // 登录接口的 401 是密码错误，不跳转登录页
    const isLoginApi = config.url?.includes('/login');
    if (data.code === 401 && !isLoginApi) {
      message.error(data.message || '登录已过期，请重新登录');
      const isMerchant = window.location.pathname.startsWith('/merchant-portal');
      if (isMerchant) {
        localStorage.removeItem('merchant_token');
        localStorage.removeItem('merchant');
        window.location.href = '/merchant-portal/login';
      } else {
        localStorage.removeItem('token');
        localStorage.removeItem('admin');
        window.location.href = '/login';
      }
      return Promise.reject(new Error('未登录'));
    }
    // 递归转换所有 ISO 日期字符串
    return transformDates(data);
  },
  (error) => {
    if (error.response) {
      const { status, data } = error.response;
      if (status === 401) {
        const msg = data?.message || '登录已过期，请重新登录';
        const isMerchant = window.location.pathname.startsWith('/merchant-portal');
        message.error(msg, 2, () => {
          if (isMerchant) {
            localStorage.removeItem('merchant_token');
            localStorage.removeItem('merchant');
            window.location.href = '/merchant-portal/login';
          } else {
            localStorage.removeItem('token');
            localStorage.removeItem('admin');
            window.location.href = '/login';
          }
        });
        return Promise.reject(error);
      }
      message.error(data?.message || `请求失败 (${status})`);
    } else {
      message.error(error.message || '网络错误');
    }
    return Promise.reject(error);
  }
);

export default request;
