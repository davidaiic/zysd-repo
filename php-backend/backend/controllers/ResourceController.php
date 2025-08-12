<?php

namespace backend\controllers;

/**
 * 资料接口
 */
class ResourceController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 药厂管理
             */
            'companyList' => [
                'class' => 'backend\controllers\resource\CompanyListAction',
            ],
            /**
             * 药厂操作
             */
            'dealCompany' => [
                'class' => 'backend\controllers\resource\DealCompanyAction',
            ],
            /**
             * 渠道管理
             */
            'channelList' => [
                'class' => 'backend\controllers\resource\ChannelListAction',
            ],
            /**
             * 渠道操作
             */
            'dealChannel' => [
                'class' => 'backend\controllers\resource\DealChannelAction',
            ],
            /**
             * 药品管理
             */
            'goodsList' => [
                'class' => 'backend\controllers\resource\GoodsListAction',
            ],
            /**
             * 药品操作
             */
            'dealGoods' => [
                'class' => 'backend\controllers\resource\DealGoodsAction',
            ],
            /**
             * 全部药厂
             */
            'allCompany' => [
                'class' => 'backend\controllers\resource\AllCompanyAction',
            ],
            /**
             * 药品说明书
             */
            'instructions' => [
                'class' => 'backend\controllers\resource\InstructionsAction',
            ],
            /**
             * 临床招募
             */
            'recruit' => [
                'class' => 'backend\controllers\resource\RecruitAction',
            ],
            /**
             * 同步临床招募
             */
            'syncRecruit' => [
                'class' => 'backend\controllers\resource\SyncRecruitAction',
            ],
            /**
             * 分类管理
             */
            'classList' => [
                'class' => 'backend\controllers\resource\ClassListAction',
            ],
            /**
             * 分类操作
             */
            'dealClass' => [
                'class' => 'backend\controllers\resource\DealClassAction',
            ],
            /**
             * 药品服务
             */
            'goodsServer' => [
                'class' => 'backend\controllers\resource\GoodsServerAction',
            ],
            /**
             * 药品服务操作
             */
            'dealGoodsServer' => [
                'class' => 'backend\controllers\resource\DealGoodsServerAction',
            ],
        ];
    }
}
