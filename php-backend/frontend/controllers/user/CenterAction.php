<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 个人主页
 * @description 个人主页接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/center
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @return {"code": 200,"message": "请求成功","data": {"info": {"username": "","mobile": "","avatar": ""}}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info object 用户信息
 * @return_param data.info.username string 用户名
 * @return_param data.info.mobile string 手机号码
 * @return_param data.info.avatar string 头像
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CenterAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();

        $result = UserService::myCenter($uid);

        Helper::response(200, $result);
    }
}
