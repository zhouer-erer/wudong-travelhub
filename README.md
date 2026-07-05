# 乌东文旅平台—平台管理后台

## 项目概述

乌东文旅"衣食住行"综合服务平台的管理后台模块，负责平台全局管理与公共后台框架。

## 技术栈

| 端 | 技术 |
|---|---|
| 后端 | Midway.js + TypeORM + MySQL |
| 管理后台 | React 18 + Vite + Ant Design 5 + Axios |
| 商家后台 | React 18 + Vite + Ant Design 5 + Axios |

## 项目结构

```
wudong-group6/
├── backend/                  # Midway 后端（端口 3000）
│   ├── sql/                 # SQL 脚本
│   │   ├── init.sql         # 建表语句
│   │   ├── wudong_admin.sql # 数据库初始化数据
│   │   └── refund_sample_data.sql  # 退款示例数据
│   └── src/
│       ├── config/          # 配置文件
│       │   ├── config.default.ts   # 默认配置
│       │   ├── config.local.ts     # 本地配置
│       │   └── oss.config.ts       # OSS 配置
│       ├── controller/      # 路由与入参校验（22个）
│       │   ├── auth.controller.ts          # 认证接口
│       │   ├── admin.controller.ts         # 管理员管理
│       │   ├── role.controller.ts          # 角色管理
│       │   ├── permission.controller.ts    # 权限管理
│       │   ├── user.controller.ts          # 用户管理
│       │   ├── merchant.controller.ts      # 商家管理
│       │   ├── merchant-application.controller.ts  # 入驻审核
│       │   ├── order.controller.ts         # 订单管理
│       │   ├── financial-record.controller.ts      # 财务管理
│       │   ├── announcement.controller.ts  # 公告管理
│       │   ├── carousel.controller.ts      # 轮播图管理
│       │   ├── activity-banner.controller.ts       # 活动横幅
│       │   ├── recommendation.controller.ts        # 推荐位管理
│       │   ├── system-message.controller.ts        # 系统消息
│       │   ├── message-template.controller.ts      # 消息模板
│       │   ├── system-config.controller.ts        # 系统配置
│       │   ├── sensitive-word.controller.ts       # 敏感词管理
│       │   ├── operation-log.controller.ts        # 操作日志
│       │   ├── dashboard.controller.ts            # 数据看板
│       │   ├── merchant-dashboard.controller.ts   # 商家工作台
│       │   ├── merchant-auth.controller.ts        # 商家认证
│       │   └── upload.controller.ts               # 文件上传
│       ├── service/         # 业务逻辑（19个）
│       ├── entity/          # TypeORM 实体（18个）
│       ├── dto/             # 数据传输对象
│       │   └── common.dto.ts # 公共 DTO
│       ├── middleware/      # 中间件
│       │   ├── auth.middleware.ts          # 认证中间件
│       │   ├── permission.middleware.ts    # 权限中间件
│       │   └── operation-log.middleware.ts # 操作日志中间件
│       ├── schedule/        # 定时任务
│       │   └── overdue-check.schedule.ts   # 超时审核检查
│       ├── configuration.ts # 应用配置
│       └── index.ts         # 入口文件
├── admin/                   # React + Vite 管理后台（端口 5174）
│   ├── public/              # 静态资源
│   ├── src/
│   │   ├── components/      # 公共组件
│   │   │   ├── Captcha.tsx          # 图形验证码
│   │   │   ├── ImageUpload.tsx      # 图片上传
│   │   │   ├── AvatarUpload.tsx     # 头像上传
│   │   │   ├── LazyImage.tsx        # 懒加载图片
│   │   │   ├── PermissionGuard.tsx  # 权限守卫
│   │   │   └── ErrorBoundary.tsx    # 错误边界
│   │   ├── layouts/         # 布局组件
│   │   │   └── MainLayout.tsx       # 主布局
│   │   ├── pages/           # 页面组件
│   │   │   ├── Dashboard.tsx        # 数据看板
│   │   │   ├── Login.tsx            # 登录页面
│   │   │   ├── admin/               # 管理员管理
│   │   │   │   ├── AdminList.tsx    # 管理员列表
│   │   │   │   └── RoleList.tsx     # 角色列表
│   │   │   ├── user/                # 用户管理
│   │   │   │   └── UserList.tsx     # 用户列表
│   │   │   ├── merchant/            # 商家管理
│   │   │   │   ├── MerchantList.tsx     # 商家列表
│   │   │   │   └── ApplicationList.ts   # 入驻审核
│   │   │   ├── content/             # 内容管理
│   │   │   │   ├── AnnouncementList.tsx  # 公告管理
│   │   │   │   ├── CarouselList.tsx     # 轮播图管理
│   │   │   │   ├── BannerList.tsx       # 活动横幅
│   │   │   │   └── RecommendationList.ts # 推荐位管理
│   │   │   ├── order/               # 订单管理
│   │   │   │   ├── OrderList.tsx        # 订单列表
│   │   │   │   ├── RefundApproval.tsx   # 退款审批
│   │   │   │   └── AbnormalOrder.tsx    # 异常订单
│   │   │   ├── finance/             # 财务管理
│   │   │   │   ├── SettlementList.tsx   # 结算管理
│   │   │   │   ├── FinancialReport.tsx  # 财务报表
│   │   │   │   └── Reconciliation.tsx   # 对账管理
│   │   │   ├── message/             # 消息管理
│   │   │   │   ├── MessageList.tsx      # 系统消息
│   │   │   │   └── TemplateList.tsx     # 消息模板
│   │   │   ├── system/              # 系统管理
│   │   │   │   ├── SystemConfig.tsx     # 系统配置
│   │   │   │   ├── SensitiveWordList.tsx # 敏感词管理
│   │   │   │   └── OperationLog.tsx     # 操作日志
│   │   │   └── merchant-portal/     # 商家后台
│   │   │       ├── MerchantLogin.tsx       # 商家登录
│   │   │       ├── MerchantDashboard.tsx   # 商家工作台
│   │   │       ├── MerchantStatistics.tsx  # 商家统计
│   │   │       ├── ShopInfo.tsx            # 店铺信息
│   │   │       ├── MerchantMessages.tsx    # 消息通知
│   │   │       ├── AccountSettings.tsx     # 账号设置
│   │   │       └── MerchantLayout.tsx      # 商家布局
│   │   ├── styles/          # 样式文件
│   │   │   └── variables.css        # CSS 变量
│   │   ├── theme/           # 主题配置
│   │   │   └── index.ts     # 主题入口
│   │   ├── utils/           # 工具函数
│   │   │   ├── request.ts       # 请求封装
│   │   │   ├── format.ts        # 格式化工具
│   │   │   ├── export.ts        # 导出工具
│   │   │   ├── debounce.ts      # 防抖函数
│   │   │   ├── ossImage.ts      # OSS 图片处理
│   │   │   └── useSubmitLock.ts # 提交锁 Hook
│   │   ├── App.tsx          # 应用组件
│   │   ├── main.tsx         # 入口文件
│   │   └── index.css        # 全局样式
│   ├── index.html           # HTML 模板
│   ├── vite.config.ts       # Vite 配置
│   └── tsconfig.json        # TypeScript 配置
├── doc/                     # 需求文档
├── docs/                    # API 文档
│   └── openapi.json         # OpenAPI 规范
├── admin-flowchart.html     # 管理后台流程图
├── admin-main-flowchart.html # 管理后台主流程图
├── admin-sequence-diagram.html # 管理后台序列图
├── CLAUDE.md                # Claude 配置
└── README.md                # 项目说明文档
```

