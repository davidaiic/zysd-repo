<?php

namespace backend\controllers\user;

use backend\components\Helper;
use backend\models\service\UserService;
use common\components\Tool;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 修改密码
 */
class ChangePasswordAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $password = Helper::getParam('password');
        $confirmPassword = Helper::getParam('confirmPassword');

        if (!$password || !$confirmPassword) {
            Helper::response(201);
        }

        if (!Tool::checkPassword($password)) {
            Helper::responseError(1029);
        }

        if ($password !== $confirmPassword) {
            Helper::responseError(1030);
        }

        $result = UserService::changePassword($uid, $password);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
