/**
 * 登录页面 — 管理后台
 *
 * 纯 CSS/SVG 动态背景：山峦层叠 + 云朵漂浮
 * 没有静态图片，整个场景是活的
 */
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Form, Input, Button, message, Modal, Space } from 'antd';
import { UserOutlined, LockOutlined, SafetyCertificateOutlined, MessageOutlined } from '@ant-design/icons';
import request from '../utils/request';
import Captcha from '../components/Captcha';

const styles = `
/* ═══ 云朵漂浮 ═══ */
@keyframes drift1 { 0% { transform: translateX(-25%); } 100% { transform: translateX(110vw); } }
@keyframes drift2 { 0% { transform: translateX(110vw); } 100% { transform: translateX(-25%); } }

.cloud { position: absolute; pointer-events: none; }
.c { position: absolute; background: rgba(255,255,255,0.25); border-radius: 50%; }

/* ═══ 流星 ═══ */
@keyframes meteor1 {
  0%   { transform: translate(0, 0); opacity: 0; }
  3%   { opacity: 1; }
  60%  { opacity: 0.6; }
  100% { transform: translate(50vw, 30vw); opacity: 0; }
}
@keyframes meteor2 {
  0%   { transform: translate(0, 0); opacity: 0; }
  3%   { opacity: 0.9; }
  55%  { opacity: 0.5; }
  100% { transform: translate(40vw, 25vw); opacity: 0; }
}
@keyframes meteor3 {
  0%   { transform: translate(0, 0); opacity: 0; }
  4%   { opacity: 1; }
  50%  { opacity: 0.4; }
  100% { transform: translate(45vw, 28vw); opacity: 0; }
}
.meteor {
  position: absolute;
  width: 140px;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255,255,255,0.06) 40%, rgba(255,255,255,0.3) 70%, rgba(255,255,255,0.95));
  transform: rotate(-35deg);
  pointer-events: none;
  opacity: 0;
}
.meteor::before {
  content: '';
  position: absolute;
  right: -1px;
  top: -1.5px;
  width: 3px;
  height: 3px;
  background: #fff;
  border-radius: 50%;
  box-shadow: 0 0 4px 1px rgba(255,255,255,0.4);
}
`;

/** 云朵组件 — 用多个圆形叠加出蓬松的云 */
function Cloud({ top, size, opacity, duration, delay, reverse }: {
  top: string; size: number; opacity: number; duration: number; delay: number; reverse?: boolean;
}) {
  // 每朵云由 6-8 个圆组成，模拟自然蓬松感
  const circles = [
    { l: '10%', b: '20%', w: 0.35, h: 0.55 },
    { l: '22%', b: '30%', w: 0.30, h: 0.65 },
    { l: '35%', b: '35%', w: 0.32, h: 0.70 },
    { l: '50%', b: '30%', w: 0.35, h: 0.75 },
    { l: '62%', b: '25%', w: 0.28, h: 0.60 },
    { l: '18%', b: '10%', w: 0.50, h: 0.45 },
    { l: '40%', b: '5%',  w: 0.40, h: 0.40 },
    { l: '55%', b: '8%',  w: 0.30, h: 0.35 },
  ];
  return (
    <div className="cloud" style={{
      top, width: size, height: size * 0.4,
      animation: `${reverse ? 'drift2' : 'drift1'} ${duration}s linear ${delay}s infinite`,
      opacity,
    }}>
      {circles.map((c, i) => (
        <div key={i} className="c" style={{
          left: c.l, bottom: c.b,
          width: `${c.w * 100}%`, height: `${c.h * 100}%`,
          opacity: 0.7 + i * 0.04,
        }} />
      ))}
    </div>
  );
}

