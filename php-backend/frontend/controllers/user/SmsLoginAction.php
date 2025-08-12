<?php

namespace frontend\controllers\user;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 验证码登录
 * @description 验证码登录接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/smsLogin
 * @param phone 必选 string 手机号
 * @param code 必选 string 验证码
 * @return {"code": 200,"message": "请求成功","data": {"uid": "","token": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.uid int 用户id
 * @return_param data.token string token令牌
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class SmsLoginAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $phone = Helper::getParam('phone');
        $code = Helper::getParam('code');

        if (!$phone) {
            Helper::responseError(1005);
        }

        if (!$code) {
            Helper::responseError(1047);
        }

        if (!Tool::checkPhone($phone)) {
            Helper::responseError(1031);
        }

        $result = UserService::smsLogin($phone, $code);

        if (!empty($result)) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
