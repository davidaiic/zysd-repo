<?php

namespace frontend\controllers\query;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 价格查询
 * @description 价格查询接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/priceSearch
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsName 必选 string 药品名称
 * @param companyId 必选 int 药厂id
 * @param specs 必选 string 规格名称
 * @param price 必选 string 药品价格
 * @param channelId 必选 int 渠道id
 * @param goodsId 否 int 传过来的药品id
 * @return {"code": 200,"message": "请求成功","data": {"goodsInfo": {"goodsId": 1,"goodsName": "克唑替尼","goodsImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230103/1672727222.jpg","minPrice": "350.00","maxPrice": "700.00","minCostPrice": "350.00","maxCostPrice": "700.00","compareText": "偏低","priceTrend": [],"specs": "250mg*30片","fullName": "吉非替尼，易瑞沙，Gefit","usageDosage": "","indication": ""},"rank": 212,"total": 2222}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.goodsInfo object 药品信息
 * @return_param data.goodsInfo.goodsId int 药品id
 * @return_param data.goodsInfo.goodsName string 药品名称
 * @return_param data.goodsInfo.enName string 英文药品名称
 * @return_param data.goodsInfo.commonName string 通用名称
 * @return_param data.goodsInfo.otherName string 其他名称
 * @return_param data.goodsInfo.goodsImage string 药品图片
 * @return_param data.goodsInfo.bigImage array 药品大图
 * @return_param data.goodsInfo.companyName string 药厂名称
 * @return_param data.goodsInfo.minPrice string 药品最低价格
 * @return_param data.goodsInfo.maxPrice string 药品最高价格
 * @return_param data.goodsInfo.minCostPrice string 药品月花费最低价格
 * @return_param data.goodsInfo.maxCostPrice string 药品月花费最高价格
 * @return_param data.goodsInfo.compareText string 价格比较文案
 * @return_param data.goodsInfo.priceTrend object 价格趋势
 * @return_param data.goodsInfo.priceTrend.dateList array 日期列表
 * @return_param data.goodsInfo.priceTrend.priceList array 价格列表
 * @return_param data.goodsInfo.specs string 规格
 * @return_param data.goodsInfo.number string 批准文号
 * @return_param data.goodsInfo.period string 有效期
 * @return_param data.goodsInfo.usageDosage string 用法用量
 * @return_param data.goodsInfo.indication string 适应症
 * @return_param data.goodsInfo.reaction string 不良反应
 * @return_param data.goodsInfo.taboo string 禁忌
 * @return_param data.goodsInfo.attention string 注意事项
 * @return_param data.goodsInfo.unit string 包装单位
 * @return_param data.goodsInfo.composition string 主要成份
 * @return_param data.goodsInfo.character string 性状
 * @return_param data.goodsInfo.storage string 贮藏
 * @return_param data.goodsInfo.womanDosage string 孕妇及哺乳期妇女用药
 * @return_param data.goodsInfo.childrenDosage string 儿童用药
 * @return_param data.goodsInfo.elderlyDosage string 老年患者用药
 * @return_param data.goodsInfo.linkUrl string 跳转链接
 * @return_param data.rank int 今日查询排名
 * @return_param data.total int 总共查询次数
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class PriceSearchAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $goodsName = Helper::getParam('goodsName');
        $companyId = (int)Helper::getParam('companyId');
        $specs = Helper::getParam('specs');
        $price = Helper::getParam('price');
        $channelId = (int)Helper::getParam('channelId');
        $goodsId = (int)Helper::getParam('goodsId');

        if (!$goodsName) {
            Helper::responseError(1015);
        }

        if (!$price) {
            Helper::responseError(1016);
        }

        if (!Tool::checkPrice($price)) {
            Helper::responseError(1037);
        }

        if (!$companyId) {
            Helper::responseError(1017);
        }

        if (!$channelId) {
            Helper::responseError(1018);
        }

        $result = QueryService::getPriceSearchInfo($uid, $goodsName, $price, $companyId, $channelId, $specs, $goodsId);

        Helper::response(200, $result);
    }
}
