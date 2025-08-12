<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 配置权限列表
 */
class PermissionDeployAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $roleId = (int)Helper::getParam('roleId');

        if (!$roleId) {
            Helper::response(201);
        }

        $result = PermissionService::getPermissionDeploy($roleId);

        Helper::response(200, $result);
    }
}
