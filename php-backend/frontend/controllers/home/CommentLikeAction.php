<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 评论点赞
 * @description 评论点赞接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/commentLike
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param commentId 必选 string 评论id
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CommentLikeAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $commentId = (int)Helper::getParam('commentId');

        if (!$commentId) {
            Helper::response(201);
        }

        $result = HomeService::addCommentLike($uid, $commentId);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
