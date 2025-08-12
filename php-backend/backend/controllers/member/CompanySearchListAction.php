<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 防伪查询列表
 */
class CompanySearchListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $companyName = Helper::getParam('companyName');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getCompanySearchList($username, $mobile, $companyName, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
