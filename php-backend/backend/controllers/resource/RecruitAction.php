<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 临床招募
 */
class RecruitAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $classId = (int)Helper::getParam('classId');

        if (!$classId) {
            Helper::responseError(1054);
        }

        $result = ResourceService::getGoodsRecruit($classId);

        Helper::response(200, $result);
    }
}
