/**
 * 商家数据统计页面
 * 使用 ECharts 展示专业的数据可视化图表
 * 支持时间范围筛选
 */
import { useEffect, useState, useRef } from 'react';
import { Card, Row, Col, Statistic, DatePicker, Spin, Empty, Tag } from 'antd';
import {
  ShoppingCartOutlined,
  DollarOutlined,
  UserOutlined,
  CheckCircleOutlined,
  ClockCircleOutlined,
  CarOutlined,
  ReloadOutlined,
  CloseCircleOutlined,
} from '@ant-design/icons';
import * as echarts from 'echarts';
import request from '../../utils/request';

const { RangePicker } = DatePicker;

/** 统计数据接口 */
interface StatusDistribution {
  status: string;
  label: string;
  count: number;
}

interface StatsData {
  totalSales: number;
  totalOrders: number;
  totalCustomers: number;
  pendingPayment: number;
  paid: number;
  shipped: number;
  completed: number;
  cancelled: number;
  refunding: number;
  salesTrend: { date: string; amount: number }[];
  orderTrend: { date: string; count: number }[];
  typeStats: { type: string; count: number; amount: number }[];
  statusDistribution: StatusDistribution[];
}

export default function MerchantStatistics() {
  const [loading, setLoading] = useState(true);
  const [dateRange, setDateRange] = useState<[string, string] | null>(null);
  const [stats, setStats] = useState<StatsData>({
    totalSales: 0,
    totalOrders: 0,
    totalCustomers: 0,
    pendingPayment: 0,
    paid: 0,
    shipped: 0,
    completed: 0,
    cancelled: 0,
    refunding: 0,
    salesTrend: [],
    orderTrend: [],
    typeStats: [],
    statusDistribution: [],
  });

  // 图表容器引用
  const salesChartRef = useRef<HTMLDivElement>(null);
  const orderChartRef = useRef<HTMLDivElement>(null);
  const typeChartRef = useRef<HTMLDivElement>(null);
  const statusChartRef = useRef<HTMLDivElement>(null);

  // 图表实例
  const salesChartInstance = useRef<echarts.ECharts | null>(null);
  const orderChartInstance = useRef<echarts.ECharts | null>(null);
  const typeChartInstance = useRef<echarts.ECharts | null>(null);
  const statusChartInstance = useRef<echarts.ECharts | null>(null);

  useEffect(() => {
    loadStats();
    return () => {
      // 组件卸载时销毁图表
      salesChartInstance.current?.dispose();
      orderChartInstance.current?.dispose();
      typeChartInstance.current?.dispose();
      statusChartInstance.current?.dispose();
    };
  }, []);

  useEffect(() => {
    loadStats();
  }, [dateRange]);

  useEffect(() => {
    if (!loading) {
      initCharts();
    }
  }, [stats, loading]);

  /** 窗口大小变化时重绘图表 */
  useEffect(() => {
    const handleResize = () => {
      salesChartInstance.current?.resize();
      orderChartInstance.current?.resize();
      typeChartInstance.current?.resize();
      statusChartInstance.current?.resize();
    };
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  /** 加载统计数据 */
  const loadStats = async () => {
    setLoading(true);
    try {
      const params: any = {};
      if (dateRange) {
        params.startDate = dateRange[0];
        params.endDate = dateRange[1];
      }
      const res: any = await request.get('/merchant-dashboard/statistics', { params });
      if (res.code === 200) {
        setStats(res.data);
      }
    } catch {
      /* 静默处理 */
    } finally {
      setLoading(false);
    }
  };

  /** 初始化所有图表 */
  const initCharts = () => {
    initSalesChart();
    initOrderChart();
    initTypeChart();
    initStatusChart();
  };

  /** 初始化销售趋势图 */
  const initSalesChart = () => {
    if (!salesChartRef.current) return;
    if (!salesChartInstance.current) {
      salesChartInstance.current = echarts.init(salesChartRef.current);
    }

    const option: echarts.EChartsOption = {
      tooltip: {
        trigger: 'axis',
        formatter: '{b}<br/>销售额：¥{c}',
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#eee',
        borderWidth: 1,
        textStyle: { color: '#333' },
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        top: '10%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: stats.salesTrend.map(item => item.date.slice(5)),
        axisLine: { lineStyle: { color: '#ddd' } },
        axisLabel: { color: '#666', fontSize: 11 },
      },
      yAxis: {
        type: 'value',
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: {
          color: '#666',
          formatter: (value: number) => {
            if (value >= 10000) return `${(value / 10000).toFixed(1)}万`;
            return value.toString();
          },
        },
        splitLine: { lineStyle: { color: '#f0f0f0' } },
      },
      series: [
        {
          type: 'line',
          data: stats.salesTrend.map(item => item.amount),
          smooth: true,
          symbol: 'circle',
          symbolSize: 8,
          lineStyle: {
            color: '#1F5FA8',
            width: 3,
          },
          itemStyle: {
            color: '#1F5FA8',
            borderColor: '#fff',
            borderWidth: 2,
          },
          areaStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: 'rgba(31, 95, 168, 0.3)' },
              { offset: 1, color: 'rgba(31, 95, 168, 0.02)' },
            ]),
          },
        },
      ],
    };

    salesChartInstance.current.setOption(option);
  };

  /** 初始化订单趋势图 */
  const initOrderChart = () => {
    if (!orderChartRef.current) return;
    if (!orderChartInstance.current) {
      orderChartInstance.current = echarts.init(orderChartRef.current);
    }

    const option: echarts.EChartsOption = {
      tooltip: {
        trigger: 'axis',
        formatter: '{b}<br/>订单数：{c}单',
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#eee',
        borderWidth: 1,
        textStyle: { color: '#333' },
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        top: '10%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        data: stats.orderTrend.map(item => item.date.slice(5)),
        axisLine: { lineStyle: { color: '#ddd' } },
        axisLabel: { color: '#666', fontSize: 11 },
      },
      yAxis: {
        type: 'value',
        axisLine: { show: false },
        axisTick: { show: false },
        axisLabel: { color: '#666' },
        splitLine: { lineStyle: { color: '#f0f0f0' } },
      },
      series: [
        {
          type: 'bar',
          data: stats.orderTrend.map(item => item.count),
          barWidth: '60%',
          itemStyle: {
            color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
              { offset: 0, color: '#E85D2F' },
              { offset: 1, color: '#E85D2F99' },
            ]),
            borderRadius: [4, 4, 0, 0],
          },
        },
      ],
    };

    orderChartInstance.current.setOption(option);
  };

  /** 初始化订单类型饼图 */
  const initTypeChart = () => {
    if (!typeChartRef.current) return;
    if (!typeChartInstance.current) {
      typeChartInstance.current = echarts.init(typeChartRef.current);
    }

    const colorMap: Record<string, string> = {
      '商品': '#1F5FA8',
      '餐饮': '#E85D2F',
      '住宿': '#6B8E3D',
      '门票': '#7A5230',
      '路线': '#8B5CF6',
    };

    // 过滤掉数量为0的数据
    const validData = stats.typeStats.filter(item => item.count > 0);

    const option: echarts.EChartsOption = {
      tooltip: {
        trigger: 'item',
        formatter: '{b}<br/>订单数：{c}单<br/>占比：{d}%',
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#eee',
        borderWidth: 1,
        textStyle: { color: '#333' },
      },
      legend: {
        orient: 'vertical',
        right: '5%',
        top: 'center',
        textStyle: { color: '#666' },
      },
      series: [
        {
          type: 'pie',
          radius: ['45%', '75%'],
          center: ['40%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 6,
            borderColor: '#fff',
            borderWidth: 3,
          },
          label: {
            show: validData.length <= 1, // 只有一个类型时显示标签
            position: 'center',
            formatter: '{b}\n{c}单',
            fontSize: 16,
            fontWeight: 'bold',
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 14,
              fontWeight: 'bold',
            },
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.2)',
            },
          },
          data: validData.map(item => ({
            name: item.type,
            value: item.count,
            itemStyle: { color: colorMap[item.type] || '#999' },
          })),
        },
      ],
    };

    typeChartInstance.current.setOption(option);
  };

  /** 初始化订单状态环形图 */
  const initStatusChart = () => {
    if (!statusChartRef.current) return;
    if (!statusChartInstance.current) {
      statusChartInstance.current = echarts.init(statusChartRef.current);
    }

    // 使用后端返回的真实状态分布
    const statusColorMap: Record<string, string> = {
      pending_payment: '#1F5FA8',
      paid: '#52c41a',
      shipped: '#722ed1',
      completed: '#6B8E3D',
      cancelled: '#999',
      closed: '#d9d9d9',
      refunding: '#E85D2F',
      refund_approved: '#faad14',
      refund_rejected: '#ff4d4f',
      refunded: '#ff7a45',
    };

    const statusData = (stats.statusDistribution || [])
      .filter(item => item.count > 0)
      .map(item => ({
        name: item.label,
        value: item.count,
        itemStyle: { color: statusColorMap[item.status] || '#999' },
      }));

    const option: echarts.EChartsOption = {
      tooltip: {
        trigger: 'item',
        formatter: '{b}<br/>订单数：{c}单<br/>占比：{d}%',
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#eee',
        borderWidth: 1,
        textStyle: { color: '#333' },
      },
      legend: {
        orient: 'vertical',
        right: '5%',
        top: 'center',
        textStyle: { color: '#666' },
      },
      series: [
        {
          type: 'pie',
          radius: ['50%', '75%'],
          center: ['40%', '50%'],
          avoidLabelOverlap: false,
          itemStyle: {
            borderRadius: 6,
            borderColor: '#fff',
            borderWidth: 3,
          },
          label: {
            show: statusData.length <= 1,
            position: 'center',
            formatter: '{b}\n{c}单',
            fontSize: 16,
            fontWeight: 'bold',
          },
          emphasis: {
            label: {
              show: true,
              fontSize: 14,
              fontWeight: 'bold',
            },
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(0, 0, 0, 0.2)',
            },
          },
          data: statusData,
        },
      ],
    };

    statusChartInstance.current.setOption(option);
  };

  /** 日期选择回调 */
  const handleDateChange = (dates: any, dateStrings: [string, string]) => {
    if (dates) {
      setDateRange(dateStrings);
    } else {
      setDateRange(null);
    }
  };

  /** 卡片样式 */
  const cardStyle = {
    borderRadius: 'var(--radius-lg)',
    boxShadow: 'var(--shadow-light)',
    border: 'none',
  };

  return (
    <Spin spinning={loading}>
      <div>
        <div style={{
          display: 'flex',
          justifyContent: 'space-between',
          alignItems: 'center',
          marginBottom: 'var(--spacing-lg)',
        }}>
          <h2 style={{
            margin: 0,
            fontSize: 'var(--text-h2)',
            fontFamily: 'var(--font-family-heading)',
            fontWeight: 'var(--weight-bold)',
            color: 'var(--color-text-primary)',
          }}>
            数据统计
          </h2>
          <RangePicker
            onChange={handleDateChange}
            style={{ width: 280 }}
            placeholder={['开始日期', '结束日期']}
          />
        </div>

        {/* 核心指标卡片 */}
        <Row gutter={[16, 16]} style={{ marginBottom: 'var(--spacing-lg)' }}>
          <Col xs={12} sm={8}>
            <Card style={cardStyle}>
              <Statistic
                title="总销售额"
                value={stats.totalSales}
                prefix={<DollarOutlined />}
                precision={2}
                valueStyle={{ color: '#1F5FA8', fontSize: 28 }}
              />
            </Card>
          </Col>
          <Col xs={12} sm={8}>
            <Card style={cardStyle}>
              <Statistic
                title="总订单数"
                value={stats.totalOrders}
                prefix={<ShoppingCartOutlined />}
                valueStyle={{ color: '#E85D2F', fontSize: 28 }}
              />
            </Card>
          </Col>
          <Col xs={12} sm={8}>
            <Card style={cardStyle}>
              <Statistic
                title="客户数"
                value={stats.totalCustomers}
                prefix={<UserOutlined />}
                valueStyle={{ color: '#6B8E3D', fontSize: 28 }}
              />
            </Card>
          </Col>
        </Row>

        {/* 订单状态统计 */}
        <Card
          title="订单状态分布"
          style={{ marginBottom: 'var(--spacing-lg)', ...cardStyle }}
        >
          <Row gutter={[16, 16]}>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #1F5FA8 0%, #1F5FA899 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <ClockCircleOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.pendingPayment}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>待支付</div>
              </div>
            </Col>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #52c41a 0%, #52c41a99 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <CheckCircleOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.paid}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>已支付</div>
              </div>
            </Col>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #722ed1 0%, #722ed199 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <CarOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.shipped}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>已发货</div>
              </div>
            </Col>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #6B8E3D 0%, #6B8E3D99 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <CheckCircleOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.completed}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>已完成</div>
              </div>
            </Col>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #999 0%, #99999999 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <CloseCircleOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.cancelled}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>已取消</div>
              </div>
            </Col>
            <Col xs={8} sm={4}>
              <div style={{ textAlign: 'center', padding: '12px 0' }}>
                <div style={{
                  width: 48, height: 48, borderRadius: '50%',
                  background: 'linear-gradient(135deg, #E85D2F 0%, #E85D2F99 100%)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  margin: '0 auto 12px',
                }}>
                  <ReloadOutlined style={{ fontSize: 24, color: '#fff' }} />
                </div>
                <div style={{ fontSize: 24, fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>
                  {stats.refunding}
                </div>
                <div style={{ fontSize: 'var(--text-caption)', color: 'var(--color-text-tertiary)', marginTop: 4 }}>退款中</div>
              </div>
            </Col>
          </Row>
        </Card>

        {/* 趋势图表 */}
        <Row gutter={[16, 16]} style={{ marginBottom: 'var(--spacing-lg)' }}>
          <Col xs={24} lg={12}>
            <Card title="销售趋势" style={cardStyle}>
              {stats.salesTrend.length > 0 ? (
                <div ref={salesChartRef} style={{ height: 320 }} />
              ) : (
                <Empty description="暂无数据" style={{ padding: '60px 0' }} />
              )}
            </Card>
          </Col>
          <Col xs={24} lg={12}>
            <Card title="订单趋势" style={cardStyle}>
              {stats.orderTrend.length > 0 ? (
                <div ref={orderChartRef} style={{ height: 320 }} />
              ) : (
                <Empty description="暂无数据" style={{ padding: '60px 0' }} />
              )}
            </Card>
          </Col>
        </Row>

        {/* 类型和状态分布 */}
        <Row gutter={[16, 16]}>
          <Col xs={24} lg={12}>
            <Card title="订单类型分布" style={cardStyle}>
              {stats.typeStats.length > 0 ? (
                <div ref={typeChartRef} style={{ height: 320 }} />
              ) : (
                <Empty description="暂无数据" style={{ padding: '60px 0' }} />
              )}
            </Card>
          </Col>
          <Col xs={24} lg={12}>
            <Card title="订单状态分布" style={cardStyle}>
              {stats.totalOrders > 0 ? (
                <div ref={statusChartRef} style={{ height: 320 }} />
              ) : (
                <Empty description="暂无数据" style={{ padding: '60px 0' }} />
              )}
            </Card>
          </Col>
        </Row>
      </div>
    </Spin>
  );
}
