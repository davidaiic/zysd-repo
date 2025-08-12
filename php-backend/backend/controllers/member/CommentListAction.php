<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 评论列表
 */
class CommentListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $status = Helper::getParam('status');
        $isHot = Helper::getParam('isHot');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getCommentList($username, $mobile, $status, $isHot, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
