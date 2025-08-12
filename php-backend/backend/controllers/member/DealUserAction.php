<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 会员操作
 */
class DealUserAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = (int)Helper::getParam('uid');
        $addWx = (int)Helper::getParam('addWx');
        $type = (int)Helper::getParam('type');

        if (!$uid) {
            Helper::response(201);
        }

        $result = MemberService::dealWithUser($uid, $addWx, $type);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
