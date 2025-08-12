<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 公共配置
 */
class CommonSettingAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = SystemService::getCommonSetting();

        Helper::response(200, ['list' => $result]);
    }
}
