<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 更新信息
 * @description 更新信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/updateInfo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param nickname 必选 string 昵称
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class UpdateInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $nickname = Helper::getParam('nickname');

        if (!$nickname) {
            Helper::responseError(1003);
        }

        $result = UserService::saveUserInfo($uid, $nickname);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
