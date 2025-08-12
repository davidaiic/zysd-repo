<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 扫一扫列表
 */
class ScanLogAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $code = Helper::getParam('code');
        $goodsName = Helper::getParam('goodsName');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getScanLog($username, $mobile, $code, $goodsName, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