## 功能清单

### 一、管理后台（Admin）

#### 1. 登录认证

| 功能 | 路径 | 说明 |
|------|------|------|
| 管理员登录 | /login | 账号密码登录，JWT Token 鉴权 |
| 图形验证码 | - | 4位随机字符，点击刷新，防机器人 |
| 路由守卫 | - | 未登录自动跳转登录页 |

#### 2. 数据看板（/dashboard）

| 功能 | 说明 |
|------|------|
| 核心统计卡片 | 注册用户数、商家数量、待审核申请、平台订单数 |
| 次要统计卡片 | 管理员数、入驻申请数、平台公告数、轮播图数 |
| 商家模块分布饼图 | 按衣食住行四大模块统计商家分布 |
| 订单趋势折线图 | 近7天订单趋势可视化 |
| 最近入驻申请列表 | 展示最近5条入驻申请记录 |

#### 3. 管理员管理（/admin/list）

| 功能 | 说明 |
|------|------|
| 管理员列表 | 分页展示，支持按用户名/姓名搜索 |
| 新增管理员 | 用户名、密码、姓名、手机号、角色、状态 |
| 编辑管理员 | 修改基本信息，密码留空不修改 |
| 删除管理员 | 二次确认后删除 |
| 角色关联 | 关联角色列表，显示角色名称 |
| 状态显示 | 启用/禁用标签展示 |

#### 4. 角色管理（/role/list）

| 功能 | 说明 |
|------|------|
| 角色列表 | 分页展示，支持按角色名称搜索 |
| 新增角色 | 角色名称、描述、状态 |
| 编辑角色 | 修改角色信息 |
| 删除角色 | 二次确认后删除 |
| 状态显示 | 启用/禁用标签展示 |

#### 5. 用户管理（/user/list）

| 功能 | 说明 |
|------|------|
| 用户列表 | 分页展示，支持按用户名/昵称/手机号搜索 |
| 状态筛选 | 按正常/封禁状态筛选 |
| 查看详情 | 弹窗展示用户完整信息（头像、性别、地区、简介等） |
| 编辑用户 | 修改昵称、手机号、性别、地区、简介 |
| 封禁/解封 | 切换用户状态 |
| 删除用户 | 二次确认后删除 |
| 手机号脱敏 | 列表展示时手机号中间4位用*号代替 |

#### 6. 商家管理（/merchant/list）

