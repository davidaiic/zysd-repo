<?php

namespace frontend\models\service;

use common\components\Tool;
use Exception;
use frontend\components\Helper;
use frontend\models\home\Article;
use frontend\models\home\ArticleComment;
use frontend\models\home\ArticleCommentLike;
use frontend\models\home\ArticleLike;
use frontend\models\home\Banner;
use frontend\models\home\Comment;
use frontend\models\home\CommentLike;
use frontend\models\home\Goods;
use frontend\models\home\GoodsClass;
use frontend\models\home\Hot;
use frontend\models\home\Search;
use frontend\models\plugin\Setting;
use frontend\models\query\CompanySearch;
use frontend\models\query\ComparePrice;
use frontend\models\query\Photo;
use frontend\models\query\PriceSearch;
use frontend\models\query\ScanLog;
use frontend\models\user\User;
use Yii;
use yii\base\ExitException;
use yii\db\Expression;
use yii\db\Query;

/**
 * 首页
 */
class HomeService
{
    /**
     * 获取首页搜索配置内容
     * @return string
     */
    public static function getSearchText()
    {
        $search = Setting::findByKeyword('search_text');
        return $search ? $search['value'] : '';
    }

    /**
     * 获取搜索提示
     * @return string
     */
    public static function getSearchTip()
    {
        $search = Setting::findByKeyword('search_tip');
        return $search ? $search['value'] : '';
    }

    /**
     * 获取首页banner列表
     * @return array
     */
    public static function getBannerList()
    {
        $banner = Banner::findAllBanner();

        $bannerList = [];
        if ($banner) {
            foreach ($banner as $key => $value) {
                $bannerList[] = [
                    'bannerId' => $value['id'],
                    'name'     => $value['name'],
                    'notes'    => $value['notes'],
                    'imageUrl' => $value['image_url'],
                    'type'     => $value['type'],
                    'linkUrl'  => $value['link_url'],
                    'text1'    => $value['text1'],
                    'text2'    => $value['text2']
                ];
            }
        }

        return $bannerList;
    }

    /**
     * 获取扫一扫查真伪人数
     */
    public static function getScanNum()
    {
        $num = ScanLog::findTotalNum();
        return (int)$num * 3;
    }

    /**
     * 获取自助查询人数
     * @return int
     */
    public static function getSelfQueryNum()
    {
        $num = CompanySearch::findTotalNum();
        return (int)$num * 3;
    }

    /**
     * 获取人工核查人数
     * @return int
     */
    public static function getManualVerifyNum()
    {
        $num = Photo::findTotalNum();
        return (int)$num * 3;
    }

    /**
     * 获取价格查询人数
     * @return int
     */
    public static function getPriceQueryNum()
    {
        $num = PriceSearch::findTotalNum();
        return (int)$num * 3;
    }

    /**
     * 获取我要送检人数
     */
    public static function getCheckNum()
    {
        $num = Setting::findByKeyword('check_num');
        return $num ? (int)$num['value'] : 0;
    }

    /**
     * 获取我要比价人数
     */
    public static function getCompareNum()
    {
        $num = ComparePrice::findTotalNum();
        return (int)$num * 15;
    }

    /**
     * 获取搜索列表
     * @return array
     */
    public static function getSearchList()
    {
        //获取最新的10跳记录
        $query = new Query();
        $list = $query->select(['log.goods_name as goodsName',
            'log.company_name as companyName',
            'log.type',
            'log.created',
            'user.username',
            'user.mobile',
            'user.avatar'])
            ->from('ky_query_log as log')
            ->innerJoin('ky_user as user', 'user.id = log.uid')
            ->orderBy('log.id desc')
            ->offset(0)
            ->limit(10)
            ->all();

        $arr = [];
        if (!empty($list)) {
            foreach ($list as $key => $value) {
                $username = $value['username'] != '微信用户' ? $value['username'] : Tool::getPhoneHide($value['mobile']);

                switch ($value['type']) {
                    case '4':
                        $searchText = '搜索了';
                        break;
                    case '5':
                        $searchText = '扫一扫';
                        break;
                    case '6':
                        $searchText = '比价了';
                        break;
                    default:
                        $searchText = '查询过';
                        break;
                }

                $arr[] = [
                    'avatar'  => $value['avatar'],
                    'content' => $username . ' ' . Tool::getTimeText($value['created']) . $searchText . $value['goodsName']
                ];
            }
        }

        return $arr;
    }

