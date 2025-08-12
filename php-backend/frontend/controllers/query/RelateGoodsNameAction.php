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
 * @title 新版药品名称列表
 * @description 新版药品名称列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/relateGoodsName
 * @param keyword 必选 string 搜索词
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
class RelateGoodsNameAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Tool::filterKeyword(Helper::getParam('keyword'));
        $page = Helper::getParam('page');
        $page = $page ? $page : 0;

        $result = QueryService::getRelateGoodsNameList($keyword, $page);

        Helper::response(200, ['goodsNameList' => $result]);
    }
}
