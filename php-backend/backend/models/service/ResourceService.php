<?php

namespace backend\models\service;

use backend\components\Helper;
use common\components\Tool;
use frontend\models\home\Goods;
use frontend\models\home\GoodsClass;
use frontend\models\home\GoodsServer;
use frontend\models\query\Channel;
use frontend\models\query\Company;
use yii\base\ExitException;
use yii\db\Expression;
use yii\db\Query;

/**
 * 资料
 */
class ResourceService
{
    /**
     * 获取药厂列表
     * @param string $companyName 药厂名称
     * @param string $enable 状态：0-正常，1-禁用
     * @param string $hotType 热门类型：0-非热门，1-国外仿制药热门，2-其他热门
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getCompanyList($companyName, $enable, $hotType, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id as companyId',
            'company_name as companyName',
            'en_name as enName',
            'company_image as companyImage',
            'code_query as codeQuery',
            'request_url as requestUrl',
            'request_method as requestMethod',
            'element',
            'result_field as resultField',
            'sort',
            'enable',
            'hot_type as hotType'])
            ->from('ky_company')
            ->where(['is_delete' => 0]);

        if ($companyName) {
            $list->andWhere(['like', 'company_name', $companyName]);
        }

        if ($enable !== '') {
            $list->andWhere(['enable' => $enable]);
        }

        if ($hotType !== '') {
            $list->andWhere(['hot_type' => $hotType]);
        }

        //获取总数量
        $total = $list->count();

        //获取导出数据
        //$excelList = $list->orderBy('id desc')->all();
        $excelList = [];

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'excelList' => $excelList, 'total' => $total];
    }

    /**
     * 药厂操作
     * @param string $companyName 药厂名称
     * @param string $enName 英文药厂名称
     * @param string $companyImage 药厂图片
     * @param string $codeQuery 防伪码查询方法
     * @param string $requestUrl 药厂查询url
     * @param string $requestMethod 请求方式
     * @param string $element 标识元素
     * @param string $resultField 结果字段标识
     * @param string $sort 排序
     * @param int $hotType 热门类型：0-非热门，1-国外仿制药热门，2-其他热门
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-改变状态
     * @param int $companyId 药厂id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithCompany($companyName, $enName, $companyImage, $codeQuery, $requestUrl, $requestMethod, $element, $resultField, $sort, $hotType, $enable, $operateType, $companyId)
    {
        if ($operateType != 1) {
            $company = Company::findByCompanyId($companyId);

            if (!$company) Helper::responseError(1013);

            $company->updated = time();

            if ($operateType == 3) {
                $company->is_delete = 1;
                return $company->save();
            }

            if ($operateType == 4) {
                $company->enable = $enable;
                return $company->save();
            }
        } else {
            $company = new Company();
            $company->created = time();
        }

        $company->company_name = $companyName;
        $company->en_name = $enName;
        $company->company_image = $companyImage;
        $company->code_query = $codeQuery;
        $company->request_url = $requestUrl;
        $company->request_method = $requestMethod;
        $company->element = $element;
        $company->result_field = $resultField;
        $company->sort = $sort;
        $company->enable = $enable;
        $company->hot_type = $hotType;

        return $company->save();
    }

    /**
     * 获取渠道列表
     * @param string $channelName 渠道名称
     * @param string $enable 状态：0-正常，1-禁用
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getChannelList($channelName, $enable, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id as channelId',
            'channel_name as channelName',
            'sort',
            'select_num as selectNum',
            'enable'])
            ->from('ky_channel')
            ->where(['is_delete' => 0]);

        if ($channelName) {
            $list->andWhere(['like', 'channel_name', $channelName]);
        }

        if ($enable !== '') {
            $list->andWhere(['enable' => $enable]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 渠道操作
     * @param string $channelName 渠道名称
     * @param string $sort 排序
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-改变状态
     * @param int $channelId 渠道id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithChannel($channelName, $sort, $enable, $operateType, $channelId)
    {
        if ($operateType != 1) {
            $channel = Channel::findByChannelId($channelId);

            if (!$channel) Helper::responseError(1034);

            $channel->updated = time();

            if ($operateType == 3) {
                $channel->is_delete = 1;
                return $channel->save();
            }

            if ($operateType == 4) {
                $channel->enable = $enable;
                return $channel->save();
            }
        } else {
            $channel = new Channel();
            $channel->created = time();
        }

        $channel->channel_name = $channelName;
        $channel->sort = $sort;
        $channel->enable = $enable;

        return $channel->save();
    }

    /**
     * 获取药品列表
     * @param string $goodsName 药品名称
     * @param string $enName 英文药品名称
     * @param string $specs 规格
     * @param string $companyName 药厂名称
     * @param array $classList 分类集合
     * @param string $number 批准文号
     * @param string $enable 状态：0-正常，1-禁用
     * @param string $isHot 是否热门：0-否，1-是
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getGoodsList($goodsName, $enName, $specs, $companyName, $classList, $number, $enable, $isHot, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['goods.id as goodsId',
            'goods.goods_name as goodsName',
            'goods.en_name as enName',
            'goods.common_name as commonName',
            'goods.other_name as otherName',
            'goods.goods_image as goodsImage',
            'goods.big_image as bigImage',
            'goods.class_id as classId',
            'goods.class_list as classList',
            'goods.company_id as companyId',
            'company.company_name as companyName',
            'goods.search_num as searchNum',
            'goods.money_type as moneyType',
            'goods.min_price as minPrice',
            'goods.max_price as maxPrice',
            'goods.min_cost_price as minCostPrice',
            'goods.max_cost_price as maxCostPrice',
            'goods.price_trend as priceTrend',
            'goods.specs',
            'goods.full_name as fullName',
            'goods.goods_type as goodsType',
            'goods.number',
            'goods.period',
            'goods.goods_code as goodsCode',
            'goods.ndc',
            'goods.ability',
            'goods.usage_dosage as usageDosage',
            'goods.indication',
            'goods.reaction',
            'goods.taboo',
            'goods.attention',
            'goods.unit',
            'goods.composition',
            'goods.character',
            'goods.storage',
            'goods.standard',
            'goods.eligibility',
            'goods.woman_dosage as womanDosage',
            'goods.children_dosage as childrenDosage',
            'goods.elderly_dosage as elderlyDosage',
            'goods.register_info as registerInfo',
            'goods.data_sources as dataSources',
            'goods.query_time as queryTime',
            'goods.interactions',
            'goods.pharmacokinetics',
            'goods.toxicology',
            'goods.clinical_trial as clinicalTrial',
            'goods.drug_overdose as drugOverdose',
            'goods.import_number as importNumber',
            'goods.license_holder as licenseHolder',
            'goods.license_address as licenseAddress',
            'goods.import_company as importCompany',
            'goods.medical_type as medicalType',
            'goods.submit_scope as submitScope',
            'goods.gene_scope as geneScope',
            'goods.medical_date as medicalDate',
            'goods.gene_target as geneTarget',
            'goods.send_examine as sendExamine',
            'goods.charitable_donation as charitableDonation',
            'goods.clinical_recruitment as clinicalRecruitment',
            'goods.gene_check as geneCheck',
            'goods.is_market as isMarket',
            'goods.market_place as marketPlace',
            'goods.clinical_stage as clinicalStage',
            'goods.market_date as marketDate',
            'goods.drug_properties as drugProperties',
            'goods.risk',
            'goods.sort',
            'goods.enable',
            'goods.is_hot as isHot'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where(['goods.is_delete' => 0]);

        if ($goodsName) {
            $list->andWhere(['like', 'goods.goods_name', $goodsName]);
        }

        if ($enName) {
            $list->andWhere(['like', 'goods.en_name', $enName]);
        }

        if ($specs) {
            $list->andWhere(['like', 'goods.specs', $specs]);
        }

        if ($companyName) {
            $list->andWhere(['like', 'company.company_name', $companyName]);
        }

        if (!empty($classList)) {
            $classId = end($classList);
            $list->andWhere(new Expression('find_in_set(:classId, class_list)', [':classId' => $classId]));
        }

        if ($number) {
            $list->andWhere(['like', 'goods.number', $number]);
        }

        if ($enable !== '') {
            $list->andWhere(['goods.enable' => $enable]);
        }

        if ($isHot !== '') {
            $list->andWhere(['goods.is_hot' => $isHot]);
        }

        //获取总数量
        $total = $list->count();

        //获取导出数据
        //$excelList = $list->orderBy('goods.id desc')->all();
        $excelList = [];

        $list = $list->orderBy('goods.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                //药品图片取第一张
                $value['goodsImage'] = $value['bigImage'] ? explode(',', $value['bigImage'])[0] : $value['goodsImage'];

                //药品分类
                $value['classList'] = $value['classList'] ? explode(',', $value['classList']) : [];

                //（乙类）基因靶点
                $value['geneScope'] = $value['geneScope'] ? explode(',', $value['geneScope']) : [];

                //基因靶点
                $value['geneTarget'] = $value['geneTarget'] ? explode(',', $value['geneTarget']) : [];

                //价格趋势
                $value['priceTrend'] = $value['priceTrend'] ? json_decode($value['priceTrend'], true) : Tool::generateDateData(6);
                $value['priceTrendList'] = [];
                if (isset($value['priceTrend']['dateList']) && !empty($value['priceTrend']['dateList'])) {
                    foreach ($value['priceTrend']['dateList'] as $k => $v) {
                        $value['priceTrendList'][] = [
                            'date'  => $v,
                            'value' => isset($value['priceTrend']['priceList']) && isset($value['priceTrend']['priceList'][$k]) ? $value['priceTrend']['priceList'][$k] : ''
                        ];
                    }
                }
            }
        }

        return ['list' => $list, 'excelList' => $excelList, 'total' => $total];
    }

    /**
     * 药厂操作
     * @param string $goodsName 药品名称
     * @param string $enName 英文药品名称
     * @param string $commonName 通用名称
     * @param string $otherName 其他名称
     * @param string $goodsImage 药品图片
     * @param array $bigImage 药品大图
     * @param array $classList 分类集合
     * @param string $companyId 药厂id
     * @param int $moneyType 货币类型：0-人民币，1-美金
     * @param string $minPrice 药品最低价格
     * @param string $maxPrice 药品最高价格
     * @param string $minCostPrice 药品月花费最低价格
     * @param string $maxCostPrice 药品月花费最高价格
     * @param string $specs 规格
     * @param string $fullName 全称
     * @param int $goodsType 药品类型：1-处方，2-OTC，3-医疗器械
     * @param string $number 批准文号
     * @param string $period 有效期
     * @param string $goodsCode 条形码
     * @param string $ndc NDC，美国药品上市的准字号
     * @param string $ability 功能主治
     * @param string $usageDosage 用法用量
     * @param string $indication 适应症
     * @param string $reaction 不良反应
     * @param string $taboo 禁忌
     * @param string $attention 注意事项
     * @param string $unit 包装单位
     * @param string $composition 主要成份
     * @param string $character 性状
     * @param string $storage 贮藏
     * @param string $standard 执行标准
     * @param string $eligibility 适用人群
     * @param string $womanDosage 孕妇及哺乳期妇女用药
     * @param string $childrenDosage 儿童用药
     * @param string $elderlyDosage 老年患者用药
     * @param string $registerInfo 药品查询注册信息
     * @param string $dataSources 数据来源
     * @param string $queryTime 查询时间
     * @param string $interactions 药物相互作用
     * @param string $pharmacokinetics 药代动力学
     * @param string $toxicology 药理毒理
     * @param string $clinicalTrial 临床试验
     * @param string $drugOverdose 药物过量
     * @param string $importNumber 进口药品注册证号
     * @param string $licenseHolder 药品上市许可持有人
     * @param string $licenseAddress 药品上市许可持有人地址
     * @param string $importCompany 进口分装企业
     * @param int $medicalType 医保类型：0-无，1-甲类，2-乙类
     * @param int $submitScope （乙类）目前医保报销范围：0-无，1-报销仅限基因靶点
     * @param array $geneScope （乙类）基因靶点，多个标签以,隔开
     * @param string $medicalDate 医保执行时间
     * @param array $geneTarget 基因靶点，多个标签以,隔开
     * @param string $sendExamine 我要送检
     * @param string $charitableDonation 慈善赠药
     * @param string $clinicalRecruitment 患者临床招募
     * @param string $geneCheck 基因检测
     * @param string $isMarket 是否已上市：0-未上市，1-已上市
     * @param string $marketPlace 上市区域
     * @param string $clinicalStage 国内临床阶段
     * @param string $marketDate 上市时间
     * @param string $drugProperties 药品属性，多个标签以,隔开
     * @param int $risk 药品风险等级：0-无，1-高风险
     * @param string $sort 排序
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $isHot 是否热门：0-否，1-是
     * @param string $priceTrend 价格趋势，json格式
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-改变状态，5-热门，6-价格趋势
     * @param int $goodsId 药品id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithGoods(
        $goodsName,
        $enName,
        $commonName,
        $otherName,
        $goodsImage,
        $bigImage,
        $classList,
        $companyId,
        $moneyType,
        $minPrice,
        $maxPrice,
        $minCostPrice,
        $maxCostPrice,
        $specs,
        $fullName,
        $goodsType,
        $number,
        $period,
        $goodsCode,
        $ndc,
        $ability,
        $usageDosage,
        $indication,
        $reaction,
        $taboo,
        $attention,
        $unit,
        $composition,
        $character,
        $storage,
        $standard,
        $eligibility,
        $womanDosage,
        $childrenDosage,
        $elderlyDosage,
        $registerInfo,
        $dataSources,
        $queryTime,
        $interactions,
        $pharmacokinetics,
        $toxicology,
        $clinicalTrial,
        $drugOverdose,
        $importNumber,
        $licenseHolder,
        $licenseAddress,
        $importCompany,
        $medicalType,
        $submitScope,
        $geneScope,
        $medicalDate,
        $geneTarget,
        $sendExamine,
        $charitableDonation,
        $clinicalRecruitment,
        $geneCheck,
        $isMarket,
        $marketPlace,
        $clinicalStage,
        $marketDate,
        $drugProperties,
        $risk,
        $sort,
        $enable,
        $isHot,
        $priceTrend,
        $operateType,
        $goodsId
    )
    {
        if ($operateType != 1) {
            $goods = Goods::findGoodsDetail($goodsId);

            if (!$goods) Helper::responseError(1035);

            $goods->updated = time();

            if ($operateType == 3) {
                $goods->is_delete = 1;
                return $goods->save();
            }

            if ($operateType == 4) {
                $goods->enable = $enable;
                return $goods->save();
            }

            if ($operateType == 5) {
                $goods->is_hot = $isHot;
                return $goods->save();
            }

            if ($operateType == 6) {
                $goods->price_trend = $priceTrend;
                return $goods->save();
            }
        } else {
            $goods = new Goods();
            $goods->created = time();
        }

        $goods->goods_name = $goodsName;
        $goods->en_name = $enName;
        $goods->common_name = $commonName;
        $goods->other_name = $otherName;
        $goods->goods_image = !empty($bigImage) ? $bigImage[0] : $goodsImage;
        $goods->big_image = !empty($bigImage) ? implode(',', $bigImage) : '';
        $goods->class_id = !empty($classList) ? end($classList) : 0;
        $goods->class_list = !empty($classList) ? implode(',', $classList) : '';
        $goods->company_id = $companyId;
        $goods->money_type = $moneyType;
        $goods->min_price = $minPrice;
        $goods->max_price = $maxPrice;
        $goods->min_cost_price = $minCostPrice;
        $goods->max_cost_price = $maxCostPrice;
        $goods->specs = $specs;
        $goods->full_name = $fullName;
        $goods->goods_type = $goodsType;
        $goods->number = $number;
        $goods->period = $period;
        $goods->goods_code = $goodsCode;
        $goods->ndc = $ndc;
        $goods->ability = $ability;
        $goods->usage_dosage = $usageDosage;
        $goods->indication = $indication;
        $goods->reaction = $reaction;
        $goods->taboo = $taboo;
        $goods->attention = $attention;
        $goods->unit = $unit;
        $goods->composition = $composition;
        $goods->character = $character;
        $goods->storage = $storage;
        $goods->standard = $standard;
        $goods->eligibility = $eligibility;
        $goods->woman_dosage = $womanDosage;
        $goods->children_dosage = $childrenDosage;
        $goods->elderly_dosage = $elderlyDosage;
        $goods->register_info = $registerInfo;
        $goods->data_sources = $dataSources;
        $goods->query_time = $queryTime;
        $goods->interactions = $interactions;
        $goods->pharmacokinetics = $pharmacokinetics;
        $goods->toxicology = $toxicology;
        $goods->clinical_trial = $clinicalTrial;
        $goods->drug_overdose = $drugOverdose;
        $goods->import_number = $importNumber;
        $goods->license_holder = $licenseHolder;
        $goods->license_address = $licenseAddress;
        $goods->import_company = $importCompany;
        $goods->medical_type = $medicalType;
        $goods->submit_scope = $submitScope;
        $goods->gene_scope = !empty($geneScope) ? implode(',', $geneScope) : '';
        $goods->medical_date = $medicalDate;
        $goods->gene_target = !empty($geneTarget) ? implode(',', $geneTarget) : '';
        $goods->send_examine = $sendExamine;
        $goods->charitable_donation = $charitableDonation;
        $goods->clinical_recruitment = $clinicalRecruitment;
        $goods->gene_check = $geneCheck;
        $goods->is_market = $isMarket;
        $goods->market_place = $marketPlace;
        $goods->clinical_stage = $clinicalStage;
        $goods->market_date = $marketDate;
        $goods->drug_properties = $drugProperties;
        $goods->risk = $risk;
        $goods->sort = $sort;
        $goods->enable = $enable;
        $goods->is_hot = $isHot;

        return $goods->save();
    }

    /**
     * 获取全部药厂
     * @param string $search 关键词
     * @return array
     */
    public static function getAllCompany($search)
    {
        if (!$search) return [];

        //获取全部药厂
        $query = new Query();
        return $query->select(['id as companyId', 'company_name as companyName'])
            ->from('ky_company')
            ->where(['enable' => 0, 'is_delete' => 0])
            ->andWhere(['like', 'company_name', $search])
            ->orderBy('id desc')
            ->all();
    }

