<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 渠道管理
 */
class ChannelListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $channelName = Helper::getParam('channelName');
        $enable = Helper::getParam('enable');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = ResourceService::getChannelList($channelName, $enable, $page, $limit);

        Helper::response(200, $result);
    }
}
