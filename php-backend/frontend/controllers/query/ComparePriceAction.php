<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 比价
 * @description 比价接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/comparePrice
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 否 int 传过来的药品id
 * @param leftGoodsName 必选 string 左边药品名称
 * @param leftCompanyId 必选 int 左边药厂id
 * @param leftSpecs 必选 string 左边规格名称
 * @param rightGoodsName 必选 string 右边药品名称
 * @param rightCompanyId 必选 int 右边药厂id
 * @param rightSpecs 必选 string 右边规格名称
 * @return {"code": 200,"message": "请求成功","data": {"leftGoodsInfo": {"goodsId": "1","goodsName": "克唑替尼  Crizotinib","goodsImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230109/1673251980.png","clinicalStage": "","drugProperties": "","drugPropertiesColor": "#459BF0","companyId": 8,"companyName": "孟加拉伊思达药厂 Incepta Pharmaceuticals Ltd.","marketTag": "","medicalTag": "","moneyText": "¥","minPrice": "2200.00","maxPrice": "2800.00","marketPlace": ""},"rightGoodsInfo": {"goodsId": "9","goodsName": "乐伐替尼  Lenvatinib","goodsImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230108/1673142741.png","clinicalStage": "","drugProperties": "","drugPropertiesColor": "#459BF0","companyId": 1,"companyName": "老挝第二制药厂 PHARMACEUTICAL FACTORY NO.2","marketTag": "","medicalTag": "","moneyText": "¥","minPrice": "600.00","maxPrice": "850.00","marketPlace": ""},"compareText": "555"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.leftGoodsInfo object 左边药品信息
 * @return_param data.leftGoodsInfo.goodsId string 药品id
 * @return_param data.leftGoodsInfo.goodsName string 药品名称
 * @return_param data.leftGoodsInfo.goodsImage string 药品图片
 * @return_param data.leftGoodsInfo.clinicalStage string 国内临床阶段，为空不显示
 * @return_param data.leftGoodsInfo.drugProperties string 药品属性，左上角标签，为空不显示
 * @return_param data.leftGoodsInfo.drugPropertiesColor string 药品属性，左上角标签颜色
 * @return_param data.leftGoodsInfo.risk string 药品风险等级，为1显示高风险，为0不显示
 * @return_param data.leftGoodsInfo.companyId string 药厂id
 * @return_param data.leftGoodsInfo.companyName string 药厂名称
 * @return_param data.leftGoodsInfo.marketTag string 上市标签，为空不显示
 * @return_param data.leftGoodsInfo.medicalTag string 医保标签，为空不显示
 * @return_param data.leftGoodsInfo.moneyText string 货币符号
 * @return_param data.leftGoodsInfo.minPrice string 药品最低价格
 * @return_param data.leftGoodsInfo.maxPrice string 药品最高价格
 * @return_param data.leftGoodsInfo.marketPlace string 所在地区
 * @return_param data.rightGoodsInfo object 右边药品信息
 * @return_param data.rightGoodsInfo.goodsId string 药品id
 * @return_param data.rightGoodsInfo.goodsName string 药品名称
 * @return_param data.rightGoodsInfo.goodsImage string 药品图片
 * @return_param data.rightGoodsInfo.clinicalStage string 国内临床阶段，为空不显示
 * @return_param data.rightGoodsInfo.drugProperties string 药品属性，左上角标签，为空不显示
 * @return_param data.rightGoodsInfo.drugPropertiesColor string 药品属性，左上角标签颜色
 * @return_param data.rightGoodsInfo.risk string 药品风险等级，为1显示高风险，为0不显示
 * @return_param data.rightGoodsInfo.companyId string 药厂id
 * @return_param data.rightGoodsInfo.companyName string 药厂名称
 * @return_param data.rightGoodsInfo.marketTag string 上市标签，为空不显示
 * @return_param data.rightGoodsInfo.medicalTag string 医保标签，为空不显示
 * @return_param data.rightGoodsInfo.moneyText string 货币符号
 * @return_param data.rightGoodsInfo.minPrice string 药品最低价格
 * @return_param data.rightGoodsInfo.maxPrice string 药品最高价格
 * @return_param data.rightGoodsInfo.marketPlace string 所在地区
 * @return_param data.compareText string 比价说明文案
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ComparePriceAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $goodsId = (int)Helper::getParam('goodsId');
        $leftGoodsName = Helper::getParam('leftGoodsName');
        $leftCompanyId = (int)Helper::getParam('leftCompanyId');
        $leftSpecs = Helper::getParam('leftSpecs');
        $rightGoodsName = Helper::getParam('rightGoodsName');
        $rightCompanyId = (int)Helper::getParam('rightCompanyId');
        $rightSpecs = Helper::getParam('rightSpecs');

        if (!$leftGoodsName || !$rightGoodsName) {
            Helper::responseError(1015);
        }

        if (!$leftCompanyId || !$rightCompanyId) {
            Helper::responseError(1017);
        }

        if (!$leftSpecs || !$rightSpecs) {
            Helper::responseError(1041);
        }

        $result = QueryService::getComparePriceInfo($uid, $goodsId, $leftGoodsName, $leftCompanyId, $leftSpecs, $rightGoodsName, $rightCompanyId, $rightSpecs);

        Helper::response(200, $result);
    }
}