    /**
     * 获取热门药品列表
     * @param int $page 页数
     * @return array
     */
    public static function getHotGoodsList($page = 0)
    {
        if ($page) {
            //列表分页
            $pageSize = Yii::$app->params['pageSize'];
            $offset = ($page - 1) * $pageSize;
        } else {
            //首页
            $pageSize = 4;
            $offset = 0;
        }

        $marketPlaceList = Tool::getMarketPlace();

        //获取热门药品列表
        $query = new Query();
        $list = $query->select(['goods.id as goodsId',
            'concat(goods.goods_name, " ", goods.en_name) as goodsName',
            'goods.goods_image as goodsImage',
            'goods.is_market as isMarket',
            'goods.market_place as marketPlace',
            'goods.clinical_stage as clinicalStage',
            'goods.medical_type as medicalType',
            'goods.drug_properties as drugProperties',
            'if(goods.drug_properties = "原研药", "#0FC8AC", "#459BF0") as drugPropertiesColor',
            'goods.risk',
            'company.id as companyId',
            'company.company_name as companyName',
            'goods.search_num as searchNum'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where(['goods.enable' => 0, 'goods.is_delete' => 0, 'goods.is_hot' => 1, 'company.enable' => 0, 'company.is_delete' => 0])
            ->orderBy([new Expression('goods.drug_properties != "原研药",goods.goods_image = "",goods.risk asc,goods.sort desc,goods.id desc')])
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['marketTag'] = $value['isMarket'] == '1' && $value['marketPlace'] && in_array($value['marketPlace'], $marketPlaceList) ? $value['marketPlace'] : '';
                $value['clinicalStage'] = $value['isMarket'] == '1' ? $value['clinicalStage'] : '';
                $value['medicalTag'] = $value['medicalType'] > 0 ? '医保' : '';
                unset($value['isMarket']);
                unset($value['marketPlace']);
                unset($value['medicalType']);
            }
        }

        return $list;
    }

    /**
     * 获取评论列表
     * @param int $uid 用户id
     * @param int $type 类型：0-所有评论，1-热门评论
     * @param string $keyword 搜索词
     * @param string $sortId 排序id
     * @param string $labelId 标签id，多个标签以,隔开
     * @param int $page 页数
     * @return array
     */
    public static function getCommentList($uid, $type, $keyword, $sortId, $labelId, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取标签名称
        $labelNameList = self::getLabelNameList($labelId);

        $commentList = Comment::findCommentList($type, $keyword, $sortId, $labelNameList, $offset, $pageSize);

        if ($commentList) {
            foreach ($commentList as $key => &$value) {
                //用户名掩码处理
                $value['username'] = $value['username'] != '微信用户' ? $value['username'] : Tool::getPhoneHide($value['mobile']);

                //评论图片
                $value['pictures'] = $value['pictures'] ? explode(',', $value['pictures']) : [];

                //判断用户有没有点赞
                $isLike = CommentLike::findUserLike($value['commentId'], $uid);
                $value['isLike'] = $isLike ? 1 : 0;
            }
        }

        return $commentList;
    }

