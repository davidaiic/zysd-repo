<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 搜索列表
 */
class SearchListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $word = Helper::getParam('word');
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getSearchList($word, $beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
