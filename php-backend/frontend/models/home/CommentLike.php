<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 评论点赞模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null comment_id 评论id
 * @property int|mixed|null created 创建时间
 */
class CommentLike extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_comment_like}}';
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
     * @return CommentLike|null
     */
    public static function findUserLike($commentId, $uid)
    {
        return static::findOne(['comment_id' => $commentId, 'uid' => $uid]);
    }
}
