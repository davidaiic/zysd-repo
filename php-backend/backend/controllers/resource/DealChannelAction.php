<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 渠道操作
 */
class DealChannelAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $channelName = Helper::getParam('channelName');
        $sort = (int)Helper::getParam('sort');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $channelId = (int)Helper::getParam('channelId');

        if (($operateType != 1 && !$channelId) || ($operateType != 3 && $operateType != 4 && !$channelName)) {
            Helper::response(201);
        }

        $result = ResourceService::dealWithChannel($channelName, $sort, $enable, $operateType, $channelId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
