<?php

namespace frontend\models\user;

use yii\db\ActiveRecord;

/**
 * 查询记录模块
 * @property mixed|null uid 用户id
 * @property mixed|string|null goods_name 药品名称
 * @property mixed|string|null company_name 药厂名称
 * @property int|mixed|null type 查询类型：1-人工核查，2-自助查询，3-价格查询
 * @property int|mixed|null relate_id 关联id
 * @property int|mixed|null created 创建时间
 */
class QueryLog extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_query_log}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取用户查询详情
     * @param int $uid 用户id
     * @param int $logId 记录id
     * @return QueryLog|null
     */
    public static function findUserQueryInfo($uid, $logId)
    {
        return static::findOne(['id' => $logId, 'uid' => $uid]);
    }

    /**
     * 获取查询总数
     */
    public static function findQueryLogNum()
    {
        return static::find()->count();
    }
}
