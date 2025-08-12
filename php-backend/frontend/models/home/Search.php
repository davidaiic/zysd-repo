<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 搜索记录模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null word 搜索词
 * @property int|mixed|null created 创建时间
 */
class Search extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_search}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }
}
