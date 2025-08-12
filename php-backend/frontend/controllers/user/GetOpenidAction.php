<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 获取小程序openid
 * @description 获取小程序openid接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/getOpenid
 * @param code 必选 string 登录凭证code
 * @return {"code": 200,"message": "请求成功","data": {"openid": "","uid": "","token": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.openid string 小程序openid，没有用户信息会返回
 * @return_param data.uid int 用户id，有用户信息返回
 * @return_param data.token string token令牌，有用户信息返回
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GetOpenidAction extends Action
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

        $result = UserService::getOpenid($code);

        Helper::response(200, $result);
    }
}
