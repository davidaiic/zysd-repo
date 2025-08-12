<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 用户操作
 */
class SetRoleAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $mobile = Helper::getParam('mobile');
        $username = Helper::getParam('username');
        $roleId = (int)Helper::getParam('roleId');
        $type = (int)Helper::getParam('type');
        $uid = (int)Helper::getParam('uid');

        if (($type != 1 && !$uid) || ($type != 3 && $type != 4 && (!$mobile || !$username || !$roleId))) {
            Helper::response(201);
        }

        $result = PermissionService::dealWithUserInfo($mobile, $username, $roleId, $type, $uid);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
