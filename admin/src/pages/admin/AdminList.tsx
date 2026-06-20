/**
 * 管理员列表页面
 * 展示管理员账号列表，支持按用户名/姓名搜索、新增、编辑、删除操作
 */
import { useEffect, useState } from 'react';
import { Table, Button, Space, Input, Modal, Form, Select, message, Popconfirm, Tag, Tooltip } from 'antd';
import { PlusOutlined, SearchOutlined, EditOutlined, DeleteOutlined } from '@ant-design/icons';
import request from '../../utils/request';

/**
 * 管理员列表页面组件
 * 提供管理员账号的增删改查功能，支持分页和关键词搜索
 */
export default function AdminListPage() {
  /** 管理员列表数据 */
  const [data, setData] = useState<any[]>([]);
  /** 数据总条数 */
  const [total, setTotal] = useState(0);
  /** 当前页码 */
  const [page, setPage] = useState(1);
  /** 每页条数 */
  const [pageSize, setPageSize] = useState(20);
  /** 搜索关键词 */
  const [keyword, setKeyword] = useState('');
  /** 数据加载状态 */
  const [loading, setLoading] = useState(false);
  /** 新增/编辑弹窗显示状态 */
  const [modalOpen, setModalOpen] = useState(false);
  /** 当前编辑的记录，null 表示新增 */
  const [editing, setEditing] = useState<any>(null);
  /** 表单实例 */
  const [form] = Form.useForm();
  /** 角色列表，用于角色下拉选择 */
  const [roles, setRoles] = useState<any[]>([]);

  /** 加载管理员列表数据 */
  const loadData = async () => {
    setLoading(true);
    try {
      const res: any = await request.get('/admin/list', { params: { page, pageSize, keyword } });
      if (res.code === 200) {
        setData(res.data.list);
        setTotal(res.data.total);
      }
    } finally {
      setLoading(false);
    }
  };

  /** 加载角色列表，用于新增/编辑时选择角色 */
  const loadRoles = async () => {
    const res: any = await request.get('/roles/list', { params: { page: 1, pageSize: 100 } });
    if (res.code === 200) setRoles(res.data.list);
  };

  useEffect(() => { loadData(); }, [page, pageSize, keyword]);
  useEffect(() => { loadRoles(); }, []);

  /** 搜索操作，重置页码后加载数据 */
  const onSearch = () => { setPage(1); loadData(); };

  /**
   * 打开新增/编辑弹窗
   * @param record - 编辑时传入已有记录，不传则为新增模式
   */
  const openModal = (record?: any) => {
    setEditing(record || null);
    if (record) {
      form.setFieldsValue(record);
    } else {
      form.resetFields();
    }
    setModalOpen(true);
  };

  /** 提交表单，根据 editing 状态决定调用新增或编辑接口 */
  const handleSubmit = async () => {
    const values = await form.validateFields();
    try {
      if (editing) {
        const res: any = await request.put(`/admin/update/${editing.id}`, values);
        if (res.code === 200) { message.success('更新成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      } else {
        const res: any = await request.post('/admin/create', values);
        if (res.code === 200) { message.success('创建成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      }
    } catch (err: any) {
      message.error(err?.response?.data?.message || '操作失败');
    }
  };

  /**
   * 删除管理员
   * @param id - 管理员 ID
   */
  const handleDelete = async (id: number) => {
    const res: any = await request.delete(`/admin/delete/${id}`);
    if (res.code === 200) { message.success('删除成功'); loadData(); }
  };

  /** 表格列配置 */
  const columns = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '用户名', dataIndex: 'username' },
    { title: '姓名', dataIndex: 'name' },
    { title: '手机号', dataIndex: 'phone' },
    { title: '角色', dataIndex: 'role_id', render: (id: number) => roles.find(r => r.id === id)?.name || '-' },
    { title: '状态', dataIndex: 'status', render: (v: number) => v === 1 ? <Tag color="green">启用</Tag> : <Tag color="red">禁用</Tag> },
    { title: '最后登录', dataIndex: 'last_login_at' },
    {
      title: '操作', width: 160, fixed: 'right' as const, render: (_: any, record: any) => {
        const role = roles.find(r => r.id === record.role_id);
        const isSystemRole = role?.type === 'system';
        return (
          <Space>
            <Button type="link" icon={<EditOutlined />} onClick={() => openModal(record)}>编辑</Button>
            {isSystemRole ? (
              <Tooltip title="系统内置角色，不允许删除">
                <Button type="link" danger icon={<DeleteOutlined />} disabled>删除</Button>
              </Tooltip>
            ) : (
              <Popconfirm title="确认删除？" onConfirm={() => handleDelete(record.id)}>
                <Button type="link" danger icon={<DeleteOutlined />}>删除</Button>
              </Popconfirm>
            )}
          </Space>
        );
      },
    },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 'var(--spacing-md)', fontSize: 'var(--text-h2)', fontFamily: 'var(--font-family-heading)', fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>管理员列表</h2>
      <Space style={{ marginBottom: 16 }}>
        <Input placeholder="搜索用户名/姓名" value={keyword} onChange={e => setKeyword(e.target.value)} onPressEnter={onSearch} prefix={<SearchOutlined />} style={{ width: 240 }} />
        <Button type="primary" onClick={onSearch}>搜索</Button>
        <Button type="primary" icon={<PlusOutlined />} onClick={() => openModal()}>新增管理员</Button>
      </Space>
      <Table rowKey="id" columns={columns} dataSource={data} loading={loading} scroll={{ x: 'max-content' }}
        pagination={{ current: page, pageSize, total, showSizeChanger: true, showTotal: t => `共 ${t} 条`, onChange: (p, ps) => { setPage(p); setPageSize(ps); } }} />
      <Modal title={editing ? '编辑管理员' : '新增管理员'} open={modalOpen} onOk={handleSubmit} onCancel={() => setModalOpen(false)} destroyOnClose>
        <Form form={form} layout="vertical">
          <Form.Item name="username" label="用户名" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item name="password" label="密码" rules={editing ? [] : [{ required: true }]}><Input.Password placeholder={editing ? '留空不修改' : ''} /></Form.Item>
          <Form.Item name="name" label="姓名" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item name="phone" label="手机号" rules={[{ required: true, message: '请输入手机号' }, { pattern: /^1\d{10}$/, message: '请输入正确的11位手机号' }]}><Input maxLength={11} /></Form.Item>
          <Form.Item name="role_id" label="角色"><Select options={roles.map(r => ({ label: r.name, value: r.id }))} allowClear placeholder="选择角色" /></Form.Item>
          <Form.Item name="status" label="状态" initialValue={1}><Select options={[{ label: '启用', value: 1 }, { label: '禁用', value: 0 }]} /></Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
