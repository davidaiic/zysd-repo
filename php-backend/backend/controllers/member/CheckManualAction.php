<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 核查操作
 */
class CheckManualAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $photoId = (int)Helper::getParam('photoId');
        $status = (int)Helper::getParam('status');
        $smsText = Helper::getParam('smsText');
        $goodsName = Helper::getParam('goodsName');
        $companyName = Helper::getParam('companyName');
        $smsText = $smsText ? $smsText : '';

        if (!$photoId) {
            Helper::response(201);
        }

        if ($status == 1 && !$goodsName) {
            Helper::responseError(1015);
        }

        if ($status == 1 && !$companyName) {
            Helper::responseError(1039);
        }

        $result = MemberService::checkManualSearch($photoId, $status, $smsText, $goodsName, $companyName);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
