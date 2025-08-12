<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 人工核查信息
 * @description 人工核查信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/manual
 * @return {"code": 200,"message": "请求成功","data": {"photoServiceTime": "9:00-18:00","photoFeedbackTime": "48小时内反馈","photoQueryNum": 233,"wxServiceTime": "6:00-24:00","wxFeedbackTime": "24小时内反馈","wxQueryNum": 3286}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.photoServiceTime string 拍照上传服务时间
 * @return_param data.photoFeedbackTime string 拍照上传反馈时间
 * @return_param data.photoQueryNum int 拍照上传查询次数
 * @return_param data.wxServiceTime string 客服微信服务时间
 * @return_param data.wxFeedbackTime string 客服微信反馈时间
 * @return_param data.wxQueryNum int 客服微信查询次数
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ManualAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = QueryService::getManualInfo();

        Helper::response(200, $result);
    }
}
