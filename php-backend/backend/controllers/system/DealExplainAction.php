<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 文案操作
 */
class DealExplainAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Helper::getParam('keyword');
        $title = Helper::getParam('title');
        $content = Helper::getParam('content');
        $enable = (int)Helper::getParam('enable');
        $remark = Helper::getParam('remark');
        $type = (int)Helper::getParam('type');
        $explainId = (int)Helper::getParam('explainId');

        if (($type != 1 && !$explainId) || ($type != 3 && $type != 4 && (!$keyword || !$title || !$content))) {
            Helper::response(201);
        }

        $result = SystemService::dealWithExplain($keyword, $title, $content, $enable, $remark, $type, $explainId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
