<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 权限操作
 */
class DealPermissionAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $menuId = (int)Helper::getParam('menuId');
        $name = Helper::getParam('name');
        $alias = Helper::getParam('alias');
        $route = Helper::getParam('route');
        $icon = Helper::getParam('icon');
        $isMenu = (int)Helper::getParam('isMenu');
        $sort = (int)Helper::getParam('sort');
        $type = (int)Helper::getParam('type');
        $perId = (int)Helper::getParam('perId');

        if (!$name || !$route || !$type || ($type == 2 && !$perId)) {
            Helper::response(201);
        }

        $result = PermissionService::dealWithPermission($menuId, $name, $alias, $route, $icon, $isMenu, $sort, $type, $perId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
