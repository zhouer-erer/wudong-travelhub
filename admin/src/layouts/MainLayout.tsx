/**
 * 主布局组件
 * 管理后台的整体页面框架，包含侧边导航菜单、顶部用户操作栏和内容区域
 *
 * 设计特色：
 * - 侧边栏使用苗银蓝深色调（#0A1929），体现银饰冷冽质感
 * - Logo 区域底部有苗族蜡染几何纹样装饰带
 * - 内容区使用圆角卡片和品牌阴影
 */
import { useState, useEffect } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { Layout, Menu, Button, Dropdown, Space, message, Avatar } from 'antd';
import {
  DashboardOutlined,
  UserOutlined,
  SafetyCertificateOutlined,
  ShopOutlined,
  FileTextOutlined,
  PictureOutlined,
  AuditOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  ShoppingCartOutlined,
  MessageOutlined,
  DollarOutlined,
  SettingOutlined,
  TeamOutlined,
} from '@ant-design/icons';
import request from '../utils/request';

const { Header, Sider, Content } = Layout;

/** 侧边栏菜单配置项（permissionCode 对应 permission 表的 code 字段） */
const allMenuItems = [
  { key: '/dashboard', icon: <DashboardOutlined />, label: '数据看板', permissionCode: 'dashboard' },
  {
    key: 'admin-mgmt',
    icon: <SafetyCertificateOutlined />,
    label: '管理员管理',
    permissionCode: 'admin:manage',
    children: [
      { key: '/admin/list', label: '管理员列表', permissionCode: 'admin:list' },
      { key: '/role/list', label: '角色管理', permissionCode: 'admin:role' },
    ],
  },
  {
    key: 'user-mgmt',
    icon: <TeamOutlined />,
    label: '用户管理',
    permissionCode: 'user:manage',
    children: [
      { key: '/user/list', label: '用户列表', permissionCode: 'user:list' },
    ],
  },
  {
    key: 'merchant-mgmt',
    icon: <ShopOutlined />,
    label: '商家管理',
    permissionCode: 'merchant:manage',
    children: [
      { key: '/merchant/list', label: '商家列表', permissionCode: 'merchant:list' },
      { key: '/merchant/application', label: '入驻审核', permissionCode: 'merchant:application' },
    ],
  },
  {
    key: 'content-mgmt',
    icon: <FileTextOutlined />,
    label: '内容管理',
    permissionCode: 'content:manage',
    children: [
      { key: '/content/announcement', label: '公告管理', permissionCode: 'content:announcement' },
      { key: '/content/carousel', label: '轮播图管理', permissionCode: 'content:carousel' },
      { key: '/content/banner', label: '活动横幅', permissionCode: 'content:banner' },
      { key: '/content/recommendation', label: '推荐位管理', permissionCode: 'content:recommendation' },
    ],
  },
  {
    key: 'order-mgmt',
    icon: <ShoppingCartOutlined />,
    label: '订单管理',
    permissionCode: 'order:manage',
    children: [
      { key: '/order/list', label: '全局订单', permissionCode: 'order:list' },
      { key: '/order/refund', label: '退款审批', permissionCode: 'order:refund' },
      { key: '/order/abnormal', label: '异常订单', permissionCode: 'order:abnormal' },
    ],
  },
  {
    key: 'message-mgmt',
    icon: <MessageOutlined />,
    label: '消息中心',
    permissionCode: 'message:manage',
    children: [
      { key: '/message/list', label: '系统消息', permissionCode: 'message:list' },
      { key: '/message/template', label: '消息模板', permissionCode: 'message:template' },
    ],
  },
  {
    key: 'finance-mgmt',
    icon: <DollarOutlined />,
    label: '财务结算',
    permissionCode: 'finance:manage',
    children: [
      { key: '/finance/list', label: '结算列表', permissionCode: 'finance:list' },
      { key: '/finance/report', label: '财务报表', permissionCode: 'finance:report' },
      { key: '/finance/reconciliation', label: '对账管理', permissionCode: 'finance:reconciliation' },
    ],
  },
  {
    key: 'system-mgmt',
    icon: <SettingOutlined />,
    label: '系统设置',
    permissionCode: 'system:manage',
    children: [
      { key: '/system/config', label: '系统配置', permissionCode: 'system:config' },
      { key: '/system/sensitive', label: '敏感词库', permissionCode: 'system:sensitive' },
      { key: '/system/log', label: '操作日志', permissionCode: 'system:log' },
    ],
  },
];

/**
 * 主布局组件
 * 包含可折叠侧边栏、顶部导航和路由内容区域
 */
