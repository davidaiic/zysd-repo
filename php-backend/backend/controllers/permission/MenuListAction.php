<?php

namespace backend\controllers\permission;

use backend\components\Helper;
use backend\models\service\PermissionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 菜单列表
 */
class MenuListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = PermissionService::getMenuList();

        Helper::response(200, ['menuList' => $result]);
    }
}
