<?php

namespace backend\controllers;

/**
 * 首页数据接口
 */
class TransactionController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 统计数据
             */
            'count' => [
                'class' => 'backend\controllers\transaction\CountAction',
            ],
        ];
    }
}
