<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 标签操作
 */
class DealLabelAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $sort = (int)Helper::getParam('sort');
        $isHot = (int)Helper::getParam('isHot');
        $operateType = (int)Helper::getParam('operateType');
        $id = (int)Helper::getParam('id');

        if (($operateType != 1 && !$id) || ($operateType != 3 && $operateType != 4 && !$name)) {
            Helper::response(201);
        }

        $result = MemberService::dealWithLabel($name, $sort, $isHot, $operateType, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
