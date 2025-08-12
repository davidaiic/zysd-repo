<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;
use yii\db\Expression;
use yii\db\Query;

/**
 * 评论模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null content 内容
 * @property mixed|string|null pictures 评论图片
 * @property int|mixed|null comment_id 评论id
 * @property int|mixed|null status 状态：0-待审核，1-审核通过，2-审核失败
 * @property int|mixed|null is_hot 是否热门评论：0-否，1-是
 * @property int|mixed|null sort 排序
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Comment extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_comment}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取评论列表
     * @param int $type 类型：0-所有评论，1-热门评论
     * @param string $keyword 搜索词
     * @param string $sortId 排序id
     * @param array $labelNameList 标签名称列表
     * @param int $offset 起始位置
     * @param int $pageSize 数量
     * @return array
     */
    public static function findCommentList($type, $keyword, $sortId, $labelNameList, $offset, $pageSize)
    {
        $condition = '(comment.status = 0 or comment.status = 1) and comment.comment_id = 0 and comment.is_delete = 0';
        $params = [];

        if ($type == 1) {
            $condition .= ' and comment.is_hot = 1';
        }

        //搜索词
        if ($keyword) {
            $condition .= ' and comment.content like :keyword';
            $params = [':keyword' => '%' . $keyword . '%'];
        }

        //标签筛选
        if (!empty($labelNameList)) {
            $label = '';

            foreach ($labelNameList as $key => $value) {
                $label .= "comment.content like '%" . $value . "%' or ";
            }

            if ($label) {
                $condition .= ' and (' . rtrim($label, ' or ') . ')';
            }
        }

        //排序
        if ($sortId == '1') {
            $orderBy = 'comment.created desc,comment.id desc';
        } else {
            $orderBy = [new Expression('comment.sort = 0,comment.sort asc,comment.created desc,comment.id desc')];
        }

        $query = new Query();
        return $query->select(['comment.id as commentId',
            'user.avatar',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'comment.comment_num as commentNum',
            'FROM_UNIXTIME(comment.created, "%m-%d") as created'])
            ->from('ky_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where($condition)
            ->addParams($params)
            ->orderBy($orderBy)
            ->offset($offset)
            ->limit($pageSize)
            ->all();
    }

    /**
     * 根据评论id获取评论信息
     * @param int $commentId 评论id
     * @return Comment|null
     */
    public static function findByCommentId($commentId)
    {
        return static::findOne(['id' => $commentId]);
    }

    /**
     * 根据评论信息判断是否存在相同的
     * @param int $uid 用户id
     * @param string $content 评论内容
     * @param int $commentId 评论id
     * @return Comment|null
     */
    public static function findSameComment($uid, $content, $commentId)
    {
        return static::findOne(['uid' => $uid, 'content' => $content, 'comment_id' => $commentId]);
    }

    /**
     * 获取评论总数
     */
    public static function findCommentNum()
    {
        return static::find()->where(['comment_id' => 0, 'is_delete' => 0])->count();
    }
}
