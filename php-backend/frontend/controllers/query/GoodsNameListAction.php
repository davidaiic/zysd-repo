<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药品名称列表
 * @description 药品名称列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/goodsNameList
 * @param companyId 必选 int 药厂id
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"goodsNameList": [{"goodsName": ""}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.goodsNameList array 药品名称列表
 * @return_param data.goodsNameList[0].goodsName string 药品名称
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GoodsNameListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $companyId = (int)Helper::getParam('companyId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = QueryService::getGoodsNameList($companyId, $page);

        Helper::response(200, ['goodsNameList' => $result]);
    }
}
