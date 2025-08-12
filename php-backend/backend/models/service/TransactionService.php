<?php

namespace backend\models\service;

use frontend\models\home\Comment;
use frontend\models\home\Goods;
use frontend\models\user\QueryLog;
use frontend\models\user\User;

/**
 * 首页数据
 */
class TransactionService
{
    /**
     * 获取统计数据
     * @return array
     */
    public static function getCountInfo()
    {
        //获取用户总数
        $userNum = User::findUserNum();

        //获取评论总数
        $commentNum = Comment::findCommentNum();

        //获取查询数
        $queryNum = QueryLog::findQueryLogNum();

        //获取药品数
        $goodsNum = Goods::findGoodsNum();

        return [
            'userNum'    => intval($userNum),
            'commentNum' => intval($commentNum),
            'queryNum'   => intval($queryNum),
            'goodsNum'   => intval($goodsNum)
        ];
    }
}
