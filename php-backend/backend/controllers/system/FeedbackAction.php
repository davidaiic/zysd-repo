<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 意见反馈
 */
class FeedbackAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $beginDate = Helper::getParam('beginDate');
        $endDate = Helper::getParam('endDate');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = SystemService::getFeedbackList($beginDate, $endDate, $page, $limit);

        Helper::response(200, $result);
    }
}
