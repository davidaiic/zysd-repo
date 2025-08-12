<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药厂查询
 * @description 药厂查询接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/companySearch
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param companyId 必选 int 药厂id
 * @param goodsId 必选 int 药品id
 * @param goodsName 否 string 药品名称
 * @param code 必选 string 防伪码
 * @return {"code": 200,"message": "请求成功","data": {"info": "","registerInfo": "","dataSources": "","queryTime": "","rank": 100,"total": 867}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info string 查询信息
 * @return_param data.registerInfo string 药品查询注册信息
 * @return_param data.dataSources string 数据来源
 * @return_param data.queryTime string 查询时间
 * @return_param data.rank int 今日查询排名
 * @return_param data.total int 总共查询次数
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CompanySearchAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $companyId = (int)Helper::getParam('companyId');
        $goodsId = (int)Helper::getParam('goodsId');
        $goodsName = Helper::getParam('goodsName');
        $code = Helper::getParam('code');

        if (!$companyId) {
            Helper::response(201);
        }

        if (!$code) {
            Helper::responseError(1012);
        }

        $result = QueryService::getCompanySearchInfo($uid, $goodsId, $goodsName, $companyId, $code);

        Helper::response(200, $result);
    }
}
