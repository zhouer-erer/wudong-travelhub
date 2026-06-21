/**
 * 推荐位管理页面
 * 展示平台首页推荐位列表，支持新增、编辑、删除操作
 * 推荐内容类型包括：商品、餐厅、民宿、路线、游记
 */
import { useEffect, useState } from 'react';
import { Table, Button, Space, Input, InputNumber, Modal, Form, Select, message, Popconfirm, Tag, Alert } from 'antd';
import { PlusOutlined, EditOutlined, DeleteOutlined, InfoCircleOutlined } from '@ant-design/icons';
import request from '../../utils/request';

/** 内容类型选项配置 */
const CONTENT_TYPE_OPTIONS = [
  { label: '商品', value: 'product' },
  { label: '餐厅', value: 'restaurant' },
  { label: '民宿', value: 'homestay' },
  { label: '路线', value: 'route' },
  { label: '游记', value: 'travel_note' },
];

/** 内容类型颜色映射 */
const CONTENT_TYPE_COLORS: Record<string, string> = {
  product: 'blue',
  restaurant: 'orange',
  homestay: 'green',
  route: 'purple',
  travel_note: 'cyan',
};

/**
 * 推荐位管理页面组件
 * 提供推荐位的增删改查功能，通过排序值控制展示顺序
 */
export default function RecommendationListPage() {
  /** 推荐位列表数据 */
  const [data, setData] = useState<any[]>([]);
  /** 数据总条数 */
  const [total, setTotal] = useState(0);
  /** 当前页码 */
  const [page, setPage] = useState(1);
  /** 每页条数 */
  const [pageSize, setPageSize] = useState(20);
  /** 数据加载状态 */
  const [loading, setLoading] = useState(false);
  /** 新增/编辑弹窗显示状态 */
  const [modalOpen, setModalOpen] = useState(false);
  /** 当前编辑的记录，null 表示新增 */
  const [editing, setEditing] = useState<any>(null);
  /** 表单实例 */
  const [form] = Form.useForm();

  /** 加载推荐位列表数据 */
  const loadData = async () => {
    setLoading(true);
    try {
      const res: any = await request.get('/recommendations/list', { params: { page, pageSize } });
      if (res.code === 200) { setData(res.data.list); setTotal(res.data.total); }
    } finally { setLoading(false); }
  };

  useEffect(() => { loadData(); }, [page, pageSize]);

  /**
   * 打开新增/编辑弹窗
   * @param record - 编辑时传入已有记录，不传则为新增模式
   */
  const openModal = (record?: any) => {
    setEditing(record || null);
    if (record) form.setFieldsValue(record);
    else form.resetFields();
    setModalOpen(true);
  };

  /** 提交表单，根据 editing 状态决定调用新增或编辑接口 */
  const handleSubmit = async () => {
    const values = await form.validateFields();
    try {
      if (editing) {
        const res: any = await request.put(`/recommendations/update/${editing.id}`, values);
        if (res.code === 200) { message.success('更新成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      } else {
        const res: any = await request.post('/recommendations/create', values);
        if (res.code === 200) { message.success('创建成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      }
    } catch (err: any) { message.error(err?.response?.data?.message || '操作失败'); }
  };

  /**
   * 删除推荐位
   * @param id - 推荐位 ID
   */
  const handleDelete = async (id: number) => {
    const res: any = await request.delete(`/recommendations/delete/${id}`);
    if (res.code === 200) { message.success('删除成功'); loadData(); }
  };

  /** 表格列配置 */
  const columns = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '名称', dataIndex: 'name' },
    {
      title: '内容类型', dataIndex: 'content_type',
      render: (v: string) => v ? <Tag color={CONTENT_TYPE_COLORS[v] || 'default'}>{CONTENT_TYPE_OPTIONS.find(o => o.value === v)?.label || v}</Tag> : <Tag>待关联</Tag>,
    },
    { title: '内容ID', dataIndex: 'content_id', render: (v: number) => v || '-' },
    { title: '排序', dataIndex: 'sort_order' },
    { title: '状态', dataIndex: 'status', render: (v: number) => v === 1 ? <Tag color="green">启用</Tag> : <Tag color="default">禁用</Tag> },
    {
      title: '操作', width: 150, fixed: 'right' as const, render: (_: any, record: any) => (
        <Space size="small" wrap>
          <Button type="link" size="small" icon={<EditOutlined />} onClick={() => openModal(record)}>编辑</Button>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(record.id)}>
            <Button type="link" size="small" danger icon={<DeleteOutlined />}>删除</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 'var(--spacing-md)', fontSize: 'var(--text-h2)', fontFamily: 'var(--font-family-heading)', fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>推荐管理</h2>
      <Alert
        type="info"
        showIcon
        icon={<InfoCircleOutlined />}
        message="内容关联功能暂未开放"
        description="「内容类型」和「内容ID」用于关联商品、餐厅、民宿等业务数据，相关模块开发完成后即可启用。当前可先创建推荐位，这两个字段为选填。"
        style={{ marginBottom: 16 }}
      />
      <Space style={{ marginBottom: 16 }}>
        <Button type="primary" icon={<PlusOutlined />} onClick={() => openModal()}>新增推荐</Button>
      </Space>
      <Table rowKey="id" columns={columns} dataSource={data} loading={loading} scroll={{ x: 'max-content' }}
        pagination={{ current: page, pageSize, total, showSizeChanger: true, showTotal: t => `共 ${t} 条`, onChange: (p, ps) => { setPage(p); setPageSize(ps); } }} />
      <Modal title={editing ? '编辑推荐' : '新增推荐'} open={modalOpen} onOk={handleSubmit} onCancel={() => setModalOpen(false)} destroyOnHidden>
        <Form form={form} layout="vertical">
          <Form.Item name="name" label="名称" rules={[{ required: true }]}><Input placeholder="如：苗寨必去、热门民宿推荐" /></Form.Item>
          <Form.Item name="content_type" label="内容类型" tooltip="暂未开放，相关模块开发完成后可选"><Select options={CONTENT_TYPE_OPTIONS} allowClear placeholder="暂未开放，可不填" /></Form.Item>
          <Form.Item name="content_id" label="内容ID" tooltip="暂未开放，关联内容表建成后可填"><InputNumber min={1} style={{ width: '100%' }} placeholder="暂未开放，可不填" /></Form.Item>
          <Form.Item name="sort_order" label="排序" initialValue={0}><InputNumber min={0} style={{ width: '100%' }} /></Form.Item>
          <Form.Item name="status" label="状态" initialValue={1}><Select options={[{ label: '启用', value: 1 }, { label: '禁用', value: 0 }]} /></Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
