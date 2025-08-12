<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药品风险信息
 * @description 药品风险信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/goodsRisk
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 必选 int 药品id
 * @return {"code": 200,"message": "请求成功","data": {"queryTime": "","dataSources": "","solutionText": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.queryTime string 查询时间
 * @return_param data.dataSources string 查询来源
 * @return_param data.solutionText string 解决方案文案
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GoodsRiskAction extends Action
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

        $result = QueryService::getGoodsRiskInfo($goodsId);

        Helper::response(200, $result);
    }
}
