<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * app版本操作
 */
class DealAppVersionAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $platform = (int)Helper::getParam('platform');
        $version_number = Helper::getParam('version_number');
        $version_code = Helper::getParam('version_code');
        $download_url = Helper::getParam('download_url');
        $is_must = (int)Helper::getParam('is_must');
        $content = Helper::getParam('content');
        $status = (int)Helper::getParam('status');
        $type = (int)Helper::getParam('type');
        $id = (int)Helper::getParam('id');

        if (($type != 1 && !$id) || ($type != 3 && (!$version_number || !$download_url || !$content))) {
            Helper::response(201);
        }

        $result = SystemService::dealWithAppVersion($platform, $version_number, $version_code, $download_url, $is_must, $content, $status, $type, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
