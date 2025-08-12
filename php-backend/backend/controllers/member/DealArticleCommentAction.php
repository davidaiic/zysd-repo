<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯评论操作
 */
class DealArticleCommentAction extends Action
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

        $result = MemberService::dealWithArticleComment($commentId, $value, $type);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
