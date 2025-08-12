<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 评论详情
 * @description 评论详情接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/commentInfo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param commentId 必选 string 评论id
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"info": {"commentId": 1,"avatar": "1.jpg","username": "阳*","content": "老挝二厂的药用这个小程序查验很方便","likeNum": 20,"commentNum": 14,"created": "01-03 20:54","isLike": 1},"commentList": [{"commentId": "4","avatar": "1.jpg","username": "阳*","content": "好好好豪豪豪豪好好好","likeNum": "0","created": "01-11 20:30","isLike": 0}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info object 评论信息
 * @return_param data.info.commentId string 评论id
 * @return_param data.info.avatar string 用户头像
 * @return_param data.info.username string 用户名
 * @return_param data.info.content string 评论内容
 * @return_param data.info.pictures array 评论图片集合
 * @return_param data.info.likeNum string 点赞数量
 * @return_param data.info.commentNum string 评论数量
 * @return_param data.info.created string 发布时间
 * @return_param data.info.isLike int 是否点赞：0-否，1-是
 * @return_param data.commentList array 回复列表
 * @return_param data.commentList[0].commentId string 评论id
 * @return_param data.commentList[0].avatar string 用户头像
 * @return_param data.commentList[0].username string 用户名
 * @return_param data.commentList[0].content string 评论内容
 * @return_param data.commentList[0].pictures array 评论图片集合
 * @return_param data.commentList[0].likeNum string 点赞数量
 * @return_param data.commentList[0].created string 发布时间
 * @return_param data.commentList[0].isLike int 是否点赞：0-否，1-是
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CommentInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $commentId = (int)Helper::getParam('commentId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        if (!$commentId) {
            Helper::response(201);
        }

        $result = HomeService::getCommentInfo($uid, $commentId, $page);

        Helper::response(200, $result);
    }
}
