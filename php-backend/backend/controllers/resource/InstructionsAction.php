<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药品说明书
 */
class InstructionsAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $enName = Helper::getParam('enName');
        $specs = Helper::getParam('specs');
        $specs = explode('*', $specs);
        $specs = !empty($specs) && isset($specs[0]) ? $specs[0] : '';

        if (!$enName) {
            Helper::responseError(1042);
        }

//        if (!$specs) {
//            Helper::responseError(1041);
//        }

        $result = ResourceService::getGoodsInstructions($enName, $specs);

        Helper::response(200, $result);
    }
}
