<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯热门词管理
 */
class ArticleWordListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $word = Helper::getParam('word');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getArticleWordList($word, $page, $limit);

        Helper::response(200, $result);
    }
}
