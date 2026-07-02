/*
 Navicat Premium Dump SQL

 Source Server         : 127.0.0.1
 Source Server Type    : MySQL
 Source Server Version : 80038 (8.0.38)
 Source Host           : 127.0.0.1:3306
 Source Schema         : wudong_admin

 Target Server Type    : MySQL
 Target Server Version : 80038 (8.0.38)
 File Encoding         : 65001

 Date: 02/07/2026 11:41:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for activity_banner
-- ----------------------------
DROP TABLE IF EXISTS `activity_banner`;
CREATE TABLE `activity_banner`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '横幅标题',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片URL',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '跳转链接',
  `start_time` datetime NULL DEFAULT NULL COMMENT '起始时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '活动横幅表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of activity_banner
-- ----------------------------
INSERT INTO `activity_banner` VALUES (1, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-20 23:48:37', '2026-06-20 23:48:37', 1);
INSERT INTO `activity_banner` VALUES (2, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `activity_banner` VALUES (3, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `activity_banner` VALUES (4, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `activity_banner` VALUES (5, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `activity_banner` VALUES (6, '更新横幅', '/img/banner.jpg', '/activity/1', NULL, NULL, 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `activity_banner` VALUES (7, '好消息好消息', '/api/upload/file/1782023869527-rlxase.jpg', 'www.jd.com', '2026-06-22 01:03:13', '2026-06-23 00:02:00', 1, '2026-06-21 14:38:28', '2026-06-21 14:38:37', 0);

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码（bcrypt加密）',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '姓名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `role_id` int UNSIGNED NULL DEFAULT NULL COMMENT '角色ID',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `last_login_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后登录地点',
  `login_fail_count` int NOT NULL DEFAULT 0 COMMENT '连续登录失败次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定截止时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_role_id`(`role_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, 'admin', '$2a$12$o16vgw8M5f0X7Ngs2vq7w.l6QoHekFtNSMwBi7HLwe/LzGlovJQjW', '超级管理员', '13800000000', NULL, 1, 1, '2026-07-01 12:11:29', '::1', '', 0, NULL, '2026-06-19 15:27:21', '2026-07-01 12:11:28', 0);
INSERT INTO `admin` VALUES (2, 'admintest', '$2a$12$o79vKnohUFWiwkVPy33OzennuCUvOoJxdY/Wqc.DJrVHxkMXZC0xG', 'xyYoung', '15814963251', NULL, 2, 1, '2026-06-21 20:30:56', '::1', '', 0, NULL, '2026-06-20 20:10:16', '2026-06-21 20:30:56', 0);
INSERT INTO `admin` VALUES (3, 'admintest02', '$2a$12$MWBivyoqddPMZM4Bo7GnXe62KDRC25gpWXf.xwpPlenY9fPjB3LkG', 'k-fry', '16865423695', NULL, 3, 1, '2026-07-01 12:16:37', '::1', '', 0, NULL, '2026-06-20 20:21:23', '2026-07-01 12:16:36', 0);
INSERT INTO `admin` VALUES (4, 'test_integration_1781969951948', '$2a$12$wBRiLJSamshCSP.qukdQ9e4BkHIftDxDqGU366xZ5uhU5Wh63AuMG', '集成测试管理员', '13900000000', NULL, 2, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:39:12', '2026-06-20 23:39:12', 0);
INSERT INTO `admin` VALUES (5, 'test_integration_1781969966566', '$2a$12$Ut.l4HWAQDUzFs9VJYln6.6mcu931e3uw42VmCM/RQ58j1kOvzv4G', '集成测试管理员', '13900000000', NULL, 2, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:39:27', '2026-06-20 23:39:27', 0);
INSERT INTO `admin` VALUES (6, 'test_integration_1781970004694', '$2a$12$HNYPC5BOU/5IquPUhZhn9OcsDW/LiKqUYBblrHUQU4XU4hOpgZObK', '集成测试管理员', '13900000000', NULL, 2, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:40:05', '2026-06-20 23:40:05', 0);
INSERT INTO `admin` VALUES (7, 'test_integration_1781970030965', '$2a$12$1cbUYo5Cs7e0yGtOkF3Ka.DRE5aYd9pCMvtS7PbTh/g2fdLezM10O', 'test', '13900000000', NULL, 2, 1, NULL, NULL, NULL, 5, '2026-06-21 14:51:13', '2026-06-20 23:40:31', '2026-06-21 14:21:13', 0);
INSERT INTO `admin` VALUES (8, 'test_integration_1781970115956', '$2a$12$GyzBRQk8mMU4bk8Ot/FXSOztNpdd8973sJYJf6LhWK38pzjQm/HeG', '集成测试管理员', '13900000000', NULL, 4, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:41:56', '2026-06-20 23:41:56', 1);
INSERT INTO `admin` VALUES (9, 'tmp_1781970514042', '$2a$12$3HeUdeod1jceJBJcFf9MLuWiUC4Ng5HzNS4riHeHi56ZADhUjDuRa', '更新后', '13900000001', NULL, 5, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:48:34', '2026-06-20 23:48:34', 1);
INSERT INTO `admin` VALUES (10, 'tmp_1781970885874', '$2a$12$q8ve44UZMpDK.xATfZPm5.z8NhlNL/9QhzrWaxXtcqHHZRMOHptgi', '更新后', '13900000001', NULL, 6, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:54:46', '2026-06-20 23:54:46', 1);
INSERT INTO `admin` VALUES (11, 'tmp_1781970964363', '$2a$12$nhZgxVN/dMyFu1FynhMzGu9gvIzo8Fve2A59G1SPmx0QZj/E43n4m', '更新后', '13900000001', NULL, 7, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:56:05', '2026-06-20 23:56:05', 1);
INSERT INTO `admin` VALUES (12, 'tmp_1781971016358', '$2a$12$0jkE.JW7lPqaRdp2vizVLeVzAVHSPX7xv.JEQivwC2nsC6SXO54qi', '更新后', '13900000001', NULL, 8, 1, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:56:57', '2026-06-20 23:56:57', 1);
INSERT INTO `admin` VALUES (13, 'tmp_1781971268035', '$2a$12$ch17Lads1cMUhCwCRXBFHOP6Ezd0ViIBXp1tslVXLwZse/i6RL5HG', '更新后', '13900000001', NULL, 9, 1, NULL, NULL, NULL, 0, NULL, '2026-06-21 00:01:08', '2026-06-21 00:01:08', 1);
INSERT INTO `admin` VALUES (14, 'tmp_1781971334755', '$2a$12$fRb8YAl4VBjuHQ6fFxHP4.A0uEsFLl6yClqvE5WGe5hZgJvGBzlzW', '更新后', '13900000001', NULL, 10, 1, NULL, NULL, NULL, 0, NULL, '2026-06-21 00:02:15', '2026-06-21 00:02:15', 1);
INSERT INTO `admin` VALUES (15, 'rbac_test_ops', '$2a$12$NyP4JLRcOV3Cs3hRzoAc3Opbgsu7/ZP330EgGbG/BUPtPtVay2Pg6', 'RBAC������ӪԱ', '13800009999', NULL, 2, 1, '2026-06-21 20:15:55', '::1', '', 0, NULL, '2026-06-21 20:15:38', '2026-06-21 20:15:55', 0);

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告内容',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-已发布 0-草稿',
  `published_at` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '平台公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '更新公告', '测试内容', 1, NULL, '2026-06-20 23:48:36', '2026-06-20 23:48:36', 1);
INSERT INTO `announcement` VALUES (2, '更新公告', '测试内容', 1, NULL, '2026-06-20 23:54:48', '2026-06-20 23:54:49', 1);
INSERT INTO `announcement` VALUES (3, '更新公告', '测试内容', 1, NULL, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `announcement` VALUES (4, '更新公告', '测试内容', 1, NULL, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `announcement` VALUES (5, '更新公告', '测试内容', 1, NULL, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `announcement` VALUES (6, '更新公告', '测试内容', 1, NULL, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `announcement` VALUES (7, '端午安康', '祝全体成员端午安康！！', 1, '2026-06-21 14:36:17', '2026-06-21 14:36:17', '2026-06-21 14:36:23', 0);

-- ----------------------------
-- Table structure for carousel
-- ----------------------------
DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片URL',
  `link_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '跳转链接',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序（越大越靠前）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-上架 0-下架',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '首页轮播图表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of carousel
-- ----------------------------
INSERT INTO `carousel` VALUES (1, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-20 23:48:36', '2026-06-20 23:48:36', 1);
INSERT INTO `carousel` VALUES (2, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `carousel` VALUES (3, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `carousel` VALUES (4, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `carousel` VALUES (5, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `carousel` VALUES (6, '更新轮播', '/img/test.jpg', NULL, 1, 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `carousel` VALUES (7, 'PC端官网首页', '/api/upload/file/1782023810422-xhd5wd.jpg', 'www.baidu.com', 1, 1, '2026-06-21 14:37:05', '2026-06-21 14:37:05', 0);

-- ----------------------------
-- Table structure for financial_record
-- ----------------------------
DROP TABLE IF EXISTS `financial_record`;
CREATE TABLE `financial_record`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_id` int UNSIGNED NULL DEFAULT NULL COMMENT '订单ID',
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '订单编号',
  `merchant_id` int UNSIGNED NOT NULL COMMENT '商家ID',
  `order_amount` decimal(10, 2) NOT NULL COMMENT '订单金额',
  `commission_rate` decimal(5, 4) NOT NULL DEFAULT 0.0000 COMMENT '平台抽佣比例',
  `commission_amount` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '平台抽佣金额',
  `merchant_income` decimal(10, 2) NOT NULL DEFAULT 0.00 COMMENT '商家收入',
  `settlement_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '结算状态：pending/settled',
  `settled_at` datetime NULL DEFAULT NULL COMMENT '结算时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_settlement_status`(`settlement_status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '财务记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of financial_record
-- ----------------------------
INSERT INTO `financial_record` VALUES (1, 22, 'ORD_COMPLETED2_1781971338460', 14, 150.00, 0.1500, 22.50, 127.50, 'settled', '2026-06-21 00:02:19', '2026-06-21 00:02:19', '2026-06-21 01:37:08', 1);
INSERT INTO `financial_record` VALUES (2, 21, 'ORD_COMPLETED_1781971338439', 14, 200.00, 0.0800, 16.00, 184.00, 'settled', '2026-06-21 00:02:19', '2026-06-21 00:02:19', '2026-06-21 01:37:08', 1);
INSERT INTO `financial_record` VALUES (3, 23, 'ORD_COMPLETED3_1781971338480', 14, 80.00, 0.0500, 4.00, 76.00, 'settled', '2026-06-21 00:02:19', '2026-06-21 00:02:19', '2026-06-21 01:37:08', 1);
INSERT INTO `financial_record` VALUES (4, 1, 'WD20260615001', 1, 299.00, 0.1000, 29.90, 269.10, 'settled', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (5, 2, 'WD20260615002', 2, 156.50, 0.1000, 15.65, 140.85, 'settled', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (6, 3, 'WD20260616001', 17, 680.00, 0.1000, 68.00, 612.00, 'settled', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (7, 4, 'WD20260616002', 18, 320.00, 0.1000, 32.00, 288.00, 'settled', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (8, 5, 'WD20260617001', 16, 459.00, 0.1000, 45.90, 413.10, 'pending', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (9, 6, 'WD20260617002', 15, 88.00, 0.1000, 8.80, 79.20, 'settled', '2026-06-21 15:31:02', '2026-06-21 01:46:48', '2026-06-21 15:31:02', 0);
INSERT INTO `financial_record` VALUES (10, 7, 'WD20260621001', 1, 1280.00, 0.1000, 128.00, 1152.00, 'settled', '2026-06-21 15:31:02', '2026-06-21 01:46:48', '2026-06-21 15:31:02', 0);
INSERT INTO `financial_record` VALUES (11, 8, 'WD20260621002', 15, 235.00, 0.1000, 23.50, 211.50, 'pending', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (12, 9, 'WD20260621003', 17, 1560.00, 0.1000, 156.00, 1404.00, 'pending', NULL, '2026-06-21 01:46:48', '2026-06-21 01:46:48', 0);
INSERT INTO `financial_record` VALUES (13, 24, 'WD20260615001', 1, 299.00, 0.1500, 44.85, 254.15, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (14, 25, 'WD20260615002', 2, 156.50, 0.0800, 12.52, 143.98, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (15, 26, 'WD20260616001', 17, 680.00, 0.0800, 54.40, 625.60, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (16, 27, 'WD20260616002', 18, 320.00, 0.0500, 16.00, 304.00, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (17, 28, 'WD20260617001', 16, 459.00, 0.1500, 68.85, 390.15, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (18, 29, 'WD20260617002', 15, 88.00, 0.0800, 7.04, 80.96, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (19, 30, 'WD20260621001', 1, 1280.00, 0.1500, 192.00, 1088.00, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (20, 31, 'WD20260621002', 15, 235.00, 0.0800, 18.80, 216.20, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (21, 32, 'WD20260621003', 17, 1560.00, 0.0800, 124.80, 1435.20, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (22, 33, 'WD20260621004', 16, 688.00, 0.1500, 103.20, 584.80, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `financial_record` VALUES (23, 34, 'WD20260621005', 2, 178.00, 0.0800, 14.24, 163.76, 'pending', NULL, '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);

-- ----------------------------
-- Table structure for merchant
-- ----------------------------
DROP TABLE IF EXISTS `merchant`;
CREATE TABLE `merchant`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL COMMENT '关联用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '商家用户名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名称',
  `module_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '所属模块：clothing/food/stay/travel',
  `contact_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人姓名',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '绑定手机号（登录验证/接收通知）',
  `logo` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺Logo',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '店铺简介',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '店铺地址',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-禁用',
  `joined_at` datetime NULL DEFAULT NULL COMMENT '入驻时间',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  `last_login_location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '最后登录地点',
  `login_fail_count` int NOT NULL DEFAULT 0 COMMENT '连续登录失败次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定截止时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家账号表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant
-- ----------------------------
INSERT INTO `merchant` VALUES (1, NULL, 'merchant01', '$2a$12$4KrFlIIwLCVFk0QwkmU8ZehqtQT203UPpZaEUl9K79tolrhSssdvq', '好衣', 'clothing', '艳火', '866-2506-231', '16865423695', '/api/upload/file/1781955417556-nil9cg.jpg', '卖GGBOND', '广州城市理工学院', 1, NULL, '2026-06-24 16:24:31', '::1', '', 0, NULL, '2026-06-19 16:37:19', '2026-06-24 16:24:31', 0);
INSERT INTO `merchant` VALUES (2, NULL, 'merchant02', '$2a$12$AjeLLAz.ZIvvgr5A.2lWYuwbdmcZqB.1qGLgDQ9Zkg5hl4AJY/.8O', '好食', 'food', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 5, '2026-06-20 22:47:14', '2026-06-20 21:56:22', '2026-06-20 22:17:13', 0);
INSERT INTO `merchant` VALUES (3, NULL, 'test_shop_1781969903264', '$2a$12$SR2u./6z6g6HS6tlSKp6tuChP7xIeO/LgSZyQoSfuAvCi9JeHX/pG', '集成测试店铺', 'food', '测试联系人', '13900001111', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-20 23:38:25', NULL, NULL, 0, NULL, '2026-06-20 23:38:24', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant` VALUES (4, NULL, '集成测试店铺_1781969950198', '$2a$12$/sYzZfkzJpPjtKUk7/DeD.xgUbmRlx8X.RwP0ALDAoGAEd9VxQdPu', '集成测试店铺_1781969950198', 'food', '测试联系人', '13900001111', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-20 23:39:12', NULL, NULL, 0, NULL, '2026-06-20 23:39:11', '2026-06-21 01:46:02', 1);
INSERT INTO `merchant` VALUES (5, NULL, '集成测试店铺_1781969964765', '$2a$12$DLK0W/.L3/qZi3LcOWYnlOpedMM.DyCeqkHyvaVfznIg.X9mKmt5a', '集成测试店铺_1781969964765', 'food', '测试联系人', '13900001111', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-20 23:39:26', NULL, NULL, 0, NULL, '2026-06-20 23:39:25', '2026-06-21 01:46:02', 1);
INSERT INTO `merchant` VALUES (6, NULL, '集成测试店铺_1781970003019', '$2a$12$xYaRwj2Ud0cghWGZpPIjnOKTDh9w9nTCwnC.JlFDxhOHg3SPzpJUy', '集成测试店铺_1781970003019', 'food', '测试联系人', '13900001111', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-20 23:40:05', NULL, NULL, 0, NULL, '2026-06-20 23:40:03', '2026-06-21 01:46:02', 1);
INSERT INTO `merchant` VALUES (7, NULL, '集成测试店铺_1781970114224', '$2a$12$JUiHJzSJusOpRNSC2HmSfebdkJhUQ66TBkrI55IWsCmjOwmqGC0Te', '集成测试店铺_1781970114224', 'food', '测试联系人', '13900001111', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-20 23:41:56', NULL, NULL, 0, NULL, '2026-06-20 23:41:55', '2026-06-21 01:46:02', 1);
INSERT INTO `merchant` VALUES (8, NULL, '完整测试_1781970512171', '$2a$12$fVZUh.2esYFNHMz0L1njh.aIrAYcWc810wPQWErdb1T8Lb6A9/BfW', '完整测试_1781970512171', 'food', '测试', '13900001111', NULL, NULL, '更新描述', NULL, 1, NULL, NULL, NULL, NULL, 0, NULL, '2026-06-20 23:48:32', '2026-06-20 23:48:37', 1);
INSERT INTO `merchant` VALUES (9, NULL, '13900002222', '$2a$12$6w61wkIMxig95yjkGD7RjucaF7Ymgiw6JypaBxEzabf.WZwBPn8N6', '测试申请店铺', 'clothing', '张三', '13900002222', NULL, NULL, NULL, NULL, 1, '2026-06-20 23:48:37', NULL, NULL, NULL, 0, NULL, '2026-06-20 23:48:36', '2026-06-21 01:46:02', 1);
INSERT INTO `merchant` VALUES (10, NULL, '完整测试_1781970884142', '$2a$12$qeUSnRPkAwr8zd7OaZZGaOoXQKswK.GMJNCvsp6866ZLuTvjz76XK', '完整测试_1781970884142', 'food', '测试', '13900001111', NULL, NULL, '测试简介', NULL, 1, NULL, '2026-06-20 23:54:49', NULL, NULL, 0, NULL, '2026-06-20 23:54:44', '2026-06-20 23:54:49', 1);
INSERT INTO `merchant` VALUES (11, NULL, '完整测试_1781970962802', '$2a$12$gpdiSdfu2RgdUekmClO/m.pZ.fVELCvLyNHrRYnEvXgtf1SWIibCq', '完整测试_1781970962802', 'food', '测试', '13900001111', NULL, NULL, '更新描述', NULL, 1, NULL, '2026-06-20 23:56:07', NULL, NULL, 0, NULL, '2026-06-20 23:56:03', '2026-06-20 23:56:07', 1);
INSERT INTO `merchant` VALUES (12, NULL, '完整测试_1781971014693', '$2a$12$uUSFX.RIdFCvBGgVB3X3HOg1oSQLdoIcpTXE/hHgHflVql/ugLy9S', '完整测试_1781971014693', 'food', '测试', '13900001111', NULL, NULL, '测试简介', NULL, 1, NULL, '2026-06-20 23:56:59', NULL, NULL, 0, NULL, '2026-06-20 23:56:55', '2026-06-20 23:57:00', 1);
INSERT INTO `merchant` VALUES (13, NULL, '完整测试_1781971266460', '$2a$12$sXu8UI0AJsdHbyh23hacyu1UA00jORwg8dw.ph1SwvZWUadDvl/ei', '完整测试_1781971266460', 'food', '测试', '13900001111', NULL, NULL, '测试简介', NULL, 1, NULL, '2026-06-21 00:01:11', NULL, NULL, 0, NULL, '2026-06-21 00:01:07', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant` VALUES (14, NULL, '完整测试_1781971332973', '$2a$12$lVO7HgtEjap7QRgY9n6Dwu9ML0FbpCZylIlNEptYsAuTuK52g0rFu', '完整测试_1781971332973', 'food', '测试', '13900001111', NULL, NULL, '测试简介', NULL, 1, NULL, '2026-06-21 00:02:18', NULL, NULL, 0, NULL, '2026-06-21 00:02:13', '2026-06-21 00:02:19', 1);
INSERT INTO `merchant` VALUES (15, NULL, 'guizhou_tea', '$2a$12$abc123', '贵州茶庄', 'food', '陈老板', '13800001001', NULL, NULL, NULL, NULL, 1, '2026-06-21 01:46:02', NULL, NULL, NULL, 1, NULL, '2026-06-21 01:46:02', '2026-06-21 20:20:37', 0);
INSERT INTO `merchant` VALUES (16, NULL, 'miao_xiu_fang', '$2a$12$abc123', '苗绣坊', 'clothing', '王绣娘', '13800001002', NULL, NULL, NULL, NULL, 1, '2026-06-21 01:46:02', NULL, NULL, NULL, 0, NULL, '2026-06-21 01:46:02', '2026-06-21 01:46:02', 0);
INSERT INTO `merchant` VALUES (17, NULL, 'dong_homestay', '$2a$12$abc123', '侗寨民宿', 'stay', '吴老板', '13800001003', NULL, NULL, NULL, NULL, 1, '2026-06-21 01:46:02', NULL, NULL, NULL, 0, NULL, '2026-06-21 01:46:02', '2026-06-21 01:46:02', 0);
INSERT INTO `merchant` VALUES (18, NULL, 'huangguoshu_tour', '$2a$12$abc123', '黄果树旅行社', 'travel', '李导', '13800001004', NULL, NULL, NULL, NULL, 1, '2026-06-21 01:46:02', NULL, NULL, NULL, 0, NULL, '2026-06-21 01:46:02', '2026-06-21 17:33:13', 0);
INSERT INTO `merchant` VALUES (19, 3, '13900003333', '$2a$12$hmz72rO.WpBFk61bL98da.528FGlTQrbwd8zl7bdYEgx5eEcAzE7W', '千户苗寨观景民宿', 'stay', '王山水', '13900003333', NULL, '/api/upload/file/1782037771177-eclnwe.jpg', NULL, NULL, 1, '2026-06-21 17:51:26', '2026-06-21 18:29:00', NULL, NULL, 0, NULL, '2026-06-21 17:51:25', '2026-06-21 18:29:32', 0);
INSERT INTO `merchant` VALUES (20, NULL, 'test_rbac_merchant', '$2a$12$EmgmKmMpMv3yvPq4JX/U9.5DRlWuF2s6whZLfF3EgL3pho3gakxym', 'RBAC���Ե���', 'clothing', '�����̼�', '13800008888', NULL, NULL, NULL, NULL, 1, NULL, '2026-06-21 20:24:23', '::1', '', 0, NULL, '2026-06-21 20:22:35', '2026-06-21 20:24:23', 0);

-- ----------------------------
-- Table structure for merchant_application
-- ----------------------------
DROP TABLE IF EXISTS `merchant_application`;
CREATE TABLE `merchant_application`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL COMMENT '申请人用户ID',
  `applicant_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请人姓名',
  `applicant_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '申请人电话',
  `shop_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '店铺名称',
  `module_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请模块：clothing/food/stay/travel',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '申请说明',
  `materials` json NULL COMMENT '资质材料（图片URL数组）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT '审核状态：pending/approved/rejected',
  `reviewer_id` int UNSIGNED NULL DEFAULT NULL COMMENT '审核人ID',
  `review_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '驳回原因',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '商家入驻申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of merchant_application
-- ----------------------------
INSERT INTO `merchant_application` VALUES (1, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-20 23:48:36', NULL, '2026-06-20 23:48:35', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (2, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-20 23:48:37', '资质不全', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 1);
INSERT INTO `merchant_application` VALUES (3, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-20 23:54:49', NULL, '2026-06-20 23:54:48', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (4, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-20 23:54:49', '资质不全', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 1);
INSERT INTO `merchant_application` VALUES (5, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-20 23:56:07', NULL, '2026-06-20 23:56:07', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (6, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-20 23:56:07', '资质不全', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `merchant_application` VALUES (7, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-20 23:56:59', NULL, '2026-06-20 23:56:59', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (8, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-20 23:56:59', '资质不全', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `merchant_application` VALUES (9, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-21 00:01:11', NULL, '2026-06-21 00:01:10', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (10, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-21 00:01:11', '资质不全', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 1);
INSERT INTO `merchant_application` VALUES (11, NULL, '张三', '13900002222', '测试申请店铺', 'clothing', '更新申请', NULL, 'approved', 1, '2026-06-21 00:02:18', NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `merchant_application` VALUES (12, NULL, '李四', '13900003333', '驳回测试店铺', 'stay', NULL, NULL, 'rejected', 1, '2026-06-21 00:02:18', '资质不全', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `merchant_application` VALUES (13, 1, '张苗苗', '13900001111', '苗寨银饰坊', 'clothing', '专注苗族银饰手工制作，传承非遗工艺，拥有10年经营经验。', '[\"https://example.com/cert1.jpg\", \"https://example.com/cert2.jpg\"]', 'pending', NULL, NULL, NULL, '2026-06-20 17:50:12', '2026-06-21 17:50:12', 0);
INSERT INTO `merchant_application` VALUES (14, 2, '李阿妹', '13900002222', '酸汤鱼老店', 'food', '凯里老字号酸汤鱼，三代传承，本地特色美食。', '[\"https://example.com/food_cert.jpg\"]', 'rejected', 1, '2026-06-21 17:51:48', '不给你入驻', '2026-06-17 17:50:12', '2026-06-21 17:51:48', 0);
INSERT INTO `merchant_application` VALUES (15, 3, '王山水', '13900003333', '千户苗寨观景民宿', 'stay', '位于西江千户苗寨核心景区，观景房可俯瞰苗寨全景。', '[\"https://example.com/stay_cert.jpg\", \"https://example.com/stay_license.jpg\"]', 'approved', 1, '2026-06-21 17:51:25', NULL, '2026-06-16 17:50:12', '2026-06-21 17:51:24', 0);
INSERT INTO `merchant_application` VALUES (16, NULL, '杨侗歌', '13900004444', '侗族大歌体验馆', 'travel', '提供侗族大歌文化体验、苗侗村寨深度游线路。', '[\"https://example.com/travel_cert.jpg\"]', 'approved', NULL, NULL, NULL, '2026-06-11 17:50:12', '2026-06-21 17:50:12', 0);
INSERT INTO `merchant_application` VALUES (17, NULL, '赵蜡染', '13900005555', '蜡染手作坊', 'clothing', '传统蜡染技艺，可提供体验教学和成品销售。', '[\"https://example.com/cert3.jpg\"]', 'rejected', NULL, NULL, NULL, '2026-06-14 17:50:12', '2026-06-21 17:50:12', 0);
INSERT INTO `merchant_application` VALUES (18, NULL, '吴刺绣', '13900006666', '苗绣工坊', 'clothing', '苗族刺绣非遗传承人，主营手工苗绣服饰及文创产品，曾获省级非遗技艺大赛金奖。', '[\"https://example.com/embroidery_cert.jpg\", \"https://example.com/award.jpg\"]', 'pending', NULL, NULL, NULL, '2026-06-19 17:55:09', '2026-06-21 17:55:09', 0);
INSERT INTO `merchant_application` VALUES (19, NULL, '陈酸汤', '13900007777', '凯里酸汤鱼总店', 'food', '30年老店，正宗凯里酸汤鱼，日均接待200+桌，持有食品经营许可证。', '[\"https://example.com/food_license.jpg\", \"https://example.com/shop_photo.jpg\"]', 'pending', NULL, NULL, NULL, '2026-06-21 17:55:09', '2026-06-21 17:55:09', 0);
INSERT INTO `merchant_application` VALUES (20, NULL, '潘客栈', '13900008888', '西江观景台客栈', 'stay', '紧邻观景台，12间客房，可远眺苗寨全景，持特种行业许可证。', '[\"https://example.com/stay_license.jpg\"]', 'pending', NULL, NULL, NULL, '2026-06-15 17:55:09', '2026-06-21 17:55:09', 0);
INSERT INTO `merchant_application` VALUES (21, NULL, '韦导游', '13900009999', '黔东南深度游旅行社', 'travel', '专注黔东南苗侗文化深度游，开发5条精品线路，年服务游客3000+。', '[\"https://example.com/travel_license.jpg\", \"https://example.com/line_plan.pdf\"]', 'pending', NULL, NULL, NULL, '2026-06-18 17:55:09', '2026-06-21 17:55:09', 0);

-- ----------------------------
-- Table structure for message_template
-- ----------------------------
DROP TABLE IF EXISTS `message_template`;
CREATE TABLE `message_template`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板编码',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模板名称',
  `title_template` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题模板（含占位符）',
  `content_template` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '内容模板（含占位符）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '消息模板表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of message_template
-- ----------------------------
INSERT INTO `message_template` VALUES (1, 'order_created', '下单成功', '订单创建成功', '您的订单{{order_no}}已创建，请在15分钟内完成支付。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (2, 'order_paid', '支付成功', '订单支付成功', '您的订单{{order_no}}已支付成功，金额¥{{amount}}。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (3, 'order_shipped', '发货通知', '商品已发货', '您的订单{{order_no}}已发货，物流公司：{{company}}，运单号：{{tracking_no}}。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (4, 'refund_success', '退款成功', '退款已到账', '您的订单{{order_no}}退款¥{{amount}}已到账，请注意查收。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (5, 'application_approved', '入驻审核通过', '商家入驻申请已通过', '恭喜！您的商家入驻申请已通过审核，店铺名：{{shop_name}}。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (6, 'application_rejected', '入驻审核驳回', '商家入驻申请被驳回', '您的商家入驻申请未通过审核，原因：{{reason}}。请修改后重新提交。', 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `message_template` VALUES (7, 'test_1781970889339', '测试模板_1781970889339', '标题{var}', '更新{var}', 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `message_template` VALUES (8, 'test_1781970967496', '测试模板_1781970967496', '标题{var}', '更新{var}', 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `message_template` VALUES (9, 'test_1781971019633', '测试模板_1781971019633', '标题{var}', '更新{var}', 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `message_template` VALUES (10, 'test_1781971271307', '测试模板_1781971271307', '标题{var}', '更新{var}', 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `message_template` VALUES (11, 'test_1781971338783', '测试模板_1781971338783', '标题{var}', '更新{var}', 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);

-- ----------------------------
-- Table structure for operation_log
-- ----------------------------
DROP TABLE IF EXISTS `operation_log`;
CREATE TABLE `operation_log`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `operator_id` int UNSIGNED NOT NULL COMMENT '操作人ID',
  `operator_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `operator_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'admin' COMMENT '操作人类型：admin/merchant/user',
  `action` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型',
  `target` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作对象',
  `target_id` int UNSIGNED NULL DEFAULT NULL COMMENT '操作对象ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作内容',
  `ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '浏览器UA',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operator_id`(`operator_id` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 472 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of operation_log
-- ----------------------------
INSERT INTO `operation_log` VALUES (1, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"merchant01\",\"shop_name\":\"测试商家\",\"module_type\":\"clothing\",\"contact_name\":\"艳火\",\"contact_phone\":\"12332112332\",\"status\":1},\"status\":200,\"duration\":756}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-19 16:37:19', '2026-06-19 16:37:19', 0);
INSERT INTO `operation_log` VALUES (2, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/3\",\"status\":200,\"duration\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-19 17:31:06', '2026-06-19 17:31:06', 0);
INSERT INTO `operation_log` VALUES (3, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/2\",\"status\":200,\"duration\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-19 18:17:34', '2026-06-19 18:17:34', 0);
INSERT INTO `operation_log` VALUES (4, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/2\",\"status\":200,\"duration\":9}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-19 18:17:35', '2026-06-19 18:17:35', 0);
INSERT INTO `operation_log` VALUES (5, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"admintest\",\"name\":\"xyYoung\",\"phone\":\"15814963251\",\"role_id\":2,\"status\":1},\"status\":200,\"duration\":743}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 20:10:16', '2026-06-20 20:10:16', 0);
INSERT INTO `operation_log` VALUES (6, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"admintest02\",\"name\":\"k-fry\",\"phone\":\"16865423695\",\"role_id\":3,\"status\":1},\"status\":200,\"duration\":688}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 20:21:23', '2026-06-20 20:21:23', 0);
INSERT INTO `operation_log` VALUES (7, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/1\",\"body\":{\"status\":0},\"status\":200,\"duration\":12}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:10:03', '2026-06-20 21:10:03', 0);
INSERT INTO `operation_log` VALUES (8, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/1\",\"body\":{\"status\":1},\"status\":200,\"duration\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:10:04', '2026-06-20 21:10:04', 0);
INSERT INTO `operation_log` VALUES (9, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/3\",\"body\":{\"permissionIds\":[18,19,20,15,16,17,1,6,5]},\"status\":200,\"duration\":34}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `operation_log` VALUES (10, 3, 'k-fry', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/3\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36 Edg/149.0.0.0', '2026-06-20 21:55:31', '2026-06-20 21:55:31', 0);
INSERT INTO `operation_log` VALUES (11, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"merchant02\",\"shop_name\":\"好食\",\"module_type\":\"food\",\"status\":1},\"status\":200,\"duration\":753}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:56:22', '2026-06-20 21:56:22', 0);
INSERT INTO `operation_log` VALUES (12, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/2\",\"body\":{\"status\":0},\"status\":200,\"duration\":9}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:56:33', '2026-06-20 21:56:33', 0);
INSERT INTO `operation_log` VALUES (13, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/2\",\"body\":{\"status\":1},\"status\":200,\"duration\":8}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:57:03', '2026-06-20 21:57:03', 0);
INSERT INTO `operation_log` VALUES (14, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/2\",\"status\":200,\"duration\":8}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 21:57:24', '2026-06-20 21:57:24', 0);
INSERT INTO `operation_log` VALUES (15, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/2\",\"status\":200,\"duration\":109}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 22:03:34', '2026-06-20 22:03:34', 0);
INSERT INTO `operation_log` VALUES (16, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/2\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 22:06:41', '2026-06-20 22:06:41', 0);
INSERT INTO `operation_log` VALUES (17, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/2\",\"status\":200,\"duration\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '2026-06-20 22:08:36', '2026-06-20 22:08:36', 0);
INSERT INTO `operation_log` VALUES (18, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"test_shop_1781969903264\",\"shop_name\":\"集成测试店铺\",\"module_type\":\"food\",\"contact_name\":\"测试联系人\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":881}', '::1', '', '2026-06-20 23:38:24', '2026-06-20 23:38:24', 0);
INSERT INTO `operation_log` VALUES (19, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"集成测试店铺_1781969950198\",\"shop_name\":\"集成测试店铺_1781969950198\",\"module_type\":\"food\",\"contact_name\":\"测试联系人\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":821}', '::1', '', '2026-06-20 23:39:11', '2026-06-20 23:39:11', 0);
INSERT INTO `operation_log` VALUES (20, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"test_integration_1781969951948\",\"name\":\"集成测试管理员\",\"role_id\":2,\"phone\":\"13900000000\"},\"status\":200,\"duration\":853}', '::1', '', '2026-06-20 23:39:12', '2026-06-20 23:39:12', 0);
INSERT INTO `operation_log` VALUES (21, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/4\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:39:12', '2026-06-20 23:39:12', 0);
INSERT INTO `operation_log` VALUES (22, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"集成测试店铺_1781969964765\",\"shop_name\":\"集成测试店铺_1781969964765\",\"module_type\":\"food\",\"contact_name\":\"测试联系人\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":849}', '::1', '', '2026-06-20 23:39:25', '2026-06-20 23:39:25', 0);
INSERT INTO `operation_log` VALUES (23, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"test_integration_1781969966566\",\"name\":\"集成测试管理员\",\"role_id\":2,\"phone\":\"13900000000\"},\"status\":200,\"duration\":776}', '::1', '', '2026-06-20 23:39:27', '2026-06-20 23:39:27', 0);
INSERT INTO `operation_log` VALUES (24, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/5\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:39:27', '2026-06-20 23:39:27', 0);
INSERT INTO `operation_log` VALUES (25, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"集成测试店铺_1781970003019\",\"shop_name\":\"集成测试店铺_1781970003019\",\"module_type\":\"food\",\"contact_name\":\"测试联系人\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":806}', '::1', '', '2026-06-20 23:40:03', '2026-06-20 23:40:03', 0);
INSERT INTO `operation_log` VALUES (26, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"test_integration_1781970004694\",\"name\":\"集成测试管理员\",\"role_id\":2,\"phone\":\"13900000000\"},\"status\":200,\"duration\":860}', '::1', '', '2026-06-20 23:40:05', '2026-06-20 23:40:05', 0);
INSERT INTO `operation_log` VALUES (27, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/6\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:40:05', '2026-06-20 23:40:05', 0);
INSERT INTO `operation_log` VALUES (28, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"test_integration_1781970030965\",\"name\":\"test\",\"role_id\":2,\"phone\":\"13900000000\"},\"status\":200,\"duration\":659}', '::1', '', '2026-06-20 23:40:31', '2026-06-20 23:40:31', 0);
INSERT INTO `operation_log` VALUES (29, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/7\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:40:31', '2026-06-20 23:40:31', 0);
INSERT INTO `operation_log` VALUES (30, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"集成测试店铺_1781970114224\",\"shop_name\":\"集成测试店铺_1781970114224\",\"module_type\":\"food\",\"contact_name\":\"测试联系人\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":805}', '::1', '', '2026-06-20 23:41:55', '2026-06-20 23:41:55', 0);
INSERT INTO `operation_log` VALUES (31, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试临时角色_1781970115935\",\"type\":\"custom\",\"description\":\"集成测试临时角色\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:41:55', '2026-06-20 23:41:55', 0);
INSERT INTO `operation_log` VALUES (32, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"test_integration_1781970115956\",\"name\":\"集成测试管理员\",\"role_id\":4,\"phone\":\"13900000000\"},\"status\":200,\"duration\":830}', '::1', '', '2026-06-20 23:41:56', '2026-06-20 23:41:56', 0);
INSERT INTO `operation_log` VALUES (33, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/8\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:41:56', '2026-06-20 23:41:56', 0);
INSERT INTO `operation_log` VALUES (34, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/4\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:41:56', '2026-06-20 23:41:56', 0);
INSERT INTO `operation_log` VALUES (35, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781970512171\",\"shop_name\":\"完整测试_1781970512171\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":752}', '::1', '', '2026-06-20 23:48:32', '2026-06-20 23:48:32', 0);
INSERT INTO `operation_log` VALUES (36, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781970513974\",\"type\":\"custom\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:48:33', '2026-06-20 23:48:33', 0);
INSERT INTO `operation_log` VALUES (37, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781970514042\",\"name\":\"临时\",\"role_id\":5,\"phone\":\"13900000001\"},\"status\":200,\"duration\":800}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (38, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/9\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (39, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/9\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (40, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/5\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (41, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/5/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (42, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/5\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (43, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781970514951\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (44, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/28\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (45, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `operation_log` VALUES (46, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/28\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (47, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781970515015\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":722}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (48, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/4\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (49, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/4\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (50, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/4\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (51, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/4\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (52, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/8\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (53, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/8\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (54, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (55, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/1\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:35', '2026-06-20 23:48:35', 0);
INSERT INTO `operation_log` VALUES (56, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/1\",\"status\":200,\"duration\":762}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (57, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (58, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/2\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (59, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/2\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (60, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781970516737\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":8,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (61, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/1\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (62, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/1\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (63, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/1\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (64, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781970516813\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":8,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (65, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/2\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (66, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781970516841\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":8,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (67, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/3\",\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (68, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (69, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/1\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (70, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/1\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (71, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (72, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/1\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (73, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/1\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:36', '2026-06-20 23:48:36', 0);
INSERT INTO `operation_log` VALUES (74, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (75, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/1\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (76, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/1\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (77, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (78, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/1\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (79, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/1\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (80, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781970517227\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (81, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/site_name\",\"body\":{\"value\":\"乌东文旅\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (82, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781970517265\",\"category\":\"test\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (83, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/1\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (84, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781970517319\",\"批量词2_1781970517319\"]},\"status\":200,\"duration\":15}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (85, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/1\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (86, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-20 23:48:37', '2026-06-20 23:48:37', 1);
INSERT INTO `operation_log` VALUES (87, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":26}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (88, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/86\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":17}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (89, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/86\",\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (90, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":75}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (91, 1, '超级管理员', 'admin', 'delete', 'merchants', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchants/delete/8\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `operation_log` VALUES (92, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1],\"message_type\":\"system\",\"title\":\"测试批量\",\"content\":\"内容\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:19', '2026-06-20 23:54:19', 0);
INSERT INTO `operation_log` VALUES (93, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781970884142\",\"shop_name\":\"完整测试_1781970884142\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":857}', '::1', '', '2026-06-20 23:54:45', '2026-06-20 23:54:45', 0);
INSERT INTO `operation_log` VALUES (94, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781970885823\",\"type\":\"custom\"},\"status\":200,\"duration\":11}', '::1', '', '2026-06-20 23:54:45', '2026-06-20 23:54:45', 0);
INSERT INTO `operation_log` VALUES (95, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781970885874\",\"name\":\"临时\",\"role_id\":6,\"phone\":\"13900000001\"},\"status\":200,\"duration\":746}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (96, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/10\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (97, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/10\",\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (98, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/6\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (99, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/6/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (100, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/6\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (101, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781970886772\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (102, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/29\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (103, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (104, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/29\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `operation_log` VALUES (105, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781970886859\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":818}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (106, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/5\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (107, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/5\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (108, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/5\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (109, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/5\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (110, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/10\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (111, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/10\",\"status\":200,\"duration\":11}', '::1', '', '2026-06-20 23:54:47', '2026-06-20 23:54:47', 0);
INSERT INTO `operation_log` VALUES (112, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (113, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/3\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (114, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/3\",\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (115, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (116, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/4\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (117, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/4\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (118, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781970888761\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":10,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (119, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/4\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (120, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/4\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (121, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/4\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (122, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781970888853\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":10,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (123, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/5\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (124, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781970888892\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":10,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (125, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/6\",\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (126, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (127, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/2\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:54:48', '2026-06-20 23:54:48', 0);
INSERT INTO `operation_log` VALUES (128, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/2\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (129, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (130, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/2\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":11}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (131, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/2\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (132, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"测试推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (133, 1, '超级管理员', 'admin', 'update', 'recommendations', NULL, '{\"method\":\"PUT\",\"path\":\"/api/recommendations/update/1\",\"body\":{\"name\":\"更新推荐\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (134, 1, '超级管理员', 'admin', 'delete', 'recommendations', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/recommendations/delete/1\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (135, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":11}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (136, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/2\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (137, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/2\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (138, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (139, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1,2],\"message_type\":\"system\",\"title\":\"批量消息\",\"content\":\"批量内容\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (140, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/3\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (141, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/3\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (142, 1, '超级管理员', 'admin', 'create', 'message-templates', NULL, '{\"method\":\"POST\",\"path\":\"/api/message-templates/create\",\"body\":{\"name\":\"测试模板_1781970889339\",\"code\":\"test_1781970889339\",\"title_template\":\"标题{var}\",\"content_template\":\"内容{var}\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (143, 1, '超级管理员', 'admin', 'update', 'message-templates', NULL, '{\"method\":\"PUT\",\"path\":\"/api/message-templates/update/7\",\"body\":{\"content_template\":\"更新{var}\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (144, 1, '超级管理员', 'admin', 'delete', 'message-templates', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/message-templates/delete/7\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (145, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781970889403\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (146, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/commission_rate_clothing\",\"body\":{\"value\":\"0.15\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (147, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781970889429\",\"category\":\"test\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (148, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/4\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (149, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781970889469\",\"批量词2_1781970889469\"]},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (150, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/4\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (151, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `operation_log` VALUES (152, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":15}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (153, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/151\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (154, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/151\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (155, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (156, 1, '超级管理员', 'admin', 'delete', 'merchants', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchants/delete/10\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `operation_log` VALUES (157, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781970962802\",\"shop_name\":\"完整测试_1781970962802\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":813}', '::1', '', '2026-06-20 23:56:03', '2026-06-20 23:56:03', 0);
INSERT INTO `operation_log` VALUES (158, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781970964326\",\"type\":\"custom\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:04', '2026-06-20 23:56:04', 0);
INSERT INTO `operation_log` VALUES (159, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781970964363\",\"name\":\"临时\",\"role_id\":7,\"phone\":\"13900000001\"},\"status\":200,\"duration\":678}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (160, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/11\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (161, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/11\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (162, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/7\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (163, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/7/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":18}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (164, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/7\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (165, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781970965198\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (166, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/30\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (167, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (168, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/30\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `operation_log` VALUES (169, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781970965266\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":806}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (170, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/6\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (171, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/6\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (172, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/6\",\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (173, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/6\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (174, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/11\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (175, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/11\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:06', '2026-06-20 23:56:06', 0);
INSERT INTO `operation_log` VALUES (176, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (177, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/5\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (178, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/5\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (179, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (180, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/6\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (181, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/6\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (182, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781970967099\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":11,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (183, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/7\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (184, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/7\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (185, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/7\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (186, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781970967162\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":11,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (187, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/8\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (188, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781970967189\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":11,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":16}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (189, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/9\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (190, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (191, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/3\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (192, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/3\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (193, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (194, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/3\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (195, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/3\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (196, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"测试推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (197, 1, '超级管理员', 'admin', 'update', 'recommendations', NULL, '{\"method\":\"PUT\",\"path\":\"/api/recommendations/update/2\",\"body\":{\"name\":\"更新推荐\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (198, 1, '超级管理员', 'admin', 'delete', 'recommendations', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/recommendations/delete/2\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (199, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (200, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/3\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (201, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/3\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (202, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (203, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1,2],\"message_type\":\"system\",\"title\":\"批量消息\",\"content\":\"批量内容\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (204, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/6\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (205, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/6\",\"status\":200,\"duration\":13}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (206, 1, '超级管理员', 'admin', 'create', 'message-templates', NULL, '{\"method\":\"POST\",\"path\":\"/api/message-templates/create\",\"body\":{\"name\":\"测试模板_1781970967496\",\"code\":\"test_1781970967496\",\"title_template\":\"标题{var}\",\"content_template\":\"内容{var}\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (207, 1, '超级管理员', 'admin', 'update', 'message-templates', NULL, '{\"method\":\"PUT\",\"path\":\"/api/message-templates/update/8\",\"body\":{\"content_template\":\"更新{var}\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (208, 1, '超级管理员', 'admin', 'delete', 'message-templates', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/message-templates/delete/8\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (209, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781970967549\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (210, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/commission_rate_clothing\",\"body\":{\"value\":\"0.15\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (211, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781970967571\",\"category\":\"test\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (212, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/7\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (213, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781970967601\",\"批量词2_1781970967601\"]},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (214, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/7\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (215, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `operation_log` VALUES (216, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (217, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/215\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (218, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/215\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (219, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (220, 1, '超级管理员', 'admin', 'create', 'upload', NULL, '{\"method\":\"POST\",\"path\":\"/api/upload/delete\",\"body\":{\"url\":\"test.png\"},\"status\":200,\"duration\":1}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (221, 1, '超级管理员', 'admin', 'delete', 'merchants', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchants/delete/11\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `operation_log` VALUES (222, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781971014693\",\"shop_name\":\"完整测试_1781971014693\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":802}', '::1', '', '2026-06-20 23:56:55', '2026-06-20 23:56:55', 0);
INSERT INTO `operation_log` VALUES (223, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781971016323\",\"type\":\"custom\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:56', '2026-06-20 23:56:56', 0);
INSERT INTO `operation_log` VALUES (224, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781971016358\",\"name\":\"临时\",\"role_id\":8,\"phone\":\"13900000001\"},\"status\":200,\"duration\":798}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (225, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/12\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (226, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/12\",\"status\":200,\"duration\":11}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (227, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/8\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (228, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/8/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (229, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/8\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (230, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781971017310\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (231, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/31\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (232, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":13}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (233, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/31\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `operation_log` VALUES (234, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781971017400\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":766}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (235, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/7\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (236, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/7\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (237, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/7\",\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (238, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/7\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (239, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/12\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":13}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (240, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/12\",\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:56:58', '2026-06-20 23:56:58', 0);
INSERT INTO `operation_log` VALUES (241, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (242, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/7\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (243, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/7\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (244, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (245, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/8\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (246, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/8\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (247, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781971019181\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":12,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (248, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/10\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (249, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/10\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (250, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/10\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (251, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781971019248\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":12,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (252, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/11\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (253, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781971019272\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":12,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (254, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/12\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (255, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (256, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/4\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (257, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/4\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (258, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (259, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/4\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (260, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/4\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (261, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"测试推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":1},\"status\":200,\"duration\":12}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (262, 1, '超级管理员', 'admin', 'update', 'recommendations', NULL, '{\"method\":\"PUT\",\"path\":\"/api/recommendations/update/3\",\"body\":{\"name\":\"更新推荐\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (263, 1, '超级管理员', 'admin', 'delete', 'recommendations', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/recommendations/delete/3\",\"status\":200,\"duration\":15}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (264, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (265, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/4\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (266, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/4\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (267, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (268, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1,2],\"message_type\":\"system\",\"title\":\"批量消息\",\"content\":\"批量内容\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (269, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/9\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (270, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/9\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (271, 1, '超级管理员', 'admin', 'create', 'message-templates', NULL, '{\"method\":\"POST\",\"path\":\"/api/message-templates/create\",\"body\":{\"name\":\"测试模板_1781971019633\",\"code\":\"test_1781971019633\",\"title_template\":\"标题{var}\",\"content_template\":\"内容{var}\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (272, 1, '超级管理员', 'admin', 'update', 'message-templates', NULL, '{\"method\":\"PUT\",\"path\":\"/api/message-templates/update/9\",\"body\":{\"content_template\":\"更新{var}\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (273, 1, '超级管理员', 'admin', 'delete', 'message-templates', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/message-templates/delete/9\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (274, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781971019711\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (275, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/commission_rate_clothing\",\"body\":{\"value\":\"0.15\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (276, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781971019738\",\"category\":\"test\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (277, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/10\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":16}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (278, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781971019792\",\"批量词2_1781971019792\"]},\"status\":200,\"duration\":13}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (279, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/10\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (280, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `operation_log` VALUES (281, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (282, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/280\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (283, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/280\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (284, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":15}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (285, 1, '超级管理员', 'admin', 'create', 'upload', NULL, '{\"method\":\"POST\",\"path\":\"/api/upload/delete\",\"body\":{\"url\":\"test.png\"},\"status\":200,\"duration\":0}', '::1', '', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `operation_log` VALUES (286, 1, '超级管理员', 'admin', 'delete', 'merchants', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchants/delete/12\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-20 23:57:00', '2026-06-20 23:57:00', 0);
INSERT INTO `operation_log` VALUES (287, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781971266460\",\"shop_name\":\"完整测试_1781971266460\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":801}', '::1', '', '2026-06-21 00:01:07', '2026-06-21 00:01:07', 0);
INSERT INTO `operation_log` VALUES (288, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781971267989\",\"type\":\"custom\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (289, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781971268035\",\"name\":\"临时\",\"role_id\":9,\"phone\":\"13900000001\"},\"status\":200,\"duration\":720}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (290, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/13\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (291, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/13\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (292, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/9\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (293, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/9/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":10}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (294, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/9\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (295, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781971268882\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (296, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/32\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (297, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":19}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (298, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/32\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `operation_log` VALUES (299, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781971268990\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":782}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (300, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/8\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (301, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/8\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (302, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/8\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (303, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/8\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (304, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/13\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (305, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/13\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:09', '2026-06-21 00:01:09', 0);
INSERT INTO `operation_log` VALUES (306, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (307, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/9\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":11}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (308, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/9\",\"status\":200,\"duration\":14}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (309, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (310, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/10\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (311, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/10\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (312, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781971270911\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":13,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (313, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/13\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (314, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/13\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (315, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/13\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (316, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781971270975\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":13,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (317, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/14\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:10', '2026-06-21 00:01:10', 0);
INSERT INTO `operation_log` VALUES (318, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781971271002\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":13,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (319, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/15\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (320, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_COMPLETED_1781971271037\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":13,\"total_amount\":200,\"status\":\"completed\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (321, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_COMPLETED2_1781971271049\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":13,\"total_amount\":150,\"status\":\"completed\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (322, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (323, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/5\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (324, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/5\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (325, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":10}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (326, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/5\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (327, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/5\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (328, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"测试推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":1},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (329, 1, '超级管理员', 'admin', 'update', 'recommendations', NULL, '{\"method\":\"PUT\",\"path\":\"/api/recommendations/update/4\",\"body\":{\"name\":\"更新推荐\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (330, 1, '超级管理员', 'admin', 'delete', 'recommendations', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/recommendations/delete/4\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (331, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (332, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/5\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (333, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/5\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (334, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (335, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1,2],\"message_type\":\"system\",\"title\":\"批量消息\",\"content\":\"批量内容\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (336, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/12\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (337, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/12\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (338, 1, '超级管理员', 'admin', 'create', 'message-templates', NULL, '{\"method\":\"POST\",\"path\":\"/api/message-templates/create\",\"body\":{\"name\":\"测试模板_1781971271307\",\"code\":\"test_1781971271307\",\"title_template\":\"标题{var}\",\"content_template\":\"内容{var}\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (339, 1, '超级管理员', 'admin', 'update', 'message-templates', NULL, '{\"method\":\"PUT\",\"path\":\"/api/message-templates/update/10\",\"body\":{\"content_template\":\"更新{var}\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (340, 1, '超级管理员', 'admin', 'delete', 'message-templates', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/message-templates/delete/10\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (341, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781971271362\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (342, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/commission_rate_clothing\",\"body\":{\"value\":\"0.15\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (343, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781971271387\",\"category\":\"test\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (344, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/13\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (345, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781971271427\",\"批量词2_1781971271427\"]},\"status\":200,\"duration\":19}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (346, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/13\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (347, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `operation_log` VALUES (348, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (349, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/347\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (350, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/347\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (351, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `operation_log` VALUES (352, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/create\",\"body\":{\"username\":\"完整测试_1781971332973\",\"shop_name\":\"完整测试_1781971332973\",\"module_type\":\"food\",\"contact_name\":\"测试\",\"contact_phone\":\"13900001111\",\"status\":1},\"status\":200,\"duration\":849}', '::1', '', '2026-06-21 00:02:13', '2026-06-21 00:02:13', 0);
INSERT INTO `operation_log` VALUES (353, 1, '超级管理员', 'admin', 'create', 'roles', NULL, '{\"method\":\"POST\",\"path\":\"/api/roles/create\",\"body\":{\"name\":\"测试角色_1781971334697\",\"type\":\"custom\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:02:14', '2026-06-21 00:02:14', 0);
INSERT INTO `operation_log` VALUES (354, 1, '超级管理员', 'admin', 'create', 'admin', NULL, '{\"method\":\"POST\",\"path\":\"/api/admin/create\",\"body\":{\"username\":\"tmp_1781971334755\",\"name\":\"临时\",\"role_id\":10,\"phone\":\"13900000001\"},\"status\":200,\"duration\":893}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (355, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/14\",\"body\":{\"name\":\"更新后\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (356, 1, '超级管理员', 'admin', 'delete', 'admin', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/admin/delete/14\",\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (357, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/update/10\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (358, 1, '超级管理员', 'admin', 'update', 'roles', NULL, '{\"method\":\"PUT\",\"path\":\"/api/roles/10/permissions\",\"body\":{\"permissionIds\":[1,2,3]},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (359, 1, '超级管理员', 'admin', 'delete', 'roles', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/roles/delete/10\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (360, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/create\",\"body\":{\"code\":\"test:perm_1781971335777\",\"name\":\"测试权限\",\"type\":\"button\",\"parent_id\":1},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (361, 1, '超级管理员', 'admin', 'update', 'permissions', NULL, '{\"method\":\"PUT\",\"path\":\"/api/permissions/update/33\",\"body\":{\"name\":\"更新后权限\"},\"status\":200,\"duration\":13}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (362, 1, '超级管理员', 'admin', 'create', 'permissions', NULL, '{\"method\":\"POST\",\"path\":\"/api/permissions/role/1\",\"body\":{\"permissionIds\":[1,2]},\"status\":200,\"duration\":28}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (363, 1, '超级管理员', 'admin', 'delete', 'permissions', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/permissions/delete/33\",\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `operation_log` VALUES (364, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"testuser_1781971335967\",\"nickname\":\"测试用户\"},\"status\":200,\"duration\":925}', '::1', '', '2026-06-21 00:02:16', '2026-06-21 00:02:16', 0);
INSERT INTO `operation_log` VALUES (365, 1, '超级管理员', 'admin', 'update', 'users', NULL, '{\"method\":\"PUT\",\"path\":\"/api/users/update/9\",\"body\":{\"nickname\":\"更新昵称\"},\"status\":200,\"duration\":36}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (366, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/9\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (367, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/9\",\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (368, 1, '超级管理员', 'admin', 'delete', 'users', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/users/delete/9\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (369, 1, '超级管理员', 'admin', 'update', 'merchants', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchants/update/14\",\"body\":{\"description\":\"更新描述\"},\"status\":200,\"duration\":10}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (370, 1, '超级管理员', 'admin', 'create', 'merchants', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchants/force-offline/14\",\"status\":200,\"duration\":14}', '::1', '', '2026-06-21 00:02:17', '2026-06-21 00:02:17', 0);
INSERT INTO `operation_log` VALUES (371, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"张三\",\"applicant_phone\":\"13900002222\",\"shop_name\":\"测试申请店铺\",\"module_type\":\"clothing\",\"description\":\"测试申请\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (372, 1, '超级管理员', 'admin', 'update', 'merchant-applications', NULL, '{\"method\":\"PUT\",\"path\":\"/api/merchant-applications/update/11\",\"body\":{\"description\":\"更新申请\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (373, 1, '超级管理员', 'admin', 'approve', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/approve/11\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (374, 1, '超级管理员', 'admin', 'create', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/create\",\"body\":{\"applicant_name\":\"李四\",\"applicant_phone\":\"13900003333\",\"shop_name\":\"驳回测试店铺\",\"module_type\":\"stay\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (375, 1, '超级管理员', 'admin', 'reject', 'merchant-applications', NULL, '{\"method\":\"POST\",\"path\":\"/api/merchant-applications/reject/12\",\"body\":{\"reject_reason\":\"资质不全\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (376, 1, '超级管理员', 'admin', 'delete', 'merchant-applications', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchant-applications/delete/12\",\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (377, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST_1781971338279\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":99.5,\"status\":\"pending_payment\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (378, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/18\",\"body\":{\"status\":\"paid\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (379, 1, '超级管理员', 'admin', 'update', 'orders', NULL, '{\"method\":\"PUT\",\"path\":\"/api/orders/update/18\",\"body\":{\"status\":\"refunding\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (380, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/18\",\"body\":{\"reason\":\"测试拒绝\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (381, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST2_1781971338366\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":50,\"status\":\"refunding\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (382, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-approve/19\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (383, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_TEST3_1781971338401\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":30,\"status\":\"pending_payment\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (384, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/close/20\",\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (385, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_COMPLETED_1781971338439\",\"order_type\":\"food_order\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":200,\"status\":\"completed\",\"pay_time\":\"2026-05-31T16:02:18.437Z\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (386, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_COMPLETED2_1781971338460\",\"order_type\":\"product\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":150,\"status\":\"completed\",\"pay_time\":\"2026-05-31T16:02:18.437Z\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (387, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/create\",\"body\":{\"order_no\":\"ORD_COMPLETED3_1781971338480\",\"order_type\":\"ticket\",\"user_id\":1,\"merchant_id\":14,\"total_amount\":80,\"status\":\"completed\",\"pay_time\":\"2026-05-31T16:02:18.437Z\"},\"status\":200,\"duration\":7}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (388, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"测试公告\",\"content\":\"测试内容\",\"status\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (389, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/6\",\"body\":{\"title\":\"更新公告\"},\"status\":200,\"duration\":8}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (390, 1, '超级管理员', 'admin', 'delete', 'announcements', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/announcements/delete/6\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (391, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"测试轮播\",\"image_url\":\"/img/test.jpg\",\"sort_order\":1,\"status\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (392, 1, '超级管理员', 'admin', 'update', 'carousels', NULL, '{\"method\":\"PUT\",\"path\":\"/api/carousels/update/6\",\"body\":{\"title\":\"更新轮播\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (393, 1, '超级管理员', 'admin', 'delete', 'carousels', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/carousels/delete/6\",\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (394, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"测试推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (395, 1, '超级管理员', 'admin', 'update', 'recommendations', NULL, '{\"method\":\"PUT\",\"path\":\"/api/recommendations/update/5\",\"body\":{\"name\":\"更新推荐\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (396, 1, '超级管理员', 'admin', 'delete', 'recommendations', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/recommendations/delete/5\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (397, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"测试横幅\",\"image_url\":\"/img/banner.jpg\",\"link_url\":\"/activity/1\",\"status\":1},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (398, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/6\",\"body\":{\"title\":\"更新横幅\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (399, 1, '超级管理员', 'admin', 'delete', 'activity-banners', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/activity-banners/delete/6\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (400, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/create\",\"body\":{\"user_id\":1,\"message_type\":\"system\",\"title\":\"测试消息\",\"content\":\"测试内容\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (401, 1, '超级管理员', 'admin', 'create', 'system-messages', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-messages/batch-send\",\"body\":{\"userIds\":[1,2],\"message_type\":\"system\",\"title\":\"批量消息\",\"content\":\"批量内容\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (402, 1, '超级管理员', 'admin', 'update', 'system-messages', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-messages/read/15\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (403, 1, '超级管理员', 'admin', 'delete', 'system-messages', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/system-messages/delete/15\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (404, 1, '超级管理员', 'admin', 'create', 'message-templates', NULL, '{\"method\":\"POST\",\"path\":\"/api/message-templates/create\",\"body\":{\"name\":\"测试模板_1781971338783\",\"code\":\"test_1781971338783\",\"title_template\":\"标题{var}\",\"content_template\":\"内容{var}\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (405, 1, '超级管理员', 'admin', 'update', 'message-templates', NULL, '{\"method\":\"PUT\",\"path\":\"/api/message-templates/update/11\",\"body\":{\"content_template\":\"更新{var}\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (406, 1, '超级管理员', 'admin', 'delete', 'message-templates', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/message-templates/delete/11\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (407, 1, '超级管理员', 'admin', 'create', 'system-configs', NULL, '{\"method\":\"POST\",\"path\":\"/api/system-configs/create\",\"body\":{\"config_key\":\"test_key_1781971338849\",\"config_value\":\"test_val\",\"description\":\"测试配置\"},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (408, 1, '超级管理员', 'admin', 'update', 'system-configs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/system-configs/update/commission_rate_clothing\",\"body\":{\"value\":\"0.15\"},\"status\":200,\"duration\":9}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (409, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"测试敏感词_1781971338880\",\"category\":\"test\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (410, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/16\",\"body\":{\"category\":\"updated\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (411, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/batch-import\",\"body\":{\"words\":[\"批量词1_1781971338919\",\"批量词2_1781971338919\"]},\"status\":200,\"duration\":6}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (412, 1, '超级管理员', 'admin', 'delete', 'sensitive-words', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/sensitive-words/delete/16\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (413, 1, '测试', 'admin', 'test', 'integration', NULL, '更新内容', NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `operation_log` VALUES (414, 1, '超级管理员', 'admin', 'create', 'operation-logs', NULL, '{\"method\":\"POST\",\"path\":\"/api/operation-logs/create\",\"body\":{\"operator_id\":1,\"operator_name\":\"测试\",\"action\":\"test\",\"target\":\"integration\"},\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (415, 1, '超级管理员', 'admin', 'update', 'operation-logs', NULL, '{\"method\":\"PUT\",\"path\":\"/api/operation-logs/update/413\",\"body\":{\"content\":\"更新内容\"},\"status\":200,\"duration\":5}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (416, 1, '超级管理员', 'admin', 'delete', 'operation-logs', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/operation-logs/delete/413\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `operation_log` VALUES (417, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":21}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (418, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/settle/3\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (419, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":10}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (420, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/settle-batch\",\"body\":{\"ids\":[2,1]},\"status\":200,\"duration\":3}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (421, 1, '超级管理员', 'admin', 'create', 'upload', NULL, '{\"method\":\"POST\",\"path\":\"/api/upload/delete\",\"body\":{\"url\":\"test.png\"},\"status\":200,\"duration\":0}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (422, 1, '超级管理员', 'admin', 'delete', 'merchants', NULL, '{\"method\":\"DELETE\",\"path\":\"/api/merchants/delete/14\",\"status\":200,\"duration\":4}', '::1', '', '2026-06-21 00:02:19', '2026-06-21 00:02:19', 0);
INSERT INTO `operation_log` VALUES (423, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"wudong_user_01\",\"nickname\":\"张三\",\"phone\":\"13800001111\"},\"status\":200,\"duration\":766}', '::1', '', '2026-06-21 01:33:08', '2026-06-21 01:33:08', 0);
INSERT INTO `operation_log` VALUES (424, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"wudong_user_02\",\"nickname\":\"李四\",\"phone\":\"13800002222\"},\"status\":200,\"duration\":832}', '::1', '', '2026-06-21 01:33:09', '2026-06-21 01:33:09', 0);
INSERT INTO `operation_log` VALUES (425, 1, '超级管理员', 'admin', 'create', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/create\",\"body\":{\"username\":\"wudong_user_03\",\"nickname\":\"王五\",\"phone\":\"13800003333\"},\"status\":200,\"duration\":810}', '::1', '', '2026-06-21 01:33:09', '2026-06-21 01:33:09', 0);
INSERT INTO `operation_log` VALUES (426, 1, '超级管理员', 'admin', 'update', 'admin', NULL, '{\"method\":\"PUT\",\"path\":\"/api/admin/update/2\",\"body\":{\"username\":\"admintest\",\"name\":\"xyYoung\",\"phone\":\"15814963251\",\"role_id\":2,\"status\":1},\"status\":200,\"duration\":410}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:22:23', '2026-06-21 14:22:23', 0);
INSERT INTO `operation_log` VALUES (427, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/settle/9\",\"status\":200,\"duration\":8}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:26:32', '2026-06-21 14:26:32', 0);
INSERT INTO `operation_log` VALUES (428, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":16}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:27:14', '2026-06-21 14:27:14', 0);
INSERT INTO `operation_log` VALUES (429, 1, '超级管理员', 'admin', 'create', 'orders', NULL, '{\"method\":\"POST\",\"path\":\"/api/orders/refund-reject/36\",\"body\":{\"reason\":\"就不给你退款\"},\"status\":200,\"duration\":17}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:32:51', '2026-06-21 14:32:51', 0);
INSERT INTO `operation_log` VALUES (430, 1, '超级管理员', 'admin', 'create', 'announcements', NULL, '{\"method\":\"POST\",\"path\":\"/api/announcements/create\",\"body\":{\"title\":\"端午安康\",\"content\":\"祝全体成员端午安康！！\",\"status\":0,\"published_at\":\"2026-06-21T06:36:17.083Z\"},\"status\":200,\"duration\":14}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:36:17', '2026-06-21 14:36:17', 0);
INSERT INTO `operation_log` VALUES (431, 1, '超级管理员', 'admin', 'update', 'announcements', NULL, '{\"method\":\"PUT\",\"path\":\"/api/announcements/update/7\",\"body\":{\"title\":\"端午安康\",\"content\":\"祝全体成员端午安康！！\",\"status\":1},\"status\":200,\"duration\":14}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:36:23', '2026-06-21 14:36:23', 0);
INSERT INTO `operation_log` VALUES (432, 1, '超级管理员', 'admin', 'create', 'carousels', NULL, '{\"method\":\"POST\",\"path\":\"/api/carousels/create\",\"body\":{\"title\":\"PC端官网首页\",\"link_url\":\"www.baidu.com\",\"sort_order\":1,\"status\":1,\"image_url\":\"/api/upload/file/1782023810422-xhd5wd.jpg\"},\"status\":200,\"duration\":19}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:37:05', '2026-06-21 14:37:05', 0);
INSERT INTO `operation_log` VALUES (433, 1, '超级管理员', 'admin', 'create', 'activity-banners', NULL, '{\"method\":\"POST\",\"path\":\"/api/activity-banners/create\",\"body\":{\"title\":\"好消息好消息\",\"link_url\":\"www.jd.com\",\"status\":1,\"image_url\":\"/api/upload/file/1782023869527-rlxase.jpg\",\"start_time\":\"2026-06-22 01:03:13\",\"end_time\":\"2026-06-23 00:02:00\"},\"status\":200,\"duration\":16}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:38:28', '2026-06-21 14:38:28', 0);
INSERT INTO `operation_log` VALUES (434, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/7\",\"body\":{\"title\":\"好消息好消息\",\"link_url\":\"www.jd.com\",\"status\":0,\"image_url\":\"/api/upload/file/1782023869527-rlxase.jpg\",\"start_time\":\"2026-06-22 01:03:13\",\"end_time\":\"2026-06-23 00:02:00\"},\"status\":200,\"duration\":14}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:38:33', '2026-06-21 14:38:33', 0);
INSERT INTO `operation_log` VALUES (435, 1, '超级管理员', 'admin', 'update', 'activity-banners', NULL, '{\"method\":\"PUT\",\"path\":\"/api/activity-banners/update/7\",\"body\":{\"title\":\"好消息好消息\",\"link_url\":\"www.jd.com\",\"status\":1,\"image_url\":\"/api/upload/file/1782023869527-rlxase.jpg\",\"start_time\":\"2026-06-22 01:03:13\",\"end_time\":\"2026-06-23 00:02:00\"},\"status\":200,\"duration\":15}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:38:37', '2026-06-21 14:38:37', 0);
INSERT INTO `operation_log` VALUES (436, 1, '超级管理员', 'admin', 'create', 'recommendations', NULL, '{\"method\":\"POST\",\"path\":\"/api/recommendations/create\",\"body\":{\"name\":\"商品推荐\",\"content_type\":\"product\",\"content_id\":1,\"sort_order\":0,\"status\":1},\"status\":200,\"duration\":10}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:39:07', '2026-06-21 14:39:07', 0);
INSERT INTO `operation_log` VALUES (437, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/10\",\"status\":200,\"duration\":15}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:41:15', '2026-06-21 14:41:15', 0);
INSERT INTO `operation_log` VALUES (438, 1, '超级管理员', 'admin', 'create', 'sensitive-words', NULL, '{\"method\":\"POST\",\"path\":\"/api/sensitive-words/create\",\"body\":{\"word\":\"v我50\",\"category\":\"广告\",\"status\":1},\"status\":200,\"duration\":26}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:45:06', '2026-06-21 14:45:06', 0);
INSERT INTO `operation_log` VALUES (439, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/19\",\"body\":{\"word\":\"v我50\",\"category\":\"广告\",\"status\":0},\"status\":200,\"duration\":22}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:45:13', '2026-06-21 14:45:13', 0);
INSERT INTO `operation_log` VALUES (440, 1, '超级管理员', 'admin', 'update', 'sensitive-words', NULL, '{\"method\":\"PUT\",\"path\":\"/api/sensitive-words/update/19\",\"body\":{\"word\":\"v我50\",\"category\":\"广告\",\"status\":1},\"status\":200,\"duration\":16}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 14:45:19', '2026-06-21 14:45:19', 0);
INSERT INTO `operation_log` VALUES (441, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:11:57', '2026-06-21 15:11:57', 0);
INSERT INTO `operation_log` VALUES (442, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:12:03', '2026-06-21 15:12:03', 0);
INSERT INTO `operation_log` VALUES (443, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/settle-batch\",\"body\":{\"ids\":[9,10]},\"status\":200,\"duration\":6}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:31:02', '2026-06-21 15:31:02', 0);
INSERT INTO `operation_log` VALUES (444, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:31:09', '2026-06-21 15:31:09', 0);
INSERT INTO `operation_log` VALUES (445, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:31:44', '2026-06-21 15:31:44', 0);
INSERT INTO `operation_log` VALUES (446, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"body\":{\"orderIds\":[8]},\"status\":200,\"duration\":11}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:44:22', '2026-06-21 15:44:22', 0);
INSERT INTO `operation_log` VALUES (447, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"body\":{\"orderIds\":[9,7]},\"status\":200,\"duration\":13}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:51:27', '2026-06-21 15:51:27', 0);
INSERT INTO `operation_log` VALUES (448, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":123}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 15:58:08', '2026-06-21 15:58:08', 0);
INSERT INTO `operation_log` VALUES (449, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":103}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 16:10:18', '2026-06-21 16:10:18', 0);
INSERT INTO `operation_log` VALUES (450, 1, '超级管理员', 'admin', 'create', 'financial-records', NULL, '{\"method\":\"POST\",\"path\":\"/api/financial-records/generate\",\"status\":200,\"duration\":74}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 16:10:29', '2026-06-21 16:10:29', 0);
INSERT INTO `operation_log` VALUES (451, 1, 'admin', 'admin', '用户账号封禁', '用户', 11, '封禁用户：wudong_user_02', 'unknown', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:07:50', '2026-06-21 17:07:50', 0);
INSERT INTO `operation_log` VALUES (452, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/11\",\"status\":200,\"duration\":29}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:07:50', '2026-06-21 17:07:50', 0);
INSERT INTO `operation_log` VALUES (453, 1, 'admin', 'admin', '用户账号解封', '用户', 11, '解封用户：wudong_user_02', 'unknown', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:09:30', '2026-06-21 17:09:30', 0);
INSERT INTO `operation_log` VALUES (454, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/11\",\"status\":200,\"duration\":21}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:09:30', '2026-06-21 17:09:30', 0);
INSERT INTO `operation_log` VALUES (455, 1, 'admin', 'admin', '用户账号解封', '用户', 10, '解封用户：wudong_user_01', 'unknown', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:10:16', '2026-06-21 17:10:16', 0);
INSERT INTO `operation_log` VALUES (456, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/10\",\"status\":200,\"duration\":18}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:10:16', '2026-06-21 17:10:16', 0);
INSERT INTO `operation_log` VALUES (457, 1, '超级管理员', 'admin', 'ban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/ban/12\",\"status\":200,\"duration\":14}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:20:35', '2026-06-21 17:20:35', 0);
INSERT INTO `operation_log` VALUES (458, 1, '超级管理员', 'admin', 'unban', 'users', NULL, '{\"method\":\"POST\",\"path\":\"/api/users/unban/12\",\"status\":200,\"duration\":9}', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:21:10', '2026-06-21 17:21:10', 0);
INSERT INTO `operation_log` VALUES (459, 1, '超级管理员', 'admin', '编辑', '商家', NULL, '编辑商家（ID: 18）', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:33:02', '2026-06-21 17:33:02', 0);
INSERT INTO `operation_log` VALUES (460, 1, '超级管理员', 'admin', '编辑', '商家', NULL, '编辑商家（ID: 18）', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:33:13', '2026-06-21 17:33:13', 0);
INSERT INTO `operation_log` VALUES (461, 1, '超级管理员', 'admin', '封禁', '用户', NULL, '封禁用户（ID: 12）', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:33:17', '2026-06-21 17:33:17', 0);
INSERT INTO `operation_log` VALUES (462, 1, '超级管理员', 'admin', '新增', '推荐内容', NULL, '新增推荐内容：苗寨必去', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:48:46', '2026-06-21 17:48:46', 0);
INSERT INTO `operation_log` VALUES (463, 1, '超级管理员', 'admin', '审核通过', '入驻申请', NULL, '审核通过入驻申请（ID: 15），已自动创建商家账号', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:51:25', '2026-06-21 17:51:25', 0);
INSERT INTO `operation_log` VALUES (464, 1, '超级管理员', 'admin', '审核驳回', '入驻申请', NULL, '驳回入驻申请（ID: 14），原因：不给你入驻', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Safari/537.36', '2026-06-21 17:51:48', '2026-06-21 17:51:48', 0);
INSERT INTO `operation_log` VALUES (465, 1, '超级管理员', 'admin', '新增', '订单', NULL, '新增订单', '::1', 'curl/8.10.1', '2026-06-21 19:38:25', '2026-06-21 19:38:25', 0);
INSERT INTO `operation_log` VALUES (466, 1, '超级管理员', 'admin', '编辑', '订单', NULL, '编辑订单（ID: 39）', '::1', 'curl/8.10.1', '2026-06-21 19:38:40', '2026-06-21 19:38:40', 0);
INSERT INTO `operation_log` VALUES (467, 1, '超级管理员', 'admin', '编辑', '订单', NULL, '编辑订单（ID: 39）', '::1', 'curl/8.10.1', '2026-06-21 19:38:54', '2026-06-21 19:38:54', 0);
INSERT INTO `operation_log` VALUES (468, 1, '超级管理员', 'admin', '编辑', '订单', NULL, '编辑订单（ID: 39）', '::1', 'curl/8.10.1', '2026-06-21 19:38:54', '2026-06-21 19:38:54', 0);
INSERT INTO `operation_log` VALUES (469, 1, '超级管理员', 'admin', '退款通过', '订单', NULL, '同意订单（ID: 39）的退款申请', '::1', 'curl/8.10.1', '2026-06-21 19:39:06', '2026-06-21 19:39:06', 0);
INSERT INTO `operation_log` VALUES (470, 1, '超级管理员', 'admin', '新增', 'admin', NULL, '新增admin：RBAC������ӪԱ', '::1', 'curl/8.10.1', '2026-06-21 20:15:38', '2026-06-21 20:15:38', 0);
INSERT INTO `operation_log` VALUES (471, 1, '超级管理员', 'admin', '新增', '商家', NULL, '新增商家：RBAC���Ե���', '::1', 'curl/8.10.1', '2026-06-21 20:22:35', '2026-06-21 20:22:35', 0);

-- ----------------------------
-- Table structure for order
-- ----------------------------
DROP TABLE IF EXISTS `order`;
CREATE TABLE `order`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `order_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单类型：product/food_order/stay/ticket/route',
  `user_id` int UNSIGNED NOT NULL COMMENT '用户ID',
  `merchant_id` int UNSIGNED NULL DEFAULT NULL COMMENT '商家ID',
  `total_amount` decimal(10, 2) NOT NULL COMMENT '订单总金额',
  `status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending_payment' COMMENT '订单状态',
  `pay_time` datetime NULL DEFAULT NULL COMMENT '支付时间',
  `pay_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '支付方式',
  `transaction_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信支付交易号',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `refund_reject_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '退款拒绝原因',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_merchant_id`(`merchant_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 40 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of order
-- ----------------------------
INSERT INTO `order` VALUES (1, 'ORD_TEST_1781970516737', 'food_order', 1, 8, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-20 23:48:36', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (2, 'ORD_TEST2_1781970516813', 'product', 1, 8, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:48:36', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (3, 'ORD_TEST3_1781970516841', 'ticket', 1, 8, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:48:36', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (4, 'ORD_TEST_1781970888761', 'food_order', 1, 10, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-20 23:54:48', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (5, 'ORD_TEST2_1781970888853', 'product', 1, 10, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:54:48', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (6, 'ORD_TEST3_1781970888892', 'ticket', 1, 10, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:54:48', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (7, 'ORD_TEST_1781970967099', 'food_order', 1, 11, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-20 23:56:07', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (8, 'ORD_TEST2_1781970967162', 'product', 1, 11, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:56:07', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (9, 'ORD_TEST3_1781970967189', 'ticket', 1, 11, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:56:07', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (10, 'ORD_TEST_1781971019181', 'food_order', 1, 12, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-20 23:56:59', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (11, 'ORD_TEST2_1781971019248', 'product', 1, 12, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:56:59', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (12, 'ORD_TEST3_1781971019272', 'ticket', 1, 12, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-20 23:56:59', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (13, 'ORD_TEST_1781971270911', 'food_order', 1, 13, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-21 00:01:10', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (14, 'ORD_TEST2_1781971270975', 'product', 1, 13, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:01:10', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (15, 'ORD_TEST3_1781971271002', 'ticket', 1, 13, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:01:11', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (16, 'ORD_COMPLETED_1781971271037', 'food_order', 1, 13, 200.00, 'completed', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:01:11', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (17, 'ORD_COMPLETED2_1781971271049', 'product', 1, 13, 150.00, 'completed', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:01:11', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (18, 'ORD_TEST_1781971338279', 'food_order', 1, 14, 99.50, 'refund_rejected', NULL, NULL, NULL, NULL, '测试拒绝', '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (19, 'ORD_TEST2_1781971338366', 'product', 1, 14, 50.00, 'refund_approved', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (20, 'ORD_TEST3_1781971338401', 'ticket', 1, 14, 30.00, 'closed', NULL, NULL, NULL, NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (21, 'ORD_COMPLETED_1781971338439', 'food_order', 1, 14, 200.00, 'completed', '2026-06-01 00:02:18', NULL, NULL, NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (22, 'ORD_COMPLETED2_1781971338460', 'product', 1, 14, 150.00, 'completed', '2026-06-01 00:02:18', NULL, NULL, NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (23, 'ORD_COMPLETED3_1781971338480', 'ticket', 1, 14, 80.00, 'completed', '2026-06-01 00:02:18', NULL, NULL, NULL, NULL, '2026-06-21 00:02:18', '2026-06-21 01:37:08', 1);
INSERT INTO `order` VALUES (24, 'WD20260615001', 'product', 10, 1, 299.00, 'completed', '2026-06-15 10:30:00', NULL, NULL, NULL, NULL, '2026-06-15 10:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (25, 'WD20260615002', 'food_order', 11, 2, 156.50, 'completed', '2026-06-15 12:00:00', NULL, NULL, NULL, NULL, '2026-06-15 11:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (26, 'WD20260616001', 'stay', 12, 17, 680.00, 'completed', '2026-06-16 14:00:00', NULL, NULL, NULL, NULL, '2026-06-16 13:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (27, 'WD20260616002', 'ticket', 10, 18, 320.00, 'completed', '2026-06-16 09:00:00', NULL, NULL, NULL, NULL, '2026-06-16 08:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (28, 'WD20260617001', 'product', 11, 16, 459.00, 'completed', '2026-06-17 16:00:00', NULL, NULL, NULL, NULL, '2026-06-17 15:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (29, 'WD20260617002', 'food_order', 12, 15, 88.00, 'completed', '2026-06-17 19:00:00', NULL, NULL, NULL, NULL, '2026-06-17 18:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (30, 'WD20260621001', 'product', 10, 1, 1280.00, 'completed', '2026-06-21 09:30:00', NULL, NULL, NULL, NULL, '2026-06-21 09:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (31, 'WD20260621002', 'food_order', 11, 15, 235.00, 'completed', '2026-06-21 11:00:00', NULL, NULL, NULL, NULL, '2026-06-21 10:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (32, 'WD20260621003', 'stay', 12, 17, 1560.00, 'completed', '2026-06-21 14:00:00', NULL, NULL, NULL, NULL, '2026-06-21 13:30:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (33, 'WD20260621004', 'product', 10, 16, 688.00, 'paid', NULL, NULL, NULL, NULL, NULL, '2026-06-21 15:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (34, 'WD20260621005', 'food_order', 11, 2, 178.00, 'paid', NULL, NULL, NULL, NULL, NULL, '2026-06-21 16:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (35, 'WD20260621006', 'ticket', 12, 18, 450.00, 'pending_payment', NULL, NULL, NULL, NULL, NULL, '2026-06-21 17:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (36, 'WD20260620001', 'product', 10, 1, 399.00, 'refund_rejected', '2026-06-20 10:00:00', NULL, NULL, NULL, '就不给你退款', '2026-06-20 09:30:00', '2026-06-21 14:32:51', 0);
INSERT INTO `order` VALUES (37, 'WD20260619001', 'food_order', 11, 15, 126.00, 'refund_approved', '2026-06-19 12:00:00', NULL, NULL, NULL, NULL, '2026-06-19 11:00:00', '2026-06-21 01:46:48', 0);
INSERT INTO `order` VALUES (39, 'WD20260621010', 'product', 1, 1, 599.00, 'refund_approved', '2026-06-21 19:38:00', 'wechat', NULL, NULL, NULL, '2026-06-21 19:38:25', '2026-06-21 19:39:06', 0);

-- ----------------------------
-- Table structure for permission
-- ----------------------------
DROP TABLE IF EXISTS `permission`;
CREATE TABLE `permission`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '权限编码（如 product:manage）',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'menu' COMMENT '权限类型：menu-菜单 button-按钮 api-接口',
  `parent_id` int UNSIGNED NULL DEFAULT 0 COMMENT '父权限ID（0为顶级）',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '前端路由路径',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图标',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_code`(`code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of permission
-- ----------------------------
INSERT INTO `permission` VALUES (1, '数据看板', 'dashboard', 'menu', 0, '/dashboard', NULL, 100, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (2, '管理员管理', 'admin:manage', 'menu', 0, NULL, NULL, 90, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (3, '管理员列表', 'admin:list', 'menu', 2, '/admin/list', NULL, 91, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (4, '角色管理', 'admin:role', 'menu', 2, '/role/list', NULL, 92, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (5, '用户管理', 'user:manage', 'menu', 0, NULL, NULL, 80, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (6, '用户列表', 'user:list', 'menu', 5, '/user/list', NULL, 81, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (7, '商家管理', 'merchant:manage', 'menu', 0, NULL, NULL, 70, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (8, '商家列表', 'merchant:list', 'menu', 7, '/merchant/list', NULL, 71, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (9, '入驻审核', 'merchant:application', 'menu', 7, '/merchant/application', NULL, 72, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (10, '内容管理', 'content:manage', 'menu', 0, NULL, NULL, 60, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (11, '公告管理', 'content:announcement', 'menu', 10, '/content/announcement', NULL, 61, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (12, '轮播图管理', 'content:carousel', 'menu', 10, '/content/carousel', NULL, 62, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (13, '活动横幅', 'content:banner', 'menu', 10, '/content/banner', NULL, 63, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (14, '推荐位管理', 'content:recommendation', 'menu', 10, '/content/recommendation', NULL, 64, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (15, '订单管理', 'order:manage', 'menu', 0, NULL, NULL, 50, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (16, '全局订单', 'order:list', 'menu', 15, '/order/list', NULL, 51, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (17, '退款审批', 'order:refund', 'menu', 15, '/order/refund', NULL, 52, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (18, '财务结算', 'finance:manage', 'menu', 0, NULL, NULL, 40, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (19, '结算列表', 'finance:list', 'menu', 18, '/finance/list', NULL, 41, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (20, '财务报表', 'finance:report', 'menu', 18, '/finance/report', NULL, 42, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (21, '消息中心', 'message:manage', 'menu', 0, NULL, NULL, 30, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (22, '系统消息', 'message:list', 'menu', 21, '/message/list', NULL, 31, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (23, '消息模板', 'message:template', 'menu', 21, '/message/template', NULL, 32, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (24, '系统设置', 'system:manage', 'menu', 0, NULL, NULL, 20, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (25, '系统配置', 'system:config', 'menu', 24, '/system/config', NULL, 21, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (26, '敏感词库', 'system:sensitive', 'menu', 24, '/system/sensitive', NULL, 22, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (27, '操作日志', 'system:log', 'menu', 24, '/system/log', NULL, 23, 1, '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `permission` VALUES (28, '更新后权限', 'test:perm_1781970514951', 'button', 1, NULL, NULL, 0, 1, '2026-06-20 23:48:34', '2026-06-20 23:48:35', 1);
INSERT INTO `permission` VALUES (29, '更新后权限', 'test:perm_1781970886772', 'button', 1, NULL, NULL, 0, 1, '2026-06-20 23:54:46', '2026-06-20 23:54:46', 1);
INSERT INTO `permission` VALUES (30, '更新后权限', 'test:perm_1781970965198', 'button', 1, NULL, NULL, 0, 1, '2026-06-20 23:56:05', '2026-06-20 23:56:05', 1);
INSERT INTO `permission` VALUES (31, '更新后权限', 'test:perm_1781971017310', 'button', 1, NULL, NULL, 0, 1, '2026-06-20 23:56:57', '2026-06-20 23:56:57', 1);
INSERT INTO `permission` VALUES (32, '更新后权限', 'test:perm_1781971268882', 'button', 1, NULL, NULL, 0, 1, '2026-06-21 00:01:08', '2026-06-21 00:01:08', 1);
INSERT INTO `permission` VALUES (33, '更新后权限', 'test:perm_1781971335777', 'button', 1, NULL, NULL, 0, 1, '2026-06-21 00:02:15', '2026-06-21 00:02:15', 1);
INSERT INTO `permission` VALUES (34, '异常订单', 'order:abnormal', 'menu', 15, NULL, NULL, 0, 1, '2026-06-21 00:09:40', '2026-06-21 00:09:40', 0);
INSERT INTO `permission` VALUES (35, '对账管理', 'finance:reconciliation', 'menu', 18, NULL, NULL, 0, 1, '2026-06-21 00:09:40', '2026-06-21 00:09:40', 0);

-- ----------------------------
-- Table structure for recommendation
-- ----------------------------
DROP TABLE IF EXISTS `recommendation`;
CREATE TABLE `recommendation`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '推荐位名称',
  `content_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联内容类型：product/restaurant/homestay/route/travel_note',
  `content_id` int UNSIGNED NOT NULL COMMENT '关联内容ID',
  `sort_order` int NOT NULL DEFAULT 0 COMMENT '排序',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_content`(`content_type` ASC, `content_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '推荐位表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of recommendation
-- ----------------------------
INSERT INTO `recommendation` VALUES (1, '更新推荐', 'product', 1, 1, 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `recommendation` VALUES (2, '更新推荐', 'product', 1, 1, 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `recommendation` VALUES (3, '更新推荐', 'product', 1, 1, 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `recommendation` VALUES (4, '更新推荐', 'product', 1, 1, 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `recommendation` VALUES (5, '更新推荐', 'product', 1, 1, 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `recommendation` VALUES (6, '商品推荐', 'product', 1, 0, 1, '2026-06-21 14:39:07', '2026-06-21 14:39:07', 0);
INSERT INTO `recommendation` VALUES (7, '苗寨必去', '', 0, 0, 1, '2026-06-21 17:48:46', '2026-06-21 17:48:46', 0);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '角色描述',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'custom' COMMENT '角色类型：system-系统内置 custom-自定义',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, '超级管理员', '拥有全部权限', 'system', 1, '2026-06-19 15:27:21', '2026-06-20 21:29:29', 0);
INSERT INTO `role` VALUES (2, '运营管理员', '内容运营管理', 'system', 1, '2026-06-19 15:27:21', '2026-06-20 21:29:29', 0);
INSERT INTO `role` VALUES (3, '财务管理员', '财务结算管理', 'system', 1, '2026-06-19 15:27:21', '2026-06-20 21:29:29', 0);
INSERT INTO `role` VALUES (4, '测试临时角色_1781970115935', '集成测试临时角色', 'custom', 1, '2026-06-20 23:41:55', '2026-06-20 23:41:56', 1);
INSERT INTO `role` VALUES (5, '测试角色_1781970513974', '更新描述', 'custom', 1, '2026-06-20 23:48:33', '2026-06-20 23:48:34', 1);
INSERT INTO `role` VALUES (6, '测试角色_1781970885823', '更新描述', 'custom', 1, '2026-06-20 23:54:45', '2026-06-20 23:54:46', 1);
INSERT INTO `role` VALUES (7, '测试角色_1781970964326', '更新描述', 'custom', 1, '2026-06-20 23:56:04', '2026-06-20 23:56:05', 1);
INSERT INTO `role` VALUES (8, '测试角色_1781971016323', '更新描述', 'custom', 1, '2026-06-20 23:56:56', '2026-06-20 23:56:57', 1);
INSERT INTO `role` VALUES (9, '测试角色_1781971267989', '更新描述', 'custom', 1, '2026-06-21 00:01:07', '2026-06-21 00:01:08', 1);
INSERT INTO `role` VALUES (10, '测试角色_1781971334697', '更新描述', 'custom', 1, '2026-06-21 00:02:14', '2026-06-21 00:02:15', 1);

-- ----------------------------
-- Table structure for role_permission
-- ----------------------------
DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int UNSIGNED NOT NULL COMMENT '角色ID',
  `permission_id` int UNSIGNED NOT NULL COMMENT '权限ID',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_role_permission`(`role_id` ASC, `permission_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 117 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色-权限关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role_permission
-- ----------------------------
INSERT INTO `role_permission` VALUES (28, 2, 1, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (29, 2, 5, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (30, 2, 6, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (31, 2, 7, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (32, 2, 8, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (33, 2, 9, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (34, 2, 10, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (35, 2, 11, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (36, 2, 12, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (37, 2, 13, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (38, 2, 14, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (39, 2, 21, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (40, 2, 22, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (41, 2, 23, '2026-06-20 20:13:29', '2026-06-20 20:13:29', 0);
INSERT INTO `role_permission` VALUES (49, 3, 18, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (50, 3, 19, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (51, 3, 20, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (52, 3, 15, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (53, 3, 16, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (54, 3, 17, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (55, 3, 1, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (56, 3, 6, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (57, 3, 5, '2026-06-20 21:55:16', '2026-06-20 21:55:16', 0);
INSERT INTO `role_permission` VALUES (58, 5, 1, '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `role_permission` VALUES (59, 5, 2, '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `role_permission` VALUES (60, 5, 3, '2026-06-20 23:48:34', '2026-06-20 23:48:34', 0);
INSERT INTO `role_permission` VALUES (63, 6, 1, '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `role_permission` VALUES (64, 6, 2, '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `role_permission` VALUES (65, 6, 3, '2026-06-20 23:54:46', '2026-06-20 23:54:46', 0);
INSERT INTO `role_permission` VALUES (68, 7, 1, '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `role_permission` VALUES (69, 7, 2, '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `role_permission` VALUES (70, 7, 3, '2026-06-20 23:56:05', '2026-06-20 23:56:05', 0);
INSERT INTO `role_permission` VALUES (73, 8, 1, '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `role_permission` VALUES (74, 8, 2, '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `role_permission` VALUES (75, 8, 3, '2026-06-20 23:56:57', '2026-06-20 23:56:57', 0);
INSERT INTO `role_permission` VALUES (78, 9, 1, '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `role_permission` VALUES (79, 9, 2, '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `role_permission` VALUES (80, 9, 3, '2026-06-21 00:01:08', '2026-06-21 00:01:08', 0);
INSERT INTO `role_permission` VALUES (83, 10, 1, '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `role_permission` VALUES (84, 10, 2, '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `role_permission` VALUES (85, 10, 3, '2026-06-21 00:02:15', '2026-06-21 00:02:15', 0);
INSERT INTO `role_permission` VALUES (88, 1, 1, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (89, 1, 2, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (90, 1, 3, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (91, 1, 4, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (92, 1, 5, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (93, 1, 6, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (94, 1, 7, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (95, 1, 8, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (96, 1, 9, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (97, 1, 10, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (98, 1, 11, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (99, 1, 12, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (100, 1, 13, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (101, 1, 14, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (102, 1, 15, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (103, 1, 16, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (104, 1, 17, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (105, 1, 18, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (106, 1, 19, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (107, 1, 20, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (108, 1, 21, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (109, 1, 22, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (110, 1, 23, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (111, 1, 24, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (112, 1, 25, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (113, 1, 26, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (114, 1, 27, '2026-06-21 00:07:33', '2026-06-21 00:07:33', 0);
INSERT INTO `role_permission` VALUES (115, 1, 34, '2026-06-21 00:09:40', '2026-06-21 00:09:40', 0);
INSERT INTO `role_permission` VALUES (116, 1, 35, '2026-06-21 00:09:40', '2026-06-21 00:09:40', 0);

-- ----------------------------
-- Table structure for sensitive_word
-- ----------------------------
DROP TABLE IF EXISTS `sensitive_word`;
CREATE TABLE `sensitive_word`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `word` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '敏感词',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-启用 0-禁用',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_word`(`word` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '敏感词库表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sensitive_word
-- ----------------------------
INSERT INTO `sensitive_word` VALUES (1, '测试敏感词_1781970517265', 'updated', 1, '2026-06-20 23:48:37', '2026-06-20 23:48:37', 1);
INSERT INTO `sensitive_word` VALUES (2, '批量词1_1781970517319', NULL, 1, '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `sensitive_word` VALUES (3, '批量词2_1781970517319', NULL, 1, '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `sensitive_word` VALUES (4, '测试敏感词_1781970889429', 'updated', 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `sensitive_word` VALUES (5, '批量词1_1781970889469', NULL, 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `sensitive_word` VALUES (6, '批量词2_1781970889469', NULL, 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `sensitive_word` VALUES (7, '测试敏感词_1781970967571', 'updated', 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `sensitive_word` VALUES (8, '批量词1_1781970967601', NULL, 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `sensitive_word` VALUES (9, '批量词2_1781970967601', NULL, 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `sensitive_word` VALUES (10, '测试敏感词_1781971019738', 'updated', 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `sensitive_word` VALUES (11, '批量词1_1781971019792', NULL, 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `sensitive_word` VALUES (12, '批量词2_1781971019792', NULL, 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `sensitive_word` VALUES (13, '测试敏感词_1781971271387', 'updated', 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `sensitive_word` VALUES (14, '批量词1_1781971271427', NULL, 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `sensitive_word` VALUES (15, '批量词2_1781971271427', NULL, 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `sensitive_word` VALUES (16, '测试敏感词_1781971338880', 'updated', 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `sensitive_word` VALUES (17, '批量词1_1781971338919', NULL, 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `sensitive_word` VALUES (18, '批量词2_1781971338919', NULL, 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `sensitive_word` VALUES (19, 'v我50', '广告', 1, '2026-06-21 14:45:06', '2026-06-21 14:45:19', 0);

-- ----------------------------
-- Table structure for system_config
-- ----------------------------
DROP TABLE IF EXISTS `system_config`;
CREATE TABLE `system_config`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置值',
  `config_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'string' COMMENT '值类型：string/number/json/boolean',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '配置说明',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_config
-- ----------------------------
INSERT INTO `system_config` VALUES (1, 'commission_rate_clothing', '0.15', 'number', '衣模块抽佣比例', '2026-06-19 15:27:21', '2026-06-21 00:02:18', 0);
INSERT INTO `system_config` VALUES (2, 'commission_rate_food', '0.0800', 'number', '食模块抽佣比例', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (3, 'commission_rate_stay', '0.0800', 'number', '住模块抽佣比例', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (4, 'commission_rate_travel', '0.0500', 'number', '行模块抽佣比例', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (5, 'settlement_cycle_ticket', '7', 'number', '门票/线路结算周期（天）', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (6, 'settlement_cycle_other', '15', 'number', '商品/餐厅/民宿结算周期（天）', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (7, 'shipping_template', '{\"free_shipping_amount\":99,\"default_fee\":10}', 'json', '运费模板', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (8, 'payment_mch_id', '', 'string', '微信支付商户号', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (9, 'sms_provider', 'aliyun', 'string', '短信服务商', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (10, 'sms_access_key', '', 'string', '短信AccessKey', '2026-06-19 15:27:21', '2026-06-19 15:27:21', 0);
INSERT INTO `system_config` VALUES (11, 'test_key_1781970517227', 'test_val', 'string', '测试配置', '2026-06-20 23:48:37', '2026-06-20 23:48:37', 0);
INSERT INTO `system_config` VALUES (12, 'test_key_1781970889403', 'test_val', 'string', '测试配置', '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `system_config` VALUES (13, 'test_key_1781970967549', 'test_val', 'string', '测试配置', '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `system_config` VALUES (14, 'test_key_1781971019711', 'test_val', 'string', '测试配置', '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `system_config` VALUES (15, 'test_key_1781971271362', 'test_val', 'string', '测试配置', '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `system_config` VALUES (16, 'test_key_1781971338849', 'test_val', 'string', '测试配置', '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);

-- ----------------------------
-- Table structure for system_message
-- ----------------------------
DROP TABLE IF EXISTS `system_message`;
CREATE TABLE `system_message`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` int UNSIGNED NULL DEFAULT NULL COMMENT '接收用户ID（NULL表示群发）',
  `message_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息类型：system/order/payment/refund/interaction',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '消息标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '消息内容',
  `is_read` tinyint NOT NULL DEFAULT 0 COMMENT '已读状态：0-未读 1-已读',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_is_read`(`is_read` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统消息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of system_message
-- ----------------------------
INSERT INTO `system_message` VALUES (1, 1, 'system', '测试消息', '测试内容', 1, '2026-06-20 23:48:37', '2026-06-21 00:02:19', 1);
INSERT INTO `system_message` VALUES (2, 1, 'system', '测试批量', '内容', 0, '2026-06-20 23:54:19', '2026-06-20 23:54:19', 0);
INSERT INTO `system_message` VALUES (3, 1, 'system', '测试消息', '测试内容', 1, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 1);
INSERT INTO `system_message` VALUES (4, 1, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `system_message` VALUES (5, 2, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:54:49', '2026-06-20 23:54:49', 0);
INSERT INTO `system_message` VALUES (6, 1, 'system', '测试消息', '测试内容', 1, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 1);
INSERT INTO `system_message` VALUES (7, 1, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `system_message` VALUES (8, 2, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:56:07', '2026-06-20 23:56:07', 0);
INSERT INTO `system_message` VALUES (9, 1, 'system', '测试消息', '测试内容', 1, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 1);
INSERT INTO `system_message` VALUES (10, 1, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `system_message` VALUES (11, 2, 'system', '批量消息', '批量内容', 0, '2026-06-20 23:56:59', '2026-06-20 23:56:59', 0);
INSERT INTO `system_message` VALUES (12, 1, 'system', '测试消息', '测试内容', 1, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 1);
INSERT INTO `system_message` VALUES (13, 1, 'system', '批量消息', '批量内容', 0, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `system_message` VALUES (14, 2, 'system', '批量消息', '批量内容', 0, '2026-06-21 00:01:11', '2026-06-21 00:01:11', 0);
INSERT INTO `system_message` VALUES (15, 1, 'system', '测试消息', '测试内容', 1, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 1);
INSERT INTO `system_message` VALUES (16, 1, 'system', '批量消息', '批量内容', 1, '2026-06-21 00:02:18', '2026-06-21 00:06:47', 0);
INSERT INTO `system_message` VALUES (17, 2, 'system', '批量消息', '批量内容', 0, '2026-06-21 00:02:18', '2026-06-21 00:02:18', 0);
INSERT INTO `system_message` VALUES (18, NULL, 'system', '入驻申请超时提醒', '商家入驻申请「西江观景台客栈」（申请人：潘客栈）已超过3个工作日未处理，请尽快审核。', 0, '2026-06-21 17:56:28', '2026-06-21 17:56:28', 0);
INSERT INTO `system_message` VALUES (19, NULL, 'system', '入驻申请超时提醒', '商家入驻申请「黔东南深度游旅行社」（申请人：韦导游）已超过3个工作日未处理，请尽快审核。', 0, '2026-06-21 18:00:07', '2026-06-21 18:00:07', 0);
INSERT INTO `system_message` VALUES (20, 1, 'order', '新订单通知', '您有新订单 WD20260621001，商品：苗族银饰手镯 x1，金额 ¥1280.00，请及时处理。', 0, '2026-06-21 16:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (21, 1, 'payment', '收款到账通知', '订单 WD20260615001 已完成支付，到账金额 ¥299.00，请及时发货。', 1, '2026-06-18 18:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (22, 1, 'refund', '退款申请通知', '用户申请退款订单 WD20260615001，退款金额 ¥299.00，原因：商品不符合预期。请在3个工作日内处理。', 0, '2026-06-21 13:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (23, 1, 'order', '订单即将超时提醒', '订单 WD20260621001 已支付超过24小时未发货，请尽快处理，避免影响店铺评分。', 0, '2026-06-21 17:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (24, 2, 'order', '新订单通知', '您有新订单 WD20260615002，餐厅：酸汤鱼套餐 x2，金额 ¥156.50，请及时备餐。', 1, '2026-06-15 18:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (25, 2, 'refund', '退款申请通知', '用户申请退款订单 WD20260615002，退款金额 ¥156.50，原因：等待时间过长。请在3个工作日内处理。', 0, '2026-06-21 16:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (26, 17, 'order', '新订单通知', '您有新订单 WD20260621003，房型：观景大床房 x2晚，金额 ¥1560.00，请确认房态。', 0, '2026-06-21 18:19:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (27, 17, 'payment', '收款到账通知', '订单 WD20260616001 已完成支付，到账金额 ¥680.00。', 1, '2026-06-16 18:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (28, 17, 'refund', '退款审核结果通知', '订单 WD20260616001 退款申请已通过，退款金额 ¥680.00，预计1-3个工作日到账。', 0, '2026-06-20 18:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (29, 16, 'order', '新订单通知', '您有新订单 WD20260621004，商品：苗绣围巾 x3，金额 ¥688.00，请及时处理。', 0, '2026-06-21 18:04:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (30, 16, 'payment', '收款到账通知', '订单 WD20260617001 已完成支付，到账金额 ¥459.00。', 1, '2026-06-17 18:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (31, 16, 'refund', '退款申请通知', '用户申请退款订单 WD20260617001，退款金额 ¥459.00，原因：尺码不合适。请在3个工作日内处理。', 0, '2026-06-21 15:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (32, 15, 'order', '新订单通知', '您有新订单 WD20260621002，商品：都匀毛尖 x2罐，金额 ¥235.00，请及时发货。', 0, '2026-06-21 18:39:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (33, 15, 'refund', '退款申请通知', '用户申请退款订单 WD20260617002，退款金额 ¥88.00，原因：口味不符。请在3个工作日内处理。', 0, '2026-06-21 10:49:01', '2026-06-21 18:49:01', 0);
INSERT INTO `system_message` VALUES (34, 1, 'order', '新订单通知', '您有新订单 WD20260621010，商品订单，金额 ¥599.00，请及时处理。', 0, '2026-06-21 19:38:25', '2026-06-21 19:38:25', 0);
INSERT INTO `system_message` VALUES (35, 1, 'payment', '收款到账通知', '订单 WD20260621010 已完成支付，到账金额 ¥599.00。', 0, '2026-06-21 19:38:40', '2026-06-21 19:38:40', 0);
INSERT INTO `system_message` VALUES (36, 1, 'refund', '退款审核结果通知', '订单 WD20260621010 退款申请已通过，退款金额 ¥599.00，预计1-3个工作日到账。', 1, '2026-06-21 19:39:06', '2026-06-21 20:43:53', 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `openid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '微信openid',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '用户名',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '密码（bcrypt加密）',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '手机号',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '昵称',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像URL',
  `gender` tinyint NULL DEFAULT 0 COMMENT '性别：0-未知 1-男 2-女',
  `region` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地区',
  `bio` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '个人简介',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态：1-正常 0-封禁',
  `last_login_at` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `login_fail_count` int NOT NULL DEFAULT 0 COMMENT '连续登录失败次数',
  `locked_until` datetime NULL DEFAULT NULL COMMENT '锁定截止时间',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_openid`(`openid` ASC) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `uk_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 13 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '统一用户表（游客/注册用户）' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'test_openid_001', 'user001', NULL, '13900001111', '苗寨游客', NULL, 1, '贵州凯里', NULL, 1, '2026-06-21 08:00:00', 0, NULL, '2026-06-19 15:27:21', '2026-06-21 01:46:48', 0);
INSERT INTO `user` VALUES (2, 'test_openid_002', 'user002', NULL, '13900002222', '旅行达人', NULL, 2, '上海', NULL, 1, '2026-06-21 08:00:00', 0, NULL, '2026-06-19 15:27:21', '2026-06-21 01:46:48', 0);
INSERT INTO `user` VALUES (3, 'test_openid_003', 'user003', NULL, '13900003333', '非遗爱好者', NULL, 1, '北京', NULL, 1, '2026-06-21 08:00:00', 0, NULL, '2026-06-19 15:27:21', '2026-06-21 01:46:48', 0);
INSERT INTO `user` VALUES (4, NULL, 'testuser_1781970515015', '$2a$12$5yXn8VQJ/ZMCQ88HK1GAw.QQk82aIKQ9TnEA7yAm4k3J6/Xv129Dm', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-20 23:48:35', '2026-06-20 23:48:35', 1);
INSERT INTO `user` VALUES (5, NULL, 'testuser_1781970886859', '$2a$12$6o8LyVQxvcOqAyMegeMhieQ3BDJjh9by3oU4vk/oI5eZAPXm4MARy', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-20 23:54:47', '2026-06-20 23:54:47', 1);
INSERT INTO `user` VALUES (6, NULL, 'testuser_1781970965266', '$2a$12$c9m0EF9bEL1Nu7yvVZXnHO2QtSn6ruJeEy0Vtq3UQ7aOE/EB6nUzG', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-20 23:56:06', '2026-06-20 23:56:06', 1);
INSERT INTO `user` VALUES (7, NULL, 'testuser_1781971017400', '$2a$12$8pl2CGwt5WKSOlZZ7Sym4.monweZapGAUWg.SrXWI83/hAUCFiT3u', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-20 23:56:58', '2026-06-20 23:56:58', 1);
INSERT INTO `user` VALUES (8, NULL, 'testuser_1781971268990', '$2a$12$TjYETmQKGus5Adaghm7vj.wyReso.FHMUblkr6XG9joZ6Vn.wH8gS', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-21 00:01:09', '2026-06-21 00:01:09', 1);
INSERT INTO `user` VALUES (9, NULL, 'testuser_1781971335967', '$2a$12$oMOF/cFWJMe/apy1trZK6uG4mo3R7uSKflTK9jl27rNdGUBYycGJq', NULL, '更新昵称', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-21 00:02:16', '2026-06-21 00:02:17', 1);
INSERT INTO `user` VALUES (10, NULL, 'wudong_user_01', '$2a$12$P74/33PF0swmgbRRnefKsOcb2u9gENg0PgiqHgSFGjMHGZjXMFRLi', '13800001111', '张三', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-21 01:33:08', '2026-06-21 17:10:16', 0);
INSERT INTO `user` VALUES (11, NULL, 'wudong_user_02', '$2a$12$V83xtwyZrneATgMKVo.6n.mz6nKn8.oVEtpa1fC6yMeUavseFOOPy', '13800002222', '李四', NULL, 0, NULL, NULL, 1, NULL, 0, NULL, '2026-06-21 01:33:09', '2026-06-21 17:09:30', 0);
INSERT INTO `user` VALUES (12, NULL, 'wudong_user_03', '$2a$12$0ebW9mmcIA3.O5js7oqw0.1H.a5qgYUglSdI8aIb/b..98C.8btji', '13800003333', '王五', NULL, 0, NULL, NULL, 0, NULL, 0, NULL, '2026-06-21 01:33:09', '2026-06-21 17:33:17', 0);

SET FOREIGN_KEY_CHECKS = 1;
