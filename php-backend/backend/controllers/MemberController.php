<?php

namespace backend\controllers;

/**
 * 会员接口
 */
class MemberController extends BaseController
{
    public function actions()
    {
        return [
            /**
             * 会员列表
             */
            'userList' => [
                'class' => 'backend\controllers\member\UserListAction',
            ],
            /**
             * 会员操作
             */
            'dealUser' => [
                'class' => 'backend\controllers\member\DealUserAction',
            ],
            /**
             * 评论列表
             */
            'commentList' => [
                'class' => 'backend\controllers\member\CommentListAction',
            ],
            /**
             * 评论操作
             */
            'dealComment' => [
                'class' => 'backend\controllers\member\DealCommentAction',
            ],
            /**
             * 回复列表
             */
            'replyList' => [
                'class' => 'backend\controllers\member\ReplyListAction',
            ],
            /**
             * 搜索列表
             */
            'searchList' => [
                'class' => 'backend\controllers\member\SearchListAction',
            ],
            /**
             * 热门列表
             */
            'hotList' => [
                'class' => 'backend\controllers\member\HotListAction',
            ],
            /**
             * 人工核查列表
             */
            'manualSearchList' => [
                'class' => 'backend\controllers\member\ManualSearchListAction',
            ],
            /**
             * 核查操作
             */
            'checkManual' => [
                'class' => 'backend\controllers\member\CheckManualAction',
            ],
            /**
             * 短信提示
             */
            'smsTip' => [
                'class' => 'backend\controllers\member\SmsTipAction',
            ],
            /**
             * 防伪查询列表
             */
            'companySearchList' => [
                'class' => 'backend\controllers\member\CompanySearchListAction',
            ],
            /**
             * 价格查询列表
             */
            'priceSearchList' => [
                'class' => 'backend\controllers\member\PriceSearchListAction',
            ],
            /**
             * 纠错类目
             */
            'errorDirectory' => [
                'class' => 'backend\controllers\member\ErrorDirectoryAction',
            ],
            /**
             * 标签管理
             */
            'labelList' => [
                'class' => 'backend\controllers\member\LabelListAction',
            ],
            /**
             * 标签操作
             */
            'dealLabel' => [
                'class' => 'backend\controllers\member\DealLabelAction',
            ],
            /**
             * 所有标签
             */
            'allLabel' => [
                'class' => 'backend\controllers\member\AllLabelAction',
            ],
            /**
             * 资讯管理
             */
            'articleList' => [
                'class' => 'backend\controllers\member\ArticleListAction',
            ],
            /**
             * 资讯操作
             */
            'dealArticle' => [
                'class' => 'backend\controllers\member\DealArticleAction',
            ],
            /**
             * 资讯评论列表
             */
            'articleCommentList' => [
                'class' => 'backend\controllers\member\ArticleCommentListAction',
            ],
            /**
             * 资讯评论操作
             */
            'dealArticleComment' => [
                'class' => 'backend\controllers\member\DealArticleCommentAction',
            ],
            /**
             * 图片识别列表
             */
            'imageRecognition' => [
                'class' => 'backend\controllers\member\ImageRecognitionAction',
            ],
            /**
             * 扫一扫列表
             */
            'scanLog' => [
                'class' => 'backend\controllers\member\ScanLogAction',
            ],
            /**
             * 比价列表
             */
            'comparePrice' => [
                'class' => 'backend\controllers\member\ComparePriceAction',
            ],
            /**
             * 资讯热门词管理
             */
            'articleWordList' => [
                'class' => 'backend\controllers\member\ArticleWordListAction',
            ],
            /**
             * 资讯热门词操作
             */
            'dealArticleWord' => [
                'class' => 'backend\controllers\member\DealArticleWordAction',
            ],
        ];
    }
}
