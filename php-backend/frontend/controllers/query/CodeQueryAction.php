<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药厂防伪码查询文案
 * @description 药厂防伪码查询文案接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/codeQuery
 * @param companyId 必选 int 药厂id
 * @return {"code": 200,"message": "请求成功","data": {"codeQuery": "<p>11111111111111</p>"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.codeQuery string 防伪码查询文案
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CodeQueryAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $companyId = (int)Helper::getParam('companyId');

        if (!$companyId) {
            Helper::response(201);
        }

        $result = QueryService::getCompanyCodeQuery($companyId);

        Helper::response(200, $result);
    }
}
