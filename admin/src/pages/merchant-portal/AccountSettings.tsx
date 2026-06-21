/**
 * 账号设置
 * 商家修改密码、绑定手机、查看账号信息
 */
import { useState } from 'react';
import { Card, Form, Input, Button, message, Descriptions, Modal } from 'antd';
import { LockOutlined, MobileOutlined, SafetyCertificateOutlined } from '@ant-design/icons';
import request from '../../utils/request';
import { MODULE_TYPE_MAP } from '../../utils/format';

export default function AccountSettings() {
  const [passwordForm] = Form.useForm();
  const [phoneForm] = Form.useForm();
  const [passwordLoading, setPasswordLoading] = useState(false);
  const [phoneLoading, setPhoneLoading] = useState(false);
  const [phoneModalVisible, setPhoneModalVisible] = useState(false);
  const [countdown, setCountdown] = useState(0);
  const merchantStr = localStorage.getItem('merchant');
  const merchant = merchantStr ? JSON.parse(merchantStr) : {};

  /** 修改密码 */
  const handleChangePassword = async () => {
    const values = await passwordForm.validateFields();
    if (values.newPassword !== values.confirmPassword) {
      message.error('两次密码不一致');
      return;
    }
    setPasswordLoading(true);
    try {
      const res: any = await request.put('/merchant-auth/profile', {
        password: values.newPassword,
      });
      if (res.code === 200) {
        message.success('密码修改成功');
        passwordForm.resetFields();
      } else {
        message.error(res.message);
      }
    } catch (err: any) {
      message.error('修改失败');
    } finally {
      setPasswordLoading(false);
    }
  };

  /** 发送验证码 */
  const handleSendCode = async () => {
    const phone = phoneForm.getFieldValue('phone');
    if (!phone) {
      message.error('请输入手机号');
      return;
    }
    try {
      const res: any = await request.post('/merchant-auth/send-sms-code', { phone });
      if (res.code === 200) {
        message.success('验证码已发送');
        setCountdown(60);
        const timer = setInterval(() => {
          setCountdown((prev) => {
            if (prev <= 1) {
              clearInterval(timer);
              return 0;
            }
            return prev - 1;
          });
        }, 1000);
      } else {
        message.error(res.message || '发送失败');
      }
    } catch (err: any) {
      message.error('发送失败');
    }
  };

  /** 绑定手机号 */
  const handleBindPhone = async () => {
    const values = await phoneForm.validateFields();
    setPhoneLoading(true);
    try {
      const res: any = await request.put('/merchant-auth/bind-phone', {
        phone: values.phone,
        code: values.code,
      });
      if (res.code === 200) {
        message.success('手机号绑定成功');
        setPhoneModalVisible(false);
        phoneForm.resetFields();
        // 更新本地存储
        localStorage.setItem('merchant', JSON.stringify({ ...merchant, phone: values.phone }));
      } else {
        message.error(res.message || '绑定失败');
      }
    } catch (err: any) {
      message.error('绑定失败');
    } finally {
      setPhoneLoading(false);
    }
  };

  return (
    <div>
      <h2 style={{
        marginBottom: 'var(--spacing-lg)',
        fontSize: 'var(--text-h2)',
        fontFamily: 'var(--font-family-heading)',
        fontWeight: 'var(--weight-bold)',
        color: 'var(--color-text-primary)',
      }}>
        账号设置
      </h2>

      {/* 账号信息 */}
      <Card title="账号信息" style={{ marginBottom: 24 }}>
        <Descriptions column={1}>
          <Descriptions.Item label="用户名">{merchant.username}</Descriptions.Item>
          <Descriptions.Item label="店铺名称">{merchant.shop_name}</Descriptions.Item>
          <Descriptions.Item label="所属模块">{MODULE_TYPE_MAP[merchant.module_type] || merchant.module_type}</Descriptions.Item>
          <Descriptions.Item label="绑定手机">
            {merchant.phone ? (
              <span>{merchant.phone}</span>
            ) : (
              <span style={{ color: 'var(--color-text-tertiary)' }}>未绑定</span>
            )}
            <Button
              type="link"
              size="small"
              onClick={() => setPhoneModalVisible(true)}
              style={{ marginLeft: 8 }}
            >
              {merchant.phone ? '更换' : '绑定'}
            </Button>
          </Descriptions.Item>
        </Descriptions>
      </Card>

      {/* 修改密码 */}
      <Card title="修改密码">
        <Form form={passwordForm} layout="vertical" style={{ maxWidth: 400 }}>
          <Form.Item name="newPassword" label="新密码" rules={[{ required: true, min: 6 }]}>
            <Input.Password prefix={<LockOutlined />} />
          </Form.Item>
          <Form.Item name="confirmPassword" label="确认密码" rules={[{ required: true }]}>
            <Input.Password prefix={<LockOutlined />} />
          </Form.Item>
          <Form.Item>
            <Button type="primary" onClick={handleChangePassword} loading={passwordLoading}>
              修改密码
            </Button>
          </Form.Item>
        </Form>
      </Card>

      {/* 绑定手机号弹窗 */}
      <Modal
        title="绑定手机号"
        open={phoneModalVisible}
        onCancel={() => {
          setPhoneModalVisible(false);
          phoneForm.resetFields();
        }}
        footer={null}
        destroyOnClose
      >
        <Form form={phoneForm} layout="vertical">
          <Form.Item
            name="phone"
            label="手机号"
            rules={[
              { required: true, message: '请输入手机号' },
              { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号' },
            ]}
          >
            <Input prefix={<MobileOutlined />} placeholder="请输入手机号" />
          </Form.Item>
          <Form.Item
            name="code"
            label="验证码"
            rules={[{ required: true, message: '请输入验证码' }]}
          >
            <div style={{ display: 'flex', gap: 12 }}>
              <Input prefix={<SafetyCertificateOutlined />} placeholder="请输入验证码" style={{ flex: 1 }} />
              <Button
                onClick={handleSendCode}
                disabled={countdown > 0}
                style={{ minWidth: 120 }}
              >
                {countdown > 0 ? `${countdown}秒后重试` : '发送验证码'}
              </Button>
            </div>
          </Form.Item>
          <Form.Item>
            <Button type="primary" onClick={handleBindPhone} loading={phoneLoading} block>
              确认绑定
            </Button>
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
