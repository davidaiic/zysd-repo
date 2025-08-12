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
 * @title 资讯列表
 * @description 资讯列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/articleList
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param keyword 否 string 搜索词
 * @param sortId 否 string 排序id
 * @param labelId 否 string 标签id，多个标签以,隔开
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"articleList": [{"articleId": "1","title": "一文告诉你卡瑞利珠单抗是什么药？适用什么病症？","cover": "1.jpg","label": ["医保"],"likeNum": "1","commentNum": "2","readNum": "1","created": "2小时前","isLike": 0}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.articleList array 资讯列表
 * @return_param data.articleList[0].articleId string 资讯id
 * @return_param data.articleList[0].title string 标题
 * @return_param data.articleList[0].cover string 封面
 * @return_param data.articleList[0].label array 标签集合
 * @return_param data.articleList[0].likeNum string 点赞数量
 * @return_param data.articleList[0].commentNum string 评论数量
 * @return_param data.articleList[0].readNum string 阅读数量
 * @return_param data.articleList[0].created string 发布时间
 * @return_param data.articleList[0].isLike int 是否点赞：0-否，1-是
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ArticleListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $keyword = Tool::filterKeyword(Helper::getParam('keyword'));
        $sortId = Helper::getParam('sortId');
        $labelId = Helper::getParam('labelId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = HomeService::getArticleList($uid, $keyword, $sortId, $labelId, $page);

        Helper::response(200, ['articleList' => $result]);
    }
}
