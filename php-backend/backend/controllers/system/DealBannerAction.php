<?php

namespace backend\controllers\system;

use backend\components\Helper;
use backend\models\service\SystemService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * banner操作
 */
class DealBannerAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $notes = Helper::getParam('notes');
        $imageUrl = Helper::getParam('imageUrl');
        $type = (int)Helper::getParam('type');
        $linkUrl = Helper::getParam('linkUrl');
        $sort = (int)Helper::getParam('sort');
        $text1 = Helper::getParam('text1');
        $text2 = Helper::getParam('text2');
        $enable = (int)Helper::getParam('enable');
        $operateType = (int)Helper::getParam('operateType');
        $bannerId = (int)Helper::getParam('bannerId');

        if (($operateType == 2 && !$bannerId) || !$name || !$imageUrl || ($type == 1 && !$linkUrl)) {
            Helper::response(201);
        }

        $result = SystemService::dealWithBanner($name, $notes, $imageUrl, $type, $linkUrl, $sort, $text1, $text2, $enable, $operateType, $bannerId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
