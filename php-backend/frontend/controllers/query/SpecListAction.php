<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 规格列表
 * @description 规格列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/specList
 * @param goodsName 必选 string 药品名称
 * @param companyId 必选 int 药厂id
 * @return {"code": 200,"message": "请求成功","data": {"specList": [{"specs": ""}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.specList array 规格列表
 * @return_param data.specList[0].specs string 规格名称
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class SpecListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $goodsName = Helper::getParam('goodsName');
        $companyId = (int)Helper::getParam('companyId');

        $result = QueryService::getSpecList($goodsName, $companyId);

        Helper::response(200, ['specList' => $result]);
    }
}