| 功能 | 说明 |
|------|------|
| 商家列表 | 分页展示，支持按用户名/店铺名搜索 |
| 新增商家 | 用户名、密码、店铺名称、所属模块、联系人、联系电话、状态 |
| 编辑商家 | 修改商家信息，密码留空不修改 |
| 删除商家 | 二次确认后删除 |
| 状态切换 | 启用/禁用商家账号 |
| 模块分类 | 非遗商品（衣）、餐饮美食（食）、住宿预订（住）、线路订票（行） |
| 手机号脱敏 | 联系电话脱敏展示 |

#### 7. 入驻审核（/merchant/application）

| 功能 | 说明 |
|------|------|
| 申请列表 | 分页展示，按状态标签页切换（待审核/已通过/已驳回） |
| 搜索功能 | 按申请人/店铺名搜索 |
| 查看详情 | 弹窗展示申请详细信息 |
| 审核通过 | 一键通过审核 |
| 审核驳回 | 需填写驳回原因，展示给申请人 |
| 状态标签 | 待审核（蓝）、已通过（绿）、已驳回（红） |

#### 8. 公告管理（/content/announcement）

| 功能 | 说明 |
|------|------|
| 公告列表 | 分页展示，支持按标题搜索 |
| 新增公告 | 标题、内容、状态（已发布/草稿） |
| 编辑公告 | 修改公告内容 |
| 删除公告 | 二次确认后删除 |
| 状态显示 | 已发布/草稿标签 |

#### 9. 轮播图管理（/content/carousel）

| 功能 | 说明 |
|------|------|
| 轮播图列表 | 分页展示，支持按标题搜索 |
| 新增轮播图 | 标题、图片上传、跳转链接、排序、状态 |
| 编辑轮播图 | 修改轮播图信息 |
| 删除轮播图 | 二次确认后删除 |
| 图片预览 | 列表中展示缩略图 |
| 排序控制 | 数值越大越靠前 |
| 状态显示 | 上架/下架标签 |

#### 10. 活动横幅管理（/content/banner）

| 功能 | 说明 |
|------|------|
| 横幅列表 | 分页展示，支持按标题搜索 |
| 新增横幅 | 标题、图片上传、跳转链接、活动时间范围、状态 |
| 编辑横幅 | 修改横幅信息 |
| 删除横幅 | 二次确认后删除 |
| 时间选择 | 支持日期时间范围选择器 |
| 图片预览 | 列表中展示缩略图 |
| 状态显示 | 启用/禁用标签 |

#### 11. 推荐位管理（/content/recommendation）

| 功能 | 说明 |
|------|------|
| 推荐列表 | 分页展示 |
| 新增推荐 | 名称、内容类型、内容ID、排序、状态 |
| 编辑推荐 | 修改推荐信息 |
| 删除推荐 | 二次确认后删除 |
| 内容类型 | 商品、餐厅、民宿、路线、游记 |
| 排序控制 | 数值越大越靠前 |
| 状态显示 | 启用/禁用标签 |

#### 12. 订单管理（/order/list）

| 功能 | 说明 |
|------|------|
| 订单列表 | 分页展示，支持按订单号搜索 |
| 类型筛选 | 按订单类型筛选（商品、餐位、住宿、门票、路线） |
| 状态筛选 | 按订单状态筛选（待支付、已支付、已发货、已完成、已取消、退款中、已退款） |
| 查看详情 | 弹窗展示订单完整信息 |
| 订单类型标签 | 不同类型使用不同颜色标签 |
| 状态标签 | 不同状态使用不同颜色标签 |

#### 13. 退款审批（/order/refund）

| 功能 | 说明 |
|------|------|
| 退款列表 | 分页展示所有退款中的订单 |
| 审批通过 | 一键通过退款申请 |
| 审批驳回 | 需填写驳回原因 |
| 退款金额 | 展示退款金额 |
| 状态标签 | 统一显示"退款中"标签 |

#### 14. 系统消息（/message/list）

| 功能 | 说明 |
|------|------|
| 消息列表 | 分页展示系统消息 |
| 类型筛选 | 按消息类型筛选（系统通知、订单通知、活动通知、审核通知） |
| 已读筛选 | 按已读/未读状态筛选 |
| 查看详情 | 弹窗展示消息详细信息 |
| 标记已读 | 将未读消息标记为已读 |
| 删除消息 | 二次确认后删除 |
| 发送消息 | 指定用户ID、消息类型、标题、内容发送消息 |
| 已读状态 | 未读（红）/已读（绿）标签 |

#### 15. 消息模板（/message/template）

| 功能 | 说明 |
|------|------|
| 模板列表 | 分页展示消息模板 |
| 新增模板 | 模板编码、模板名称、标题模板、内容模板、状态 |
| 编辑模板 | 修改模板信息 |
| 删除模板 | 二次确认后删除 |
| 变量支持 | 支持 {username}、{order_no} 等变量占位符 |
| 状态显示 | 启用/禁用标签 |

#### 16. 财务结算（/finance/list）

