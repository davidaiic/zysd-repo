<?php

namespace backend\controllers\resource;

use backend\components\Helper;
use backend\models\service\ResourceService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * 分类管理
 */
class ClassListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $type = (int)Helper::getParam('type');
        $currentId = (int)Helper::getParam('currentId');

        if ($type == 1) {
            $result = ResourceService::getSelectClassList($currentId);//选择用

            if (!empty($result)) {
                array_unshift($result, ['value' => '0', 'label' => '无']);
            }
        } else {
            $result = ResourceService::getClassList();//列表用
        }

        Helper::response(200, ['list' => $result]);
    }
}
