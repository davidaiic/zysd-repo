<?php

namespace frontend\controllers;

/**
 * 用户接口
 */
class UserController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 获取小程序openid
             */
            'getOpenid' => [
                'class' => 'frontend\controllers\user\GetOpenidAction',
            ],
            /**
             * 获取小程序手机号
             */
            'getPhone' => [
                'class' => 'frontend\controllers\user\GetPhoneAction',
            ],
            /**
             * 新版获取小程序手机号
             */
            'getUserPhone' => [
                'class' => 'frontend\controllers\user\GetUserPhoneAction',
            ],
            /**
             * 小程序注册
             */
            'register' => [
                'class' => 'frontend\controllers\user\RegisterAction',
            ],
            /**
             * 生成小程序码
             */
            'createWxQRCode' => [
                'class' => 'frontend\controllers\user\CreateWxQRCodeAction',
            ],
            /**
             * 个人主页
             */
            'center' => [
                'class' => 'frontend\controllers\user\CenterAction',
            ],
            /**
             * 查询历史
             */
            'queryLog' => [
                'class' => 'frontend\controllers\user\QueryLogAction',
            ],
            /**
             * 查询详情
             */
            'queryInfo' => [
                'class' => 'frontend\controllers\user\QueryInfoAction',
            ],
            /**
             * 创建分享码
             */
            'createShare' => [
                'class' => 'frontend\controllers\user\CreateShareAction',
            ],
            /**
             * 分享码信息
             */
            'shareInfo' => [
                'class' => 'frontend\controllers\user\ShareInfoAction',
            ],
            /**
             * 用户列表
             */
            'userList' => [
                'class' => 'frontend\controllers\user\UserListAction',
            ],
            /**
             * 邀请人信息
             */
            'inviteInfo' => [
                'class' => 'frontend\controllers\user\InviteInfoAction',
            ],
            /**
             * 意见反馈
             */
            'feedback' => [
                'class' => 'frontend\controllers\user\FeedbackAction',
            ],
            /**
             * 移动一键登录
             */
            'oneLogin' => [
                'class' => 'frontend\controllers\user\OneLoginAction',
            ],
            /**
             * 更换头像
             */
            'updateAvatar' => [
                'class' => 'frontend\controllers\user\UpdateAvatarAction',
            ],
            /**
             * 更新信息
             */
            'updateInfo' => [
                'class' => 'frontend\controllers\user\UpdateInfoAction',
            ],
            /**
             * 发送验证码
             */
            'sendSms' => [
                'class' => 'frontend\controllers\user\SendSmsAction',
            ],
            /**
             * 验证码登录
             */
            'smsLogin' => [
                'class' => 'frontend\controllers\user\SmsLoginAction',
            ],
            /**
             * 退出登录
             */
            'logout' => [
                'class' => 'frontend\controllers\user\LogoutAction',
            ],
        ];
    }
}
