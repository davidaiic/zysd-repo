<?php

namespace frontend\controllers\home;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 评论列表
 * @description 评论列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/commentList
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param type 必选 int 类型：0-所有评论，1-热门评论
 * @param keyword 否 string 搜索词
 * @param sortId 否 string 排序id
 * @param labelId 否 string 标签id，多个标签以,隔开
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"commentList": [{"commentId": "1","avatar": "1.jpg","username": "阳*","content": "老挝二厂的药用这个小程序查验很方便","likeNum": "20","commentNum": "12","created": "01-03 20:54","isLike": 1}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.commentList array 评论列表
 * @return_param data.commentList[0].commentId string 评论id
 * @return_param data.commentList[0].avatar string 用户头像
 * @return_param data.commentList[0].username string 用户名
 * @return_param data.commentList[0].content string 评论内容
 * @return_param data.commentList[0].pictures array 评论图片集合
 * @return_param data.commentList[0].likeNum string 点赞数量
 * @return_param data.commentList[0].commentNum string 评论数量
 * @return_param data.commentList[0].created string 发布时间
 * @return_param data.commentList[0].isLike int 是否点赞：0-否，1-是
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CommentListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $type = (int)Helper::getParam('type');
        $keyword = Tool::filterKeyword(Helper::getParam('keyword'));
        $sortId = Helper::getParam('sortId');
        $labelId = Helper::getParam('labelId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = HomeService::getCommentList($uid, $type, $keyword, $sortId, $labelId, $page);

        Helper::response(200, ['commentList' => $result]);
    }
}
