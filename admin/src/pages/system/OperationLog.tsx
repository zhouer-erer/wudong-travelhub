/**
 * 操作日志页面
 * 展示系统操作日志列表，支持按操作人和操作类型筛选
 * 操作类型包括：登录、新增、编辑、删除、审核通过、审核驳回、封禁、解封、标记已读、强制下线、退款通过、退款驳回、关闭
 */
import { useEffect, useState } from 'react';
import { Table, Space, Input, Tag, Select } from 'antd';
import { SearchOutlined } from '@ant-design/icons';
import request from '../../utils/request';

/** 操作类型显示映射 - key为中文（与后端存储一致） */
const ACTION_MAP: Record<string, { color: string; text: string }> = {
  '登录': { color: 'blue', text: '登录' },
  '新增': { color: 'green', text: '新增' },
  '编辑': { color: 'orange', text: '编辑' },
  '删除': { color: 'red', text: '删除' },
  '审核通过': { color: 'green', text: '审核通过' },
  '审核驳回': { color: 'red', text: '审核驳回' },
  '封禁': { color: 'volcano', text: '封禁' },
  '解封': { color: 'lime', text: '解封' },
  '标记已读': { color: 'cyan', text: '标记已读' },
  '强制下线': { color: 'magenta', text: '强制下线' },
  '退款通过': { color: 'green', text: '退款通过' },
  '退款驳回': { color: 'red', text: '退款驳回' },
  '关闭': { color: 'default', text: '关闭' },
};

/**
 * 操作日志页面组件
 * 提供操作日志的查看和筛选功能（只读）
 */
export default function OperationLogPage() {
  /** 操作日志列表数据 */
  const [data, setData] = useState<any[]>([]);
  /** 数据总条数 */
  const [total, setTotal] = useState(0);
  /** 当前页码 */
  const [page, setPage] = useState(1);
  /** 每页条数 */
  const [pageSize, setPageSize] = useState(20);
  /** 搜索关键词（操作人） */
  const [keyword, setKeyword] = useState('');
  /** 操作类型筛选条件 */
  const [action, setAction] = useState<string | undefined>(undefined);
  /** 数据加载状态 */
  const [loading, setLoading] = useState(false);

  /** 加载操作日志列表数据 */
  const loadData = async () => {
    setLoading(true);
    try {
      const params: any = { page, pageSize };
      if (keyword) params.keyword = keyword;
      if (action) params.action = action;
      const res: any = await request.get('/operation-logs/list', { params });
      if (res.code === 200) { setData(res.data.list); setTotal(res.data.total); }
    } finally { setLoading(false); }
  };

  useEffect(() => { loadData(); }, [page, pageSize, action, keyword]);

  /** 搜索操作，重置页码后加载数据 */
  const onSearch = () => { setPage(1); loadData(); };

  /** 表格列配置 */
  const columns = [
    { title: 'ID', dataIndex: 'id', width: 80 },
    { title: '操作人', dataIndex: 'operator_name', render: (v: string, r: any) => v || `ID:${r.operator_id}` },
    { title: '操作类型', dataIndex: 'action', render: (v: string) => {
      const info = ACTION_MAP[v] || { color: 'default', text: v };
      return <Tag color={info.color}>{info.text}</Tag>;
    }},
    { title: '操作对象', dataIndex: 'target' },
    { title: '操作内容', dataIndex: 'content', ellipsis: true },
    { title: 'IP', dataIndex: 'ip' },
    { title: '操作时间', dataIndex: 'created_at' },
  ];

  return (
    <div>
      <h2 style={{ marginBottom: 'var(--spacing-md)', fontSize: 'var(--text-h2)', fontFamily: 'var(--font-family-heading)', fontWeight: 'var(--weight-bold)', color: 'var(--color-text-primary)' }}>操作日志</h2>
      {/* 筛选区域 */}
      <Space style={{ marginBottom: 16 }}>
        <Input placeholder="搜索操作人" value={keyword} onChange={e => setKeyword(e.target.value)} onPressEnter={onSearch} prefix={<SearchOutlined />} style={{ width: 200 }} />
        <Select allowClear placeholder="操作类型" value={action} onChange={setAction} style={{ width: 140 }}
          options={Object.entries(ACTION_MAP).map(([k, v]) => ({ label: v.text, value: k }))}
          showSearch filterOption={(input, option) => (option?.label ?? '').toString().toLowerCase().includes(input.toLowerCase())} />
      </Space>
      {/* 操作日志列表表格 */}
      <Table rowKey="id" columns={columns} dataSource={data} loading={loading}
        pagination={{ current: page, pageSize, total, showSizeChanger: true, showTotal: t => `共 ${t} 条`, onChange: (p, ps) => { setPage(p); setPageSize(ps); } }} />
    </div>
  );
}
