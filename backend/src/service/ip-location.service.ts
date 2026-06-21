import { Provide } from '@midwayjs/decorator';
import * as http from 'http';
import * as https from 'https';

/**
 * IP 地理位置服务
 * 通过 IP 查询城市信息，用于异地登录检测
 */
@Provide()
export class IpLocationService {
  /**
   * 根据 IP 查询地理位置
   * 使用 ip-api.com 免费接口（HTTP，每分钟45次限制）
   * @param ip IP 地址
   * @returns 城市信息，如 "贵州省凯里市"，查询失败返回 null
   */
  async getLocation(ip: string): Promise<string | null> {
    // 本地 IP 不查询
    if (!ip || ip === '127.0.0.1' || ip === '::1' || ip === '::ffff:127.0.0.1') {
      return null;
    }

    try {
      const url = `http://ip-api.com/json/${ip}?lang=zh-CN&fields=status,country,regionName,city`;
      const data = await this.httpGet(url);

      if (data.status === 'success') {
        const parts = [data.country, data.regionName, data.city].filter(Boolean);
        return parts.join('') || null;
      }

      return null;
    } catch (error) {
      console.error('[IP定位] 查询失败:', error.message);
      return null;
    }
  }

  /**
   * HTTP GET 请求封装
   * @param url 请求地址
   * @returns JSON 响应
   */
  private httpGet(url: string): Promise<any> {
    return new Promise((resolve, reject) => {
      const client = url.startsWith('https') ? https : http;
      client.get(url, { timeout: 3000 }, (res) => {
        let data = '';
        res.on('data', chunk => data += chunk);
        res.on('end', () => {
          try {
            resolve(JSON.parse(data));
          } catch (e) {
            reject(new Error('JSON 解析失败'));
          }
        });
      }).on('error', reject).on('timeout', function () { this.destroy(); reject(new Error('请求超时')); });
    });
  }
}
