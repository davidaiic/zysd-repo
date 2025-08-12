<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * 价格查询模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null goods_name 药品名称
 * @property mixed|string|null price 药品价格
 * @property int|mixed|null company_id 药厂id
 * @property int|mixed|null channel_id 渠道id
 * @property mixed|null goods_id 药品id
 * @property int|mixed|null created 创建时间
 */
class PriceSearch extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_price_search}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取价格查询信息
     * @param int $id 记录id
     * @return PriceSearch|null
     */
    public static function findPriceSearchInfo($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 统计查询次数
     */
    public static function findTotalNum()
    {
        return static::find()->count();
    }

    /**
     * 获取当天查询次数
     */
    public static function findTodayNum()
    {
        return static::find()->where(new Expression("FROM_UNIXTIME(created, '%Y-%m-%d') = curdate()"))->count();
    }
}