| 功能 | 说明 |
|------|------|
| 结算列表 | 分页展示结算记录 |
| 状态筛选 | 按结算状态筛选（待结算/已结算） |
| 商家筛选 | 按商家ID筛选 |
| 单条结算 | 对单条记录执行结算操作 |
| 批量结算 | 勾选多条记录批量结算 |
| 金额展示 | 订单金额、佣金比例、佣金金额、商家收入 |
| 状态显示 | 已结算（绿）/待结算（橙）标签 |

#### 17. 财务报表（/finance/report）

| 功能 | 说明 |
|------|------|
| 财务概览 | 总营收、平台收入、商家收入、待结算金额 |
| 商家收入汇总 | 按商家统计订单数、订单总额、平台佣金、商家收入、待结算金额 |
| 统计卡片 | 带图标的财务指标卡片 |

#### 18. 系统配置（/system/config）

| 功能 | 说明 |
|------|------|
| 配置列表 | 展示所有系统配置项 |
| 编辑配置 | 修改配置值（文本域） |
| 刷新功能 | 手动刷新配置列表 |
| 配置类型 | 显示配置项类型标签 |

#### 19. 敏感词管理（/system/sensitive）

| 功能 | 说明 |
|------|------|
| 敏感词列表 | 分页展示敏感词 |
| 新增敏感词 | 敏感词、分类、状态 |
| 编辑敏感词 | 修改敏感词信息 |
| 删除敏感词 | 二次确认后删除 |
| 批量导入 | 文本框输入多个敏感词（每行一个），批量导入 |
| 分类标签 | 显示敏感词分类 |
| 状态显示 | 启用/禁用标签 |

#### 20. 操作日志（/system/log）

| 功能 | 说明 |
|------|------|
| 日志列表 | 分页展示操作日志（只读） |
| 操作人筛选 | 按操作人搜索 |
| 类型筛选 | 按操作类型筛选（登录、新增、编辑、删除、审核通过、审核驳回） |
| 日志详情 | 展示操作人、操作类型、操作对象、操作内容、IP、时间 |
| 类型标签 | 不同操作类型使用不同颜色标签 |

---

### 二、商家后台（Merchant Portal）

#### 1. 商家登录（/merchant-portal/login）

| 功能 | 说明 |
|------|------|
| 商家登录 | 账号密码登录，JWT Token 鉴权 |
| 图形验证码 | 4位随机字符，点击刷新，防机器人 |
| 路由守卫 | 未登录自动跳转登录页 |

#### 2. 商家工作台（/merchant-portal/dashboard）

| 功能 | 说明 |
|------|------|
| 欢迎卡片 | 展示商家名称和所属模块 |
| 统计卡片 | 今日订单数、待发货数、待退款数、营业额 |
| 订单管理占位 | 预留业务模块组开发区域 |

#### 3. 店铺信息（/merchant-portal/shop）

| 功能 | 说明 |
|------|------|
| 店铺Logo | 上传/修改店铺Logo图片 |
| 基本信息 | 店铺名称、联系人、联系电话、店铺地址、店铺简介 |
| 保存功能 | 保存修改后的店铺信息 |

#### 4. 消息通知（/merchant-portal/messages）

| 功能 | 说明 |
|------|------|
| 消息列表 | 分页展示商家相关消息 |
| 类型筛选 | 按消息类型筛选（订单、支付、退款、系统、互动） |
| 已读筛选 | 按已读/未读状态筛选 |
| 标记已读 | 将未读消息标记为已读 |
| 未读标识 | 未读消息显示蓝色圆点 |
| 类型标签 | 不同类型使用不同颜色标签 |

#### 5. 账号设置（/merchant-portal/settings）

| 功能 | 说明 |
|------|------|
| 账号信息 | 展示用户名、店铺名称、所属模块 |
| 修改密码 | 新密码、确认密码，需二次确认 |

---

### 三、公共功能

#### 1. 布局组件

| 功能 | 说明 |
|------|------|
| 管理后台布局 | 可折叠侧边栏、顶部导航、内容区域 |
| 商家后台布局 | 可折叠侧边栏、顶部导航、内容区域 |
| 品牌Logo | 侧边栏展示乌东文旅Logo |
| 蜡染装饰带 | 侧边栏底部苗族蜡染几何纹样装饰 |
| 用户菜单 | 顶部右侧显示当前用户，支持退出登录 |

#### 2. 登录页面

| 功能 | 说明 |
|------|------|
| 管理后台登录 | 动态SVG背景（山峦层叠、云朵漂浮、流星划过） |
| 商家后台登录 | 动态SVG背景（山水场景、船只行走、水波荡漾、蒙蒙细雨） |
| 品牌展示 | 左下角品牌标题、英文副标题、品牌标语 |
| 图形验证码 | 表单右上角Logo，支持点击刷新 |
| 表单验证 | 用户名、密码、验证码必填验证 |

#### 3. 图形验证码组件

| 功能 | 说明 |
|------|------|
| 随机字符 | 4位数字+大写字母（排除易混淆字符） |
| 干扰线 | 贝塞尔曲线干扰线 |
| 噪点 | 随机圆形噪点 |
| 旋转字符 | 每个字符随机旋转角度 |
| 点击刷新 | 点击验证码图片刷新 |
| 品牌配色 | 使用苗族风格配色 |

