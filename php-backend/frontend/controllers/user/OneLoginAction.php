<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 移动一键登录
 * @description 移动一键登录接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/oneLogin
 * @param accessToken 必选 string 一键登录token
 * @return {"code": 200,"message": "请求成功","data": {"uid": "","token": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.uid int 用户id
 * @return_param data.token string token令牌
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class OneLoginAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $accessToken = Helper::getParam('accessToken');

        if (!$accessToken) {
            Helper::responseError(1043);
        }

        $result = UserService::getOneClickLogin($accessToken);

        if (!empty($result)) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
