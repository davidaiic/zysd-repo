<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;
use yii\db\Expression;

/**
 * 照片查询模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null positive 正面
 * @property mixed|string|null left_side 左侧面
 * @property mixed|string|null right_side 右侧面
 * @property mixed|string|null back 背面
 * @property mixed|string|null other 其余照片
 * @property mixed|string|null mobile 手机号
 * @property int|mixed|null status 状态：0-待核查，1-核查通过，2-核查失败
 * @property mixed|string|null sms_text 短信内容
 * @property int|mixed|null is_sms 是否发送短信：0-否，1-是
 * @property mixed|string|null goods_name 药品名称
 * @property mixed|string|null company_name 药厂名称
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Photo extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_photo}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取照片查询信息
     * @param int $id 记录id
     * @return Photo|null
     */
    public static function findPhotoInfo($id)
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
