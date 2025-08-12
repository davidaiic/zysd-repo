<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯操作
 */
class DealArticleAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $title = Helper::getParam('title');
        $cover = Helper::getParam('cover');
        $publishDate = Helper::getParam('publishDate');
        $label = Helper::getParam('label');
        $content = Helper::getParam('content');
        $isTop = (int)Helper::getParam('isTop');
        $sort = (int)Helper::getParam('sort');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $articleId = (int)Helper::getParam('articleId');

        if (($operateType != 1 && !$articleId) || ($operateType != 3 && $operateType != 4 && $operateType != 5 && !$title)) {
            Helper::response(201);
        }

        $result = MemberService::dealWithArticle($title, $cover, $publishDate, $label, $content, $isTop, $sort, $enable, $operateType, $articleId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
