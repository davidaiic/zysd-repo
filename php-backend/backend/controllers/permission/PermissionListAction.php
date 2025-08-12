<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 权限列表
 */
class PermissionListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $menuName = Helper::getParam('menuName');
        $name = Helper::getParam('name');
        $alias = Helper::getParam('alias');
        $route = Helper::getParam('route');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = PermissionService::getPermissionsList($menuName, $name, $alias, $route, $page, $limit);

        Helper::response(200, $result);
    }
}
