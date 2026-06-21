/**
 * 商家后台布局组件
 * 提供商家后台的侧边栏导航和内容区域
 *
 * 与管理后台保持一致的品牌化视觉风格
 */
import { useState } from 'react';
import { Outlet, useNavigate, useLocation } from 'react-router-dom';
import { Layout, Menu, Button, Dropdown, Space, message, Avatar } from 'antd';
import {
  DashboardOutlined,
  ShopOutlined,
  SettingOutlined,
  LogoutOutlined,
  MenuFoldOutlined,
  MenuUnfoldOutlined,
  UserOutlined,
  BellOutlined,
  BarChartOutlined,
} from '@ant-design/icons';

const { Header, Sider, Content } = Layout;

const menuItems = [
  { key: '/merchant-portal/dashboard', icon: <DashboardOutlined />, label: '工作台' },
  { key: '/merchant-portal/shop', icon: <ShopOutlined />, label: '店铺信息' },
  { key: '/merchant-portal/statistics', icon: <BarChartOutlined />, label: '数据统计' },
  { key: '/merchant-portal/messages', icon: <BellOutlined />, label: '消息通知' },
  { key: '/merchant-portal/settings', icon: <SettingOutlined />, label: '账号设置' },
];

export default function MerchantLayout() {
  const [collapsed, setCollapsed] = useState(false);
  const navigate = useNavigate();
  const location = useLocation();
  const merchantStr = localStorage.getItem('merchant');
  const merchant = merchantStr ? JSON.parse(merchantStr) : {};

  const handleLogout = () => {
    localStorage.removeItem('merchant_token');
    localStorage.removeItem('merchant');
    message.success('已退出登录');
    navigate('/merchant-portal/login');
  };

  const userMenu = {
    items: [
      { key: 'logout', icon: <LogoutOutlined />, label: '退出登录', onClick: handleLogout },
    ],
  };

  return (
    <Layout style={{ height: '100vh', overflow: 'hidden' }}>
      <Sider
        trigger={null}
        collapsible
        collapsed={collapsed}
        style={{
          background: 'var(--color-sider-bg)',
          boxShadow: '2px 0 8px rgba(0,0,0,0.15)',
          overflow: 'hidden',
        }}
      >
        {/* 内部 flex 容器，确保装饰带始终固定在侧边栏最底部 */}
        <div style={{ display: 'flex', flexDirection: 'column', height: '100%' }}>
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
            flexShrink: 0,
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
            {!collapsed && <span>商家后台</span>}
          </div>

          {/* 导航菜单 - 可滚动区域 */}
          <div style={{ flex: 1, overflow: 'auto' }}>
            <Menu
              theme="dark"
              mode="inline"
              selectedKeys={[location.pathname]}
              items={menuItems}
              onClick={({ key }) => navigate(key)}
              style={{ borderRight: 0, background: 'transparent' }}
            />
          </div>

          {/* 底部苗族蜡染装饰带 - 固定在侧边栏最底部 */}
          <div style={{
            flexShrink: 0,
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
        </div>
      </Sider>

      <Layout style={{ display: 'flex', flexDirection: 'column', overflow: 'hidden' }}>
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
          lineHeight: '64px',
          flexShrink: 0,
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
                style={{ background: 'var(--color-terraced)' }}
              />
              <span style={{ fontSize: 'var(--text-body)', fontWeight: 'var(--weight-medium)' }}>
                {merchant.shop_name || merchant.username || '商家'}
              </span>
            </Space>
          </Dropdown>
        </Header>

        {/* 内容区域 - 可滚动 */}
        <Content style={{
          flex: 1,
          overflow: 'auto',
          margin: 'var(--spacing-lg)',
          padding: 'var(--spacing-lg)',
          background: 'var(--color-bg-card)',
          borderRadius: 'var(--radius-lg)',
          boxShadow: 'var(--shadow-light)',
        }}>
          <Outlet />
        </Content>
      </Layout>
    </Layout>
  );
}
