<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 发布帖子
 * @description 发布帖子接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/addComment
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param content 必选 string 评论内容
 * @param pictures 必选 string 评论图片，多张照片以,拼接的字符串，例如：1.jpg,2.jpg
 * @param commentId 否 string 评论id
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class AddCommentAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $content = Helper::getParam('content');
        $pictures = Helper::getParam('pictures');
        $commentId = (int)Helper::getParam('commentId');

        if (!$content) {
            Helper::responseError(1009);
        }

        if (mb_strlen($content) < 10) {
            Helper::responseError(1038);
        }

        $result = HomeService::addComment($uid, $content, $pictures, $commentId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