#### 4. 图片上传组件

| 功能 | 说明 |
|------|------|
| 图片上传 | 支持拖拽或点击上传 |
| 格式限制 | 支持 JPG/PNG/GIF/WebP 格式 |
| 大小限制 | 不超过 5MB |
| 预览功能 | 上传后展示图片预览 |

#### 5. 工具函数

| 功能 | 说明 |
|------|------|
| 手机号脱敏 | maskPhone - 中间4位用*号代替 |
| 模块类型映射 | MODULE_TYPE_MAP - 英文转中文 |
| 审核状态映射 | AUDIT_STATUS_MAP - 状态转标签配置 |

---

### 四、后端接口

共 22 个 Controller，107 个 HTTP 接口。每个实体提供标准 CRUD 接口：列表（分页）、详情、新增、更新、删除。

#### 认证接口（AuthController）

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/auth/login` | 管理员登录（验证账号密码，发送短信验证码） |
| POST | `/api/auth/resend-sms` | 重新发送短信验证码 |
| POST | `/api/auth/verify-sms` | 短信验证码校验（完成登录，返回 JWT） |
| GET | `/api/auth/info` | 获取当前登录管理员信息 |
| GET | `/api/auth/permissions` | 获取当前登录管理员的权限列表 |

#### 管理员管理（AdminController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/admin/list` | 管理员列表（分页） |
| GET | `/api/admin/detail/:id` | 管理员详情 |
| POST | `/api/admin/create` | 创建管理员 |
| PUT | `/api/admin/update/:id` | 更新管理员 |
| DELETE | `/api/admin/delete/:id` | 删除管理员 |

#### 角色管理（RoleController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/roles/list` | 角色列表（分页） |
| GET | `/api/roles/detail/:id` | 角色详情 |
| POST | `/api/roles/create` | 创建角色 |
| PUT | `/api/roles/update/:id` | 更新角色 |
| DELETE | `/api/roles/delete/:id` | 删除角色 |
| GET | `/api/roles/:id/permissions` | 获取角色的权限列表 |
| PUT | `/api/roles/:id/permissions` | 设置角色的权限 |

#### 权限管理（PermissionController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/permissions/list` | 权限列表（分页） |
| GET | `/api/permissions/tree` | 权限树形结构 |
| GET | `/api/permissions/detail/:id` | 权限详情 |
| POST | `/api/permissions/create` | 创建权限 |
| PUT | `/api/permissions/update/:id` | 更新权限 |
| DELETE | `/api/permissions/delete/:id` | 删除权限 |
| GET | `/api/permissions/role/:roleId` | 获取指定角色的权限列表 |
| POST | `/api/permissions/role/:roleId` | 设置角色权限 |

#### 用户管理（UserController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/users/list` | 用户列表（分页） |
| GET | `/api/users/detail/:id` | 用户详情 |
| POST | `/api/users/create` | 创建用户 |
| PUT | `/api/users/update/:id` | 更新用户 |
| DELETE | `/api/users/delete/:id` | 删除用户 |
| POST | `/api/users/ban/:id` | 封禁用户 |
| POST | `/api/users/unban/:id` | 解封用户 |

#### 商家管理（MerchantController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/merchants/list` | 商家列表（分页） |
| GET | `/api/merchants/detail/:id` | 商家详情 |
| POST | `/api/merchants/create` | 创建商家 |
| PUT | `/api/merchants/update/:id` | 更新商家 |
| DELETE | `/api/merchants/delete/:id` | 删除商家 |
| POST | `/api/merchants/force-offline/:id` | 强制商家下线（Redis 使 token 失效） |

#### 入驻审核（MerchantApplicationController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/merchant-applications/list` | 申请列表（分页） |
| GET | `/api/merchant-applications/detail/:id` | 申请详情 |
| POST | `/api/merchant-applications/create` | 提交入驻申请 |
| PUT | `/api/merchant-applications/update/:id` | 更新入驻申请 |
| DELETE | `/api/merchant-applications/delete/:id` | 删除入驻申请 |
| POST | `/api/merchant-applications/approve/:id` | 审核通过（自动创建商家账号） |
| POST | `/api/merchant-applications/reject/:id` | 审核驳回 |
| GET | `/api/merchant-applications/overdue-check` | 超时未审核检查（超过 3 个工作日） |

#### 公告管理（AnnouncementController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/announcements/list` | 公告列表（分页） |
| GET | `/api/announcements/detail/:id` | 公告详情 |
| POST | `/api/announcements/create` | 创建公告 |
| PUT | `/api/announcements/update/:id` | 更新公告 |
| DELETE | `/api/announcements/delete/:id` | 删除公告 |

#### 轮播图管理（CarouselController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/carousels/list` | 轮播图列表（分页） |
| GET | `/api/carousels/detail/:id` | 轮播图详情 |
| POST | `/api/carousels/create` | 创建轮播图 |
| PUT | `/api/carousels/update/:id` | 更新轮播图 |
| DELETE | `/api/carousels/delete/:id` | 删除轮播图 |

