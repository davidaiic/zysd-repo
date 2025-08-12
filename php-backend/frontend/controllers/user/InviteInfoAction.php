<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 邀请人信息
 * @description 邀请人信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/inviteInfo
 * @param inviteId 必选 int 邀请人id
 * @return {"code": 200,"message": "请求成功","data": {"info": {"username": "阳*","avatar": "1.jpg"}}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info object 邀请人信息
 * @return_param data.info.username string 邀请人用户名
 * @return_param data.info.avatar string 邀请人头像
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class InviteInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $inviteId = Helper::getParam('inviteId');

        if (!$inviteId) {
            Helper::response(201);
        }

        $result = UserService::getInviteInfo($inviteId);

        Helper::response(200, $result);
    }
}
