<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 热门药厂
 * @description 热门药厂接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/hotCompany
 * @return {"code": 200,"message": "请求成功","data": {"hotCompanyList": [{"companyId": 1,"companyName": "老挝第二制药厂","companyImage": ""}],"otherCompanyList": [{"companyId": 2,"companyName": "老挝磨丁元素制药","companyImage": ""}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.hotCompanyList array 国外仿制药热门厂家列表
 * @return_param data.hotCompanyList[0].companyId int 药厂id
 * @return_param data.hotCompanyList[0].companyName string 药厂名称
 * @return_param data.hotCompanyList[0].companyImage string 药厂图片
 * @return_param data.otherCompanyList array 其他热门药厂列表
 * @return_param data.otherCompanyList[0].companyId int 药厂id
 * @return_param data.otherCompanyList[0].companyName string 药厂名称
 * @return_param data.otherCompanyList[0].companyImage string 药厂图片
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class HotCompanyAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = QueryService::getHotCompanyList();

        Helper::response(200, $result);
    }
}
