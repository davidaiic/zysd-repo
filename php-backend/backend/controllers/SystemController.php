<?php

namespace backend\controllers;

/**
 * 系统接口
 */
class SystemController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * banner管理
             */
            'banner' => [
                'class' => 'backend\controllers\system\BannerAction',
            ],
            /**
             * banner操作
             */
            'dealBanner' => [
                'class' => 'backend\controllers\system\DealBannerAction',
            ],
            /**
             * 文案列表
             */
            'explain' => [
                'class' => 'backend\controllers\system\ExplainAction',
            ],
            /**
             * 文案操作
             */
            'dealExplain' => [
                'class' => 'backend\controllers\system\DealExplainAction',
            ],
            /**
             * app版本列表
             */
            'appVersion' => [
                'class' => 'backend\controllers\system\AppVersionAction',
            ],
            /**
             * app版本操作
             */
            'dealAppVersion' => [
                'class' => 'backend\controllers\system\DealAppVersionAction',
            ],
            /**
             * 公共配置
             */
            'commonSetting' => [
                'class' => 'backend\controllers\system\CommonSettingAction',
            ],
            /**
             * 处理公共配置
             */
            'dealCommonSetting' => [
                'class' => 'backend\controllers\system\DealCommonSettingAction',
            ],
            /**
             * 意见反馈
             */
            'feedback' => [
                'class' => 'backend\controllers\system\FeedbackAction',
            ],
            /**
             * web链接管理
             */
            'webUrl' => [
                'class' => 'backend\controllers\system\WebUrlAction',
            ],
            /**
             * web链接操作
             */
            'dealWebUrl' => [
                'class' => 'backend\controllers\system\DealWebUrlAction',
            ],
        ];
    }
}
