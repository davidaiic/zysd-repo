<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药厂列表
 * @description 药厂列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/companyList
 * @param type 必选 int 类型：0-全部，1-对接了第三方查询的药厂，2-价格相关药厂列表
 * @param goodsName 否 string 药品名称，type=2时传
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"companyList": [{"companyId": 2,"companyName": "老挝元素","companyImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230103/1672727348.png"},{"companyId": 0,"companyName": "其他厂家","companyImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230103/1672727387.png"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.companyList array 药厂列表
 * @return_param data.companyList[0].companyId int 药厂id
 * @return_param data.companyList[0].companyName string 药厂名称
 * @return_param data.companyList[0].companyImage string 药厂图片
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CompanyListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $type = (int)Helper::getParam('type');
        $goodsName = Helper::getParam('goodsName');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = QueryService::getCompanyList($type, $goodsName, $page);

        Helper::response(200, ['companyList' => $result]);
    }
}
