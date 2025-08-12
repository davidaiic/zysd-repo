<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 分类列表
 * @description 分类列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/classList
 * @return {"code": 200,"message": "请求成功","data": {"classList": [{"classId": "1","className": "肺癌","children": [{"classId": "7","className": "ALK1"},{"classId": "8","className": "ALK2"},{"classId": "9","className": "其他"}]}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.classList array 分类列表
 * @return_param data.classList[0].classId int 分类id
 * @return_param data.classList[0].className string 分类名称
 * @return_param data.classList[0].children array 子分类列表
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ClassListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = QueryService::getClassList();

        Helper::response(200, ['classList' => $result]);
    }
}
