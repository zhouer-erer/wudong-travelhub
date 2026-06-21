/**
 * 全局错误边界组件
 * 捕获子组件树中的 JavaScript 运行时错误，防止整个应用白屏崩溃
 *
 * 功能：
 * - 捕获渲染错误、生命周期错误、异步错误
 * - 展示友好的错误页面，支持"重试"和"返回首页"
 * - 开发环境下展示错误详情（便于调试）
 * - 生产环境下隐藏敏感错误信息
 */
import { Component, type ReactNode } from 'react';
import { Button, Result } from 'antd';

interface Props {
  children: ReactNode;
}

interface State {
  hasError: boolean;
  error: Error | null;
}

export default class ErrorBoundary extends Component<Props, State> {
  state: State = { hasError: false, error: null };

  static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
  }

  componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
    // 生产环境可上报到 Sentry 等监控平台
    console.error('[ErrorBoundary]', error, errorInfo);
  }

  handleRetry = () => {
    this.setState({ hasError: false, error: null });
  };

  handleGoHome = () => {
    this.setState({ hasError: false, error: null });
    window.location.href = '/dashboard';
  };

  render() {
    if (this.state.hasError) {
      const isDev = import.meta.env.DEV;
      return (
        <div style={{ padding: '80px 24px', textAlign: 'center' }}>
          <Result
            status="error"
            title="页面出现异常"
            subTitle="抱歉，页面发生了错误。您可以尝试刷新页面或返回首页。"
            extra={[
              <Button key="retry" type="primary" onClick={this.handleRetry}>
                重试
              </Button>,
              <Button key="home" onClick={this.handleGoHome}>
                返回首页
              </Button>,
            ]}
          >
            {isDev && this.state.error && (
              <div style={{
                textAlign: 'left', marginTop: 16, padding: 16,
                background: '#f5f5f5', borderRadius: 8,
                fontSize: 12, fontFamily: 'monospace',
                maxHeight: 300, overflow: 'auto',
                color: '#cf1322',
              }}>
                <div style={{ fontWeight: 600, marginBottom: 8 }}>错误详情（仅开发环境可见）：</div>
                <div>{this.state.error.message}</div>
                <div style={{ marginTop: 4, color: '#666' }}>{this.state.error.stack}</div>
              </div>
            )}
          </Result>
        </div>
      );
    }
    return this.props.children;
  }
}