    /**
     * 根据英文药品名称和规格获取说明书信息
     * @param string $enName 英文药品名称
     * @param string $specs 规格
     * @return array
     */
    public static function getGoodsInstructions($enName, $specs)
    {
        //获取药品信息
        $info = Goods::findInstructionsBySpecs($enName, $specs);

        return ['isExist' => $info ? 1 : 0, 'info' => $info];
    }

    /**
     * 根据药品分类获取临床招募
     * @param int $classId 药品分类id
     * @return array
     */
    public static function getGoodsRecruit($classId)
    {
        //获取药品信息
        $info = Goods::findRecruitByClassId($classId);

        return ['isExist' => $info ? 1 : 0, 'clinicalRecruitment' => $info['clinical_recruitment']];
    }

    /**
     * 根据药品分类同步临床招募
     * @param int $classId 药品分类id
     * @return bool|int
     */
    public static function dealGoodsSyncRecruit($classId)
    {
        //获取药品信息
        $info = Goods::findRecruitByClassId($classId);

        if (!$info) return false;

        return Goods::updateAll(['clinical_recruitment' => $info['clinical_recruitment']], "class_id = {$classId} and clinical_recruitment = '' and is_delete = 0");
    }

    /**
     * 获取分类列表
     * @param int $classId 分类id
     * @return array
     */
    public static function getClassList($classId = 0)
    {
        $list = (new Query())->select(['id',
            'class_name as className',
            'parent_id as parentId',
            'pid_list as pidList',
            'sort',
            'enable'])
            ->from('ky_goods_class')
            ->where(['parent_id' => $classId, 'is_delete' => 0])
            ->orderBy('sort desc,id desc')
            ->all();

        if (empty($list)) {
            return [];
        }

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['pidList'] = $value['pidList'] ? explode(',', $value['pidList']) : [];
                $value['children'] = self::getClassList($value['id']);
            }
        }

        return $list;
    }

    /**
     * 获取可选择的分类列表
     * @param int $currentId 当前分类id
     * @param int $classId 分类id
     * @return array
     */
    public static function getSelectClassList($currentId, $classId = 0)
    {
        $list = (new Query())->select(['id as value', 'class_name as label'])
            ->from('ky_goods_class')
            ->where(['parent_id' => $classId, 'enable' => 0, 'is_delete' => 0])
            ->andWhere(['<>', 'id', $currentId])
            ->orderBy('sort desc,id desc')
            ->all();

        if (empty($list)) {
            return [];
        }

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['children'] = self::getSelectClassList($currentId, $value['value']);
            }
        }

        return $list;
    }

    /**
     * 分类操作
     * @param array $pidList 上级分类集合
     * @param string $className 分类名称
     * @param string $sort 排序
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-改变状态
     * @param int $id 分类id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithClass($pidList, $className, $sort, $enable, $operateType, $id)
    {
        if ($operateType != 1) {
            $classInfo = GoodsClass::findByClassId($id);

            if (!$classInfo) Helper::responseError(1054);

            $classInfo->updated = time();

            if ($operateType == 3) {
                $classInfo->is_delete = 1;
                return $classInfo->save();
            }

            if ($operateType == 4) {
                $classInfo->enable = $enable;
                return $classInfo->save();
            }
        } else {
            $classInfo = new GoodsClass();
            $classInfo->created = time();
        }

        $classInfo->class_name = $className;
        $classInfo->parent_id = !empty($pidList) ? end($pidList) : 0;
        $classInfo->pid_list = !empty($pidList) ? implode(',', $pidList) : '';
        $classInfo->sort = $sort;
        $classInfo->enable = $enable;

        return $classInfo->save();
    }

    /**
     * 获取药品服务列表
     * @param string $name 服务名称
     * @param string $enable 状态：0-正常，1-禁用
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getGoodsServerList($name, $enable, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id',
            'name',
            'icon',
            'desc',
            'link_url as linkUrl',
            'sort',
            'enable'])
            ->from('ky_goods_server');

        if ($name) {
            $list->andWhere(['like', 'name', $name]);
        }

        if ($enable !== '') {
            $list->andWhere(['enable' => $enable]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 药品服务操作
     * @param string $name 服务名称
     * @param string $icon 图标
     * @param string $desc 描述
     * @param string $linkUrl 跳转链接
     * @param string $sort 排序
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑，3-改变状态
     * @param int $id 服务id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithGoodsServer($name, $icon, $desc, $linkUrl, $sort, $enable, $operateType, $id)
    {
        if ($operateType != 1) {
            $server = GoodsServer::findByServerId($id);

            if (!$server) Helper::responseError(1051);

            $server->updated = time();

            if ($operateType == 3) {
                $server->enable = $enable;
                return $server->save();
            }
        } else {
            $server = new GoodsServer();
            $server->created = time();
        }

        $server->name = $name;
        $server->icon = $icon;
        $server->desc = $desc;
        $server->link_url = $linkUrl;
        $server->sort = $sort;
        $server->enable = $enable;

        return $server->save();
    }
}
