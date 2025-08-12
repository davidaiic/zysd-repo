<?php

namespace backend\controllers\user;

use backend\components\Helper;
use backend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 退出登录
 */
class SignOutAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $token = Helper::getToken();

        $result = UserService::deleteToken($token);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
