/**
 * 应用路由配置文件
 * 定义所有页面路由，包含登录页、管理后台和商家后台
 * 未登录用户会被重定向到对应登录页
 *
 * 性能优化：使用 React.lazy 实现路由级代码分割，首屏只加载当前路由所需的代码
 */
import { lazy, Suspense } from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { Spin } from 'antd';
import MainLayout from './layouts/MainLayout';
import ErrorBoundary from './components/ErrorBoundary';

// ── 路由级懒加载（代码分割） ──
const LoginPage = lazy(() => import('./pages/Login'));
const DashboardPage = lazy(() => import('./pages/Dashboard'));
const AdminListPage = lazy(() => import('./pages/admin/AdminList'));
const RoleListPage = lazy(() => import('./pages/admin/RoleList'));
const UserListPage = lazy(() => import('./pages/user/UserList'));
const MerchantListPage = lazy(() => import('./pages/merchant/MerchantList'));
const ApplicationListPage = lazy(() => import('./pages/merchant/ApplicationList'));
const AnnouncementListPage = lazy(() => import('./pages/content/AnnouncementList'));
const CarouselListPage = lazy(() => import('./pages/content/CarouselList'));
const BannerListPage = lazy(() => import('./pages/content/BannerList'));
const RecommendationListPage = lazy(() => import('./pages/content/RecommendationList'));
const OrderListPage = lazy(() => import('./pages/order/OrderList'));
const RefundApprovalPage = lazy(() => import('./pages/order/RefundApproval'));
const AbnormalOrderPage = lazy(() => import('./pages/order/AbnormalOrder'));
const MessageListPage = lazy(() => import('./pages/message/MessageList'));
const TemplateListPage = lazy(() => import('./pages/message/TemplateList'));
const SettlementListPage = lazy(() => import('./pages/finance/SettlementList'));
const FinancialReportPage = lazy(() => import('./pages/finance/FinancialReport'));
const ReconciliationPage = lazy(() => import('./pages/finance/Reconciliation'));
const SystemConfigPage = lazy(() => import('./pages/system/SystemConfig'));
const SensitiveWordPage = lazy(() => import('./pages/system/SensitiveWordList'));
const OperationLogPage = lazy(() => import('./pages/system/OperationLog'));

// 商家后台页面（懒加载）
const MerchantLogin = lazy(() => import('./pages/merchant-portal/MerchantLogin'));
const MerchantLayout = lazy(() => import('./pages/merchant-portal/MerchantLayout'));
const MerchantDashboard = lazy(() => import('./pages/merchant-portal/MerchantDashboard'));
const ShopInfo = lazy(() => import('./pages/merchant-portal/ShopInfo'));
const AccountSettings = lazy(() => import('./pages/merchant-portal/AccountSettings'));
const MerchantMessages = lazy(() => import('./pages/merchant-portal/MerchantMessages'));
const MerchantStatistics = lazy(() => import('./pages/merchant-portal/MerchantStatistics'));

/** 路由级 loading 占位 */
const PageLoading = () => (
  <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
    <Spin size="large" tip="加载中..." />
  </div>
);

/**
 * 解析 JWT token 并检查是否过期
 * @returns token 有效且未过期返回 true，否则返回 false
 */
function isTokenValid(token: string): boolean {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    if (payload.exp && payload.exp * 1000 < Date.now()) {
      return false;
    }
    return true;
  } catch {
    return false;
  }
}

/**
 * 管理后台路由守卫
 * 检查 localStorage 中的 admin token 是否存在且未过期
 */
function AdminProtectedRoute({ children }: { children: React.ReactNode }) {
  const token = localStorage.getItem('token');
  if (!token || !isTokenValid(token)) {
    localStorage.removeItem('token');
    localStorage.removeItem('admin');
    return <Navigate to="/login" replace />;
  }
  return <>{children}</>;
}

/**
 * 商家后台路由守卫
 * 检查 localStorage 中的 merchant token 是否存在且未过期
 */
function MerchantProtectedRoute({ children }: { children: React.ReactNode }) {
  const token = localStorage.getItem('merchant_token');
  if (!token || !isTokenValid(token)) {
    localStorage.removeItem('merchant_token');
    localStorage.removeItem('merchant');
    return <Navigate to="/merchant-portal/login" replace />;
  }
  return <>{children}</>;
}

/**
 * 应用根组件
 * 配置全局路由表，使用 Suspense 包裹懒加载路由
 */
export default function App() {
  return (
    <ErrorBoundary>
      <Suspense fallback={<PageLoading />}>
        <Routes>
          {/* ========== 管理后台 ========== */}
          {/* 登录页 */}
          <Route path="/login" element={<LoginPage />} />
          {/* 管理后台 - 受保护路由 */}
          <Route
            path="/*"
            element={
              <AdminProtectedRoute>
                <MainLayout />
              </AdminProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/dashboard" replace />} />
            <Route path="dashboard" element={<DashboardPage />} />
            <Route path="admin/list" element={<AdminListPage />} />
            <Route path="role/list" element={<RoleListPage />} />
            <Route path="user/list" element={<UserListPage />} />
            <Route path="merchant/list" element={<MerchantListPage />} />
            <Route path="merchant/application" element={<ApplicationListPage />} />
            <Route path="content/announcement" element={<AnnouncementListPage />} />
            <Route path="content/carousel" element={<CarouselListPage />} />
            <Route path="content/banner" element={<BannerListPage />} />
            <Route path="content/recommendation" element={<RecommendationListPage />} />
            <Route path="order/list" element={<OrderListPage />} />
            <Route path="order/refund" element={<RefundApprovalPage />} />
            <Route path="order/abnormal" element={<AbnormalOrderPage />} />
            <Route path="message/list" element={<MessageListPage />} />
            <Route path="message/template" element={<TemplateListPage />} />
            <Route path="finance/list" element={<SettlementListPage />} />
            <Route path="finance/report" element={<FinancialReportPage />} />
            <Route path="finance/reconciliation" element={<ReconciliationPage />} />
            <Route path="system/config" element={<SystemConfigPage />} />
            <Route path="system/sensitive" element={<SensitiveWordPage />} />
            <Route path="system/log" element={<OperationLogPage />} />
          </Route>

          {/* ========== 商家后台 ========== */}
          {/* 商家登录页 */}
          <Route path="/merchant-portal/login" element={<MerchantLogin />} />
          {/* 商家后台 - 受保护路由 */}
          <Route
            path="/merchant-portal/*"
            element={
              <MerchantProtectedRoute>
                <MerchantLayout />
              </MerchantProtectedRoute>
            }
          >
            <Route index element={<Navigate to="/merchant-portal/dashboard" replace />} />
            <Route path="dashboard" element={<MerchantDashboard />} />
            <Route path="shop" element={<ShopInfo />} />
            <Route path="statistics" element={<MerchantStatistics />} />
            <Route path="messages" element={<MerchantMessages />} />
            <Route path="settings" element={<AccountSettings />} />
          </Route>
        </Routes>
      </Suspense>
    </ErrorBoundary>
  );
}
