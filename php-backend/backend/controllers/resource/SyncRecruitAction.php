<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 同步临床招募
 */
class SyncRecruitAction extends Action
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

        $result = ResourceService::dealGoodsSyncRecruit($classId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
