<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 处理公共配置
 */
class DealCommonSettingAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Helper::getParam('keyword');
        $value = Helper::getParam('value');

        if (!$keyword || !$value) {
            Helper::response(201);
        }

        $result = SystemService::dealWithCommonSetting($keyword, $value);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
