<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 获取小程序手机号
 * @description 获取小程序手机号接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/getPhone
 * @param encryptedData 必选 string 加密数据
 * @param iv 必选 string 初始向量
 * @param openid 必选 string 小程序openid
 * @return {"code": 200,"message": "请求成功","data": {"mobile": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.mobile string 小程序手机号
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GetPhoneAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $encryptedData = Helper::getParam('encryptedData');
        $iv = Helper::getParam('iv');
        $openid = Helper::getParam('openid');

        if (!$encryptedData) {
            Helper::responseError(1000);
        }

        if (!$iv) {
            Helper::responseError(1001);
        }

        if (!$openid) {
            Helper::responseError(1002);
        }

        $result = UserService::getPhone($encryptedData, $iv, $openid);

        Helper::response(200, $result);
    }
}
