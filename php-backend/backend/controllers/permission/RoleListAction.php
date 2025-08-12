<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 角色列表
 */
class RoleListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $roleName = Helper::getParam('roleName');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = PermissionService::getRoleList($roleName, $page, $limit);

        Helper::response(200, $result);
    }
}
