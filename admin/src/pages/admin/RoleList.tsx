/**
 * 角色管理页面
 * 展示系统角色列表，支持搜索、新增、编辑、删除角色操作
 * 支持 RBAC 菜单权限分配
 */
import { useEffect, useState } from 'react';
import { Table, Button, Space, Input, Modal, Form, Select, message, Popconfirm, Tag, Tree, Tooltip } from 'antd';
import { PlusOutlined, SearchOutlined, EditOutlined, DeleteOutlined, SettingOutlined } from '@ant-design/icons';
import request from '../../utils/request';

/**
 * 角色管理页面组件
 * 提供角色的增删改查功能，支持 RBAC 菜单权限分配
 */
export default function RoleListPage() {
  const [data, setData] = useState<any[]>([]);
  const [total, setTotal] = useState(0);
  const [page, setPage] = useState(1);
  const [pageSize, setPageSize] = useState(20);
  const [keyword, setKeyword] = useState('');
  const [loading, setLoading] = useState(false);
  const [modalOpen, setModalOpen] = useState(false);
  const [editing, setEditing] = useState<any>(null);
  const [form] = Form.useForm();

  /** 权限分配弹窗 */
  const [permModalOpen, setPermModalOpen] = useState(false);
  const [permRole, setPermRole] = useState<any>(null);
  const [checkedKeys, setCheckedKeys] = useState<number[]>([]);
  const [permSaving, setPermSaving] = useState(false);
  const [permTree, setPermTree] = useState<any[]>([]);
  const [rolePermCounts, setRolePermCounts] = useState<Record<number, number>>({});

  /** 加载角色列表 */
  const loadData = async () => {
    setLoading(true);
    try {
      const res: any = await request.get('/roles/list', { params: { page, pageSize, keyword } });
      if (res.code === 200) {
        setData(res.data.list);
        setTotal(res.data.total);
        // 加载每个角色的权限数量
        loadPermCounts(res.data.list);
      }
    } finally { setLoading(false); }
  };

  /** 批量加载角色权限数量 */
  const loadPermCounts = async (roles: any[]) => {
    const counts: Record<number, number> = {};
    await Promise.all(roles.map(async (role) => {
      try {
        const res: any = await request.get(`/permissions/role/${role.id}`);
        if (res.code === 200) counts[role.id] = res.data.length;
      } catch { counts[role.id] = 0; }
    }));
    setRolePermCounts(counts);
  };

  /** 加载权限树 */
  const loadPermTree = async () => {
    try {
      const res: any = await request.get('/permissions/tree');
      if (res.code === 200) setPermTree(res.data);
    } catch { /* ignore */ }
  };

  useEffect(() => { loadData(); }, [page, pageSize, keyword]);
  useEffect(() => { loadPermTree(); }, []);

  const onSearch = () => { setPage(1); loadData(); };

  const openModal = (record?: any) => {
    setEditing(record || null);
    if (record) form.setFieldsValue(record);
    else form.resetFields();
    setModalOpen(true);
  };

  const handleSubmit = async () => {
    const values = await form.validateFields();
    try {
      if (editing) {
        const res: any = await request.put(`/roles/update/${editing.id}`, values);
        if (res.code === 200) { message.success('更新成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      } else {
        const res: any = await request.post('/roles/create', values);
        if (res.code === 200) { message.success('创建成功'); setModalOpen(false); loadData(); }
        else message.error(res.message);
      }
    } catch (err: any) { message.error(err?.response?.data?.message || '操作失败'); }
  };

  const handleDelete = async (id: number) => {
    const res: any = await request.delete(`/roles/delete/${id}`);
    if (res.code === 200) { message.success('删除成功'); loadData(); }
  };

  /** 打开权限分配弹窗 */
  const openPermModal = async (record: any) => {
    setPermRole(record);
    try {
      const res: any = await request.get(`/permissions/role/${record.id}`);
      if (res.code === 200) setCheckedKeys(res.data.map((p: any) => p.id));
      else setCheckedKeys([]);
    } catch { setCheckedKeys([]); }
    setPermModalOpen(true);
  };

  /** 保存权限分配 */
  const handleSavePerm = async () => {
    setPermSaving(true);
    try {
      const res: any = await request.post(`/permissions/role/${permRole.id}`, {
        permissionIds: checkedKeys,
      });
      if (res.code === 200) {
        message.success('权限分配成功');
        setPermModalOpen(false);
        loadData();
      } else message.error(res.message);
    } catch { message.error('操作失败'); } finally { setPermSaving(false); }
  };

  const columns = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '角色名称', dataIndex: 'name' },
    { title: '描述', dataIndex: 'description', ellipsis: true },
    { title: '已分配权限', render: (_: any, record: any) => {
      const count = rolePermCounts[record.id] || 0;
      return count > 0 ? <Tag color="blue">{count} 项</Tag> : <Tag>未分配</Tag>;
    }},
    { title: '类型', dataIndex: 'type', render: (v: string) => v === 'system' ? <Tag color="purple">系统内置</Tag> : <Tag>自定义</Tag> },
    { title: '状态', dataIndex: 'status', render: (v: number) => v === 1 ? <Tag color="green">启用</Tag> : <Tag color="red">禁用</Tag> },
    {
      title: '操作', width: 260, fixed: 'right' as const, render: (_: any, record: any) => (
        <Space>
          <Button type="link" icon={<SettingOutlined />} onClick={() => openPermModal(record)}>分配权限</Button>
          <Button type="link" icon={<EditOutlined />} onClick={() => openModal(record)}>编辑</Button>
          {record.type === 'system' ? (
            <Tooltip title="系统内置角色，不允许删除">
              <Button type="link" danger icon={<DeleteOutlined />} disabled>删除</Button>
            </Tooltip>
          ) : (
            <Popconfirm title="确认删除？" onConfirm={() => handleDelete(record.id)}>
              <Button type="link" danger icon={<DeleteOutlined />}>删除</Button>
            </Popconfirm>
          )}
        </Space>
      ),
    },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 'var(--spacing-md)', fontSize: 'var(--text-h2)', fontFamily: 'var(--font-family-heading)', fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>角色管理</h2>
      <Space style={{ marginBottom: 16 }}>
        <Input placeholder="搜索角色名称" value={keyword} onChange={e => setKeyword(e.target.value)} onPressEnter={onSearch} prefix={<SearchOutlined />} style={{ width: 240 }} />
        <Button type="primary" onClick={onSearch}>搜索</Button>
        <Button type="primary" icon={<PlusOutlined />} onClick={() => openModal()}>新增角色</Button>
      </Space>
      <Table rowKey="id" columns={columns} dataSource={data} loading={loading} scroll={{ x: 'max-content' }}
        pagination={{ current: page, pageSize, total, showSizeChanger: true, showTotal: t => `共 ${t} 条`, onChange: (p, ps) => { setPage(p); setPageSize(ps); } }} />

      {/* 角色编辑弹窗 */}
      <Modal title={editing ? '编辑角色' : '新增角色'} open={modalOpen} onOk={handleSubmit} onCancel={() => setModalOpen(false)} destroyOnHidden>
        <Form form={form} layout="vertical">
          <Form.Item name="name" label="角色名称" rules={[{ required: true }]}><Input /></Form.Item>
          <Form.Item name="description" label="角色描述"><Input.TextArea rows={3} /></Form.Item>
          <Form.Item name="type" label="角色类型" initialValue="custom">
            <Select options={[
              { label: '系统内置', value: 'system' },
              { label: '自定义', value: 'custom' },
            ]} disabled={!!editing} />
          </Form.Item>
          <Form.Item name="status" label="状态" initialValue={1}>
            <Select options={[{ label: '启用', value: 1 }, { label: '禁用', value: 0 }]} />
          </Form.Item>
        </Form>
      </Modal>

      {/* 权限分配弹窗 */}
      <Modal
        title={`分配菜单权限 — ${permRole?.name || ''}`}
        open={permModalOpen}
        onOk={handleSavePerm}
        onCancel={() => setPermModalOpen(false)}
        confirmLoading={permSaving}
        width={480}
        destroyOnHidden
      >
        <p style={{ color: '#8C8C8C', marginBottom: 12 }}>勾选该角色可访问的功能菜单</p>
        {permTree.length > 0 ? (
          <Tree
            checkable
            defaultExpandAll
            checkedKeys={checkedKeys}
            onCheck={(keys: any) => setCheckedKeys(keys.checked || keys)}
            treeData={permTree}
            fieldNames={{ title: 'name', key: 'id', children: 'children' }}
            style={{ maxHeight: 400, overflowY: 'auto' }}
          />
        ) : (
          <p>加载权限树中...</p>
        )}
      </Modal>
    </div>
  );
}
