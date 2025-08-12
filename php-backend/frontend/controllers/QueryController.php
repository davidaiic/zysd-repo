<?php

namespace frontend\controllers;

/**
 * 查询接口
 */
class QueryController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 人工核查信息
             */
            'manual' => [
                'class' => 'frontend\controllers\query\ManualAction',
            ],
            /**
             * 照片查询
             */
            'photo' => [
                'class' => 'frontend\controllers\query\PhotoAction',
            ],
            /**
             * 药厂列表
             */
            'companyList' => [
                'class' => 'frontend\controllers\query\CompanyListAction',
            ],
            /**
             * 药厂防伪码查询文案
             */
            'codeQuery' => [
                'class' => 'frontend\controllers\query\CodeQueryAction',
            ],
            /**
             * 药厂查询
             */
            'companySearch' => [
                'class' => 'frontend\controllers\query\CompanySearchAction',
            ],
            /**
             * 价格查询
             */
            'priceSearch' => [
                'class' => 'frontend\controllers\query\PriceSearchAction',
            ],
            /**
             * 渠道列表
             */
            'channelList' => [
                'class' => 'frontend\controllers\query\ChannelListAction',
            ],
            /**
             * 规格列表
             */
            'specList' => [
                'class' => 'frontend\controllers\query\SpecListAction',
            ],
            /**
             * 药品名称列表
             */
            'goodsNameList' => [
                'class' => 'frontend\controllers\query\GoodsNameListAction',
            ],
            /**
             * 图片识别
             */
            'imageRecognition' => [
                'class' => 'frontend\controllers\query\ImageRecognitionAction',
            ],
            /**
             * 提取文字
             */
            'extractText' => [
                'class' => 'frontend\controllers\query\ExtractTextAction',
            ],
            /**
             * 扫一扫
             */
            'scanCode' => [
                'class' => 'frontend\controllers\query\ScanCodeAction',
            ],
            /**
             * 条码识别
             */
            'scanQRCode' => [
                'class' => 'frontend\controllers\query\ScanQRCodeAction',
            ],
            /**
             * 药品服务信息
             */
            'goodsServer' => [
                'class' => 'frontend\controllers\query\GoodsServerAction',
            ],
            /**
             * 药品风险信息
             */
            'goodsRisk' => [
                'class' => 'frontend\controllers\query\GoodsRiskAction',
            ],
            /**
             * 药品专题说明
             */
            'goodsSubject' => [
                'class' => 'frontend\controllers\query\GoodsSubjectAction',
            ],
            /**
             * 说明书信息
             */
            'instructions' => [
                'class' => 'frontend\controllers\query\InstructionsAction',
            ],
            /**
             * 纠错目录
             */
            'errorRecovery' => [
                'class' => 'frontend\controllers\query\ErrorRecoveryAction',
            ],
            /**
             * 热门药厂
             */
            'hotCompany' => [
                'class' => 'frontend\controllers\query\HotCompanyAction',
            ],
            /**
             * 分类列表
             */
            'classList' => [
                'class' => 'frontend\controllers\query\ClassListAction',
            ],
            /**
             * 分类药品
             */
            'classGoods' => [
                'class' => 'frontend\controllers\query\ClassGoodsAction',
            ],
            /**
             * 新版药品名称列表
             */
            'relateGoodsName' => [
                'class' => 'frontend\controllers\query\RelateGoodsNameAction',
            ],
            /**
             * 比价
             */
            'comparePrice' => [
                'class' => 'frontend\controllers\query\ComparePriceAction',
            ],
            /**
             * 药品信息
             */
            'goodsInfo' => [
                'class' => 'frontend\controllers\query\GoodsInfoAction',
            ],
        ];
    }
}
