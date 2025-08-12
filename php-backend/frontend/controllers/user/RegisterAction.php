<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 小程序登录
 * @description 小程序登录接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/register
 * @param nickname 必选 string 昵称
 * @param avatar 必选 string 头像
 * @param openid 必选 string 小程序openid
 * @param mobile 必选 string 小程序手机号
 * @param inviteId 否 int 邀请人id
 * @return {"code": 200,"message": "请求成功","data": {"uid": "","token": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.uid int 用户id
 * @return_param data.token string token令牌
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class RegisterAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $nickname = Helper::getParam('nickname');
        $avatar = Helper::getParam('avatar');
        $openid = Helper::getParam('openid');
        $mobile = Helper::getParam('mobile');
        $inviteId = (int)Helper::getParam('inviteId');

        if (!$nickname) {
            Helper::responseError(1003);
        }

        if (!$avatar) {
            Helper::responseError(1004);
        }

        if (!$openid) {
            Helper::responseError(1002);
        }

        if (!$mobile) {
            Helper::responseError(1005);
        }

        $result = UserService::register($nickname, $avatar, $openid, $mobile, $inviteId);

        if (!empty($result)) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
