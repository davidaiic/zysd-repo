<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 用户列表
 */
class UserListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $roleId = (int)Helper::getParam('roleId');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = PermissionService::getUserList($username, $roleId, $page, $limit);

        Helper::response(200, $result);
    }
}
