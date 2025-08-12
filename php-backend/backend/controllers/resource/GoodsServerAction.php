<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药品服务
 */
class GoodsServerAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $enable = Helper::getParam('enable');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = ResourceService::getGoodsServerList($name, $enable, $page, $limit);

        Helper::response(200, $result);
    }
}