    /**
     * 获取评论详情
     * @param int $uid 用户id
     * @param int $commentId 评论id
     * @param int $page 页数
     * @return array
     * @throws ExitException
     */
    public static function getCommentInfo($uid, $commentId, $page)
    {
        //获取评论信息
        $commentInfo = Comment::findByCommentId($commentId);

        if (!$commentInfo) Helper::responseError(1010);

        //获取评论的用户信息
        $commentUserInfo = User::findIdentity($commentInfo['uid']);

        if (!$commentUserInfo) Helper::responseError(1010);

        //判断用户有没有点赞
        $commentLike = CommentLike::findUserLike($commentId, $uid);

        $info = [
            'commentId'  => $commentInfo['id'],
            'avatar'     => $commentUserInfo['avatar'],
            'username'   => $commentUserInfo['username'] != '微信用户' ? $commentUserInfo['username'] : Tool::getPhoneHide($commentUserInfo['mobile']),
            'content'    => $commentInfo['content'],
            'pictures'   => $commentInfo['pictures'] ? explode(',', $commentInfo['pictures']) : [],
            'likeNum'    => $commentInfo['like_num'],
            'commentNum' => $commentInfo['comment_num'],
            'created'    => date('m-d', $commentInfo['created']),
            'isLike'     => $commentLike ? 1 : 0
        ];

        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取回复列表
        $query = new Query();
        $commentList = $query->select(['comment.id as commentId',
            'user.avatar',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'FROM_UNIXTIME(comment.created, "%m-%d") as created'])
            ->from('ky_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where('(comment.status = 0 or comment.status = 1) and comment.comment_id = :commentId and comment.is_delete = 0')
            ->addParams([':commentId' => $commentId])
            ->orderBy('comment.created desc,comment.id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if ($commentList) {
            foreach ($commentList as $key => &$value) {
                //用户名掩码处理
                $value['username'] = $value['username'] != '微信用户' ? $value['username'] : Tool::getPhoneHide($value['mobile']);

                //评论图片
                $value['pictures'] = $value['pictures'] ? explode(',', $value['pictures']) : [];

                //判断用户有没有点赞
                $isLike = CommentLike::findUserLike($value['commentId'], $uid);
                $value['isLike'] = $isLike ? 1 : 0;
            }
        }

        return ['info' => $info, 'commentList' => $commentList];
    }

    /**
     * 发布帖子
     * @param int $uid 用户id
     * @param string $content 评论内容
     * @param string $pictures 评论图片
     * @param int $commentId 评论id
     * @return bool
     * @throws ExitException
     */
    public static function addComment($uid, $content, $pictures, $commentId)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //相同内容不能再次发布
        $commentInfo = Comment::findSameComment($uid, $content, $commentId);

        if ($commentInfo) Helper::responseError(1036);

        //调用微信api检测内容是否合规
        UserService::checkContentSecurity($content, $userInfo['openid']);

        //开启事务
        $transaction = Comment::getDb()->beginTransaction();
        try {
            $comment = new Comment();
            $comment->uid = $uid;
            $comment->content = $content;
            $comment->pictures = $pictures ? $pictures : '';
            $comment->comment_id = $commentId;
            $comment->created = time();
            $comment->save();

            //若有评论id，该评论的评论数+1
            if ($commentId) {
                $commentInfo = Comment::findByCommentId($commentId);

                if ($commentInfo) {
                    $commentInfo->updateCounters(['comment_num' => 1]);
                }
            }

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }

    /**
     * 评论点赞
     * @param int $uid 用户id
     * @param int $commentId 评论id
     * @return bool
     * @throws ExitException
     */
    public static function addCommentLike($uid, $commentId)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //获取评论信息
        $commentInfo = Comment::findByCommentId($commentId);

        if (!$commentInfo) Helper::responseError(1010);

        //开启事务
        $transaction = CommentLike::getDb()->beginTransaction();
        try {
            //判断是否点赞
            $like = CommentLike::findUserLike($commentId, $uid);

            if ($like) {
                $like->delete();

                $commentInfo->updateCounters(['like_num' => -1]);
            } else {
                $like = new CommentLike();
                $like->uid = $uid;
                $like->comment_id = $commentId;
                $like->created = time();
                $like->save();

                $commentInfo->updateCounters(['like_num' => 1]);
            }

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }

    /**
     * 获取搜索药品列表
     * @param int $uid 用户id
     * @param string $keyword 搜索词
     * @param int $page 页数
     * @return array
     */
    public static function getSearchGoodsList($uid, $keyword, $page)
    {
        if (!is_string($keyword) || $keyword == 'undefined' || $keyword == 'object Object') return [];

        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        $marketPlaceList = Tool::getMarketPlace();

        //保存搜索记录
        self::saveSearchLog($uid, $keyword);

        //搜索条件
        $condition = 'goods.enable = 0 and goods.is_delete = 0 and company.enable = 0 and company.is_delete = 0';
        $params = [':keyword' => '%' . $keyword . '%'];

        //若关键词关于分类的
        $classList = GoodsClass::findAllByKeyword($keyword);

        $classId = [];

        if ($classList) {
            foreach ($classList as $c => $l) {
                $classId[] = $l['id'];
            }
        }

        if (!empty($classId)) {
            $condition .= ' and (goods.goods_name like :keyword or goods.en_name like :keyword or goods.common_name like :keyword or goods.other_name like :keyword or company.company_name like :keyword or goods.class_id in (' . implode(',', $classId) . '))';
        } else {
            $condition .= ' and (goods.goods_name like :keyword or goods.en_name like :keyword or goods.common_name like :keyword or goods.other_name like :keyword or company.company_name like :keyword)';
        }

        //获取药品列表
        $query = new Query();
        $list = $query->select(['goods.id as goodsId',
            'concat(goods.goods_name, " ", goods.en_name) as goodsName',
            'goods.goods_image as goodsImage',
            'goods.is_market as isMarket',
            'goods.market_place as marketPlace',
            'goods.clinical_stage as clinicalStage',
            'goods.medical_type as medicalType',
            'goods.drug_properties as drugProperties',
            'if(goods.drug_properties = "原研药", "#0FC8AC", "#459BF0") as drugPropertiesColor',
            'goods.risk',
            'company.id as companyId',
            'company.company_name as companyName',
            'goods.search_num as searchNum'])
            ->from('ky_goods as goods')
            ->innerJoin('ky_company as company', 'company.id = goods.company_id')
            ->where($condition)
            ->addParams($params)
            ->orderBy([new Expression('goods.drug_properties != "原研药",goods.goods_image = "",goods.risk asc,goods.sort desc,goods.id desc')])
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                //记录药品搜索次数
                $value['searchNum'] = $value['searchNum'] + 1;

                $goodsInfo = Goods::findGoodsDetail($value['goodsId']);

                if ($goodsInfo) {
                    $goodsInfo->updateCounters(['search_num' => 1]);
                }

                $value['marketTag'] = $value['isMarket'] == '1' && $value['marketPlace'] && in_array($value['marketPlace'], $marketPlaceList) ? $value['marketPlace'] : '';
                $value['clinicalStage'] = $value['isMarket'] == '1' ? $value['clinicalStage'] : '';
                $value['medicalTag'] = $value['medicalType'] > 0 ? '医保' : '';
                unset($value['isMarket']);
                unset($value['marketPlace']);
                unset($value['medicalType']);
            }
        }

