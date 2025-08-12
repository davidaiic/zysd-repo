<?php

namespace backend\controllers;

/**
 * 权限接口
 */
class PermissionController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 全部权限
             */
            'permissionAll' => [
                'class' => 'backend\controllers\permission\PermissionAllAction',
            ],
            /**
             * 全部角色
             */
            'roleAll' => [
                'class' => 'backend\controllers\permission\RoleAllAction',
            ],
            /**
             * 用户列表
             */
            'userList' => [
                'class' => 'backend\controllers\permission\UserListAction',
            ],
            /**
             * 角色列表
             */
            'roleList' => [
                'class' => 'backend\controllers\permission\RoleListAction',
            ],
            /**
             * 权限列表
             */
            'permissionList' => [
                'class' => 'backend\controllers\permission\PermissionListAction',
            ],
            /**
             * 菜单列表
             */
            'menuList' => [
                'class' => 'backend\controllers\permission\MenuListAction',
            ],
            /**
             * 权限操作
             */
            'dealPermission' => [
                'class' => 'backend\controllers\permission\DealPermissionAction',
            ],
            /**
             * 角色操作
             */
            'dealRole' => [
                'class' => 'backend\controllers\permission\DealRoleAction',
            ],
            /**
             * 配置权限列表
             */
            'permissionDeploy' => [
                'class' => 'backend\controllers\permission\PermissionDeployAction',
            ],
            /**
             * 保存配置权限
             */
            'keepDeploy' => [
                'class' => 'backend\controllers\permission\KeepDeployAction',
            ],
            /**
             * 用户操作
             */
            'setRole' => [
                'class' => 'backend\controllers\permission\SetRoleAction',
            ],
        ];
    }
}
