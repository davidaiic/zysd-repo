<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 资讯热门词操作
 */
class DealArticleWordAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $word = Helper::getParam('word');
        $sort = (int)Helper::getParam('sort');
        $operateType = (int)Helper::getParam('operateType');
        $id = (int)Helper::getParam('id');

        if (($operateType != 1 && !$id) || ($operateType != 3 && !$word)) {
            Helper::response(201);
        }

        $result = MemberService::dealWithArticleWord($word, $sort, $operateType, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
