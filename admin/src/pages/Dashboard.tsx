/**
 * 数据看板页面
 * 展示平台运营数据概览，包含统计卡片和 ECharts 图表
 * 数据来源：GET /api/dashboard/overview
 */
import { useEffect, useState } from 'react';
import { Card, Col, Row, Statistic, Table, Tag, Spin, Alert, Button } from 'antd';
import {
  UserOutlined,
  ShopOutlined,
  ShoppingCartOutlined,
  TeamOutlined,
  DollarOutlined,
  BankOutlined,
  ClockCircleOutlined,
  RiseOutlined,
  DownloadOutlined,
} from '@ant-design/icons';
import ReactECharts from 'echarts-for-react';
import request from '../utils/request';
import { MODULE_TYPE_MAP } from '../utils/format';
import { exportDashboardData } from '../utils/export';

/** ECharts 品牌色系 */
const CHART_COLORS = ['#1F5FA8', '#E85D2F', '#6B8E3D', '#D4A14B', '#7A5230', '#3B7BC5'];

/** 订单类型名称映射 */
const ORDER_TYPE_MAP: Record<string, string> = {
  product: '商品（衣）',
  food_order: '餐饮（食）',
  stay: '住宿（住）',
  ticket: '门票（行）',
  route: '路线（行）',
};

/** 商家模块名称映射 */
const MODULE_LABEL: Record<string, string> = {
  clothing: '非遗商品（衣）',
  food: '餐饮美食（食）',
  stay: '住宿预订（住）',
  travel: '线路订票（行）',
};