        return $list;
    }

    /**
     * 保存搜索记录
     * @param int $uid 用户id
     * @param string $keyword 搜索词
     * @return bool
     */
    public static function saveSearchLog($uid, $keyword)
    {
        if (!$keyword) return false;

        $time = time();

        $search = new Search();
        $search->uid = (int)$uid;
        $search->word = $keyword;
        $search->created = $time;

        if (!$search->save()) return false;

        //获取热门搜索词统计信息
        $hotInfo = Hot::findByKeyword($keyword);

        if ($hotInfo) {
            $hotInfo->search_num = $hotInfo['search_num'] + 1;
            $hotInfo->updated = $time;
        } else {
            $hotInfo = new Hot();
            $hotInfo->word = $keyword;
            $hotInfo->search_num = 1;
            $hotInfo->created = $time;
        }

        return $hotInfo->save();
    }

    /**
     * 获取热门搜索词列表
     * @return array
     */
    public static function getHotWordList()
    {
        $query = new Query();
        return $query->select(['word'])
            ->from('ky_hot')
            ->orderBy('search_num desc,id desc')
            ->offset(0)
            ->limit(4)
            ->all();
    }

    /**
     * 获取联想词列表
     * @param string $keyword 搜索词
     * @param int $page 页数
     * @return array
     */
    public static function getAssociateWordList($keyword, $page)
    {
        if (!is_string($keyword) || $keyword == 'undefined' || $keyword == 'object Object') return [];

        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取联想词列表
//        $query = new Query();
//        return $query->select(['word'])
//            ->from('ky_associate_word')
//            ->where('word like :keyword')
//            ->addParams([':keyword' => '%' . $keyword . '%'])
//            ->orderBy('sort desc,id desc')
//            ->all();
        $query = new Query();
        return $query->select(['distinct(goods_name) as word'])
            ->from('ky_goods')
            ->where('enable = 0 and is_delete = 0 and (goods_name like :keyword or en_name like :keyword or common_name like :keyword or other_name like :keyword)')
            ->addParams([':keyword' => '%' . $keyword . '%'])
            ->orderBy('sort desc,id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();
    }

    /**
     * 获取排序条件列表
     */
    public static function getSortByList()
    {
        return Tool::getSortCondition();
    }

    /**
     * 获取标签列表
     */
    public static function getLabelList()
    {
        $query = new Query();
        return $query->select(['id as labelId', 'name'])
            ->from('ky_label')
            ->where(['is_hot' => 1])
            ->orderBy('sort desc,id desc')
            ->all();
    }

    /**
     * 获取资讯列表
     * @param int $uid 用户id
     * @param string $keyword 搜索词
     * @param string $sortId 排序id
     * @param string $labelId 标签id，多个标签以,隔开
     * @param int $page 页数
     * @return array
     */
    public static function getArticleList($uid, $keyword, $sortId, $labelId, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取标签名称
        $labelNameList = self::getLabelNameList($labelId);

        //获取资讯列表
        $keyword = Tool::filterGoodsName($keyword);
        $articleList = Article::findArticleList($keyword, $sortId, $labelNameList, $offset, $pageSize);

        if ($articleList) {
            foreach ($articleList as $key => &$value) {
                //标签名称
                $value['label'] = $value['label'] ? explode(',', $value['label']) : [];

                //时间文案
                $value['created'] = Tool::getTimeText($value['created']);

                //判断用户有没有点赞
                $isLike = ArticleLike::findUserLike($value['articleId'], $uid);
                $value['isLike'] = $isLike ? 1 : 0;
            }
        }

        return $articleList;
    }

    /**
     * 获取资讯详情
     * @param int $uid 用户id
     * @param int $articleId 资讯id
     * @param int $page 页数
     * @return array
     * @throws ExitException
     */
    public static function getArticleInfo($uid, $articleId, $page)
    {
        //获取资讯信息
        $articleInfo = Article::findByArticleId($articleId);

        if (!$articleInfo) Helper::responseError(1044);

        //获取资讯的用户信息
        $articleUserInfo = User::findIdentity($articleInfo['uid']);

        if (!$articleUserInfo) Helper::responseError(1044);

        //判断用户有没有点赞
        $articleLike = ArticleLike::findUserLike($articleId, $uid);

        //默认信息
        $defaultUser = Yii::$app->params['defaultUser'];

        $info = [
            'articleId'  => $articleInfo['id'],
            'avatar'     => $defaultUser['avatar'],
            'username'   => $defaultUser['platform'],
            'title'      => $articleInfo['title'],
            'label'      => $articleInfo['label'] ? explode(',', $articleInfo['label']) : [],
            'content'    => $articleInfo['content'],
            'likeNum'    => $articleInfo['like_num'],
            'commentNum' => $articleInfo['comment_num'],
            'created'    => Tool::getTimeText($articleInfo['created']),
            'isLike'     => $articleLike ? 1 : 0
        ];

        if ($page == 1) {
            //资讯阅读数+1
            $articleInfo->updateCounters(['read_num' => 1]);
        }

        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取资讯评论列表
        $query = new Query();
        $commentList = $query->select(['comment.id as commentId',
            'user.avatar',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'FROM_UNIXTIME(comment.created, "%m-%d") as created'])
            ->from('ky_article_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where('(comment.status = 0 or comment.status = 1) and comment.article_id = :articleId and comment.is_delete = 0')
            ->addParams([':articleId' => $articleId])
            ->orderBy('comment.created desc,comment.id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if ($commentList) {
            foreach ($commentList as $key => &$value) {
                //用户名掩码处理
                $value['username'] = $value['username'] != '微信用户' ? $value['username'] : Tool::getPhoneHide($value['mobile']);

                //评论图片
                $value['pictures'] = $value['pictures'] ? explode(',', $value['pictures']) : [];

                //判断用户有没有点赞
                $isLike = ArticleCommentLike::findUserLike($value['commentId'], $uid);
                $value['isLike'] = $isLike ? 1 : 0;
            }
        }

        return ['info' => $info, 'commentList' => $commentList];
    }

    /**
     * 获取标签名称列表
     * @param string $labelId 标签id，多个标签以,隔开
     * @return array
     */
    public static function getLabelNameList($labelId)
    {
        $idList = $labelId ? explode(',', $labelId) : [];

        if (empty($idList)) return [];

        $query = new Query();
        $list = $query->select(['name'])
            ->from('ky_label')
            ->where(['in', 'id', $idList])
            ->all();

        $arr = [];
        if (!empty($list)) {
            foreach ($list as $key => $value) {
                $arr[] = $value['name'];
            }
        }

        return $arr;
    }

    /**
     * 获取资讯热门搜索词列表
     * @return array
     */
    public static function getArticleHotWordList()
    {
        //获取热门词列表
        $query = new Query();
        return $query->select(['word'])
            ->from('ky_article_word')
            ->orderBy('sort desc,id desc')
            ->all();
    }

    /**
     * 资讯发布帖子
     * @param int $uid 用户id
     * @param int $articleId 资讯id
     * @param string $content 评论内容
     * @param string $pictures 评论图片
     * @return bool
     * @throws ExitException
     */
    public static function addArticleComment($uid, $articleId, $content, $pictures)
    {
        //获取资讯信息
        $articleInfo = Article::findByArticleId($articleId);

        if (!$articleInfo) Helper::responseError(1044);

        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //相同内容不能再次发布
        $commentInfo = ArticleComment::findSameComment($uid, $articleId, $content);

        if ($commentInfo) Helper::responseError(1036);

        //调用微信api检测内容是否合规
        UserService::checkContentSecurity($content, $userInfo['openid']);

        //开启事务
        $transaction = Comment::getDb()->beginTransaction();
        try {
            $comment = new ArticleComment();
            $comment->uid = $uid;
            $comment->article_id = $articleId;
            $comment->content = $content;
            $comment->pictures = $pictures ? $pictures : '';
            $comment->created = time();
            $comment->save();

            //资讯评论数+1
            $articleInfo->updateCounters(['comment_num' => 1]);

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }

    /**
     * 资讯点赞
     * @param int $uid 用户id
     * @param int $articleId 资讯id
     * @return bool
     * @throws ExitException
     */
    public static function addArticleLike($uid, $articleId)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //获取资讯信息
        $articleInfo = Article::findByArticleId($articleId);

        if (!$articleInfo) Helper::responseError(1044);

        //开启事务
        $transaction = CommentLike::getDb()->beginTransaction();
        try {
            //判断是否点赞
            $like = ArticleLike::findUserLike($articleId, $uid);

            if ($like) {
                $like->delete();

                $articleInfo->updateCounters(['like_num' => -1]);
            } else {
                $like = new ArticleLike();
                $like->uid = $uid;
                $like->article_id = $articleId;
                $like->created = time();
                $like->save();

                $articleInfo->updateCounters(['like_num' => 1]);
            }

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }

    /**
     * 资讯评论点赞
     * @param int $uid 用户id
     * @param int $commentId 评论id
     * @return bool
     * @throws ExitException
     */
    public static function addArticleCommentLike($uid, $commentId)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //获取资讯评论信息
        $commentInfo = ArticleComment::findByCommentId($commentId);

        if (!$commentInfo) Helper::responseError(1010);

        //开启事务
        $transaction = CommentLike::getDb()->beginTransaction();
        try {
            //判断是否点赞
            $like = ArticleCommentLike::findUserLike($commentId, $uid);

            if ($like) {
                $like->delete();

                $commentInfo->updateCounters(['like_num' => -1]);
            } else {
                $like = new ArticleCommentLike();
                $like->uid = $uid;
                $like->article_comment_id = $commentId;
                $like->created = time();
                $like->save();

                $commentInfo->updateCounters(['like_num' => 1]);
            }

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }
}
