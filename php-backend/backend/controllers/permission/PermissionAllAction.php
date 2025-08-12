<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 全部权限
 */
class PermissionAllAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = PermissionService::getPermissionAll();

        Helper::response(200, $result);
    }
}
