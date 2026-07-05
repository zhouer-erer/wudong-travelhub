/**
 * 路由级权限守卫组件
 * 根据用户权限控制页面访问，无权限时显示 403 提示
 */
import { useState, useEffect } from 'react';
import { Result, Button, Spin } from 'antd';
import { useNavigate } from 'react-router-dom';
import request from '../utils/request';

/** 路由路径到权限码的映射 */
const ROUTE_PERMISSION_MAP: Record<string, string> = {
  '/dashboard': 'dashboard',
  '/admin/list': 'admin:list',
  '/role/list': 'admin:role',
  '/user/list': 'user:list',
  '/merchant/list': 'merchant:list',
  '/merchant/application': 'merchant:application',
  '/content/announcement': 'content:announcement',
  '/content/carousel': 'content:carousel',
  '/content/banner': 'content:banner',
  '/content/recommendation': 'content:recommendation',
  '/order/list': 'order:list',
  '/order/refund': 'order:refund',
  '/order/abnormal': 'order:abnormal',
  '/message/list': 'message:list',
  '/message/template': 'message:template',
  '/finance/list': 'finance:list',
  '/finance/report': 'finance:report',
  '/finance/reconciliation': 'finance:reconciliation',
  '/system/config': 'system:config',
  '/system/sensitive': 'system:sensitive',
  '/system/log': 'system:log',
};

interface PermissionGuardProps {
  /** 当前路由路径 */
  routePath: string;
  /** 子组件 */
  children: React.ReactNode;
}

export default function PermissionGuard({ routePath, children }: PermissionGuardProps) {
  const [permissions, setPermissions] = useState<Set<string>>(new Set());
  const [loading, setLoading] = useState(true);
  const [hasPermission, setHasPermission] = useState(false);
  const navigate = useNavigate();

  useEffect(() => {
    const loadPermissions = async () => {
      try {
        const res: any = await request.get('/auth/permissions');
        if (res.code === 200 && Array.isArray(res.data)) {
          const permSet = new Set<string>(res.data);
          setPermissions(permSet);

          // 检查当前路由是否需要权限
          const requiredPermission = ROUTE_PERMISSION_MAP[routePath];
          if (requiredPermission && !permSet.has(requiredPermission)) {
            setHasPermission(false);
          } else {
            setHasPermission(true);
          }
        } else {
          // 接口异常，拒绝访问
          setHasPermission(false);
        }
      } catch {
        // 请求失败，拒绝访问
        setHasPermission(false);
      } finally {
        setLoading(false);
      }
    };

    loadPermissions();
  }, [routePath]);

  if (loading) {
    return (
      <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
        <Spin size="large" tip="权限验证中..." />
      </div>
    );
  }

  if (!hasPermission) {
    return (
      <Result
        status="403"
        title="403"
        subTitle="抱歉，您没有权限访问此页面"
        extra={
          <Button type="primary" onClick={() => navigate('/dashboard')}>
            返回首页
          </Button>
        }
      />
    );
  }

  return <>{children}</>;
}
