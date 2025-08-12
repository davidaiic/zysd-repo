<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 资讯热门词模块
 * @property mixed|string|null word 热门词
 * @property mixed|string|null sort 排序
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class ArticleWord extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_article_word}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取资讯热门词信息
     * @param int $id 热门词id
     * @return ArticleWord|null
     */
    public static function findByWordId($id)
    {
        return static::findOne(['id' => $id]);
    }
}
