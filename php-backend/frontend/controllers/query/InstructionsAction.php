<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 说明书信息
 * @description 说明书信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/instructions
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 必选 int 药品id
 * @return {"code": 200,"message": "请求成功","data": {"goodsInfo": {"goodsId": 1,"goodsName": "克唑替尼 ","enName": "Crizotinib","commonName": "Crizocent 250","bigImage": [],"clinicalStage": "","drugProperties": "","drugPropertiesColor": "#459BF0","companyId": 8,"companyName": "","marketTag": "","medicalTag": ""},"directory": [{"keyword": "attention","name": "注意事项","content": ""}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.goodsInfo object 药品信息
 * @return_param data.goodsInfo.goodsId int 药品id
 * @return_param data.goodsInfo.goodsName string 药品名称
 * @return_param data.goodsInfo.enName string 英文药品名称
 * @return_param data.goodsInfo.commonName string 通用名称
 * @return_param data.goodsInfo.otherName string 别名
 * @return_param data.goodsInfo.bigImage array 药品大图
 * @return_param data.goodsInfo.goodsTag string 药品标签
 * @return_param data.goodsInfo.goodsTagColor string 药品标签颜色
 * @return_param data.goodsInfo.clinicalStage string 国内临床阶段，为空不显示
 * @return_param data.goodsInfo.drugProperties string 药品属性，左上角标签，为空不显示
 * @return_param data.goodsInfo.drugPropertiesColor string 药品属性，左上角标签颜色
 * @return_param data.goodsInfo.companyId int 药厂id
 * @return_param data.goodsInfo.companyName string 药厂名称
 * @return_param data.goodsInfo.marketTag string 上市标签，为空不显示
 * @return_param data.goodsInfo.medicalTag string 医保标签，为空不显示
 * @return_param data.directory array 说明书目录内容
 * @return_param data.directory[0].keyword string 关键词标识
 * @return_param data.directory[0].name string 名称
 * @return_param data.directory[0].content string 内容
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class InstructionsAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $goodsId = (int)Helper::getParam('goodsId');

        if (!$goodsId) {
            Helper::responseError(1035);
        }

        $result = QueryService::getGoodsInstructions($goodsId);

        Helper::response(200, $result);
    }
}