export default function MainLayout() {
  /** 侧边栏折叠状态 */
  const [collapsed, setCollapsed] = useState(false);
  /** 当前管理员拥有的权限码集合 */
  const [permissions, setPermissions] = useState<Set<string>>(new Set());
  const navigate = useNavigate();
  const location = useLocation();
  /** 从本地存储解析当前登录管理员信息 */
  const adminStr = localStorage.getItem('admin');
  const admin = adminStr ? JSON.parse(adminStr) : {};

  /** 加载当前管理员的权限列表 */
  const loadPermissions = async () => {
    try {
      const res: any = await request.get('/auth/permissions');
      if (res.code === 200 && Array.isArray(res.data)) {
        setPermissions(new Set(res.data));
      }
    } catch {
      // token 无效时不做处理
    }
  };

  useEffect(() => { loadPermissions(); }, []);

  /** 根据权限过滤菜单：有 permissionCode 的项必须在权限集合中；父菜单至少有一个子菜单可见才显示 */
  const filterByPermissions = (items: any[]): any[] => {
    return items
      .filter((item: any) => {
        if (item.permissionCode && !permissions.has(item.permissionCode)) return false;
        return true;
      })
      .map((item: any) => {
        if (item.children) {
          const filteredChildren = filterByPermissions(item.children);
          if (filteredChildren.length === 0 && !item.key.startsWith('/')) return null;
          return { ...item, children: filteredChildren };
        }
        return item;
      })
      .filter(Boolean);
  };

  const menuItems = filterByPermissions(allMenuItems);

  /** 退出登录，清除本地凭证并跳转登录页 */
  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('admin');
    message.success('已退出登录');
    navigate('/login');
  };

  /** 用户下拉菜单配置 */
  const userMenu = {
    items: [
      { key: 'logout', icon: <LogoutOutlined />, label: '退出登录', onClick: handleLogout },
    ],
  };

  /** 根据当前路径计算需要展开的菜单项 */
  const openKeys = menuItems
    .filter((item: any) => item.children?.some((c: any) => c.key === location.pathname))
    .map((item) => item.key);

  return (
    <Layout style={{ minHeight: '100vh' }}>
      <Sider
        trigger={null}
        collapsible
        collapsed={collapsed}
        width={220}
        style={{
          background: 'var(--color-sider-bg)',
          boxShadow: '2px 0 8px rgba(0,0,0,0.15)',
          position: 'relative',
          overflow: 'hidden',
        }}
      >
        {/* Logo 区域 */}
        <div style={{
          height: 64,
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          gap: collapsed ? 0 : 10,
          color: '#FFFFFF',
          fontSize: collapsed ? 16 : 18,
          fontWeight: 'var(--weight-bold)',
          fontFamily: 'var(--font-family-heading)',
          whiteSpace: 'nowrap',
          borderBottom: '1px solid rgba(255,255,255,0.08)',
          letterSpacing: '0.5px',
          padding: '0 16px',
        }}>
          <img
            src="/logo.png"
            alt="乌东文旅"
            style={{
              width: collapsed ? 32 : 36,
              height: collapsed ? 32 : 36,
              objectFit: 'contain',
              transition: 'all 0.2s',
            }}
          />
          {!collapsed && <span>乌东文旅管理后台</span>}
        </div>

        {/* 导航菜单 */}
        <Menu
          theme="dark"
          mode="inline"
          selectedKeys={[location.pathname]}
          defaultOpenKeys={openKeys}
          items={menuItems}
          onClick={({ key }) => navigate(key)}
          style={{
            borderRight: 0,
            background: 'transparent',
          }}
        />

        {/* 底部苗族蜡染装饰带 */}
        <div style={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          height: 6,
          background: `repeating-linear-gradient(
            90deg,
            var(--color-primary) 0px,
            var(--color-primary) 12px,
            transparent 12px,
            transparent 16px,
            var(--color-embroidery) 16px,
            var(--color-embroidery) 20px,
            transparent 20px,
            transparent 24px
          )`,
          opacity: 0.7,
        }} />
      </Sider>

      <Layout>
        {/* 顶部栏 */}
        <Header style={{
          background: 'var(--color-bg-card)',
          padding: '0 var(--spacing-lg)',
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          boxShadow: 'var(--shadow-light)',
          borderBottom: '1px solid var(--color-border-light)',
          height: 64,
        }}>
          <Button
            type="text"
            icon={collapsed ? <MenuUnfoldOutlined /> : <MenuFoldOutlined />}
            onClick={() => setCollapsed(!collapsed)}
            style={{ fontSize: 16, color: 'var(--color-text-secondary)' }}
          />
          <Dropdown menu={userMenu}>
            <Space style={{ cursor: 'pointer', color: 'var(--color-text-primary)' }}>
              <Avatar
                size="small"
                icon={<UserOutlined />}
                style={{ background: 'var(--color-primary)' }}
              />
              <span style={{ fontSize: 'var(--text-body)', fontWeight: 'var(--weight-medium)' }}>
                {admin.name || admin.username || '管理员'}
              </span>
            </Space>
          </Dropdown>
        </Header>

        {/* 内容区域 */}
        <Content style={{
          margin: 'var(--spacing-lg)',
          padding: 'var(--spacing-lg)',
          background: 'var(--color-bg-card)',
          borderRadius: 'var(--radius-lg)',
          minHeight: 280,
          boxShadow: 'var(--shadow-light)',
        }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
