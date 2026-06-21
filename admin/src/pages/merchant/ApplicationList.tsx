/**
 * 商家入驻审核页面
 * 展示商家入驻申请列表，支持按状态（待审核/已通过/已驳回）分页查看
 * 提供申请详情查看、审核通过、驳回（需填写原因）操作
 */
import { useEffect, useState } from 'react';
import { Table, Button, Space, Input, Modal, Form, message, Tag, Tabs, Descriptions, Popconfirm, Alert } from 'antd';
import { SearchOutlined, CheckOutlined, CloseOutlined, EyeOutlined, WarningOutlined } from '@ant-design/icons';
import request from '../../utils/request';

/** 业务模块类型映射 */
const MODULE_OPTIONS: Record<string, string> = { clothing: '非遗商品（衣）', food: '餐饮美食（食）', stay: '住宿预订（住）', travel: '线路订票（行）' };

/** 状态标签页配置 */
const STATUS_TABS = [
  { key: 'pending', label: '待审核' },
  { key: 'approved', label: '已通过' },
  { key: 'rejected', label: '已驳回' },
];

/**
 * 商家入驻审核页面组件
 * 提供入驻申请的查看、通过、驳回功能
 */
export default function ApplicationListPage() {
  /** 申请列表数据 */
  const [data, setData] = useState<any[]>([]);
  /** 数据总条数 */
  const [total, setTotal] = useState(0);
  /** 当前页码 */
  const [page, setPage] = useState(1);
  /** 每页条数 */
  const [pageSize, setPageSize] = useState(20);
  /** 搜索关键词 */
  const [keyword, setKeyword] = useState('');
  /** 当前选中的状态标签 */
  const [status, setStatus] = useState('pending');
  /** 数据加载状态 */
  const [loading, setLoading] = useState(false);
  /** 详情弹窗显示状态 */
  const [detailOpen, setDetailOpen] = useState(false);
  /** 驳回弹窗显示状态 */
  const [rejectOpen, setRejectOpen] = useState(false);
  /** 当前操作的申请记录 */
  const [current, setCurrent] = useState<any>(null);
  /** 驳回原因表单实例 */
  const [rejectForm] = Form.useForm();
  /** 超时申请数据（从待审核列表中计算） */
  const [overdueList, setOverdueList] = useState<any[]>([]);

  /** 加载申请列表数据 */
  const loadData = async () => {
    setLoading(true);
    try {
      const res: any = await request.get('/merchant-applications/list', { params: { page, pageSize, keyword, status } });
      if (res.code === 200) {
        setData(res.data.list);
        setTotal(res.data.total);
        // 待审核状态下计算超时申请（>3天），用于页面警告条展示
        if (status === 'pending') {
          const now = Date.now();
          const THREE_DAYS = 3 * 24 * 60 * 60 * 1000;
          const overdue = res.data.list.filter((item: any) =>
            now - new Date(item.created_at).getTime() > THREE_DAYS
          ).map((item: any) => ({
            id: item.id,
            shopName: item.shop_name,
            daysOverdue: Math.floor((now - new Date(item.created_at).getTime()) / (24 * 60 * 60 * 1000)),
          }));
          setOverdueList(overdue);
        } else {
          setOverdueList([]);
        }
      }
    } finally { setLoading(false); }
  };

  useEffect(() => { setPage(1); }, [status]);
  useEffect(() => { loadData(); }, [page, pageSize, status, keyword]);

  /** 搜索操作，重置页码后加载数据 */
  const onSearch = () => { setPage(1); loadData(); };

  /**
   * 审核通过操作
   * @param record - 申请记录
   */
  const handleApprove = async (record: any) => {
    const res: any = await request.post(`/merchant-applications/approve/${record.id}`);
    if (res.code === 200) { message.success(res.message || '审核通过'); loadData(); }
    else message.error(res.message);
  };

  /**
   * 打开驳回弹窗
   * @param record - 要驳回的申请记录
   */
  const openReject = (record: any) => {
    setCurrent(record);
    rejectForm.resetFields();
    setRejectOpen(true);
  };

  /** 提交驳回操作，需填写驳回原因 */
  const handleReject = async () => {
    const values = await rejectForm.validateFields();
    const res: any = await request.post(`/merchant-applications/reject/${current.id}`, { reject_reason: values.reject_reason });
    if (res.code === 200) { message.success(res.message || '已驳回'); setRejectOpen(false); loadData(); }
    else message.error(res.message);
  };

  /**
   * 打开申请详情弹窗
   * @param record - 申请记录
   */
  const showDetail = (record: any) => { setCurrent(record); setDetailOpen(true); };

  /** 表格列配置 */
  const columns = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '申请人', dataIndex: 'applicant_name' },
    { title: '联系电话', dataIndex: 'applicant_phone' },
    { title: '店铺名称', dataIndex: 'shop_name' },
    { title: '申请模块', dataIndex: 'module_type', render: (v: string) => MODULE_OPTIONS[v] || v },
    { title: '状态', dataIndex: 'status', render: (v: string) => {
      const map: Record<string, { color: string; text: string }> = { pending: { color: 'processing', text: '待审核' }, approved: { color: 'success', text: '已通过' }, rejected: { color: 'error', text: '已驳回' } };
      const s = map[v] || { color: 'default', text: v };
      return <Tag color={s.color}>{s.text}</Tag>;
    }},
    { title: '申请时间', dataIndex: 'created_at' },
    {
      title: '操作', width: 220, fixed: 'right' as const, render: (_: any, record: any) => (
        <Space size="small" wrap>
          <Button type="link" size="small" icon={<EyeOutlined />} onClick={() => showDetail(record)}>查看</Button>
          {record.status === 'pending' && (
            <>
              <Popconfirm title={`确认通过「${record.shop_name}」的入驻申请？`} onConfirm={() => handleApprove(record)}>
                <Button type="link" size="small" icon={<CheckOutlined />} style={{ color: 'var(--color-terraced)' }}>通过</Button>
              </Popconfirm>
              <Button type="link" size="small" danger icon={<CloseOutlined />} onClick={() => openReject(record)}>驳回</Button>
            </>
          )}
        </Space>
      ),
    },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 'var(--spacing-md)', fontSize: 'var(--text-h2)', fontFamily: 'var(--font-family-heading)', fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>商家入驻审核</h2>
      {/* 超时提醒 */}
      {overdueList.length > 0 && (
        <Alert
          type="warning"
          showIcon
          icon={<WarningOutlined />}
          message={`有 ${overdueList.length} 条入驻申请超过3个工作日未处理`}
          description={
            <span>
              {overdueList.map((item: any, i: number) => (
                <span key={item.id}>
                  {i > 0 && '、'}
                  「{item.shopName}」（已超{item.daysOverdue}天）
                </span>
              ))}
              ，请尽快审核。
            </span>
          }
          style={{ marginBottom: 16 }}
          closable
        />
      )}
      {/* 状态标签页切换 */}
      <Tabs activeKey={status} onChange={setStatus} items={STATUS_TABS} />
      <Space style={{ marginBottom: 16 }}>
        <Input placeholder="搜索申请人/店铺名" value={keyword} onChange={e => setKeyword(e.target.value)} onPressEnter={onSearch} prefix={<SearchOutlined />} style={{ width: 240 }} />
        <Button type="primary" onClick={onSearch}>搜索</Button>
      </Space>
      {/* 申请列表表格 */}
      <Table rowKey="id" columns={columns} dataSource={data} loading={loading} scroll={{ x: 'max-content' }}
        pagination={{ current: page, pageSize, total, showSizeChanger: true, showTotal: t => `共 ${t} 条`, onChange: (p, ps) => { setPage(p); setPageSize(ps); } }} />
      {/* 申请详情弹窗 */}
      <Modal title="申请详情" open={detailOpen} onCancel={() => setDetailOpen(false)} footer={null} width={600}>
        {current && (
          <Descriptions column={1} bordered size="small">
            <Descriptions.Item label="申请人">{current.applicant_name}</Descriptions.Item>
            <Descriptions.Item label="联系电话">{current.applicant_phone}</Descriptions.Item>
            <Descriptions.Item label="店铺名称">{current.shop_name}</Descriptions.Item>
            <Descriptions.Item label="申请模块">{MODULE_OPTIONS[current.module_type] || current.module_type}</Descriptions.Item>
            <Descriptions.Item label="申请说明">{current.description || '-'}</Descriptions.Item>
            <Descriptions.Item label="审核状态">{current.status === 'approved' ? '已通过' : current.status === 'rejected' ? '已驳回' : '待审核'}</Descriptions.Item>
            {current.reject_reason && <Descriptions.Item label="驳回原因">{current.reject_reason}</Descriptions.Item>}
            <Descriptions.Item label="申请时间">{current.created_at}</Descriptions.Item>
          </Descriptions>
        )}
      </Modal>
      {/* 驳回原因弹窗 */}
      <Modal title="驳回申请" open={rejectOpen} onOk={handleReject} onCancel={() => setRejectOpen(false)} destroyOnClose>
        <Form form={rejectForm} layout="vertical">
          <Form.Item name="reject_reason" label="驳回原因" rules={[{ required: true, message: '请输入驳回原因' }]}>
            <Input.TextArea rows={4} placeholder="请输入驳回原因，将展示给申请人" />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
