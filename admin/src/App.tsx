/**
 * 应用路由配置文件
 * 定义所有页面路由，包含登录页、管理后台和商家后台
 * 未登录用户会被重定向到对应登录页
 */
import { Routes, Route, Navigate } from 'react-router-dom';
import MainLayout from './layouts/MainLayout';
import LoginPage from './pages/Login';
import DashboardPage from './pages/Dashboard';
import AdminListPage from './pages/admin/AdminList';
import RoleListPage from './pages/admin/RoleList';
import UserListPage from './pages/user/UserList';
import MerchantListPage from './pages/merchant/MerchantList';
import ApplicationListPage from './pages/merchant/ApplicationList';
import AnnouncementListPage from './pages/content/AnnouncementList';
import CarouselListPage from './pages/content/CarouselList';
import BannerListPage from './pages/content/BannerList';
import RecommendationListPage from './pages/content/RecommendationList';
import OrderListPage from './pages/order/OrderList';
import RefundApprovalPage from './pages/order/RefundApproval';
import AbnormalOrderPage from './pages/order/AbnormalOrder';
import MessageListPage from './pages/message/MessageList';
import TemplateListPage from './pages/message/TemplateList';
import SettlementListPage from './pages/finance/SettlementList';
import FinancialReportPage from './pages/finance/FinancialReport';
import ReconciliationPage from './pages/finance/Reconciliation';
import SystemConfigPage from './pages/system/SystemConfig';
import SensitiveWordPage from './pages/system/SensitiveWordList';
import OperationLogPage from './pages/system/OperationLog';

// 商家后台页面
import MerchantLogin from './pages/merchant-portal/MerchantLogin';
import MerchantLayout from './pages/merchant-portal/MerchantLayout';
import MerchantDashboard from './pages/merchant-portal/MerchantDashboard';
import ShopInfo from './pages/merchant-portal/ShopInfo';
import AccountSettings from './pages/merchant-portal/AccountSettings';
import MerchantMessages from './pages/merchant-portal/MerchantMessages';
import MerchantStatistics from './pages/merchant-portal/MerchantStatistics';

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
 * 配置全局路由表
 */
export default function App() {
  return (
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
  );
}
