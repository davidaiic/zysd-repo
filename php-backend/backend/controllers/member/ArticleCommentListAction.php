<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯评论列表
 */
class ArticleCommentListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $articleId = (int)Helper::getParam('articleId');
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $status = Helper::getParam('status');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        if (!$articleId) {
            Helper::response(201);
        }

        $result = MemberService::getArticleCommentList($articleId, $username, $mobile, $status, $page, $limit);

        Helper::response(200, $result);
    }
}
