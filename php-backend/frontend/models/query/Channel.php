<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 渠道模块
 * @property mixed|string|null channel_name 渠道名称
 * @property mixed|string|null sort 排序
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Channel extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_channel}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取所有渠道
     * @return array|ActiveRecord
     */
    public static function findAllChannel()
    {
        return static::find()->where(['enable' => 0, 'is_delete' => 0])->orderBy('sort desc,id desc')->all();
    }

    /**
     * 获取渠道信息
     * @param int $channelId 渠道id
     * @return Channel|null
     */
    public static function findByChannelId($channelId)
    {
        return static::findOne(['id' => $channelId]);
    }
}