#### 活动横幅管理（ActivityBannerController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/activity-banners/list` | 横幅列表（分页） |
| GET | `/api/activity-banners/detail/:id` | 横幅详情 |
| POST | `/api/activity-banners/create` | 创建横幅 |
| PUT | `/api/activity-banners/update/:id` | 更新横幅 |
| DELETE | `/api/activity-banners/delete/:id` | 删除横幅 |

#### 推荐位管理（RecommendationController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/recommendations/list` | 推荐列表（分页） |
| GET | `/api/recommendations/detail/:id` | 推荐详情 |
| POST | `/api/recommendations/create` | 创建推荐 |
| PUT | `/api/recommendations/update/:id` | 更新推荐 |
| DELETE | `/api/recommendations/delete/:id` | 删除推荐 |

#### 订单管理（OrderController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/orders/list` | 订单列表（分页，支持类型/状态/关键词筛选） |
| GET | `/api/orders/detail/:id` | 订单详情 |
| POST | `/api/orders/create` | 创建订单（自动发送新订单通知给商家） |
| PUT | `/api/orders/update/:id` | 更新订单（支付完成时发送收款通知） |
| POST | `/api/orders/refund-approve/:id` | 退款审批通过 |
| POST | `/api/orders/refund-reject/:id` | 退款审批驳回 |
| GET | `/api/orders/abnormal` | 查询异常订单（长时间未支付 + 退款争议） |
| POST | `/api/orders/close/:id` | 手动关闭未支付订单 |

#### 系统消息（SystemMessageController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/system-messages/list` | 消息列表（分页） |
| GET | `/api/system-messages/detail/:id` | 消息详情 |
| POST | `/api/system-messages/create` | 创建系统消息 |
| POST | `/api/system-messages/batch-send` | 批量发送系统消息 |
| PUT | `/api/system-messages/read/:id` | 标记消息为已读 |
| DELETE | `/api/system-messages/delete/:id` | 删除消息 |

#### 消息模板（MessageTemplateController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/message-templates/list` | 模板列表（分页） |
| GET | `/api/message-templates/detail/:id` | 模板详情 |
| POST | `/api/message-templates/create` | 创建模板 |
| PUT | `/api/message-templates/update/:id` | 更新模板 |
| DELETE | `/api/message-templates/delete/:id` | 删除模板 |

#### 财务管理（FinancialRecordController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/financial-records/list` | 结算列表（分页） |
| GET | `/api/financial-records/detail/:id` | 结算详情 |
| POST | `/api/financial-records/settle/:id` | 单笔结算 |
| POST | `/api/financial-records/settle-batch` | 批量结算 |
| POST | `/api/financial-records/generate` | 自动生成结算单 |
| GET | `/api/financial-records/summary` | 财务汇总（总营收/平台收入/商家收入/待结算） |
| GET | `/api/financial-records/merchant-summary` | 商家收入汇总（按商家分组） |
| GET | `/api/financial-records/reconciliation` | 对账接口（对比订单表和财务记录表） |

#### 系统配置（SystemConfigController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/system-configs/list` | 配置列表 |
| GET | `/api/system-configs/detail/:key` | 根据 key 获取配置详情 |
| PUT | `/api/system-configs/update/:key` | 根据 key 更新配置 |
| POST | `/api/system-configs/create` | 创建配置 |

#### 敏感词管理（SensitiveWordController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/sensitive-words/list` | 敏感词列表（分页） |
| GET | `/api/sensitive-words/detail/:id` | 敏感词详情 |
| POST | `/api/sensitive-words/create` | 创建敏感词 |
| PUT | `/api/sensitive-words/update/:id` | 更新敏感词 |
| DELETE | `/api/sensitive-words/delete/:id` | 删除敏感词 |
| POST | `/api/sensitive-words/batch-import` | 批量导入敏感词 |

#### 操作日志（OperationLogController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/operation-logs/list` | 日志列表（分页，支持操作人/类型/关键词筛选） |
| GET | `/api/operation-logs/detail/:id` | 日志详情 |

#### 数据看板（DashboardController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/dashboard/overview` | 平台总览数据（用户/订单/商家/财务统计、趋势、TOP 商家、超时申请） |

#### 商家后台（MerchantDashboardController）

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | `/api/merchant-dashboard/stats` | 商家统计数据（今日订单/待发货/待退款/总营业额） |
| GET | `/api/merchant-dashboard/messages` | 商家消息列表（分页） |
| GET | `/api/merchant-dashboard/messages/read/:id` | 标记消息已读 |
| GET | `/api/merchant-dashboard/statistics` | 商家详细统计（支持时间范围，含销售/订单趋势、状态/类型分布） |

