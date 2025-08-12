<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 创建分享码
 * @description 创建分享码接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/createShare
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param wx 必选 string 微信号
 * @param qrcode 必选 string 二维码
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CreateShareAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $wx = Helper::getParam('wx');
        $qrcode = Helper::getParam('qrcode');

        if (!$wx && !$qrcode) {
            Helper::responseError(1020);
        }

        $result = UserService::createShare($uid, $wx, $qrcode);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
