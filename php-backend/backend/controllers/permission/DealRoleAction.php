<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 角色操作
 */
class DealRoleAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $roleName = Helper::getParam('roleName');
        $alias = Helper::getParam('alias');
        $note = Helper::getParam('note');
        $type = (int)Helper::getParam('type');
        $roleId = (int)Helper::getParam('roleId');

        if (($type != 1 && !$roleId) || ($type != 3 && !$roleName)) {
            Helper::response(201);
        }

        $result = PermissionService::dealWithRole($roleName, $alias, $note, $type, $roleId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
