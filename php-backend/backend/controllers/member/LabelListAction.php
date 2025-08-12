<?php

namespace backend\controllers\member;

use backend\components\Helper;
use backend\models\service\MemberService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 标签管理
 */
class LabelListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $name = Helper::getParam('name');
        $isHot = Helper::getParam('isHot');
        $page = Helper::getPage();
        $limit = Helper::getLimit();

        $result = MemberService::getLabelList($name, $isHot, $page, $limit);

        Helper::response(200, $result);
    }
}
