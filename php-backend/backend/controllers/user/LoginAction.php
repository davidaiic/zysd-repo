<?php

namespace backend\controllers\user;

use backend\components\Helper;
use backend\models\service\UserService;
use common\components\Tool;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 登录
 */
class LoginAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $phone = Helper::getParam('username');
        $password = Helper::getParam('password');

        if (!$phone || !$password) {
            Helper::response(201);
        }

        if (!Tool::checkPhone($phone)) {
            Helper::responseError(1031);
        }

        if (!Tool::checkPassword($password)) {
            Helper::responseError(1029);
        }

        $result = UserService::login($phone, $password);

        if ($result) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
