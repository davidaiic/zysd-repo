<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 资讯评论点赞模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null article_comment_id 资讯评论id
 * @property int|mixed|null created 创建时间
 */
class ArticleCommentLike extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_article_comment_like}}';
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
     * @param int $commentId 评论id
     * @param int $uid 用户id
     * @return ArticleCommentLike|null
     */
    public static function findUserLike($commentId, $uid)
    {
        return static::findOne(['article_comment_id' => $commentId, 'uid' => $uid]);
    }
}