#### 商家认证（MerchantAuthController）

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/merchant-auth/login` | 商家登录（含密码错误锁定、异地登录检测） |
| GET | `/api/merchant-auth/info` | 获取当前登录商家信息 |
| PUT | `/api/merchant-auth/profile` | 更新商家资料（店铺名/联系人/地址/简介/Logo/密码） |
| POST | `/api/merchant-auth/send-sms-code` | 发送手机验证码（演示模式） |
| PUT | `/api/merchant-auth/bind-phone` | 绑定手机号（演示模式） |

#### 文件上传（UploadController）

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/api/upload/image` | 上传单张图片（支持本地存储和 OSS） |
| POST | `/api/upload/images` | 批量上传图片 |
| GET | `/api/upload/file/:filename` | 获取本地上传的文件（返回文件流） |
| POST | `/api/upload/oss-token` | 获取 OSS 上传签名（前端直传） |
| POST | `/api/upload/delete` | 删除 OSS 文件 |
| POST | `/api/upload/moderation-callback` | OSS 内容审核回调（审核不通过自动删除） |

---

## 部署说明

### 一、环境要求

| 依赖 | 版本要求 | 说明 |
|------|----------|------|
| Node.js | >= 18.0.0 | 推荐 LTS 版本 |
| npm | >= 8.0.0 | 随 Node.js 安装 |
| MySQL | >= 5.7 | 推荐 8.0+ |
| Redis | >= 6.0 | 用于 Token 黑名单、权限缓存、商家下线管理 |

### 二、依赖服务

#### 1. MySQL 数据库

本项目使用 MySQL 作为主数据库，通过 TypeORM 进行 ORM 操作。

**数据库配置：**
- 默认数据库名：`wudong_admin`
- 默认端口：`3306`
- 字符集：建议使用 `utf8mb4`

**初始化步骤：**
```bash
# 1. 创建数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS wudong_admin DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# 2. 执行建表语句
mysql -u root -p wudong_admin < backend/sql/init.sql
```

#### 2. 阿里云 OSS（文件存储）

项目使用阿里云 OSS 进行图片等静态资源存储。如不需要文件上传功能，可跳过此配置。

