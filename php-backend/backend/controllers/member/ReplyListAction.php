<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 回复列表
 */
class ReplyListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $commentId = (int)Helper::getParam('commentId');
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $status = Helper::getParam('status');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        if (!$commentId) {
            Helper::response(201);
        }

        $result = MemberService::getReplyList($commentId, $username, $mobile, $status, $page, $limit);

        Helper::response(200, $result);
    }
}
