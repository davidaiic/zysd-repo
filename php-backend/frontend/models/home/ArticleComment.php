<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 资讯评论模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null article_id 资讯id
 * @property mixed|string|null content 内容
 * @property mixed|string|null pictures 评论图片
 * @property int|mixed|null status 状态：0-待审核，1-审核通过，2-审核失败
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class ArticleComment extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_article_comment}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 根据评论id获取评论信息
     * @param int $commentId 评论id
     * @return ArticleComment|null
     */
    public static function findByCommentId($commentId)
    {
        return static::findOne(['id' => $commentId]);
    }

    /**
     * 根据评论信息判断是否存在相同的
     * @param int $uid 用户id
     * @param int $articleId 资讯id
     * @param string $content 评论内容
     * @return ArticleComment|null
     */
    public static function findSameComment($uid, $articleId, $content)
    {
        return static::findOne(['uid' => $uid, 'article_id' => $articleId, 'content' => $content]);
    }
}
