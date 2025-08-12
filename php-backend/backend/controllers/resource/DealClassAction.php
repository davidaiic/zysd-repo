<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 分类操作
 */
class DealClassAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $pidList = Helper::getParam('pidList');
        $className = Helper::getParam('className');
        $sort = (int)Helper::getParam('sort');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $id = (int)Helper::getParam('id');

        if (($operateType != 1 && !$id) || ($operateType != 3 && $operateType != 4 && !$className)) {
            Helper::response(201);
        }

        $result = ResourceService::dealWithClass($pidList, $className, $sort, $enable, $operateType, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
