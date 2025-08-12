<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * 药厂查询模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null company_id 药厂id
 * @property mixed|string|null code 防伪码
 * @property bool|mixed|string|null content 查询内容
 * @property int|mixed|null result 查询结果：0-无法识别，1-真，2-假
 * @property int|mixed|null created 创建时间
 */
class CompanySearch extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_company_search}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取药厂查询信息
     * @param int $id 记录id
     * @return CompanySearch|null
     */
    public static function findCompanySearchInfo($id)
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
