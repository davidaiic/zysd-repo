<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 全部药厂
 */
class AllCompanyAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $search = Helper::getParam('search');

        $result = ResourceService::getAllCompany($search);

        Helper::response(200, ['list' => $result]);
    }
}
