<?php

namespace console\controllers;

use common\components\Tool;
use frontend\models\home\Goods;
use yii\console\Controller;

/**
 * 药品相关任务
 */
class GoodsController extends Controller
{
    /**
     * 药品价格趋势顺延到当前月份
     */
    public function actionTrend()
    {
        //获取有价格趋势的所有药品
        $goodsList = Goods::getGoodsTrendList();

        //当前日期
        $list = Tool::generateDateData(6);

        if ($goodsList) {
            foreach ($goodsList as $key => $value) {
                $priceTrend = $value['price_trend'] ? json_decode($value['price_trend'], true) : [];

                if (!empty($priceTrend)) {
                    $priceTrend['dateList'] = $list['dateList'];

                    $goodsInfo = Goods::findGoodsDetail($value['id']);
                    $goodsInfo->price_trend = json_encode($priceTrend);
                    $goodsInfo->save();
                }
            }
        }
    }
}
