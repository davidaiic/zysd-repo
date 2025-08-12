<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 全部角色
 */
class RoleAllAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $roleName = Helper::getParam('roleName');

        $result = PermissionService::getRoleAll($roleName);

        Helper::response(200, ['roleList' => $result]);
    }
}
