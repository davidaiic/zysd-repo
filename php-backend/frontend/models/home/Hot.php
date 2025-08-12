<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 热门搜索模块
 * @property mixed|string|null word 搜索词
 * @property int|mixed|null search_num 搜索次数
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Hot extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_hot}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取搜索词统计信息
     * @param string $keyword 搜索词
     * @return Hot|null
     */
    public static function findByKeyword($keyword)
    {
        return static::findOne(['word' => $keyword]);
    }
}
