<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * web链接管理
 */
class WebUrlAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $title = Helper::getParam('title');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = SystemService::getWebUrlList($title, $page, $limit);

        Helper::response(200, $result);
    }
}
