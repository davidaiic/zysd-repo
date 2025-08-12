<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * web链接操作
 */
class DealWebUrlAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $title = Helper::getParam('title');
        $keyword = Helper::getParam('keyword');
        $linkUrl = Helper::getParam('linkUrl');
        $operateType = (int)Helper::getParam('operateType');
        $id = (int)Helper::getParam('id');

        if (($operateType != 1 && !$id) || !$title || !$keyword || !$linkUrl) {
            Helper::response(201);
        }

        $result = SystemService::dealWithWebUrl($title, $keyword, $linkUrl, $operateType, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
