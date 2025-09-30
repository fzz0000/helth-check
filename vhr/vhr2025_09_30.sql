/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 50736
 Source Host           : localhost:3306
 Source Schema         : vhr2025

 Target Server Type    : MySQL
 Target Server Version : 50736
 File Encoding         : 65001

 Date: 30/09/2025 16:43:13
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
) ENGINE = InnoDB AUTO_INCREMENT = 44 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of notice
-- ----------------------------
INSERT INTO `notice` VALUES (29, '通知内容', '2018-01-11 21:13:42', 1);
INSERT INTO `notice` VALUES (30, '通知内容11', '2018-01-11 21:13:48', 0);
INSERT INTO `notice` VALUES (31, '通知内容555', '2018-01-11 00:00:00', 1);
INSERT INTO `notice` VALUES (33, '通知内容55555', '2018-01-14 00:00:00', 0);
INSERT INTO `notice` VALUES (34, 'notice', '2025-09-30 11:32:13', 0);
INSERT INTO `notice` VALUES (35, '	 通知内容	 通知内容', '2025-09-30 15:10:44', 1);
INSERT INTO `notice` VALUES (36, '	 通知内容	 通知内容	 通知内容	 通知内容', '2025-09-30 15:10:46', 1);
INSERT INTO `notice` VALUES (37, '	 通知内容	 通知内容	 通洒点水知内容	 通知内容', '2025-09-30 15:10:50', 1);
INSERT INTO `notice` VALUES (38, '是的撒', '2025-09-30 15:10:51', 1);
INSERT INTO `notice` VALUES (39, '刚刚发', '2025-09-30 15:10:53', 1);
INSERT INTO `notice` VALUES (40, '是的是的', '2025-09-30 15:10:59', 1);
INSERT INTO `notice` VALUES (41, '大发发', '2025-09-30 15:11:03', 0);
INSERT INTO `notice` VALUES (42, '打点', '2025-09-30 15:11:14', 1);

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
