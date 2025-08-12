<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药厂操作
 */
class DealCompanyAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $companyName = Helper::getParam('companyName');
        $enName = Helper::getParam('enName');
        $companyImage = Helper::getParam('companyImage');
        $codeQuery = Helper::getParam('codeQuery');
        $requestUrl = Helper::getParam('requestUrl');
        $requestMethod = Helper::getParam('requestMethod');
        $element = Helper::getParam('element');
        $resultField = Helper::getParam('resultField');
        $sort = (int)Helper::getParam('sort');
        $hotType = (int)Helper::getParam('hotType');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $companyId = (int)Helper::getParam('companyId');

        if (($operateType != 1 && !$companyId) || ($operateType != 3 && $operateType != 4 && (!$companyName || !$enName || !$companyImage))) {
            Helper::response(201);
        }

        $result = ResourceService::dealWithCompany($companyName, $enName, $companyImage, $codeQuery, $requestUrl, $requestMethod, $element, $resultField, $sort, $hotType, $enable, $operateType, $companyId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
