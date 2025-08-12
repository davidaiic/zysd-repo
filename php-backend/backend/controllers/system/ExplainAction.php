<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 文案列表
 */
class ExplainAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Helper::getParam('keyword');
        $title = Helper::getParam('title');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = SystemService::getExplainList($keyword, $title, $page, $limit);

        Helper::response(200, $result);
    }
}
