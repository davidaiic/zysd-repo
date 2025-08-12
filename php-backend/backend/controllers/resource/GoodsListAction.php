<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药品管理
 */
class GoodsListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $goodsName = Helper::getParam('goodsName');
        $enName = Helper::getParam('enName');
        $specs = Helper::getParam('specs');
        $companyName = Helper::getParam('companyName');
        $classList = Helper::getParam('classList');
        $number = Helper::getParam('number');
        $enable = Helper::getParam('enable');
        $isHot = Helper::getParam('isHot');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = ResourceService::getGoodsList($goodsName, $enName, $specs, $companyName, $classList, $number, $enable, $isHot, $page, $limit);

        Helper::response(200, $result);
    }
}
