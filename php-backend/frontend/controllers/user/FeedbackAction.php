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
 * @title 意见反馈
 * @description 意见反馈接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/feedback
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param content 必选 string 内容
 * @param imageUrl 必选 string 图片url，多张图片以,拼接的字符串，例如：1.jpg,2.jpg
 * @param mobile 必选 string 手机号码
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class FeedbackAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $content = Helper::getParam('content');
        $imageUrl = Helper::getParam('imageUrl');
        $mobile = Helper::getParam('mobile');

        if (!$content) {
            Helper::responseError(1009);
        }

        if (!$mobile) {
            Helper::responseError(1005);
        }

        if (!Tool::checkPhone($mobile)) {
            Helper::responseError(1031);
        }

        $result = UserService::addFeedback($uid, $content, $imageUrl, $mobile);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