**配置步骤：**
1. 登录 [阿里云控制台](https://oss.console.aliyun.com/)，创建 Bucket
2. 获取 AccessKey ID 和 AccessKey Secret
3. 在 `backend/.env` 中填入对应配置

#### 3. Redis

项目使用 Redis 进行 Token 黑名单管理、RBAC 权限缓存和商家强制下线功能。

**配置步骤：**
1. 安装并启动 Redis 服务（默认端口 6379）
2. 在 `backend/.env` 中配置 Redis 连接信息

> 注：Redis 服务具有容错设计，连接异常时会降级为直接查询数据库，不影响核心业务功能。

### 三、环境变量配置

在 `backend/` 目录下创建 `.env` 文件，可参考 `.env.example` 模板：

```bash
cd backend
cp .env.example .env
```

**环境变量说明：**

| 变量名 | 必填 | 默认值 | 说明 |
|--------|------|--------|------|
| **服务配置** | | | |
| `PORT` | 否 | `3000` | 后端服务监听端口 |
| `NODE_ENV` | 否 | `local` | 运行环境：`local` / `development` / `production` |
| **数据库配置** | | | |
| `DB_HOST` | 否 | `localhost` | MySQL 主机地址 |
| `DB_PORT` | 否 | `3306` | MySQL 端口 |
| `DB_USER` | 否 | `root` | MySQL 用户名 |
| `DB_PASSWORD` | 否 | `123456` | MySQL 密码 |
| `DB_DATABASE` | 否 | `wudong_admin` | 数据库名称 |
| **JWT 配置** | | | |
| `JWT_SECRET` | 否 | `wudong-admin-jwt-secret-2026` | JWT 签名密钥，生产环境务必修改 |
| **Redis 配置** | | | |
| `REDIS_HOST` | 否 | `127.0.0.1` | Redis 主机地址 |
| `REDIS_PORT` | 否 | `6379` | Redis 端口 |
| `REDIS_PASSWORD` | 否 | - | Redis 密码（无密码留空） |
| `REDIS_DB` | 否 | `0` | Redis 数据库编号（0-15） |
| **阿里云 OSS 配置** | | | |
| `OSS_ACCESS_KEY_ID` | 是* | - | 阿里云 AccessKey ID |
| `OSS_ACCESS_KEY_SECRET` | 是* | - | 阿里云 AccessKey Secret |
| `OSS_BUCKET` | 否 | `wudong-travel` | OSS Bucket 名称 |
| `OSS_REGION` | 否 | `oss-cn-guiyang` | OSS 区域（如 `oss-cn-guiyang`、`oss-cn-hangzhou`） |
| `OSS_ENDPOINT` | 否 | - | OSS Endpoint，优先于 region（如 `oss-cn-guiyang.aliyuncs.com`） |
| `OSS_DIR` | 否 | `uploads/` | 上传目录前缀 |
| `OSS_CNAME` | 否 | - | 自定义域名（可选） |
| `OSS_SECURE` | 否 | `true` | 是否使用 HTTPS |

> *注：仅在需要文件上传功能时必填。

**完整 `.env` 示例：**

```env
# 服务配置
PORT=3000
NODE_ENV=local

# 数据库配置
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_password_here
DB_DATABASE=wudong_admin

# JWT 密钥（生产环境请修改为强随机字符串）
JWT_SECRET=your-jwt-secret-here

# Redis 配置
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# 阿里云 OSS 配置（可选）
OSS_ACCESS_KEY_ID=your_access_key_id
OSS_ACCESS_KEY_SECRET=your_access_key_secret
OSS_BUCKET=wudong-travel
OSS_REGION=oss-cn-guiyang
OSS_DIR=uploads/
OSS_SECURE=true
```

### 四、启动命令

#### 方式一：本地开发（推荐）

**1. 安装依赖**

```bash
# 安装后端依赖
cd backend
npm install

# 安装前端依赖（新终端）
cd ../admin
npm install
```

**2. 初始化数据库**

```bash
mysql -u root -p < backend/sql/init.sql
```

**3. 配置环境变量**

```bash
cd backend
cp .env.example .env
# 编辑 .env 文件，填入数据库密码等配置
```

**4. 启动服务**

```bash
# 终端1：启动后端（端口 3000）
cd backend
npm run dev

# 终端2：启动前端（端口 5174）
cd admin
npm run dev
```

**5. 访问系统**

| 后台 | 地址 | 说明 |
|------|------|------|
| 管理后台 | http://localhost:5174 | 默认账号 `admin` / `admin123` |
| 商家后台 | http://localhost:5174/merchant-portal/login | 商家账号需管理员创建 |
| 后端 API | http://localhost:3000/api | RESTful 接口 |

#### 方式二：生产部署

**1. 构建项目**

```bash
# 构建后端
cd backend
npm run build

# 构建前端
cd ../admin
npm run build
```

**2. 启动生产服务**

```bash
# 启动后端（生产模式）
cd backend
npm start

# 前端静态文件位于 admin/dist/，使用 Nginx 或其他 Web 服务器托管
```

**3. Nginx 配置示例**

```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端静态文件
    location / {
        root /path/to/admin/dist;
        try_files $uri $uri/ /index.html;
    }

    # 后端 API 代理
    location /api {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    # 上传文件代理
    location /uploads {
        proxy_pass http://localhost:3000;
    }
}
```

#### 方式三：运行测试

```bash
cd backend
npm test              # 运行测试
npm run test:coverage # 运行测试并生成覆盖率报告
```

---

## 接口规范

- 响应格式：`{ "code": 200, "message": "success", "data": { ... } }`
- 分页参数：`?page=1&pageSize=20`
- 分页响应：`{ "list": [...], "total": 100 }`
- 软删除：`is_deleted=1`
- 鉴权方式：JWT Bearer Token（`Authorization: Bearer <token>`）

---

## 成员分工

| 角色 | 负责内容 |
|------|----------|
| 后端负责人 | 数据库设计、接口开发、接口联调 |
| 管理后台 | 后台管理端页面开发 |

---

## 设计特色

### 品牌视觉
- **侧边栏**：苗银蓝深色调（#0A1929），体现银饰冷冽质感
- **装饰带**：苗族蜡染几何纹样，使用品牌主色和刺绣橙交替
- **统计卡片**：左侧彩色竖条装饰，颜色对应数据维度
- **登录页**：动态SVG背景，山峦层叠、云朵漂浮、船只行走

### 品牌配色
- 苗银蓝：#1F5FA8（主色）
- 刺绣橙：#E85D2F（辅色）
- 梯田绿：#6B8E3D（辅色）
- 黎明金：#D4A14B（辅色）
- 蜡染棕：#7A5230（辅色）

<img width="1105" height="631" alt="image" src="https://github.com/user-attachments/assets/53978a06-0029-48bb-ad23-c08eb1bbb7ab" />
<img width="1106" height="628" alt="image" src="https://github.com/user-attachments/assets/d5d43be7-4cd3-4dfc-8749-22ee1d7411fb" />
<img width="1106" height="656" alt="image" src="https://github.com/user-attachments/assets/2143b8f8-7881-4989-902c-b97161497202" />
<img width="1106" height="650" alt="image" src="https://github.com/user-attachments/assets/8d59fca3-2051-458c-98d5-2fea2ad8ef70" />
<img width="1106" height="641" alt="image" src="https://github.com/user-attachments/assets/4652213b-98eb-461d-afd9-bf4c9cff68da" />
<img width="1106" height="655" alt="image" src="https://github.com/user-attachments/assets/7ea7261b-2e5f-450c-9660-586faa4cf5d5" />
<img width="1107" height="620" alt="image" src="https://github.com/user-attachments/assets/8a2cb136-e77b-48ec-bcf7-0e5675bb249a" />
<img width="1106" height="652" alt="image" src="https://github.com/user-attachments/assets/3807fd78-6995-4100-8f36-691f8d1ed549" />
<img width="1107" height="678" alt="image" src="https://github.com/user-attachments/assets/08425b14-dda9-4acc-aef1-072043fdebcf" />
<img width="1106" height="636" alt="image" src="https://github.com/user-attachments/assets/a399bc47-c116-458f-a2e0-31611c982eaa" />
<img width="1106" height="636" alt="image" src="https://github.com/user-attachments/assets/c32add81-dca5-49cc-a597-2e304ae4eff8" />











