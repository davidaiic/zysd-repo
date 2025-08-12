<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use common\components\Tool;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 短信提示
 */
class SmsTipAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $mobile = Helper::getParam('mobile');
        $smsText = Helper::getParam('smsText');

        if (!$mobile) {
            Helper::responseError(1005);
        }

        if (!Tool::checkPhone($mobile)) {
            Helper::responseError(1031);
        }

        if (!$smsText) {
            Helper::responseError(1009);
        }

        $result = MemberService::sendSmsTip($mobile, $smsText);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
