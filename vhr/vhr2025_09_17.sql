/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : vhr2024

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 17/09/2025 20:57:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for hr
-- ----------------------------
DROP TABLE IF EXISTS `hr`;
CREATE TABLE `hr`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'hrID',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '姓名',
  `phone` char(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号码',
  `telephone` varchar(16) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '住宅电话',
  `address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系地址',
  `enabled` tinyint(1) NULL DEFAULT 1,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '密码',
  `userface` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hr
-- ----------------------------
INSERT INTO `hr` VALUES (3, '系统管理员', '18568887789', '029-82881234', '深圳南山', 1, 'admin', '{noop}123', 'http://bpic.588ku.com/element_pic/01/40/00/64573ce2edc0728.jpg', NULL);
INSERT INTO `hr` VALUES (5, 'User', '18568123489', '029-82123434', '火星', 1, 'user', '{noop}123', 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514093920321&di=913e88c23f382933ef430024afd9128a&imgtype=0&src=http%3A%2F%2Fp.3761.com%2Fpic%2F9771429316733.jpg', NULL);
INSERT INTO `hr` VALUES (10, 'Test', '18568123666', '029-82111555', 'Localhost', 1, 'test', '{noop}123', 'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517070040185&di=be0375e0c3db6c311b837b28c208f318&imgtype=0&src=http%3A%2F%2Fimg2.soyoung.com%2Fpost%2F20150213%2F6%2F20150213141918532.jpg', NULL);

-- ----------------------------
-- Table structure for hr_role
-- ----------------------------
DROP TABLE IF EXISTS `hr_role`;
CREATE TABLE `hr_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hr_id` int(11) NULL DEFAULT NULL,
  `rid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `rid`(`rid`) USING BTREE,
  INDEX `hr_role_ibfk_1`(`hr_id`) USING BTREE,
  CONSTRAINT `hr_role_ibfk_1` FOREIGN KEY (`hr_id`) REFERENCES `hr` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `hr_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 74 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of hr_role
-- ----------------------------
INSERT INTO `hr_role` VALUES (1, 3, 6);
INSERT INTO `hr_role` VALUES (72, 5, 1);
INSERT INTO `hr_role` VALUES (73, 10, 13);

-- ----------------------------
-- Table structure for menu
-- ----------------------------
DROP TABLE IF EXISTS `menu`;
CREATE TABLE `menu`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `path` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `component` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `icon_cls` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `keep_alive` tinyint(1) NULL DEFAULT NULL,
  `require_auth` tinyint(1) NULL DEFAULT NULL,
  `parent_id` int(11) NULL DEFAULT NULL,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `parentId`(`parent_id`) USING BTREE,
  CONSTRAINT `menu_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 24 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu
-- ----------------------------
INSERT INTO `menu` VALUES (1, '/', NULL, NULL, '所有', NULL, NULL, NULL, NULL, 1);
INSERT INTO `menu` VALUES (2, '/', '/home', '/src/views/HomeView.vue', '用户管理', 'fa fa-user-circle-o', NULL, 1, 1, 1);
INSERT INTO `menu` VALUES (4, '/', '/home', '/src/views/HomeView.vue', '服务中心', 'fa fa-money', NULL, 1, 1, 1);
INSERT INTO `menu` VALUES (5, '/', '/home', '/src/views/HomeView.vue', '统计管理', 'fa fa-bar-chart', NULL, 1, 1, 1);
INSERT INTO `menu` VALUES (6, '/', '/home', '/src/views/HomeView.vue', '系统管理', 'fa fa-windows', NULL, 1, 1, 1);
INSERT INTO `menu` VALUES (7, '/user/list/**', '/user/list', '/src/views/user/list.vue', '所有用户', NULL, NULL, 1, 2, 1);
INSERT INTO `menu` VALUES (14, '/service/list/**', '/service/list', '/src/views/service/list.vue', '预约管理', NULL, NULL, 1, 4, 1);
INSERT INTO `menu` VALUES (23, '/system/notice/**', '/sys/notice', '/src/views/sys/notice.vue', '通知管理', NULL, NULL, 1, 6, 1);

-- ----------------------------
-- Table structure for menu_role
-- ----------------------------
DROP TABLE IF EXISTS `menu_role`;
CREATE TABLE `menu_role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mid` int(11) NULL DEFAULT NULL,
  `rid` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `mid`(`mid`) USING BTREE,
  INDEX `rid`(`rid`) USING BTREE,
  CONSTRAINT `menu_role_ibfk_1` FOREIGN KEY (`mid`) REFERENCES `menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `menu_role_ibfk_2` FOREIGN KEY (`rid`) REFERENCES `role` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 281 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of menu_role
-- ----------------------------
INSERT INTO `menu_role` VALUES (168, 14, 6);
INSERT INTO `menu_role` VALUES (177, 23, 6);
INSERT INTO `menu_role` VALUES (256, 7, 1);
INSERT INTO `menu_role` VALUES (263, 14, 1);
INSERT INTO `menu_role` VALUES (272, 23, 1);
INSERT INTO `menu_role` VALUES (280, 7, 13);

-- ----------------------------
-- Table structure for nation
-- ----------------------------
DROP TABLE IF EXISTS `nation`;
CREATE TABLE `nation`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of nation
-- ----------------------------
INSERT INTO `nation` VALUES (1, '汉族');
INSERT INTO `nation` VALUES (2, '蒙古族');
INSERT INTO `nation` VALUES (3, '回族');
INSERT INTO `nation` VALUES (4, '藏族');
INSERT INTO `nation` VALUES (5, '维吾尔族');
INSERT INTO `nation` VALUES (6, '苗族');
INSERT INTO `nation` VALUES (7, '彝族');
INSERT INTO `nation` VALUES (8, '壮族');
INSERT INTO `nation` VALUES (9, '布依族');
INSERT INTO `nation` VALUES (10, '朝鲜族');
INSERT INTO `nation` VALUES (11, '满族');
INSERT INTO `nation` VALUES (12, '侗族');
INSERT INTO `nation` VALUES (13, '瑶族');
INSERT INTO `nation` VALUES (14, '白族');
INSERT INTO `nation` VALUES (15, '土家族');
INSERT INTO `nation` VALUES (16, '哈尼族');
INSERT INTO `nation` VALUES (17, '哈萨克族');
INSERT INTO `nation` VALUES (18, '傣族');
INSERT INTO `nation` VALUES (19, '黎族');
INSERT INTO `nation` VALUES (20, '傈僳族');
INSERT INTO `nation` VALUES (21, '佤族');
INSERT INTO `nation` VALUES (22, '畲族');
INSERT INTO `nation` VALUES (23, '高山族');
INSERT INTO `nation` VALUES (24, '拉祜族');
INSERT INTO `nation` VALUES (25, '水族');
INSERT INTO `nation` VALUES (26, '东乡族');
INSERT INTO `nation` VALUES (27, '纳西族');
INSERT INTO `nation` VALUES (28, '景颇族');
INSERT INTO `nation` VALUES (29, '柯尔克孜族');
INSERT INTO `nation` VALUES (30, '土族');
INSERT INTO `nation` VALUES (31, '达斡尔族');
INSERT INTO `nation` VALUES (32, '仫佬族');
INSERT INTO `nation` VALUES (33, '羌族');
INSERT INTO `nation` VALUES (34, '布朗族');
INSERT INTO `nation` VALUES (35, '撒拉族');
INSERT INTO `nation` VALUES (36, '毛难族');
INSERT INTO `nation` VALUES (37, '仡佬族');
INSERT INTO `nation` VALUES (38, '锡伯族');
INSERT INTO `nation` VALUES (39, '阿昌族');
INSERT INTO `nation` VALUES (40, '普米族');
INSERT INTO `nation` VALUES (41, '塔吉克族');
INSERT INTO `nation` VALUES (42, '怒族');
INSERT INTO `nation` VALUES (43, '乌孜别克族');
INSERT INTO `nation` VALUES (44, '俄罗斯族');
INSERT INTO `nation` VALUES (45, '鄂温克族');
INSERT INTO `nation` VALUES (46, '崩龙族');
INSERT INTO `nation` VALUES (47, '保安族');
INSERT INTO `nation` VALUES (48, '裕固族');
INSERT INTO `nation` VALUES (49, '京族');
INSERT INTO `nation` VALUES (50, '塔塔尔族');
INSERT INTO `nation` VALUES (51, '独龙族');
INSERT INTO `nation` VALUES (52, '鄂伦春族');
INSERT INTO `nation` VALUES (53, '赫哲族');
INSERT INTO `nation` VALUES (54, '门巴族');
INSERT INTO `nation` VALUES (55, '珞巴族');
INSERT INTO `nation` VALUES (56, '基诺族');

-- ----------------------------
-- Table structure for notice
-- ----------------------------
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '职位',
  `create_date` timestamp(0) NULL DEFAULT CURRENT_TIMESTAMP,
  `enabled` tinyint(1) NULL DEFAULT 1,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (29, '通知内容', '2018-01-11 21:13:42', 1);
INSERT INTO `notice` VALUES (30, '通知内容11', '2018-01-11 21:13:48', 1);
INSERT INTO `notice` VALUES (31, '通知内容555', '2018-01-11 00:00:00', 1);
INSERT INTO `notice` VALUES (33, '通知内容55555', '2018-01-14 00:00:00', 0);

-- ----------------------------
-- Table structure for role
-- ----------------------------
DROP TABLE IF EXISTS `role`;
CREATE TABLE `role`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name_zh` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '角色名称',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of role
-- ----------------------------
INSERT INTO `role` VALUES (1, 'ROLE_manager', '用户');
INSERT INTO `role` VALUES (6, 'ROLE_admin', '系统管理员');
INSERT INTO `role` VALUES (13, 'ROLE_test', '测试角色');
INSERT INTO `role` VALUES (21, 'ROLE_test6', '测试角色6');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '员工编号',
  `name` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '员工姓名',
  `age` int(3) NULL DEFAULT NULL COMMENT '年龄',
  `gender` char(4) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '性别',
  `birthday` date NULL DEFAULT NULL COMMENT '出生日期',
  `id_card` char(18) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '身份证号',
  `nation_id` int(8) NULL DEFAULT NULL COMMENT '民族',
  `phone` varchar(11) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '手机号',
  `address` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '联系地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `nationId`(`nation_id`) USING BTREE,
  CONSTRAINT `user_ibfk_4` FOREIGN KEY (`nation_id`) REFERENCES `nation` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1942 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (2, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (3, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (4, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (5, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (6, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (8, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (9, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (10, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (11, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (12, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (13, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (14, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (15, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (16, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (17, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (18, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (19, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (20, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (21, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (22, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (24, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (25, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (26, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (27, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (28, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (29, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (31, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (32, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (33, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (34, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (35, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (36, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (37, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (38, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (39, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (40, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (41, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (42, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (43, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (44, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (45, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (46, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (47, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (48, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (49, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (50, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (51, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (52, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (53, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (54, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (55, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (56, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1351, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1352, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1353, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1354, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1355, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1357, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1358, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1359, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1360, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1361, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1362, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1363, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1364, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1365, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1366, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1367, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1368, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1369, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1370, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1371, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1372, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1373, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1374, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1375, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1376, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1377, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1378, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1379, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1380, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1381, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1382, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1383, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1384, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1385, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1411, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1412, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1413, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1414, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1415, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1416, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1417, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1418, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1419, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1420, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1421, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1422, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1423, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1424, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1425, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1426, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1427, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1428, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1429, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1430, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1431, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1432, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1433, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1434, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1435, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1436, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1437, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1438, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1439, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1440, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1441, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1442, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1443, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1444, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1445, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1446, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1447, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1448, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1449, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1450, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1451, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1452, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1453, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1454, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1455, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1456, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1457, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1458, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1459, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1460, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1461, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1462, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1463, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1464, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1465, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1466, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1467, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1468, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1469, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1470, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1471, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1472, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1473, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1474, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1475, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1476, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1477, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1478, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1479, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1480, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1481, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1482, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1483, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1484, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1485, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1486, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1487, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1488, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1489, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1490, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1491, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1492, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1493, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1494, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1495, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1496, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1497, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1498, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1499, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1500, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1501, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1502, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1503, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1504, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1505, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1506, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1507, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1508, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1509, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1510, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1511, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1512, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1513, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1514, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1515, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1516, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1517, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1518, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1519, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1520, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1521, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1522, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1523, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1526, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1527, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1528, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1529, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1530, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1531, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1532, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1533, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1534, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1535, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1536, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1537, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1538, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1539, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1540, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1541, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1542, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1543, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1544, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1545, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1546, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1547, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1548, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1549, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1550, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1551, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1552, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1553, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1554, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1555, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1556, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1557, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1558, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1559, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1560, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1561, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1562, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1563, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1564, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1565, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1566, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1567, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1568, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1569, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1570, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1571, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1572, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1573, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1574, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1575, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1576, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1577, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1578, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1579, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1580, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1581, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1582, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1583, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1584, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1585, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1586, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1587, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1588, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1589, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1590, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1591, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1592, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1593, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1594, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1595, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1596, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1597, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1598, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1599, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1600, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1601, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1602, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1603, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1604, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1605, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1606, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1607, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1608, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1609, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1610, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1611, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1612, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1613, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1614, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1615, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1616, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1617, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1618, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1619, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1620, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1621, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1622, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1623, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1624, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1625, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1626, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1627, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1628, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1629, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1630, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1631, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1632, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1633, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1634, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1635, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1636, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1637, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1638, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1639, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1640, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1641, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1642, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1643, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1644, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1645, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1646, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1647, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1648, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1649, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1650, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1651, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1652, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1653, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1654, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1655, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1656, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1657, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1658, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1659, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1660, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1661, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1662, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1663, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1664, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1665, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1666, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1667, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1668, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1669, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1670, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1671, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1672, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1673, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1674, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1675, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1676, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1677, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1678, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1679, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1680, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1681, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1682, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1683, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1684, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1685, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1686, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1687, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1688, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1689, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1690, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1691, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1692, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1693, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1694, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1695, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1696, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1697, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1698, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1699, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1700, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1701, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1702, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1703, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1704, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1705, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1706, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1707, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1708, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1709, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1710, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1711, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1712, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1713, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1714, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1715, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1716, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1717, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1718, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1719, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1720, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1721, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1722, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1723, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1724, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1725, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1726, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1727, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1728, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1729, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1730, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1731, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1732, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1733, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1734, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1735, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1736, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1737, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1738, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1739, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1740, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1741, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1742, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1743, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1744, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1745, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1746, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1747, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1748, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1749, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1750, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1751, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1752, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1753, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1754, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1755, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1756, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1757, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1758, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1759, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1760, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1761, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1762, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1763, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1764, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1765, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1766, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1767, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1768, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1769, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1770, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1771, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1772, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1773, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1774, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1775, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1776, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1777, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1778, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1779, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1780, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1781, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1782, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1783, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1784, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1785, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1786, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1787, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1788, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1789, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1790, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1791, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1792, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1793, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1794, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1795, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1796, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1797, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1798, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1799, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1800, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1801, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1802, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1803, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1804, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1805, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1806, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1807, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1808, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1809, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1810, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1811, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1812, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1813, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1814, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1815, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1816, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1817, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1818, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1819, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1820, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1821, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1822, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1823, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1824, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1825, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1826, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1827, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1828, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1829, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1830, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1831, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1832, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1833, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1834, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1835, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1836, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1837, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1838, '云星', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1839, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1840, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1841, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1842, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1843, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1844, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1845, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1846, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1847, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1848, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1849, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1850, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1851, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1852, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1853, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1854, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1855, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1856, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1857, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1858, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1859, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1860, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1861, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1862, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1863, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1864, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1865, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1866, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1867, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1868, '张黎明2', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1869, '薛磊4', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1870, '张洁4', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1871, '江南一点雨5', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1872, '陈静5', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1873, '赵琳浩5', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1874, '鹿存亮5', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1875, '姚森5', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1876, '云星5', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1877, '贾旭明5', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1878, '张黎明5', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1879, '薛磊5', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1880, '张洁5', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1881, '江南一点雨6', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1882, '陈静6', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1883, '赵琳浩6', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1884, '鹿存亮6', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1885, '姚森6', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1886, '云星6', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1887, '江南一点雨', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1888, '陈静', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1889, '赵琳浩', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1890, '鹿存亮', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1891, '姚森', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1892, '贾旭明', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1893, '张黎明', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1894, '薛磊', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1895, '张洁', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1896, '江南一点雨2', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1897, '陈静2', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1898, '赵琳浩2', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1899, '鹿存亮2', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1900, '姚森2', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1901, '云星2', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1902, '贾旭明2', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1903, '王一亭', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1904, '薛磊2', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1905, '张洁2', NULL, '女', '1990-10-09', '420177199010093652', 1, '13695557742', '海口市美兰区');
INSERT INTO `user` VALUES (1906, '江南一点雨3', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1907, '陈静3', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1908, '鹿存亮3', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1909, '姚森3', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1910, '云星3', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1911, '贾旭明3', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1912, '张黎明3', NULL, '男', '1991-02-01', '610144199102014569', 1, '18979994478', '广东珠海');
INSERT INTO `user` VALUES (1913, '薛磊3', NULL, '男', '1992-07-01', '610144199207017895', 1, '15648887741', '西安市雁塔区');
INSERT INTO `user` VALUES (1914, '江南一点雨4', NULL, '男', '1990-01-01', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1915, '陈静4', NULL, '女', '1989-02-01', '421288198902011234', 1, '18795556693', '海南省海口市美兰区');
INSERT INTO `user` VALUES (1916, '赵琳浩4', NULL, '男', '1993-03-04', '610122199303041456', 1, '15698887795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1917, '鹿存亮4', NULL, '男', '1990-01-03', '610122199001031456', 1, '15612347795', '陕西省西安市莲湖区');
INSERT INTO `user` VALUES (1918, '姚森4', NULL, '男', '1991-02-05', '610122199102058952', 1, '14785559936', '河南洛阳人民大道58号');
INSERT INTO `user` VALUES (1919, '云星4', NULL, '女', '1993-01-05', '610122199301054789', 1, '15644442252', '陕西西安新城区');
INSERT INTO `user` VALUES (1920, '贾旭明4', NULL, '男', '1993-11-11', '610122199311111234', 1, '15644441234', '广东省广州市天河区冼村路');
INSERT INTO `user` VALUES (1921, '谢工', NULL, '女', '1970-01-01', '618177197001011234', 1, '18558887788', '北京');
INSERT INTO `user` VALUES (1922, '林昭亮', NULL, '男', '1990-01-01', '610122199809091234', 1, '16767776654', '广东深圳');
INSERT INTO `user` VALUES (1923, '11', NULL, '男', '2018-01-01', '610122201801011234', 1, '111', '1');
INSERT INTO `user` VALUES (1924, '1', NULL, '男', '2018-01-01', '610188199809091234', 1, '1', '1');
INSERT INTO `user` VALUES (1925, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1926, '1', NULL, '男', '2018-01-01', '610122199909090000', 1, '1', '1');
INSERT INTO `user` VALUES (1927, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1928, '1', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1929, '林伯渠', NULL, '男', '2018-01-01', '610122199909099999', 1, '1', '1');
INSERT INTO `user` VALUES (1930, '1', NULL, '男', '2018-01-01', '610122199909091234', 1, '1', '1');
INSERT INTO `user` VALUES (1931, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1932, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1933, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1934, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1935, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1936, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1937, 'javaboy', NULL, '男', '1989-12-31', '610122199001011256', 1, '18565558897', '深圳市南山区');
INSERT INTO `user` VALUES (1938, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1939, 'javaboy666', NULL, '男', '2019-11-10', '610122199911111111', 1, '12345678901', '广东深圳');
INSERT INTO `user` VALUES (1940, 'javaboy', NULL, '男', '2017-11-01', '610144199905059999', 1, '18564447789', '广东深圳');
INSERT INTO `user` VALUES (1941, 'javaboy', NULL, '男', '2019-11-24', '610144199905056666', 1, '18566667777', '广东深圳');

-- ----------------------------
-- Procedure structure for addDep
-- ----------------------------
DROP PROCEDURE IF EXISTS `addDep`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addDep`(in depName varchar(32),in parentId int,in enabled boolean,out result int,out result2 int)
begin
  declare did int;
  declare pDepPath varchar(64);
  insert into department set name=depName,parentId=parentId,enabled=enabled;
  select row_count() into result;
  select last_insert_id() into did;
  set result2=did;
  select depPath into pDepPath from department where id=parentId;
  update department set depPath=concat(pDepPath,'.',did) where id=did;
  update department set isParent=true where id=parentId;
end
;;
delimiter ;

-- ----------------------------
-- Procedure structure for deleteDep
-- ----------------------------
DROP PROCEDURE IF EXISTS `deleteDep`;
delimiter ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDep`(in did int,out result int)
begin
  declare ecount int;
  declare pid int;
  declare pcount int;
  declare a int;
  select count(*) into a from department where id=did and isParent=false;
  if a=0 then set result=-2;
  else
  select count(*) into ecount from employee where departmentId=did;
  if ecount>0 then set result=-1;
  else
  select parentId into pid from department where id=did;
  delete from department where id=did and isParent=false;
  select row_count() into result;
  select count(*) into pcount from department where parentId=pid;
  if pcount=0 then update department set isParent=false where id=pid;
  end if;
  end if;
  end if;
end
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
