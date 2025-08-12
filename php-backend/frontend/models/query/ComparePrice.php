<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 比价模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null left_goods_name 左边药品名称
 * @property int|mixed|null left_company_id 左边药厂id
 * @property mixed|string|null left_specs 左边规格名称
 * @property mixed|null left_goods_id 左边药品id
 * @property mixed|string|null right_goods_name 右边药品名称
 * @property int|mixed|null right_company_id 右边药厂id
 * @property mixed|string|null right_specs 右边规格名称
 * @property mixed|null right_goods_id 右边药品id
 * @property int|mixed|null created 创建时间
 */
class ComparePrice extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_compare_price}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 统计查询次数
     */
    public static function findTotalNum()
    {
        return static::find()->count();
    }
}
