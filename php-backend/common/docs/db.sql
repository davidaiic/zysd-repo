#用户表
CREATE TABLE `ky_user` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `username` varchar(255) NOT NULL DEFAULT '' COMMENT '用户名',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `password` varchar(50) NOT NULL DEFAULT '' COMMENT '登录密码',
  `openid` varchar(50) NOT NULL DEFAULT '' COMMENT '小程序openid',
  `gender` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '性别：0-未知，1-男，2-女',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `wx` varchar(255) NOT NULL DEFAULT '' COMMENT '微信号',
  `qrcode` varchar(255) NOT NULL DEFAULT '' COMMENT '二维码',
  `add_wx` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否已添加微信：0-没有，1-已添加',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `invite_id` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '邀请人id',
  `os` varchar(20) NOT NULL DEFAULT '' COMMENT '系统类型',
  `version` varchar(20) NOT NULL DEFAULT '' COMMENT '版本号',
  `phoneModel` varchar(255) NOT NULL DEFAULT '' COMMENT '手机型号',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `username` (`username`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE,
  KEY `openid` (`openid`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE,
  KEY `invite_id` (`invite_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户表';

#文案表
CREATE TABLE `ky_explain` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `keyword` varchar(50) NOT NULL DEFAULT '' COMMENT '关键字标识',
  `title` varchar(100) NOT NULL DEFAULT '' COMMENT '标题',
  `content` text NOT NULL COMMENT '内容',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `remark` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `keyword` (`keyword`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='文案表';

#banner表
CREATE TABLE `ky_banner` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `notes` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `image_url` varchar(255) NOT NULL DEFAULT '' COMMENT '图片链接',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '类型：0-静态，1-URL跳转',
  `link_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转链接',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `text1` varchar(255) NOT NULL DEFAULT '' COMMENT '文案一',
  `text2` varchar(255) NOT NULL DEFAULT '' COMMENT '文案二',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='banner表';

#配置表
CREATE TABLE `ky_setting` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(100) NOT NULL DEFAULT '' COMMENT '名称',
  `keyword` varchar(50) NOT NULL DEFAULT '' COMMENT '关键字标识',
  `value` varchar(255) NOT NULL DEFAULT '' COMMENT '内容',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `keyword` (`keyword`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='配置表';

#药品表
CREATE TABLE `ky_goods` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药品名称',
  `en_name` varchar(255) NOT NULL DEFAULT '' COMMENT '英文药品名称',
  `common_name` varchar(255) NOT NULL DEFAULT '' COMMENT '通用名称',
  `other_name` varchar(255) NOT NULL DEFAULT '' COMMENT '其他名称',
  `goods_image` varchar(255) NOT NULL DEFAULT '' COMMENT '药品图片',
  `big_image` varchar(1000) NOT NULL DEFAULT '' COMMENT '药品大图',
  `class_id` int(11) NOT NULL DEFAULT '0' COMMENT '分类id',
  `class_list` varchar(255) NOT NULL DEFAULT '' COMMENT '分类集合',
  `company_id` int(11) NOT NULL DEFAULT '0' COMMENT '药厂id',
  `search_num` int(11) NOT NULL DEFAULT '0' COMMENT '查询次数',
  `money_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '货币类型：0-人民币，1-美金',
  `min_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '药品最低价格',
  `max_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '药品最高价格',
  `min_cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '药品月花费最低价格',
  `max_cost_price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '药品月花费最高价格',
  `price_trend` varchar(1000) NOT NULL DEFAULT '' COMMENT '价格趋势，json格式',
  `specs` varchar(255) NOT NULL DEFAULT '' COMMENT '规格',
  `full_name` varchar(255) NOT NULL DEFAULT '' COMMENT '全称',
  `goods_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '药品类型：1-处方，2-OTC，3-医疗器械',
  `number` varchar(255) NOT NULL DEFAULT '' COMMENT '批准文号',
  `period` varchar(255) NOT NULL DEFAULT '' COMMENT '有效期',
  `goods_code` varchar(255) NOT NULL DEFAULT '' COMMENT '条形码',
  `ndc` varchar(255) NOT NULL DEFAULT '' COMMENT 'NDC，美国药品上市的准字号',
  `ability` text NOT NULL COMMENT '功能主治',
  `usage_dosage` text NOT NULL COMMENT '用法用量',
  `indication` text NOT NULL COMMENT '适应症',
  `reaction` text NOT NULL COMMENT '不良反应',
  `taboo` text NOT NULL COMMENT '禁忌',
  `attention` text NOT NULL COMMENT '注意事项',
  `unit` varchar(255) NOT NULL DEFAULT '' COMMENT '包装单位',
  `composition` text NOT NULL COMMENT '主要成份',
  `character` text NOT NULL COMMENT '性状',
  `storage` varchar(255) NOT NULL DEFAULT '' COMMENT '贮藏',
  `standard` varchar(255) NOT NULL DEFAULT '' COMMENT '执行标准',
  `eligibility` varchar(255) NOT NULL DEFAULT '' COMMENT '适用人群',
  `woman_dosage` text NOT NULL COMMENT '孕妇及哺乳期妇女用药',
  `children_dosage` text NOT NULL COMMENT '儿童用药',
  `elderly_dosage` text NOT NULL COMMENT '老年患者用药',
  `interactions` text NOT NULL COMMENT '药物相互作用',
  `pharmacokinetics` text NOT NULL COMMENT '药代动力学',
  `toxicology` text NOT NULL COMMENT '药理毒理',
  `clinical_trial` text NOT NULL COMMENT '临床试验',
  `drug_overdose` text NOT NULL COMMENT '药物过量',
  `import_number` varchar(255) NOT NULL DEFAULT '' COMMENT '进口药品注册证号',
  `license_holder` varchar(255) NOT NULL DEFAULT '' COMMENT '药品上市许可持有人',
  `license_address` varchar(255) NOT NULL DEFAULT '' COMMENT '药品上市许可持有人地址',
  `import_company` varchar(255) NOT NULL DEFAULT '' COMMENT '进口分装企业',
  `medical_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '医保类型：0-无，1-甲类，2-乙类',
  `submit_scope` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '（乙类）目前医保报销范围：0-无，1-报销仅限基因靶点',
  `gene_scope` varchar(255) NOT NULL DEFAULT '' COMMENT '（乙类）基因靶点，多个标签以,隔开',
  `medical_date` varchar(50) NOT NULL DEFAULT '' COMMENT '医保执行时间',
  `gene_target` varchar(255) NOT NULL DEFAULT '' COMMENT '基因靶点，多个标签以,隔开',
  `register_info` text NOT NULL COMMENT '药品查询注册信息',
  `data_sources` varchar(255) NOT NULL DEFAULT '' COMMENT '数据来源',
  `query_time` varchar(20) NOT NULL DEFAULT '' COMMENT '查询时间',
  `send_examine` text NOT NULL COMMENT '我要送检',
  `charitable_donation` text NOT NULL COMMENT '慈善赠药',
  `clinical_recruitment` text NOT NULL COMMENT '患者临床招募',
  `gene_check` text NOT NULL COMMENT '基因检测',
  `is_market` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否已上市：0-未上市，1-已上市',
  `market_place` varchar(50) NOT NULL DEFAULT '' COMMENT '上市区域',
  `clinical_stage` varchar(50) NOT NULL DEFAULT '' COMMENT '国内临床阶段',
  `market_date` varchar(50) NOT NULL DEFAULT '' COMMENT '上市时间',
  `drug_properties` varchar(255) NOT NULL DEFAULT '' COMMENT '药品属性，多个标签以,隔开',
  `risk` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '药品风险等级：0-无，1-高风险',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `is_hot` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否热门：0-否，1-是',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_name` (`goods_name`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品表';

#药品分类表
CREATE TABLE `ky_goods_class` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '分类名称',
  `parent_id` int(11) UNSIGNED NOT NULL DEFAULT '0' COMMENT '上级分类id',
  `pid_list` varchar(255) NOT NULL DEFAULT '' COMMENT '上级分类集合',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `parent_id` (`parent_id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品分类表';

#药品服务表
CREATE TABLE `ky_goods_server` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
  `icon` varchar(255) NOT NULL DEFAULT '' COMMENT '图标',
  `desc` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `link_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转链接',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品服务表';

#药品纠错类目表
CREATE TABLE `ky_goods_error_directory` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '药品id',
  `keywords` varchar(255) NOT NULL DEFAULT '' COMMENT '关键词标识，多个以,隔开',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药品纠错类目表';

#评论表
CREATE TABLE `ky_comment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '内容',
  `pictures` varchar(2000) NOT NULL DEFAULT '' COMMENT '评论图片',
  `like_num` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comment_num` int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
  `comment_id` int(11) NOT NULL DEFAULT '0' COMMENT '评论id',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-待审核，1-审核通过，2-审核失败',
  `is_hot` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否热门评论：0-否，1-是',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `comment_id` (`comment_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_hot` (`is_hot`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';

#评论点赞表
CREATE TABLE `ky_comment_like` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `comment_id` int(11) NOT NULL DEFAULT '0' COMMENT '评论id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `comment_id` (`comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论点赞表';

#标签表
CREATE TABLE `ky_label` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) NOT NULL DEFAULT '' COMMENT '标签名称',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_hot` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否热门：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `name` (`name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='标签表';

#资讯热门词表
CREATE TABLE `ky_article_word` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `word` varchar(255) NOT NULL DEFAULT '' COMMENT '热门词',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯热门词表';

#资讯表
CREATE TABLE `ky_article` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `cover` varchar(255) NOT NULL DEFAULT '' COMMENT '封面',
  `publish_date` varchar(255) NOT NULL DEFAULT '' COMMENT '发布日期',
  `label` varchar(255) NOT NULL DEFAULT '' COMMENT '标签，多个标签以,隔开',
  `content` text NOT NULL COMMENT '内容',
  `like_num` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `comment_num` int(11) NOT NULL DEFAULT '0' COMMENT '评论数',
  `read_num` int(11) NOT NULL DEFAULT '0' COMMENT '阅读数',
  `is_top` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否置顶：0-否，1-是',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `title` (`title`) USING BTREE,
  KEY `label` (`label`) USING BTREE,
  KEY `is_top` (`is_top`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯表';

#资讯评论表
CREATE TABLE `ky_article_comment` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `article_id` int(11) NOT NULL DEFAULT '0' COMMENT '资讯id',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '内容',
  `pictures` varchar(2000) NOT NULL DEFAULT '' COMMENT '评论图片',
  `like_num` int(11) NOT NULL DEFAULT '0' COMMENT '点赞数',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-待审核，1-审核通过，2-审核失败',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `article_id` (`article_id`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯评论表';

#资讯点赞表
CREATE TABLE `ky_article_like` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `article_id` int(11) NOT NULL DEFAULT '0' COMMENT '资讯id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `article_id` (`article_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯点赞表';

#资讯评论点赞表
CREATE TABLE `ky_article_comment_like` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `article_comment_id` int(11) NOT NULL DEFAULT '0' COMMENT '资讯评论id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `article_comment_id` (`article_comment_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='资讯评论点赞表';

#搜索记录表
CREATE TABLE `ky_search` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `word` varchar(255) NOT NULL DEFAULT '' COMMENT '搜索词',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='搜索记录表';

#热门搜索表
CREATE TABLE `ky_hot` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `word` varchar(255) NOT NULL DEFAULT '' COMMENT '搜索词',
  `search_num` int(11) NOT NULL DEFAULT '0' COMMENT '搜索次数',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `word` (`word`) USING BTREE,
  KEY `search_num` (`search_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='热门搜索表';

#联想词表
CREATE TABLE `ky_associate_word` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `word` varchar(255) NOT NULL DEFAULT '' COMMENT '联想词',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `word` (`word`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='联想词表';

#照片查询表
CREATE TABLE `ky_photo` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `positive` varchar(255) NOT NULL DEFAULT '' COMMENT '正面',
  `left_side` varchar(255) NOT NULL DEFAULT '' COMMENT '左侧面',
  `right_side` varchar(255) NOT NULL DEFAULT '' COMMENT '右侧面',
  `back` varchar(255) NOT NULL DEFAULT '' COMMENT '背面',
  `other` varchar(1000) NOT NULL DEFAULT '' COMMENT '其余照片',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `status` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-待核查，1-核查通过，2-核查失败',
  `sms_text` varchar(255) NOT NULL DEFAULT '' COMMENT '短信内容',
  `is_sms` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否发送短信：0-否，1-是',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药品名称',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂名称',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='照片查询表';

#短信表
CREATE TABLE `ky_sms` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `sms_text` varchar(255) NOT NULL DEFAULT '' COMMENT '短信内容',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类型：0-默认，1-短信登录',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '状态：0-有效，1-失效',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='短信表';

#药厂表
CREATE TABLE `ky_company` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂名称',
  `en_name` varchar(255) NOT NULL DEFAULT '' COMMENT '英文药厂名称',
  `company_image` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂图片',
  `code_query` text NOT NULL COMMENT '防伪码查询方法',
  `request_url` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂查询url',
  `request_method` varchar(20) NOT NULL DEFAULT '' COMMENT '请求方式',
  `element` varchar(255) NOT NULL DEFAULT '' COMMENT '标识元素',
  `result_field` varchar(255) NOT NULL DEFAULT '' COMMENT '结果字段标识',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `hot_type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '热门类型：0-非热门，1-国外仿制药热门，2-其他热门',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `company_name` (`company_name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药厂表';

#药厂查询表
CREATE TABLE `ky_company_search` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `company_id` int(11) NOT NULL DEFAULT '0' COMMENT '药厂id',
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '防伪码',
  `content` text NOT NULL COMMENT '查询内容',
  `result` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '查询结果：0-无法识别，1-真，2-假',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='药厂查询表';

#价格查询表
CREATE TABLE `ky_price_search` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药品名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '药品价格',
  `company_id` int(11) NOT NULL DEFAULT '0' COMMENT '药厂id',
  `channel_id` int(11) NOT NULL DEFAULT '0' COMMENT '渠道id',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '药品id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `goods_name` (`goods_name`) USING BTREE,
  KEY `company_id` (`company_id`) USING BTREE,
  KEY `channel_id` (`channel_id`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='价格查询表';

#渠道表
CREATE TABLE `ky_channel` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `channel_name` varchar(255) NOT NULL DEFAULT '' COMMENT '渠道名称',
  `sort` int(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `select_num` int(11) NOT NULL DEFAULT '0' COMMENT '选择次数',
  `enable` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '状态：0-正常，1-禁用',
  `is_delete` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '是否删除：0-否，1-是',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `channel_name` (`channel_name`) USING BTREE,
  KEY `sort` (`sort`) USING BTREE,
  KEY `enable` (`enable`) USING BTREE,
  KEY `is_delete` (`is_delete`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='渠道表';

#查询记录表
CREATE TABLE `ky_query_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药品名称',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂名称',
  `type` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '查询类型：1-人工核查，2-自助查询，3-价格查询，4-药品搜索，5-扫一扫，6-我要比价',
  `relate_id` int(11) NOT NULL DEFAULT '0' COMMENT '关联id，对应查询表id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `relate_id` (`relate_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='查询记录表';

#意见反馈表
CREATE TABLE `ky_feedback` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `content` varchar(1000) NOT NULL DEFAULT '' COMMENT '内容',
  `image_url` varchar(1000) NOT NULL DEFAULT '' COMMENT '图片',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `mobile` (`mobile`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='意见反馈表';

#图片识别表
CREATE TABLE `ky_image_recognition` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `image_url` varchar(255) NOT NULL DEFAULT '' COMMENT '图片',
  `keywords` text NOT NULL COMMENT '关键词集合，json格式',
  `words` text NOT NULL COMMENT '文字集合，json格式',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='图片识别表';

#扫一扫记录表
CREATE TABLE `ky_scan_log` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `code` varchar(255) NOT NULL DEFAULT '' COMMENT '条形码',
  `goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '药品id',
  `goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药品名称',
  `company_id` int(11) NOT NULL DEFAULT '0' COMMENT '药厂id',
  `company_name` varchar(255) NOT NULL DEFAULT '' COMMENT '药厂名称',
  `risk` tinyint(1) UNSIGNED NOT NULL DEFAULT '0' COMMENT '药品风险等级：0-无，1-高风险',
  `server_name` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转页面标题',
  `link_url` varchar(255) NOT NULL DEFAULT '' COMMENT '跳转链接',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `code` (`code`) USING BTREE,
  KEY `goods_id` (`goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='扫一扫记录表';

#比价表
CREATE TABLE `ky_compare_price` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `uid` int(11) NOT NULL DEFAULT '0' COMMENT '用户id',
  `left_goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '左边药品名称',
  `left_company_id` int(11) NOT NULL DEFAULT '0' COMMENT '左边药厂id',
  `left_specs` varchar(255) NOT NULL DEFAULT '' COMMENT '左边规格名称',
  `left_goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '左边药品id',
  `right_goods_name` varchar(255) NOT NULL DEFAULT '' COMMENT '右边药品名称',
  `right_company_id` int(11) NOT NULL DEFAULT '0' COMMENT '右边药厂id',
  `right_specs` varchar(255) NOT NULL DEFAULT '' COMMENT '右边规格名称',
  `right_goods_id` int(11) NOT NULL DEFAULT '0' COMMENT '右边药品id',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `uid` (`uid`) USING BTREE,
  KEY `left_goods_id` (`left_goods_id`) USING BTREE,
  KEY `right_goods_id` (`right_goods_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='比价表';

#h5链接表
CREATE TABLE `ky_web_url` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `title` varchar(255) NOT NULL DEFAULT '' COMMENT '标题',
  `keyword` varchar(50) NOT NULL DEFAULT '' COMMENT '关键字标识',
  `link_url` varchar(255) NOT NULL DEFAULT '' COMMENT '链接url',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='h5链接表';

#app版本表
CREATE TABLE `ky_app_version` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `version_number` varchar(50) NOT NULL DEFAULT '' COMMENT '版本号',
  `version_code` varchar(50) NOT NULL DEFAULT '' COMMENT '小版本号',
  `content` text NOT NULL COMMENT '更新内容',
  `is_must` tinyint(1) NOT NULL DEFAULT '1' COMMENT '更新类型：1-非强制，2-强制更新(可取消)，3-强制更新(不可取消)',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '状态：1-上线，2-下线',
  `type` tinyint(1) NOT NULL DEFAULT '1' COMMENT '投放类型：1-用户版，2-商户版',
  `download_url` varchar(255) NOT NULL DEFAULT '' COMMENT '下载地址',
  `app_ver_low` varchar(20) NOT NULL DEFAULT '' COMMENT '系统最低版本',
  `app_ver_high` varchar(20) NOT NULL DEFAULT '' COMMENT '系统最高版本',
  `platform` tinyint(1) NOT NULL DEFAULT '1' COMMENT '系统类型：1-android，2-ios',
  `created` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) UNSIGNED NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `is_must` (`is_must`) USING BTREE,
  KEY `status` (`status`) USING BTREE,
  KEY `type` (`type`) USING BTREE,
  KEY `platform` (`platform`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='app版本表';

#后台用户表
CREATE TABLE `ky_admin_user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `username` varchar(50) NOT NULL DEFAULT '' COMMENT '用户名',
  `password` varchar(32) NOT NULL DEFAULT '' COMMENT '登录密码',
  `mobile` varchar(50) NOT NULL DEFAULT '' COMMENT '手机号',
  `avatar` varchar(255) NOT NULL DEFAULT '' COMMENT '头像',
  `created` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `mobile` (`mobile`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='后台用户表';

#角色表
CREATE TABLE `ky_roles` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(255) NOT NULL COMMENT '角色名称',
  `alias` varchar(255) NOT NULL COMMENT '角色别名',
  `note` varchar(255) NOT NULL DEFAULT '' COMMENT '备注',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '类型：0-系统预置；1-自定义',
  `created` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `roles_name_unique` (`name`) USING BTREE,
  UNIQUE KEY `roles_alias_unique` (`alias`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色表';

#权限表
CREATE TABLE `ky_permissions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `name` varchar(50) NOT NULL COMMENT '名称',
  `alias` varchar(255) NOT NULL DEFAULT '' COMMENT '别名',
  `route` varchar(255) NOT NULL COMMENT '路由',
  `icon` varchar(50) NOT NULL DEFAULT '' COMMENT '图标',
  `description` varchar(255) NOT NULL DEFAULT '' COMMENT '描述',
  `parent_id` int(10) NOT NULL DEFAULT '0' COMMENT '父级id',
  `is_menu` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '是否菜单：0-否；1-是',
  `sort` tinyint(4) NOT NULL DEFAULT '0' COMMENT '排序',
  `created` int(10) NOT NULL DEFAULT '0' COMMENT '创建时间',
  `updated` int(10) NOT NULL DEFAULT '0' COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='权限表';

#角色权限关联表
CREATE TABLE `ky_role_permissions` (
  `permission_id` int(10) unsigned NOT NULL COMMENT 'ky_permissions.id',
  `role_id` int(10) unsigned NOT NULL COMMENT 'ky_roles.id',
  PRIMARY KEY (`permission_id`,`role_id`) USING BTREE,
  KEY `ky_role_permissions_role_id_foreign` (`role_id`) USING BTREE,
  CONSTRAINT `ky_role_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `ky_permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ky_role_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `ky_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='角色权限关联表';

#用户角色关联表
CREATE TABLE `ky_user_roles` (
  `role_id` int(10) unsigned NOT NULL COMMENT '角色id，ky_roles.id',
  `user_id` int(10) unsigned NOT NULL COMMENT '用户id，ky_admin_user.id',
  PRIMARY KEY (`role_id`,`user_id`) USING BTREE,
  UNIQUE KEY `user_role` (`role_id`,`user_id`) USING BTREE,
  CONSTRAINT `ky_user_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `ky_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='用户角色关联表';
