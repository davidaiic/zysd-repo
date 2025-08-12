<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 标签模块
 * @property mixed|string|null name 标签名称
 * @property mixed|string|null sort 排序
 * @property int|mixed|null is_hot 是否热门：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Label extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_label}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取标签信息
     * @param int $id 标签id
     * @return Label|null
     */
    public static function findByLabelId($id)
    {
        return static::findOne(['id' => $id]);
    }
}