export default function LoginPage() {
  const [loading, setLoading] = useState(false);
  const [captchaCode, setCaptchaCode] = useState('');
  const navigate = useNavigate();
  const [form] = Form.useForm();

  // ── 短信二次验证弹窗状态 ──
  const [smsModalOpen, setSmsModalOpen] = useState(false);
  const [smsToken, setSmsToken] = useState('');
  const [phoneMask, setPhoneMask] = useState('');
  const [smsCode, setSmsCode] = useState('');
  const [smsCountdown, setSmsCountdown] = useState(0);
  const [smsVerifying, setSmsVerifying] = useState(false);
  const [smsResending, setSmsResending] = useState(false);

  /** 第一步：提交用户名 + 密码 */
  const onFinish = async (values: { username: string; password: string; captcha: string }) => {
    // 图形验证码校验（不区分大小写）
    if (values.captcha.toUpperCase() !== captchaCode) {
      message.error('图形验证码错误');
      form.setFieldValue('captcha', '');
      return;
    }

    setLoading(true);
    try {
      const res: any = await request.post('/auth/login', {
        username: values.username,
        password: values.password,
      });

      if (res.code === 200 && res.data?.needSms) {
        // 密码验证通过 → 弹出短信二次验证弹窗
        setSmsToken(res.data.smsToken);
        setPhoneMask(res.data.phoneMask);
        setSmsCode('');
        setSmsCountdown(60);
        setSmsModalOpen(true);

        // 倒计时
        const timer = setInterval(() => {
          setSmsCountdown(prev => {
            if (prev <= 1) { clearInterval(timer); return 0; }
            return prev - 1;
          });
        }, 1000);
      } else {
        message.error(res.message || '登录失败');
      }
    } catch (err: any) {
      message.error(err?.response?.data?.message || '登录失败');
    } finally {
      setLoading(false);
    }
  };

  /** 第二步：提交短信验证码 */
  const handleSmsVerify = async () => {
    if (!smsCode || smsCode.length !== 6) {
      message.error('请输入6位短信验证码');
      return;
    }
    setSmsVerifying(true);
    try {
      const res: any = await request.post('/auth/verify-sms', {
        smsToken,
        code: smsCode,
      });
      if (res.code === 200) {
        localStorage.setItem('token', res.data.token);
        localStorage.setItem('admin', JSON.stringify(res.data.admin));
        message.success('登录成功');
        setSmsModalOpen(false);
        navigate('/dashboard');
      } else {
        message.error(res.message || '验证码错误');
        setSmsCode('');
      }
    } catch (err: any) {
      message.error(err?.response?.data?.message || '验证失败');
    } finally {
      setSmsVerifying(false);
    }
  };

  /** 重新发送短信验证码 */
  const handleResendSms = async () => {
    setSmsResending(true);
    try {
      const res: any = await request.post('/auth/resend-sms', { smsToken });
      if (res.code === 200) {
        message.success('验证码已重新发送');
        setSmsCode('');
        setSmsCountdown(60);
        const timer = setInterval(() => {
          setSmsCountdown(prev => {
            if (prev <= 1) { clearInterval(timer); return 0; }
            return prev - 1;
          });
        }, 1000);
      } else {
        message.error(res.message || '重发失败');
      }
    } catch {
      message.error('重发失败');
    } finally {
      setSmsResending(false);
    }
  };

  return (
    <div style={{ minHeight: '100vh', position: 'relative', overflow: 'hidden' }}>
      <style>{styles}</style>

      {/* ═══ 天空渐变 ═══ */}
      <div style={{
        position: 'absolute', inset: 0,
        background: 'linear-gradient(180deg, #0B1D3A 0%, #132E5A 30%, #1A4178 55%, #2A5A8A 75%, #3B7BA8 100%)',
      }} />

      {/* ═══ 星星点缀 ═══ */}
      <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '60%', pointerEvents: 'none' }}>
        {[
          [12, 8, 1.2], [25, 15, 0.8], [38, 5, 1], [55, 12, 0.6], [68, 8, 1.1],
          [78, 18, 0.7], [88, 6, 0.9], [15, 22, 0.5], [45, 20, 0.8], [72, 25, 0.6],
          [30, 10, 0.7], [60, 18, 0.9], [85, 14, 0.5], [8, 16, 0.8], [50, 8, 1],
        ].map(([cx, cy, r], i) => (
          <circle key={i} cx={`${cx}%`} cy={`${cy}%`} r={r} fill="rgba(255,255,255,0.5)">
            <animate attributeName="opacity" values="0.3;0.8;0.3" dur={`${3 + i * 0.4}s`} repeatCount="indefinite" />
          </circle>
        ))}
      </svg>

      {/* ═══ 远山层（深色，缓慢视差） ═══ */}
      <svg style={{ position: 'absolute', bottom: 0, width: '200%', height: '45%', pointerEvents: 'none' }} preserveAspectRatio="none">
        <path d="M0 300 Q150 100 400 200 Q600 80 800 180 Q1000 60 1200 160 Q1400 90 1600 200 Q1800 120 2000 250 L2000 500 L0 500Z" fill="#0E2A48" opacity="0.6">
          <animateTransform attributeName="transform" type="translate" values="0,0;-100,0;0,0" dur="80s" repeatCount="indefinite" />
        </path>
      </svg>

      {/* ═══ 中山层 ═══ */}
      <svg style={{ position: 'absolute', bottom: 0, width: '200%', height: '38%', pointerEvents: 'none' }} preserveAspectRatio="none">
        <path d="M0 300 Q200 120 450 220 Q650 100 900 200 Q1100 80 1300 180 Q1500 130 1700 230 Q1900 150 2000 280 L2000 500 L0 500Z" fill="#132E5A" opacity="0.8">
          <animateTransform attributeName="transform" type="translate" values="0,0;-80,0;0,0" dur="60s" repeatCount="indefinite" />
        </path>
      </svg>

      {/* ═══ 近山层（最深） ═══ */}
      <svg style={{ position: 'absolute', bottom: 0, width: '200%', height: '30%', pointerEvents: 'none' }} preserveAspectRatio="none">
        <path d="M0 300 Q180 150 400 250 Q600 130 850 230 Q1050 110 1250 210 Q1450 160 1650 260 Q1850 180 2000 300 L2000 500 L0 500Z" fill="#0A1929">
          <animateTransform attributeName="transform" type="translate" values="0,0;-60,0;0,0" dur="45s" repeatCount="indefinite" />
        </path>
      </svg>

      {/* ═══ 云朵层（淡雅） ═══ */}
      <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>
        <Cloud top="10%" size={260} opacity={0.12} duration={55} delay={0} />
        <Cloud top="20%" size={200} opacity={0.08} duration={70} delay={12} reverse />
        <Cloud top="6%"  size={180} opacity={0.10} duration={60} delay={25} />
        <Cloud top="28%" size={320} opacity={0.06} duration={85} delay={5} reverse />
        <Cloud top="15%" size={160} opacity={0.14} duration={50} delay={35} />
        <Cloud top="35%" size={220} opacity={0.07} duration={75} delay={18} reverse />
        <Cloud top="8%"  size={280} opacity={0.09} duration={65} delay={40} />
        <Cloud top="42%" size={190} opacity={0.05} duration={90} delay={8} reverse />
      </div>

      {/* ═══ 流星层（偶尔一两颗） ═══ */}
      <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>
        <div className="meteor" style={{ top: '8%',  left: '15%', animation: 'meteor1 3.5s linear 12s infinite' }} />
        <div className="meteor" style={{ top: '14%', left: '50%', animation: 'meteor2 3s linear 40s infinite' }} />
      </div>

      {/* ═══ 品牌标题 — 左下角 ═══ */}
      <div style={{ position: 'absolute', bottom: 48, left: 48, zIndex: 2 }}>
        <h1 style={{
          fontFamily: "'Ma Shan Zheng', cursive", fontSize: 48, color: '#FFFFFF',
          margin: 0, lineHeight: 1.2, letterSpacing: 4,
          textShadow: '0 2px 30px rgba(0,0,0,0.4)',
        }}>
          乌东文旅
        </h1>
        <p style={{
          fontFamily: "'Inter', sans-serif", fontSize: 13,
          color: 'rgba(255,255,255,0.45)', margin: '8px 0 0 2px',
          letterSpacing: 3, textTransform: 'uppercase', fontWeight: 500,
        }}>
          Wudong Cultural Tourism · Admin
        </p>
        <div style={{ width: 40, height: 2, background: '#E85D2F', margin: '16px 0' }} />
        <p style={{ fontSize: 14, color: 'rgba(255,255,255,0.5)', margin: 0, lineHeight: 1.6 }}>
          苗寨有银，文化有纹
        </p>
      </div>

      {/* ═══ 底部蜡染装饰带 ═══ */}
      <div style={{
        position: 'absolute', bottom: 0, left: 0, right: 0, height: 4, zIndex: 2,
        background: `repeating-linear-gradient(90deg, #1F5FA8 0px, #1F5FA8 12px, transparent 12px, transparent 16px, #E85D2F 16px, #E85D2F 20px, transparent 20px, transparent 24px)`,
        opacity: 0.7,
      }} />

      {/* ═══ 浮动表单卡片（静止） ═══ */}
      <div style={{
        position: 'absolute', top: 0, right: 0, bottom: 0,
        width: '42%', minWidth: 380, maxWidth: 480,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        padding: '48px 40px', zIndex: 3,
      }}>
        <div style={{
          width: '100%', maxWidth: 380,
          background: 'rgba(255,255,255,0.10)',
          backdropFilter: 'blur(24px)', WebkitBackdropFilter: 'blur(24px)',
          borderRadius: 16, border: '1px solid rgba(255,255,255,0.15)',
          padding: '40px 36px', boxShadow: '0 8px 40px rgba(0,0,0,0.2)',
          position: 'relative',
        }}>
          {/* 右上角 Logo */}
          <img
            src="/logo.png"
            alt="乌东文旅"
            style={{
              position: 'absolute',
              top: 24,
              right: 24,
              width: 48,
              height: 48,
              objectFit: 'contain',
              opacity: 0.9,
            }}
          />
          <div style={{ marginBottom: 36 }}>
            <h2 style={{
              fontFamily: "'Alibaba PuHuiTi', 'Inter', sans-serif",
              fontSize: 22, fontWeight: 700, color: '#FFFFFF', margin: 0,
            }}>管理后台</h2>
            <p style={{ fontSize: 13, color: 'rgba(255,255,255,0.5)', margin: '6px 0 0' }}>
              使用管理员账号登录
            </p>
          </div>
          <Form form={form} onFinish={onFinish} size="large" layout="vertical">
            <Form.Item name="username" rules={[{ required: true, message: '请输入用户名' }]} style={{ marginBottom: 18 }}>
              <Input prefix={<UserOutlined style={{ color: 'rgba(255,255,255,0.35)' }} />} placeholder="用户名"
                style={{ height: 46, borderRadius: 10, background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff' }} />
            </Form.Item>
            <Form.Item name="password" rules={[{ required: true, message: '请输入密码' }]} style={{ marginBottom: 18 }}>
              <Input.Password prefix={<LockOutlined style={{ color: 'rgba(255,255,255,0.35)' }} />} placeholder="密码"
                style={{ height: 46, borderRadius: 10, background: 'rgba(255,255,255,0.08)', border: '1px solid rgba(255,255,255,0.12)', color: '#fff' }} />
            </Form.Item>
            <Form.Item name="captcha" rules={[{ required: true, message: '请输入验证码' }]} style={{ marginBottom: 24 }}>
              <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
                <Input
                  prefix={<SafetyCertificateOutlined style={{ color: 'rgba(255,255,255,0.35)' }} />}
                  placeholder="验证码"
                  maxLength={4}
                  style={{
                    flex: 1,
                    height: 46,
                    borderRadius: 10,
                    background: 'rgba(255,255,255,0.08)',
                    border: '1px solid rgba(255,255,255,0.12)',
                    color: '#fff',
                  }}
                />
                <Captcha width={120} height={46} onChange={setCaptchaCode} />
              </div>
            </Form.Item>
            <Form.Item style={{ marginBottom: 20 }}>
              <Button type="primary" htmlType="submit" loading={loading} block
                style={{ height: 46, borderRadius: 10, fontSize: 15, fontWeight: 600, letterSpacing: 2, boxShadow: '0 4px 16px rgba(31,95,168,0.35)' }}>
                登录
              </Button>
            </Form.Item>
          </Form>
          <div style={{ textAlign: 'center', color: 'rgba(255,255,255,0.3)', fontSize: 12 }}>
            默认账号：admin / admin123
          </div>

          {/* ═══ 短信二次验证弹窗 ═══ */}
          <Modal
            title="短信二次验证"
            open={smsModalOpen}
            onCancel={() => setSmsModalOpen(false)}
            footer={null}
            closable={!smsVerifying}
            maskClosable={false}
            centered
            styles={{
              header: { background: '#fff' },
              body: { padding: '24px 32px' },
            }}
          >
            <Space direction="vertical" size="middle" style={{ width: '100%' }}>
              <div style={{ fontSize: 14, color: '#666' }}>
                验证码已发送至 <span style={{ fontWeight: 600, color: '#1F5FA8' }}>{phoneMask}</span>
              </div>
              <div style={{ fontSize: 12, color: '#999' }}>
                💡 演示模式：任意6位数字均可通过
              </div>
              <div style={{ display: 'flex', gap: 12, alignItems: 'center' }}>
                <Input
                  prefix={<MessageOutlined style={{ color: '#999' }} />}
                  placeholder="请输入6位短信验证码"
                  maxLength={6}
                  value={smsCode}
                  onChange={e => setSmsCode(e.target.value)}
                  onPressEnter={handleSmsVerify}
                  style={{ flex: 1, height: 46, borderRadius: 8 }}
                />
                {smsCountdown > 0 ? (
                  <span style={{ fontSize: 13, color: '#999', whiteSpace: 'nowrap', minWidth: 60, textAlign: 'center' }}>
                    {smsCountdown}s
                  </span>
                ) : (
                  <Button
                    type="link"
                    loading={smsResending}
                    onClick={handleResendSms}
                    style={{ fontSize: 13, padding: 0, minWidth: 60, height: 32 }}
                  >
                    重新发送
                  </Button>
                )}
              </div>
              <Button
                type="primary"
                block
                loading={smsVerifying}
                onClick={handleSmsVerify}
                style={{ height: 44, borderRadius: 8, fontSize: 15, fontWeight: 600 }}
              >
                确认验证
              </Button>
            </Space>
          </Modal>
        </div>
      </div>
    </div>
  );
}
