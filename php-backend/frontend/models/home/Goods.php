<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;
use yii\db\Query;

/**
 * 药品模块
 * @property mixed|string|null goods_name 药品名称
 * @property mixed|string|null en_name 英文药品名称
 * @property mixed|string|null common_name 通用名称
 * @property mixed|string|null other_name 其他名称
 * @property mixed|string|null goods_image 药品图片
 * @property mixed|string|null big_image 药品大图
 * @property int|mixed|null class_id 分类id
 * @property mixed|string|null class_list 分类集合
 * @property mixed|string|null company_id 药厂id
 * @property int|mixed|null money_type 货币类型：0-人民币，1-美金
 * @property mixed|string|null min_price 药品最低价格
 * @property mixed|string|null max_price 药品最高价格
 * @property mixed|string|null min_cost_price 药品月花费最低价格
 * @property mixed|string|null max_cost_price 药品月花费最高价格
 * @property mixed|string|null price_trend 价格趋势
 * @property mixed|string|null specs 规格
 * @property mixed|string|null full_name 全称
 * @property int|mixed|null goods_type 药品类型：1-处方，2-OTC，3-医疗器械
 * @property mixed|string|null number 批准文号
 * @property mixed|string|null period 有效期
 * @property mixed|string|null goods_code 条形码
 * @property mixed|string|null ndc NDC，美国药品上市的准字号
 * @property mixed|string|null ability 功能主治
 * @property mixed|string|null usage_dosage 用法用量
 * @property mixed|string|null indication 适应症
 * @property mixed|string|null reaction 不良反应
 * @property mixed|string|null taboo 禁忌
 * @property mixed|string|null attention 注意事项
 * @property mixed|string|null unit 包装单位
 * @property mixed|string|null composition 主要成份
 * @property mixed|string|null character 性状
 * @property mixed|string|null storage 贮藏
 * @property mixed|string|null standard 执行标准
 * @property mixed|string|null eligibility 适用人群
 * @property mixed|string|null woman_dosage 孕妇及哺乳期妇女用药
 * @property mixed|string|null children_dosage 儿童用药
 * @property mixed|string|null elderly_dosage 老年患者用药
 * @property mixed|null interactions 药物相互作用
 * @property mixed|null pharmacokinetics 药代动力学
 * @property mixed|null toxicology 药理毒理
 * @property mixed|null clinical_trial 临床试验
 * @property mixed|string|null drug_overdose 药物过量
 * @property mixed|null import_number 进口药品注册证号
 * @property mixed|null license_holder 药品上市许可持有人
 * @property mixed|null license_address 药品上市许可持有人地址
 * @property mixed|null import_company 进口分装企业
 * @property mixed|null medical_type 医保类型：0-无，1-甲类，2-乙类
 * @property int|mixed|null submit_scope （乙类）目前医保报销范围：0-无，1-报销仅限基因靶点
 * @property mixed|string|null gene_scope （乙类）基因靶点
 * @property mixed|null medical_date 医保执行时间
 * @property mixed|null gene_target 基因靶点
 * @property mixed|string|null register_info 药品查询注册信息
 * @property mixed|string|null data_sources 数据来源
 * @property mixed|string|null query_time 查询时间
 * @property mixed|null send_examine 我要送检
 * @property mixed|null charitable_donation 慈善赠药
 * @property mixed|null clinical_recruitment 患者临床招募
 * @property mixed|string|null gene_check 基因检测
 * @property mixed|null is_market 是否已上市：0-未上市，1-已上市
 * @property mixed|string|null market_place 上市区域
 * @property mixed|string|null clinical_stage 国内临床阶段
 * @property mixed|null market_date 上市时间
 * @property mixed|null drug_properties 药品属性
 * @property int|mixed|null risk 药品风险等级：0-无，1-高风险
 * @property mixed|string|null sort 排序
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null is_hot 是否热门：0-否，1-是
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Goods extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_goods}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取药品详情
     * @param int $goodsId 药品id
     * @return Goods|null
     */
    public static function findGoodsDetail($goodsId)
    {
        return static::findOne(['id' => $goodsId]);
    }

    /**
     * 根据条形码获取药品详情
     * @param string $code 条形码
     * @return array|ActiveRecord|null
     */
    public static function findInfoByCode($code)
    {
        return static::find()->where(['goods_code' => $code, 'enable' => 0, 'is_delete' => 0])->orderBy('id desc')->limit(1)->one();
    }

    /**
     * 根据药品名称、药厂id获取药品信息
     * @param string $goodsName 药品名称
     * @param int $companyId 药厂id
     * @return array|bool
     */
    public static function findGoodsInfo($goodsName, $companyId)
    {
        $query = new Query();
        return $query->select(['goods.*'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where('(goods.goods_name like :goodsName or goods.en_name like :goodsName or goods.common_name like :goodsName or goods.other_name like :goodsName) and goods.company_id = :companyId and goods.enable = 0 and goods.is_delete = 0')
            ->addParams([':goodsName' => '%' . $goodsName . '%', ':companyId' => $companyId])
            ->orderBy('goods.sort desc,goods.id desc')
            ->limit(1)
            ->one();
    }

    /**
     * 根据药品名称、药厂id、规格获取药品信息
     * @param string $goodsName 药品名称
     * @param int $companyId 药厂id
     * @param string $specs 规格名称
     * @return array|bool
     */
    public static function findGoodsInfoBySpecs($goodsName, $companyId, $specs)
    {
        $condition = '(goods.goods_name like :goodsName or goods.en_name like :goodsName or goods.common_name like :goodsName or goods.other_name like :goodsName) and goods.company_id = :companyId and goods.enable = 0 and goods.is_delete = 0 and goods.min_price > 0';

        if ($specs) {
            $condition .= ' and goods.specs = :specs';
        }

        $query = new Query();
        return $query->select(['goods.*'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where($condition)
            ->addParams([':goodsName' => '%' . $goodsName . '%', ':companyId' => $companyId, ':specs' => $specs])
            ->orderBy('goods.sort desc,goods.id desc')
            ->limit(1)
            ->one();
    }

    /**
     * 根据药品名称、规格获取药品说明书
     * @param string $enName 英文药品名称
     * @param string $specs 规格名称
     * @return array|bool
     */
    public static function findInstructionsBySpecs($enName, $specs)
    {
        $query = new Query();
        return $query->select(['*'])
            ->from('ky_goods')
            ->where('en_name = :enName and is_delete = 0')
            ->addParams([':enName' => $enName])
            ->orderBy('id asc')
            ->limit(1)
            ->one();
    }

    /**
     * 根据药品分类获取临床招募
     * @param int $classId 药品分类id
     * @return array|bool
     */
    public static function findRecruitByClassId($classId)
    {
        $query = new Query();
        return $query->select(['*'])
            ->from('ky_goods')
            ->where('class_id = :classId and clinical_recruitment != "" and is_delete = 0')
            ->addParams([':classId' => $classId])
            ->orderBy('id asc')
            ->limit(1)
            ->one();
    }

    /**
     * 获取药品总数
     */
    public static function findGoodsNum()
    {
        return static::find()->where(['is_delete' => 0])->count();
    }

    /**
     * 获取有价格趋势的所有正常药品
     */
    public static function getGoodsTrendList()
    {
        return static::find()->where(['is_delete' => 0])->andWhere(['<>', 'price_trend', ''])->all();
    }
}
