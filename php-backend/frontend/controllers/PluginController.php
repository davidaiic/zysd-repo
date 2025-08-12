<?php

namespace frontend\controllers;

/**
 * 通用接口
 */
class PluginController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 图片上传
             */
            'upload' => [
                'class' => 'frontend\controllers\plugin\UploadAction',
            ],
            /**
             * 内容配置
             */
            'content' => [
                'class' => 'frontend\controllers\plugin\ContentAction',
            ],
            /**
             * 客服信息
             */
            'kefu' => [
                'class' => 'frontend\controllers\plugin\KefuAction',
            ],
            /**
             * 联系我们
             */
            'contact' => [
                'class' => 'frontend\controllers\plugin\ContactAction',
            ],
            /**
             * web链接
             */
            'webUrl' => [
                'class' => 'frontend\controllers\plugin\WebUrlAction',
            ],
            /**
             * app分享
             */
            'appShare' => [
                'class' => 'frontend\controllers\plugin\AppShareAction',
            ],
            /**
             * 关于我们
             */
            'about' => [
                'class' => 'frontend\controllers\plugin\AboutAction',
            ],
            /**
             * 版本更新
             */
            'checkVersion' => [
                'class' => 'frontend\controllers\plugin\CheckVersionAction',
            ],
            /**
             * 更新信息
             */
            'updateInfo' => [
                'class' => 'frontend\controllers\plugin\UpdateInfoAction',
            ],
        ];
    }
}
