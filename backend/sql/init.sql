-- 乌东文旅平台管理后台 数据库初始化脚本
-- 数据库名: wudong_admin

CREATE DATABASE IF NOT EXISTS `wudong_admin` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `wudong_admin`;

-- ============================================================
-- 1. 统一用户体系（公共表，游客/注册用户）
-- ============================================================
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid` VARCHAR(100) DEFAULT NULL COMMENT '微信openid',
  `username` VARCHAR(50) DEFAULT NULL COMMENT '用户名',
  `password_hash` VARCHAR(255) DEFAULT NULL COMMENT '密码（bcrypt加密）',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `nickname` VARCHAR(50) DEFAULT NULL COMMENT '昵称',
  `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
  `gender` TINYINT DEFAULT 0 COMMENT '性别：0-未知 1-男 2-女',
  `region` VARCHAR(100) DEFAULT NULL COMMENT '地区',
  `bio` VARCHAR(500) DEFAULT NULL COMMENT '个人简介',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-封禁',
  `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `login_fail_count` INT NOT NULL DEFAULT 0 COMMENT '连续登录失败次数',
  `locked_until` DATETIME DEFAULT NULL COMMENT '锁定截止时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_openid` (`openid`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='统一用户表（游客/注册用户）';

-- ============================================================
-- 2. RBAC 权限模型（三张表）
-- ============================================================
-- 权限表
CREATE TABLE IF NOT EXISTS `permission` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '权限名称',
  `code` VARCHAR(100) NOT NULL COMMENT '权限编码（如 product:manage）',
  `type` VARCHAR(20) NOT NULL DEFAULT 'menu' COMMENT '权限类型：menu-菜单 button-按钮 api-接口',
  `parent_id` INT UNSIGNED DEFAULT 0 COMMENT '父权限ID（0为顶级）',
  `path` VARCHAR(200) DEFAULT NULL COMMENT '前端路由路径',
  `icon` VARCHAR(100) DEFAULT NULL COMMENT '图标',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='权限表';

-- 角色表
CREATE TABLE IF NOT EXISTS `role` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL COMMENT '角色名称',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '角色描述',
  `type` VARCHAR(20) NOT NULL DEFAULT 'custom' COMMENT '角色类型：system-系统内置 custom-自定义',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `permissions` TEXT DEFAULT NULL COMMENT '菜单权限列表（JSON数组）',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色表';

-- 角色-权限关联表
CREATE TABLE IF NOT EXISTS `role_permission` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` INT UNSIGNED NOT NULL COMMENT '角色ID',
  `permission_id` INT UNSIGNED NOT NULL COMMENT '权限ID',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`, `permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色-权限关联表';

-- 管理员表
CREATE TABLE IF NOT EXISTS `admin` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL COMMENT '用户名',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密码（bcrypt加密）',
  `name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `phone` VARCHAR(20) DEFAULT NULL COMMENT '手机号',
  `avatar` VARCHAR(500) DEFAULT NULL COMMENT '头像URL',
  `role_id` INT UNSIGNED DEFAULT NULL COMMENT '角色ID',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `login_fail_count` INT NOT NULL DEFAULT 0 COMMENT '连续登录失败次数',
  `locked_until` DATETIME DEFAULT NULL COMMENT '锁定截止时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- ============================================================
-- 3. 商家相关
-- ============================================================
-- 商家账号表
CREATE TABLE IF NOT EXISTS `merchant` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT '关联用户ID',
  `username` VARCHAR(50) NOT NULL COMMENT '商家用户名',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密码',
  `shop_name` VARCHAR(100) NOT NULL COMMENT '店铺名称',
  `module_type` VARCHAR(20) NOT NULL COMMENT '所属模块：clothing/food/stay/travel',
  `contact_name` VARCHAR(50) DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
  `logo` VARCHAR(500) DEFAULT NULL COMMENT '店铺Logo',
  `description` TEXT COMMENT '店铺简介',
  `address` VARCHAR(200) DEFAULT NULL COMMENT '店铺地址',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
  `joined_at` DATETIME DEFAULT NULL COMMENT '入驻时间',
  `last_login_at` DATETIME DEFAULT NULL COMMENT '最后登录时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家账号表';

-- 商家入驻申请表
CREATE TABLE IF NOT EXISTS `merchant_application` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT '申请人用户ID',
  `applicant_name` VARCHAR(50) NOT NULL COMMENT '申请人姓名',
  `applicant_phone` VARCHAR(20) DEFAULT NULL COMMENT '申请人电话',
  `shop_name` VARCHAR(100) NOT NULL COMMENT '店铺名称',
  `module_type` VARCHAR(20) NOT NULL COMMENT '申请模块：clothing/food/stay/travel',
  `description` TEXT COMMENT '申请说明',
  `materials` JSON COMMENT '资质材料（图片URL数组）',
  `status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending/approved/rejected',
  `reviewer_id` INT UNSIGNED DEFAULT NULL COMMENT '审核人ID',
  `review_time` DATETIME DEFAULT NULL COMMENT '审核时间',
  `reject_reason` VARCHAR(500) DEFAULT NULL COMMENT '驳回原因',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`),
  KEY `idx_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商家入驻申请表';

-- ============================================================
-- 4. 内容运营
-- ============================================================
-- 平台公告表
CREATE TABLE IF NOT EXISTS `announcement` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL COMMENT '公告标题',
  `content` TEXT NOT NULL COMMENT '公告内容',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-已发布 0-草稿',
  `published_at` DATETIME DEFAULT NULL COMMENT '发布时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='平台公告表';

-- 首页轮播图表
CREATE TABLE IF NOT EXISTS `carousel` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL COMMENT '标题',
  `image_url` VARCHAR(500) NOT NULL COMMENT '图片URL',
  `link_url` VARCHAR(500) DEFAULT NULL COMMENT '跳转链接',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-上架 0-下架',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_sort_order` (`sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='首页轮播图表';

-- 活动横幅表
CREATE TABLE IF NOT EXISTS `activity_banner` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL COMMENT '横幅标题',
  `image_url` VARCHAR(500) NOT NULL COMMENT '图片URL',
  `link_url` VARCHAR(500) DEFAULT NULL COMMENT '跳转链接',
  `start_time` DATETIME DEFAULT NULL COMMENT '起始时间',
  `end_time` DATETIME DEFAULT NULL COMMENT '结束时间',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='活动横幅表';

-- 推荐位表
CREATE TABLE IF NOT EXISTS `recommendation` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL COMMENT '推荐位名称',
  `content_type` VARCHAR(30) NOT NULL COMMENT '关联内容类型：product/restaurant/homestay/route/travel_note',
  `content_id` INT UNSIGNED NOT NULL COMMENT '关联内容ID',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_content` (`content_type`, `content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='推荐位表';

-- ============================================================
-- 5. 消息中心
-- ============================================================
-- 系统消息表
CREATE TABLE IF NOT EXISTS `system_message` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED DEFAULT NULL COMMENT '接收用户ID（NULL表示群发）',
  `message_type` VARCHAR(30) NOT NULL COMMENT '消息类型：system/order/payment/refund/interaction',
  `title` VARCHAR(200) NOT NULL COMMENT '消息标题',
  `content` TEXT COMMENT '消息内容',
  `is_read` TINYINT NOT NULL DEFAULT 0 COMMENT '已读状态：0-未读 1-已读',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统消息表';

-- 消息模板表
CREATE TABLE IF NOT EXISTS `message_template` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50) NOT NULL COMMENT '模板编码',
  `name` VARCHAR(100) NOT NULL COMMENT '模板名称',
  `title_template` VARCHAR(200) NOT NULL COMMENT '标题模板（含占位符）',
  `content_template` TEXT NOT NULL COMMENT '内容模板（含占位符）',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='消息模板表';

-- ============================================================
-- 6. 财务结算
-- ============================================================
-- 财务记录表
CREATE TABLE IF NOT EXISTS `financial_record` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` INT UNSIGNED DEFAULT NULL COMMENT '订单ID',
  `order_no` VARCHAR(50) DEFAULT NULL COMMENT '订单编号',
  `merchant_id` INT UNSIGNED NOT NULL COMMENT '商家ID',
  `order_amount` DECIMAL(10,2) NOT NULL COMMENT '订单金额',
  `commission_rate` DECIMAL(5,4) NOT NULL DEFAULT 0.0000 COMMENT '平台抽佣比例',
  `commission_amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '平台抽佣金额',
  `merchant_income` DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '商家收入',
  `settlement_status` VARCHAR(20) NOT NULL DEFAULT 'pending' COMMENT '结算状态：pending/settled',
  `settled_at` DATETIME DEFAULT NULL COMMENT '结算时间',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_settlement_status` (`settlement_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='财务记录表';

-- ============================================================
-- 7. 系统设置
-- ============================================================
-- 系统配置表
CREATE TABLE IF NOT EXISTS `system_config` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key` VARCHAR(100) NOT NULL COMMENT '配置键',
  `config_value` TEXT COMMENT '配置值',
  `config_type` VARCHAR(20) NOT NULL DEFAULT 'string' COMMENT '值类型：string/number/json/boolean',
  `description` VARCHAR(200) DEFAULT NULL COMMENT '配置说明',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统配置表';

-- 敏感词库表
CREATE TABLE IF NOT EXISTS `sensitive_word` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `word` VARCHAR(100) NOT NULL COMMENT '敏感词',
  `category` VARCHAR(50) DEFAULT NULL COMMENT '分类',
  `status` TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_word` (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='敏感词库表';

-- ============================================================
-- 8. 操作日志
-- ============================================================
-- 操作日志表
CREATE TABLE IF NOT EXISTS `operation_log` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator_id` INT UNSIGNED NOT NULL COMMENT '操作人ID',
  `operator_name` VARCHAR(50) DEFAULT NULL COMMENT '操作人姓名',
  `operator_type` VARCHAR(20) NOT NULL DEFAULT 'admin' COMMENT '操作人类型：admin/merchant/user',
  `action` VARCHAR(50) NOT NULL COMMENT '操作类型',
  `target` VARCHAR(100) DEFAULT NULL COMMENT '操作对象',
  `target_id` INT UNSIGNED DEFAULT NULL COMMENT '操作对象ID',
  `content` TEXT COMMENT '操作内容',
  `ip` VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
  `user_agent` VARCHAR(500) DEFAULT NULL COMMENT '浏览器UA',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_operator_id` (`operator_id`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- ============================================================
-- 9. 全局订单（统一订单中心）
-- ============================================================
-- 统一订单表
CREATE TABLE IF NOT EXISTS `order` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` VARCHAR(50) NOT NULL COMMENT '订单编号',
  `order_type` VARCHAR(20) NOT NULL COMMENT '订单类型：product/food_order/stay/ticket/route',
  `user_id` INT UNSIGNED NOT NULL COMMENT '用户ID',
  `merchant_id` INT UNSIGNED DEFAULT NULL COMMENT '商家ID',
  `total_amount` DECIMAL(10,2) NOT NULL COMMENT '订单总金额',
  `status` VARCHAR(30) NOT NULL DEFAULT 'pending_payment' COMMENT '订单状态',
  `pay_time` DATETIME DEFAULT NULL COMMENT '支付时间',
  `pay_method` VARCHAR(20) DEFAULT NULL COMMENT '支付方式',
  `transaction_id` VARCHAR(100) DEFAULT NULL COMMENT '微信支付交易号',
  `remark` VARCHAR(500) DEFAULT NULL COMMENT '备注',
  `refund_reject_reason` VARCHAR(500) DEFAULT NULL COMMENT '退款拒绝原因',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_merchant_id` (`merchant_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='统一订单表';

-- ============================================================
-- 初始数据
-- ============================================================

-- 插入默认权限
INSERT INTO `permission` (`name`, `code`, `type`, `parent_id`, `path`, `sort_order`) VALUES
('数据看板', 'dashboard', 'menu', 0, '/dashboard', 100),
('管理员管理', 'admin:manage', 'menu', 0, NULL, 90),
('管理员列表', 'admin:list', 'menu', 2, '/admin/list', 91),
('角色管理', 'admin:role', 'menu', 2, '/role/list', 92),
('用户管理', 'user:manage', 'menu', 0, NULL, 80),
('用户列表', 'user:list', 'menu', 5, '/user/list', 81),
('商家管理', 'merchant:manage', 'menu', 0, NULL, 70),
('商家列表', 'merchant:list', 'menu', 7, '/merchant/list', 71),
('入驻审核', 'merchant:application', 'menu', 7, '/merchant/application', 72),
('内容管理', 'content:manage', 'menu', 0, NULL, 60),
('公告管理', 'content:announcement', 'menu', 10, '/content/announcement', 61),
('轮播图管理', 'content:carousel', 'menu', 10, '/content/carousel', 62),
('活动横幅', 'content:banner', 'menu', 10, '/content/banner', 63),
('推荐位管理', 'content:recommendation', 'menu', 10, '/content/recommendation', 64),
('订单管理', 'order:manage', 'menu', 0, NULL, 50),
('全局订单', 'order:list', 'menu', 15, '/order/list', 51),
('退款审批', 'order:refund', 'menu', 15, '/order/refund', 52),
('财务结算', 'finance:manage', 'menu', 0, NULL, 40),
('结算列表', 'finance:list', 'menu', 18, '/finance/list', 41),
('财务报表', 'finance:report', 'menu', 18, '/finance/report', 42),
('消息中心', 'message:manage', 'menu', 0, NULL, 30),
('系统消息', 'message:list', 'menu', 21, '/message/list', 31),
('消息模板', 'message:template', 'menu', 21, '/message/template', 32),
('系统设置', 'system:manage', 'menu', 0, NULL, 20),
('系统配置', 'system:config', 'menu', 24, '/system/config', 21),
('敏感词库', 'system:sensitive', 'menu', 24, '/system/sensitive', 22),
('操作日志', 'system:log', 'menu', 24, '/system/log', 23);

-- 插入默认超级管理员角色
INSERT INTO `role` (`name`, `description`, `type`, `status`) VALUES
('超级管理员', '拥有全部权限', 'system', 1),
('运营管理员', '内容运营管理', 'system', 1),
('财务管理员', '财务结算管理', 'system', 1);

-- 超级管理员拥有全部权限
INSERT INTO `role_permission` (`role_id`, `permission_id`)
SELECT 1, `id` FROM `permission`;

-- 插入默认管理员账号（密码: admin123，bcrypt加密）
INSERT INTO `admin` (`username`, `password_hash`, `name`, `phone`, `role_id`, `status`) VALUES
('admin', '$2a$12$o16vgw8M5f0X7Ngs2vq7w.l6QoHekFtNSMwBi7HLwe/LzGlovJQjW', '超级管理员', '13800000000', 1, 1);

-- 插入默认系统配置
INSERT INTO `system_config` (`config_key`, `config_value`, `config_type`, `description`) VALUES
('commission_rate_clothing', '0.1000', 'number', '衣模块抽佣比例'),
('commission_rate_food', '0.0800', 'number', '食模块抽佣比例'),
('commission_rate_stay', '0.0800', 'number', '住模块抽佣比例'),
('commission_rate_travel', '0.0500', 'number', '行模块抽佣比例'),
('settlement_cycle_ticket', '7', 'number', '门票/线路结算周期（天）'),
('settlement_cycle_other', '15', 'number', '商品/餐厅/民宿结算周期（天）'),
('shipping_template', '{"free_shipping_amount":99,"default_fee":10}', 'json', '运费模板'),
('payment_mch_id', '', 'string', '微信支付商户号'),
('sms_provider', 'aliyun', 'string', '短信服务商'),
('sms_access_key', '', 'string', '短信AccessKey');

-- 插入默认消息模板
INSERT INTO `message_template` (`code`, `name`, `title_template`, `content_template`) VALUES
('order_created', '下单成功', '订单创建成功', '您的订单{{order_no}}已创建，请在15分钟内完成支付。'),
('order_paid', '支付成功', '订单支付成功', '您的订单{{order_no}}已支付成功，金额¥{{amount}}。'),
('order_shipped', '发货通知', '商品已发货', '您的订单{{order_no}}已发货，物流公司：{{company}}，运单号：{{tracking_no}}。'),
('refund_success', '退款成功', '退款已到账', '您的订单{{order_no}}退款¥{{amount}}已到账，请注意查收。'),
('application_approved', '入驻审核通过', '商家入驻申请已通过', '恭喜！您的商家入驻申请已通过审核，店铺名：{{shop_name}}。'),
('application_rejected', '入驻审核驳回', '商家入驻申请被驳回', '您的商家入驻申请未通过审核，原因：{{reason}}。请修改后重新提交。');

-- 插入测试用户
INSERT INTO `user` (`openid`, `username`, `phone`, `nickname`, `avatar`, `gender`, `region`, `status`) VALUES
('test_openid_001', 'user001', '13900001111', '苗寨游客', NULL, 1, '贵州凯里', 1),
('test_openid_002', 'user002', '13900002222', '旅行达人', NULL, 2, '上海', 1),
('test_openid_003', 'user003', '13900003333', '非遗爱好者', NULL, 1, '北京', 1);

-- ============================================================
-- 升级脚本：role 表新增 type 列（已有数据库执行）
-- ============================================================
ALTER TABLE `role` ADD COLUMN `type` VARCHAR(20) NOT NULL DEFAULT 'custom' COMMENT '角色类型：system-系统内置 custom-自定义' AFTER `description`;

-- 将已有内置角色标记为 system
UPDATE `role` SET `type` = 'system' WHERE `id` IN (1, 2, 3);

-- ============================================================
-- 升级脚本：merchant 表新增登录失败计数和锁定字段
-- ============================================================
ALTER TABLE `merchant` ADD COLUMN `login_fail_count` INT NOT NULL DEFAULT 0 COMMENT '连续登录失败次数' AFTER `last_login_at`;
ALTER TABLE `merchant` ADD COLUMN `locked_until` DATETIME DEFAULT NULL COMMENT '锁定截止时间' AFTER `login_fail_count`;
