<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药厂管理
 */
class CompanyListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $companyName = Helper::getParam('companyName');
        $enable = Helper::getParam('enable');
        $hotType = Helper::getParam('hotType');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = ResourceService::getCompanyList($companyName, $enable, $hotType, $page, $limit);

        Helper::response(200, $result);
    }
}
