<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 药品服务操作
 */
class DealGoodsServerAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $icon = Helper::getParam('icon');
        $desc = Helper::getParam('desc');
        $linkUrl = Helper::getParam('linkUrl');
        $sort = (int)Helper::getParam('sort');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $id = (int)Helper::getParam('id');

        if (($operateType != 1 && !$id) || ($operateType != 3 && (!$name || !$icon || !$desc || !$linkUrl))) {
            Helper::response(201);
        }

        $result = ResourceService::dealWithGoodsServer($name, $icon, $desc, $linkUrl, $sort, $enable, $operateType, $id);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
