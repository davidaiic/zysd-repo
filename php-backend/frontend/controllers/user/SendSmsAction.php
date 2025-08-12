<?php

namespace frontend\controllers\user;

use AlibabaCloud\Client\Exception\ClientException;
use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 发送验证码
 * @description 发送验证码接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/sendSms
 * @param phone 必选 string 手机号
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class SendSmsAction extends Action
{
    /**
     * @throws ExitException
     * @throws ClientException
     */
    public function run()
    {
        $phone = Helper::getParam('phone');

        if (!$phone) {
            Helper::responseError(1005);
        }

        if (!Tool::checkPhone($phone)) {
            Helper::responseError(1031);
        }

        $result = UserService::sendSms($phone);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
