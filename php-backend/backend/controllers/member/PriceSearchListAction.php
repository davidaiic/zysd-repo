<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 价格查询列表
 */
class PriceSearchListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $username = Helper::getParam('username');
        $mobile = Helper::getParam('mobile');
        $goodsName = Helper::getParam('goodsName');
        $searchResult = Helper::getParam('searchResult');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getPriceSearchList($username, $mobile, $goodsName, $searchResult, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
