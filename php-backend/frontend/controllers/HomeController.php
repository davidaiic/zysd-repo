<?php

namespace frontend\controllers;

/**
 * 首页接口
 */
class HomeController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 首页
             */
            'index' => [
                'class' => 'frontend\controllers\home\IndexAction',
            ],
            /**
             * 评论列表
             */
            'commentList' => [
                'class' => 'frontend\controllers\home\CommentListAction',
            ],
            /**
             * 评论详情
             */
            'commentInfo' => [
                'class' => 'frontend\controllers\home\CommentInfoAction',
            ],
            /**
             * 发布帖子
             */
            'addComment' => [
                'class' => 'frontend\controllers\home\AddCommentAction',
            ],
            /**
             * 评论点赞
             */
            'commentLike' => [
                'class' => 'frontend\controllers\home\CommentLikeAction',
            ],
            /**
             * 热门搜索词
             */
            'hotWord' => [
                'class' => 'frontend\controllers\home\HotWordAction',
            ],
            /**
             * 搜索
             */
            'search' => [
                'class' => 'frontend\controllers\home\SearchAction',
            ],
            /**
             * 联想词
             */
            'associateWord' => [
                'class' => 'frontend\controllers\home\AssociateWordAction',
            ],
            /**
             * 热门药品
             */
            'hotGoods' => [
                'class' => 'frontend\controllers\home\HotGoodsAction',
            ],
            /**
             * 筛选条件
             */
            'filterCriteria' => [
                'class' => 'frontend\controllers\home\FilterCriteriaAction',
            ],
            /**
             * 资讯列表
             */
            'articleList' => [
                'class' => 'frontend\controllers\home\ArticleListAction',
            ],
            /**
             * 资讯详情
             */
            'articleInfo' => [
                'class' => 'frontend\controllers\home\ArticleInfoAction',
            ],
            /**
             * 资讯发布帖子
             */
            'addArticleComment' => [
                'class' => 'frontend\controllers\home\AddArticleCommentAction',
            ],
            /**
             * 资讯点赞
             */
            'articleLike' => [
                'class' => 'frontend\controllers\home\ArticleLikeAction',
            ],
            /**
             * 资讯评论点赞
             */
            'articleCommentLike' => [
                'class' => 'frontend\controllers\home\ArticleCommentLikeAction',
            ],
        ];
    }
}
