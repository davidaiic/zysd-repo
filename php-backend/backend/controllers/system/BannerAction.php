<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * banner管理
 */
class BannerAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $type = Helper::getParam('type');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = SystemService::getBannerList($name, $type, $page, $limit);

        Helper::response(200, $result);
    }
}
