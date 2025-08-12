<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * app版本列表
 */
class AppVersionAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $platform = Helper::getParam('platform');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = SystemService::getAppVersionList($platform, $page, $limit);

        Helper::response(200, $result);
    }
}
