<?php

namespace backend\controllers\transaction;

use backend\components\Helper;
use backend\models\service\TransactionService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 统计数据
 */
class CountAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = TransactionService::getCountInfo();

        Helper::response(200, ['info' => $result]);
    }
}
