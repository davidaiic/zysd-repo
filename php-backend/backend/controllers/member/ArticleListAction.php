<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯管理
 */
class ArticleListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $title = Helper::getParam('title');
        $publishDate = Helper::getParam('publishDate');
        $label = Helper::getParam('label');
        $isTop = Helper::getParam('isTop');
        $enable = Helper::getParam('enable');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getArticleList($title, $publishDate, $label, $isTop, $enable, $page, $limit);

        Helper::response(200, $result);
    }
}
