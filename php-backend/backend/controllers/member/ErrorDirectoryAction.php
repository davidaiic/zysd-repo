<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 纠错类目
 */
class ErrorDirectoryAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $goodsName = Helper::getParam('goodsName');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getErrorDirectoryList($username, $mobile, $goodsName, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
