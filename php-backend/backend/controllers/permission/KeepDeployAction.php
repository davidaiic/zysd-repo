<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 保存配置权限
 */
class KeepDeployAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $roleId = (int)Helper::getParam('roleId');
        $perIdList = Helper::getParam('perIdList');
        $perIdArr = json_decode($perIdList, true);

        if (!$roleId) {
            Helper::response(201);
        }

        if (empty($perIdArr)) {
            Helper::responseError(1028);
        }

        $result = PermissionService::getKeepDeploy($roleId, $perIdArr);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
