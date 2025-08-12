<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 评论操作
 */
class DealCommentAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $commentId = (int)Helper::getParam('commentId');
        $value = (int)Helper::getParam('value');
        $type = (int)Helper::getParam('type');

        if (!$commentId) {
            Helper::response(201);
        }

        $result = MemberService::dealWithComment($commentId, $value, $type);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
