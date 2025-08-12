<?php

namespace backend\controllers;

/**
 * 用户接口
 */
class UserController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 登录
             */
            'login' => [
                'class' => 'backend\controllers\user\LoginAction',
            ],
            /**
             * 退出登录
             */
            'signOut' => [
                'class' => 'backend\controllers\user\SignOutAction',
            ],
            /**
             * 用户信息
             */
            'userInfo' => [
                'class' => 'backend\controllers\user\UserInfoAction',
            ],
            /**
             * 修改密码
             */
            'changePassword' => [
                'class' => 'backend\controllers\user\ChangePasswordAction',
            ],
        ];
    }
}
