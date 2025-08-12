<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 资讯点赞模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null article_id 资讯id
 * @property int|mixed|null created 创建时间
 */
class ArticleLike extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_article_like}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取用户点赞记录
     * @param int $articleId 资讯id
     * @param int $uid 用户id
     * @return ArticleLike|null
     */
    public static function findUserLike($articleId, $uid)
    {
        return static::findOne(['article_id' => $articleId, 'uid' => $uid]);
    }
}
