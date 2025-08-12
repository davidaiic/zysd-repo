<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 所有标签
 */
class AllLabelAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = MemberService::getAllLabelList();

        Helper::response(200, ['list' => $result]);
    }
}
