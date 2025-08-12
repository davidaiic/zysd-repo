<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 资讯详情
 * @description 资讯详情接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/articleInfo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param articleId 必选 string 资讯id
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"info": {"articleId": 1,"avatar": "1.jpg","username": "152****6561","title": "一文告诉你卡瑞利珠单抗是什么药？适用什么病症？","label": ["医保"],"content": "1111111111111111111111111111111111","likeNum": 1,"commentNum": 3,"created": "3小时前","isLike": 0},"commentList": [{"commentId": "1","avatar": "1.jpg","username": "152****6561","mobile": "15298836561","content": "12333336666666666666666","pictures": ["1.jpg","2.jpg"],"likeNum": "0","created": "04-04 00:15","isLike": 0}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info object 资讯信息
 * @return_param data.info.articleId int 资讯id
 * @return_param data.info.avatar string 用户头像
 * @return_param data.info.username string 用户名
 * @return_param data.info.title string 标题
 * @return_param data.info.label array 标签集合
 * @return_param data.info.content string 资讯内容
 * @return_param data.info.likeNum int 点赞数量
 * @return_param data.info.commentNum int 评论数量
 * @return_param data.info.created string 发布时间
 * @return_param data.info.isLike int 是否点赞：0-否，1-是
 * @return_param data.commentList array 评论列表
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
class ArticleInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $articleId = (int)Helper::getParam('articleId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        if (!$articleId) {
            Helper::response(201);
        }

        $result = HomeService::getArticleInfo($uid, $articleId, $page);

        Helper::response(200, $result);
    }
}
