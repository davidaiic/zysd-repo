<?php

namespace backend\controllers\user;

use backend\components\Helper;
use backend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 用户信息
 */
class UserInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();

        $result = UserService::getUserInfo($uid);

        Helper::response(200, $result);
    }
}