export default function DashboardPage() {
  const [data, setData] = useState<any>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => { loadData(); }, []);

  const loadData = async () => {
    setLoading(true);
    try {
      const res: any = await request.get('/dashboard/overview');
      if (res.code === 200) setData(res.data);
    } catch { /* ignore */ } finally { setLoading(false); }
  };

  const users = data?.users || {};
  const orders = data?.orders || {};
  const merchants = data?.merchants || {};
  const financial = data?.financial || {};
  const trend = data?.orderTrend || { days: [], counts: [] };
  const moduleDist = data?.moduleDistribution || [];
  const moduleGMV = data?.moduleGMV || [];
  const topMerchants = data?.topMerchants || [];
  const overdue = data?.overdueApplications || {};
  const conversionRates = data?.conversionRates || [];

  /** 商家模块分布饼图 */
  const pieOption = {
    title: { text: '商家模块分布', left: 'center', textStyle: { fontSize: 14, fontWeight: 500, color: '#1A1A1A' } },
    tooltip: { trigger: 'item' as const, formatter: '{a} <br/>{b}: {c} ({d}%)' },
    legend: { orient: 'vertical' as const, left: 'left', top: 'middle' },
    color: CHART_COLORS,
    series: [{
      name: '商家模块',
      type: 'pie',
      radius: '50%',
      data: moduleDist.map((d: any) => ({ value: d.count, name: MODULE_LABEL[d.module] || d.module })),
    }],
  };

  /** 近7天订单趋势折线图 */
  const lineOption = {
    title: { text: '近7天订单趋势', left: 'center', textStyle: { fontSize: 14, fontWeight: 500, color: '#1A1A1A' } },
    tooltip: { trigger: 'axis' as const },
    color: [CHART_COLORS[0]],
    xAxis: { type: 'category' as const, data: trend.days },
    yAxis: { type: 'value' as const },
    series: [{
      name: '订单数',
      type: 'line',
      smooth: true,
      data: trend.counts,
      areaStyle: {
        color: { type: 'linear', x: 0, y: 0, x2: 0, y2: 1,
          colorStops: [
            { offset: 0, color: 'rgba(31,95,168,0.30)' },
            { offset: 1, color: 'rgba(31,95,168,0.02)' },
          ],
        },
      },
      lineStyle: { width: 2 },
    }],
  };

  /** 各模块订单量与 GMV 柱状图 */
  const barOption = {
    title: { text: '各模块订单量与GMV', left: 'center', textStyle: { fontSize: 14, fontWeight: 500, color: '#1A1A1A' } },
    tooltip: { trigger: 'axis' as const },
    legend: { bottom: 0 },
    color: [CHART_COLORS[0], CHART_COLORS[3]],
    xAxis: { type: 'category' as const, data: moduleGMV.map((d: any) => ORDER_TYPE_MAP[d.type] || d.type) },
    yAxis: [
      { type: 'value' as const, name: '订单数', position: 'left' as const },
      { type: 'value' as const, name: 'GMV (元)', position: 'right' as const },
    ],
    series: [
      { name: '订单数', type: 'bar', data: moduleGMV.map((d: any) => d.count), barMaxWidth: 40 },
      { name: 'GMV', type: 'bar', yAxisIndex: 1, data: moduleGMV.map((d: any) => d.gmv), barMaxWidth: 40 },
    ],
  };

  /** TOP5 商家表格列配置 */
  const topColumns = [
    { title: '排名', render: (_: any, __: any, i: number) => i + 1, width: 60 },
    { title: '商家名称', dataIndex: 'shopName' },
    { title: '订单数', dataIndex: 'orderCount' },
    { title: 'GMV', dataIndex: 'gmv', render: (v: number) => `¥${Number(v).toFixed(2)}` },
  ];

  return (
    <Spin spinning={loading}>
      <div>
        {/* 超时提醒横幅 */}
        {overdue.count > 0 && (
          <Alert
            type="warning"
            showIcon
            closable
            style={{ marginBottom: 16 }}
            message={`有 ${overdue.count} 条入驻申请超过3个工作日未处理`}
            description={
              <span>
                {overdue.list?.map((item: any, i: number) => (
                  <span key={item.id}>
                    {i > 0 && '、'}
                    「{item.shopName}」（已超{item.daysOverdue}天）
                  </span>
                ))}
                ，请尽快审核。
              </span>
            }
          />
        )}

        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 }}>
          <h2 style={{ margin: 0, fontSize: 20, fontWeight: 600 }}>数据看板</h2>
          <Button icon={<DownloadOutlined />} onClick={() => exportDashboardData(data)} disabled={!data}>导出报表</Button>
        </div>

        {/* 核心指标卡片 - 第一行 */}
        <Row gutter={[16, 16]}>
          <Col xs={12} sm={6}>
            <Card><Statistic title="注册用户总数" value={users.total || 0} prefix={<TeamOutlined />} valueStyle={{ color: '#1F5FA8' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="今日活跃用户" value={users.todayActive || 0} prefix={<UserOutlined />} valueStyle={{ color: '#6B8E3D' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="今日新增用户" value={users.todayNew || 0} prefix={<RiseOutlined />} valueStyle={{ color: '#E85D2F' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="今日订单数" value={orders.todayCount || 0} prefix={<ShoppingCartOutlined />} valueStyle={{ color: '#D4A14B' }} /></Card>
          </Col>
        </Row>

        {/* 核心指标卡片 - 第二行 */}
        <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
          <Col xs={12} sm={6}>
            <Card><Statistic title="今日GMV" value={orders.todayGMV || 0} precision={2} prefix="¥" valueStyle={{ color: '#D4A14B' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="本月GMV" value={orders.monthGMV || 0} precision={2} prefix="¥" valueStyle={{ color: '#7A5230' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="商家总数 / 活跃" value={merchants.total || 0} suffix={`/ ${merchants.active || 0}`} prefix={<ShopOutlined />} valueStyle={{ color: '#6B8E3D' }} /></Card>
          </Col>
          <Col xs={12} sm={6}>
            <Card><Statistic title="待结算金额" value={financial.pendingSettlement || 0} precision={2} prefix="¥" valueStyle={{ color: '#E85D2F' }} /></Card>
          </Col>
        </Row>

        {/* 财务总览卡片 - 第三行 */}
        <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
          <Col xs={8}>
            <Card style={{ borderLeft: '3px solid #1F5FA8' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <DollarOutlined style={{ fontSize: 28, color: '#1F5FA8' }} />
                <div>
                  <div style={{ color: '#8C8C8C', fontSize: 13 }}>总流水</div>
                  <div style={{ fontSize: 22, fontWeight: 600 }}>¥{(financial.totalRevenue || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}</div>
                </div>
              </div>
            </Card>
          </Col>
          <Col xs={8}>
            <Card style={{ borderLeft: '3px solid #6B8E3D' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <BankOutlined style={{ fontSize: 28, color: '#6B8E3D' }} />
                <div>
                  <div style={{ color: '#8C8C8C', fontSize: 13 }}>平台收入（佣金）</div>
                  <div style={{ fontSize: 22, fontWeight: 600 }}>¥{(financial.platformIncome || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}</div>
                </div>
              </div>
            </Card>
          </Col>
          <Col xs={8}>
            <Card style={{ borderLeft: '3px solid #D4A14B' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
                <ClockCircleOutlined style={{ fontSize: 28, color: '#D4A14B' }} />
                <div>
                  <div style={{ color: '#8C8C8C', fontSize: 13 }}>商家收入</div>
                  <div style={{ fontSize: 22, fontWeight: 600 }}>¥{(financial.merchantIncome || 0).toLocaleString('zh-CN', { minimumFractionDigits: 2 })}</div>
                </div>
              </div>
            </Card>
          </Col>
        </Row>

        {/* 各模块转化率卡片 */}
        {conversionRates.length > 0 && (
          <Card title="各模块转化率（已完成 / 总订单）" size="small" style={{ marginTop: 16 }}>
            <Row gutter={[16, 16]}>
              {conversionRates.map((cr: any) => (
                <Col xs={12} sm={6} key={cr.type}>
                  <Card style={{ textAlign: 'center', borderColor: cr.rate >= 50 ? '#6B8E3D' : '#F5A623' }}>
                    <div style={{ fontSize: 13, color: '#8C8C8C', marginBottom: 8 }}>{ORDER_TYPE_MAP[cr.type] || cr.type}</div>
                    <div style={{ fontSize: 24, fontWeight: 600, color: cr.rate >= 50 ? '#6B8E3D' : '#F5A623' }}>{cr.rate}%</div>
                    <div style={{ fontSize: 12, color: '#BFBFBF', marginTop: 4 }}>已完成 {cr.completed} / 总 {cr.total}</div>
                  </Card>
                </Col>
              ))}
            </Row>
          </Card>
        )}

        {/* ECharts 图表 */}
        <Row gutter={[16, 16]} style={{ marginTop: 24 }}>
          <Col xs={24} lg={12}>
            <Card><ReactECharts option={pieOption} style={{ height: 300 }} /></Card>
          </Col>
          <Col xs={24} lg={12}>
            <Card><ReactECharts option={lineOption} style={{ height: 300 }} /></Card>
          </Col>
        </Row>

        <Row gutter={[16, 16]} style={{ marginTop: 16 }}>
          <Col xs={24}>
            <Card><ReactECharts option={barOption} style={{ height: 320 }} /></Card>
          </Col>
        </Row>

        {/* TOP5 商家 */}
        <Card title="TOP5 商家（按 GMV）" style={{ marginTop: 16 }}>
          <Table rowKey="merchantId" columns={topColumns} dataSource={topMerchants} pagination={false} size="small" />
        </Card>
      </div>
    </Spin>
  );
}

