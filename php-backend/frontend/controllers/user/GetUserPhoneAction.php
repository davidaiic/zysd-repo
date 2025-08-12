<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 新版获取小程序手机号
 * @description 新版获取小程序手机号接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/getUserPhone
 * @param code 必选 string 手机号获取凭证
 * @return {"code": 200,"message": "请求成功","data": {"mobile": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.mobile string 小程序手机号
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GetUserPhoneAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $code = Helper::getParam('code');

        if (!$code) {
            Helper::response(201);
        }

        $result = UserService::getUserPhone($code);

        Helper::response(200, $result);
    }
}
