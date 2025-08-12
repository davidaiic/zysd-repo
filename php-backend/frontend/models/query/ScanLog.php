<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 扫一扫记录模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null code 条形码
 * @property int|mixed|null goods_id 药品id
 * @property mixed|string|null goods_name 药品名称
 * @property int|mixed|null company_id 药厂id
 * @property mixed|string|null company_name 药厂名称
 * @property int|mixed|null risk 药品风险等级：0-无，1-高风险
 * @property mixed|string|null server_name 跳转页面标题
 * @property mixed|string|null link_url 跳转链接
 * @property int|mixed|null created 创建时间
 */
class ScanLog extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_scan_log}}';
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
