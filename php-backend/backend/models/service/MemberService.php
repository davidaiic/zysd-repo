<?php

namespace backend\models\service;

use AlibabaCloud\Client\Exception\ClientException;
use backend\components\Helper;
use common\components\AliCloud;
use common\components\Tool;
use Exception;
use frontend\models\home\Article;
use frontend\models\home\ArticleComment;
use frontend\models\home\ArticleWord;
use frontend\models\home\Comment;
use frontend\models\home\Label;
use frontend\models\plugin\Setting;
use frontend\models\query\Photo;
use frontend\models\query\Sms;
use frontend\models\user\QueryLog;
use frontend\models\user\User;
use yii\base\ExitException;
use yii\db\Query;

/**
 * 会员
 */
class MemberService
{
    /**
     * 获取会员列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getUserList($username, $mobile, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['user.id as uid',
            'user.username',
            'user.mobile',
            'user.openid',
            'user.avatar',
            'user.wx',
            'user.qrcode',
            'user.add_wx as addWx',
            'if(user.invite_id > 0, user.invite_id, "") as inviteId',
            'ifnull(invite.username, "") as inviteUsername',
            'ifnull(invite.mobile, "") as inviteMobile',
            'user.os',
            'user.version',
            'user.phoneModel',
            'if(user.created > 0, FROM_UNIXTIME(user.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_user as user')
            ->leftJoin('ky_user as invite', 'invite.id = user.invite_id');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'user.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'user.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        //获取导出数据
        $excelList = $list->orderBy('user.id desc')->all();

        $list = $list->orderBy('user.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'excelList' => $excelList, 'total' => $total];
    }

    /**
     * 会员操作
     * @param int $uid 会员id
     * @param int $addWx 是否已添加微信：0-否，1-是
     * @param int $type 类型：1-添加微信标记
     * @return bool
     * @throws ExitException
     */
    public static function dealWithUser($uid, $addWx, $type)
    {
        //获取会员信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        if ($type != 1) return false;

        $userInfo->add_wx = $addWx;

        return $userInfo->save();
    }

    /**
     * 获取评论列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $status 状态：0-待审核，1-审核通过，2-审核失败
     * @param string $isHot 是否热门评论：0-否，1-是
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getCommentList($username, $mobile, $status, $isHot, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['comment.id as commentId',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'comment.comment_num as commentNum',
            'comment.status',
            'comment.is_hot as isHot',
            'comment.sort',
            'if(comment.created > 0, FROM_UNIXTIME(comment.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where(['comment.comment_id' => 0, 'comment.is_delete' => 0]);

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($status !== '') {
            $list->andWhere(['comment.status' => $status]);
        }

        if ($isHot !== '') {
            $list->andWhere(['comment.is_hot' => $isHot]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'comment.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'comment.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('comment.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['picturesList'] = $value['pictures'] ? explode(',', $value['pictures']) : [];
                $value['pictures'] = !empty($value['picturesList']) ? $value['picturesList'][0] : '';
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 评论操作
     * @param int $commentId 评论id
     * @param int $value 内容
     * @param int $type 类型：1-审核，2-热门，3-置顶，4-删除
     * @return bool
     * @throws ExitException
     */
    public static function dealWithComment($commentId, $value, $type)
    {
        //获取评论信息
        $comment = Comment::findByCommentId($commentId);

        if (!$comment) Helper::responseError(1010);

        if ($type == 1) {
            $comment->status = $value;
        } else if ($type == 3) {
            $comment->sort = $value;
        } else if ($type == 4) {
            $comment->is_delete = 1;
        } else {
            $comment->is_hot = $value;
        }

        $comment->updated = time();

        return $comment->save();
    }

    /**
     * 获取回复列表
     * @param int $commentId 评论id
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $status 状态：0-待审核，1-审核通过，2-审核失败
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getReplyList($commentId, $username, $mobile, $status, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['comment.id as commentId',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'comment.status',
            'if(comment.created > 0, FROM_UNIXTIME(comment.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where(['comment.comment_id' => $commentId, 'comment.is_delete' => 0]);

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($status !== '') {
            $list->andWhere(['comment.status' => $status]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('comment.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['picturesList'] = $value['pictures'] ? explode(',', $value['pictures']) : [];
                $value['pictures'] = !empty($value['picturesList']) ? $value['picturesList'][0] : '';
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取搜索列表
     * @param string $word 搜索词
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getSearchList($word, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['search.id as searchId',
            'search.word',
            'ifnull(user.username, "") as username',
            'ifnull(user.mobile, "") as mobile',
            'if(search.created > 0, FROM_UNIXTIME(search.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_search as search')
            ->leftJoin('ky_user as user', 'user.id = search.uid');

        if ($word) {
            $list->andWhere(['like', 'search.word', $word]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'search.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'search.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('search.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取热门列表
     * @param string $word 搜索词
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getHotList($word, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['word',
            'search_num as searchNum',
            'if(updated > 0, FROM_UNIXTIME(updated, "%Y-%m-%d %H:%i"), "") as updated'])
            ->from('ky_hot');

        if ($word) {
            $list->andWhere(['like', 'word', $word]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('search_num desc,id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取人工核查列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $status 状态：0-待核查，1-核查通过，2-核查失败
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getManualSearchList($username, $mobile, $status, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['photo.id as photoId',
            'photo.positive',
            'photo.left_side as leftSide',
            'photo.right_side as rightSide',
            'photo.back',
            'photo.other',
            'photo.mobile',
            'photo.status',
            'photo.sms_text as smsText',
            'photo.is_sms as isSms',
            'photo.goods_name as goodsName',
            'photo.company_name as companyName',
            'ifnull(user.username, "") as username',
            'if(photo.created > 0, FROM_UNIXTIME(photo.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_photo as photo')
            ->leftJoin('ky_user as user', 'user.id = photo.uid');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['photo.mobile' => $mobile]);
        }

        if ($status !== '') {
            $list->andWhere(['photo.status' => $status]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'photo.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'photo.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('photo.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['positiveList'] = $value['positive'] ? explode(',', $value['positive']) : [];
                $value['leftSideList'] = $value['leftSide'] ? explode(',', $value['leftSide']) : [];
                $value['rightSideList'] = $value['rightSide'] ? explode(',', $value['rightSide']) : [];
                $value['backList'] = $value['back'] ? explode(',', $value['back']) : [];
                $value['otherList'] = $value['other'] ? explode(',', $value['other']) : [];
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 核查操作
     * @param int $photoId 查询id
     * @param int $status 状态：0-待核查，1-核查通过，2-核查失败
     * @param string $smsText 短信内容
     * @param string $goodsName 药品名称
     * @param string $companyName 药厂名称
     * @return bool
     * @throws ExitException
     */
    public static function checkManualSearch($photoId, $status, $smsText, $goodsName, $companyName)
    {
        $photoInfo = Photo::findPhotoInfo($photoId);

        if (!$photoInfo) Helper::responseError(1019);

        if ($status != 1) {
            $goodsName = '';
            $companyName = '';
        }

        $time = time();

        //开启事务
        $transaction = Photo::getDb()->beginTransaction();
        try {
            $photoInfo->status = $status;
            $photoInfo->sms_text = $smsText;
            $photoInfo->is_sms = 1;
            $photoInfo->goods_name = $goodsName;
            $photoInfo->company_name = $companyName;
            $photoInfo->updated = $time;
            $photoInfo->save();

            //阿里云发送短信
            if (Tool::checkPhone($photoInfo['mobile'])) {
                self::sendSmsTip($photoInfo['mobile'], $smsText, $status);
            }

            //成功的话，插入用户查询记录
            if ($status == 1) {
                $log = new QueryLog();
                $log->uid = $photoInfo['uid'];
                $log->goods_name = $goodsName;
                $log->company_name = $companyName;
                $log->type = 1;
                $log->relate_id = $photoId;
                $log->created = $time;
                $log->save();
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
     * 发送短信提示
     * @param string $mobile 手机号
     * @param string $smsText 短信内容
     * @param int $type 类型：1-通过，2-失败
     * @return bool
     * @throws ClientException
     */
    public static function sendSmsTip($mobile, $smsText, $type = 0)
    {
        if (!$type) return false;

        //阿里云发送短信
        $kefuMobile = Setting::findByKeyword('kefu_mobile');
        $phone = $kefuMobile ? $kefuMobile['value'] : '';
        $data = json_encode(['phone' => $phone]);
        AliCloud::sendSms($mobile, $type, $data);

        //记录短信内容
        $sms = new Sms();
        $sms->mobile = $mobile;
        $sms->sms_text = $smsText;
        $sms->created = time();

        return $sms->save();
    }

    /**
     * 获取防伪查询列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $companyName 药厂名称
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getCompanySearchList($username, $mobile, $companyName, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['search.id as searchId',
            'user.username',
            'user.mobile',
            'ifnull(company.company_name, "") as companyName',
            'search.code',
            'search.content',
            'search.result',
            'if(search.created > 0, FROM_UNIXTIME(search.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_company_search as search')
            ->innerJoin('ky_user as user', 'user.id = search.uid')
            ->leftJoin('ky_company as company', 'company.id = search.company_id');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($companyName) {
            $list->andWhere(['like', 'company.company_name', $companyName]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'search.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'search.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('search.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取价格查询列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $goodsName 药品名称
     * @param string $searchResult 查询结果：1-偏低，2-偏高
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getPriceSearchList($username, $mobile, $goodsName, $searchResult, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['search.id as searchId',
            'user.username',
            'user.mobile',
            'search.goods_name as goodsName',
            'search.price',
            'ifnull(company.company_name, "") as companyName',
            'ifnull(channel.channel_name, "") as channelName',
            'if(search.goods_id > 0, search.goods_id, "") as goodsId',
            'ifnull(goods.goods_name, "") as searchGoodsName',
            'ifnull(goods.min_price, "") as minPrice',
            'ifnull(goods.max_price, "") as maxPrice',
            'if(search.created > 0, FROM_UNIXTIME(search.created, "%Y-%m-%d %H:%i"), "") as created',
            'if(search.price < goods.min_price, "偏低", if(search.price > goods.max_price, "偏高", "合理")) as searchResult'])
            ->from('ky_price_search as search')
            ->innerJoin('ky_user as user', 'user.id = search.uid')
            ->leftJoin('ky_company as company', 'company.id = search.company_id')
            ->leftJoin('ky_channel as channel', 'channel.id = search.channel_id')
            ->leftJoin('ky_goods as goods', 'goods.id = search.goods_id');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($goodsName) {
            $list->andWhere(['like', 'search.goods_name', $goodsName]);
        }

        if ($searchResult == 1) {
            $list->andWhere('search.price < goods.min_price');
        } else if ($searchResult == 2) {
            $list->andWhere('search.price > goods.max_price');
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'search.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'search.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        //获取导出数据
        $excelList = $list->orderBy('search.id desc')->all();

        $list = $list->orderBy('search.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'excelList' => $excelList, 'total' => $total];
    }

    /**
     * 获取纠错类目列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $goodsName 药品名称
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getErrorDirectoryList($username, $mobile, $goodsName, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['error.id',
            'user.username',
            'user.mobile',
            'ifnull(goods.goods_name, "") as goodsName',
            'error.keywords',
            'if(error.created > 0, FROM_UNIXTIME(error.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_goods_error_directory as error')
            ->innerJoin('ky_user as user', 'user.id = error.uid')
            ->leftJoin('ky_goods as goods', 'goods.id = error.goods_id');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($goodsName) {
            $list->andWhere(['like', 'goods.goods_name', $goodsName]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'search.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'search.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('error.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        //说明书目录
        $direct = Tool::getInstrCorrespond();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['keywords'] = $value['keywords'] ? explode(',', $value['keywords']) : [];

                if (!empty($value['keywords'])) {
                    foreach ($value['keywords'] as $k => &$v) {
                        $v = $direct[$v];
                    }
                }
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取标签列表
     * @param string $name 标签名称
     * @param string $isHot 是否热门：0-否，1-是
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getLabelList($name, $isHot, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id', 'name', 'sort', 'is_hot as isHot'])
            ->from('ky_label');

        if ($name) {
            $list->andWhere(['like', 'name', $name]);
        }

        if ($isHot !== '') {
            $list->andWhere(['is_hot' => $isHot]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 标签操作
     * @param string $name 标签名称
     * @param string $sort 排序
     * @param int $isHot 是否热门：0-否，1-是
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-热门
     * @param int $id 标签id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithLabel($name, $sort, $isHot, $operateType, $id)
    {
        if ($operateType != 1) {
            $label = Label::findByLabelId($id);

            if (!$label) Helper::responseError(1055);

            $label->updated = time();

            if ($operateType == 3) {
                return $label->delete();
            }

            if ($operateType == 4) {
                $label->is_hot = $isHot;
                return $label->save();
            }
        } else {
            $label = new Label();
            $label->created = time();
        }

        $label->name = $name;
        $label->sort = $sort;
        $label->is_hot = $isHot;

        return $label->save();
    }

    /**
     * 获取所有标签
     * @return array
     */
    public static function getAllLabelList()
    {
        //获取列表
        $query = new Query();
        return $query->select(['id', 'name'])
            ->from('ky_label')
            ->orderBy('id desc')
            ->all();
    }

    /**
     * 获取资讯列表
     * @param string $title 标题
     * @param string $publishDate 发布日期
     * @param string $label 标签
     * @param string $isTop 是否置顶：0-否，1-是
     * @param string $enable 状态：0-正常，1-禁用
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getArticleList($title, $publishDate, $label, $isTop, $enable, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id as articleId',
            'title',
            'cover',
            'publish_date as publishDate',
            'label',
            'content',
            'like_num as likeNum',
            'comment_num as commentNum',
            'read_num as readNum',
            'is_top as isTop',
            'sort',
            'enable'])
            ->from('ky_article')
            ->where(['is_delete' => 0]);

        if ($title) {
            $list->andWhere(['like', 'title', $title]);
        }

        if ($publishDate) {
            $list->andWhere(['publish_date' => $publishDate]);
        }

        if ($label) {
            $list->andWhere(['like', 'label', $label]);
        }

        if ($isTop !== '') {
            $list->andWhere(['is_top' => $isTop]);
        }

        if ($enable !== '') {
            $list->andWhere(['enable' => $enable]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['label'] = $value['label'] ? explode(',', $value['label']) : [];
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 资讯操作
     * @param string $title 标题
     * @param string $cover 封面
     * @param string $publishDate 发布日期
     * @param array $label 标签
     * @param string $content 内容
     * @param int $isTop 是否置顶：0-否，1-是
     * @param string $sort 排序
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除，4-置顶，5-改变状态
     * @param $articleId
     * @return bool
     * @throws ExitException
     */
    public static function dealWithArticle($title, $cover, $publishDate, $label, $content, $isTop, $sort, $enable, $operateType, $articleId)
    {
        if ($operateType != 1) {
            $article = Article::findByArticleId($articleId);

            if (!$article) Helper::responseError(1044);

            $article->updated = time();

            if ($operateType == 3) {
                $article->is_delete = 1;
                return $article->save();
            }

            if ($operateType == 4) {
                $article->is_top = $isTop;
                return $article->save();
            }

            if ($operateType == 5) {
                $article->enable = $enable;
                return $article->save();
            }
        } else {
            $article = new Article();
            $article->uid = mt_rand(2, 10);
            $article->created = time();
        }

        $article->title = $title;
        $article->cover = $cover;
        $article->publish_date = $publishDate;
        $article->label = !empty($label) ? implode(',', $label) : '';
        $article->content = $content;
        $article->is_top = $isTop;
        $article->sort = $sort;
        $article->enable = $enable;

        return $article->save();
    }

    /**
     * 获取资讯评论列表
     * @param int $articleId 资讯id
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $status 状态：0-待审核，1-审核通过，2-审核失败
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getArticleCommentList($articleId, $username, $mobile, $status, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['comment.id as commentId',
            'user.username',
            'user.mobile',
            'comment.content',
            'comment.pictures',
            'comment.like_num as likeNum',
            'comment.status',
            'if(comment.created > 0, FROM_UNIXTIME(comment.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_article_comment as comment')
            ->innerJoin('ky_user as user', 'user.id = comment.uid')
            ->where(['comment.article_id' => $articleId, 'comment.is_delete' => 0]);

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($status !== '') {
            $list->andWhere(['comment.status' => $status]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('comment.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['picturesList'] = $value['pictures'] ? explode(',', $value['pictures']) : [];
                $value['pictures'] = !empty($value['picturesList']) ? $value['picturesList'][0] : '';
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 资讯评论操作
     * @param int $commentId 资讯评论id
     * @param int $value 内容
     * @param int $type 类型：1-审核，2-删除
     * @return bool
     * @throws ExitException
     */
    public static function dealWithArticleComment($commentId, $value, $type)
    {
        //获取评论信息
        $comment = ArticleComment::findByCommentId($commentId);

        if (!$comment) Helper::responseError(1010);

        if ($type == 2) {
            $comment->is_delete = 1;
        } else {
            $comment->status = $value;
        }

        $comment->updated = time();

        return $comment->save();
    }

    /**
     * 获取图片识别列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getImageRecognition($username, $mobile, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['image.id as imageId',
            'user.username',
            'user.mobile',
            'image.image_url as imageUrl',
            'image.keywords',
            'image.words',
            'if(image.created > 0, FROM_UNIXTIME(image.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_image_recognition as image')
            ->innerJoin('ky_user as user', 'user.id = image.uid');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'image.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'image.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('image.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['keywords'] = json_decode($value['keywords'], true);
                $value['words'] = json_decode($value['words'], true);
            }
        }

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取扫一扫列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $code 条形码
     * @param string $goodsName 药品名称
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getScanLog($username, $mobile, $code, $goodsName, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['scan.id as scanId',
            'user.username',
            'user.mobile',
            'scan.code',
            'scan.goods_id as goodsId',
            'scan.goods_name as goodsName',
            'scan.company_id as companyId',
            'scan.company_name as companyName',
            'scan.risk',
            'scan.server_name as serverName',
            'scan.link_url as linkUrl',
            'if(scan.created > 0, FROM_UNIXTIME(scan.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_scan_log as scan')
            ->innerJoin('ky_user as user', 'user.id = scan.uid');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($code) {
            $list->andWhere(['scan.code' => $code]);
        }

        if ($goodsName) {
            $list->andWhere(['like', 'scan.goods_name', $goodsName]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'scan.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'scan.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('scan.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取比价列表
     * @param string $username 用户名
     * @param string $mobile 手机号
     * @param string $goodsName 药品名称
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getComparePrice($username, $mobile, $goodsName, $beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['compare.id as compareId',
            'user.username',
            'user.mobile',
            'compare.left_goods_name as leftGoodsName',
            'compare.left_company_id as leftCompanyId',
            'compare.left_specs as leftSpecs',
            'compare.left_goods_id as leftGoodsId',
            'compare.right_goods_name as rightGoodsName',
            'compare.right_company_id as rightCompanyId',
            'compare.right_specs as rightSpecs',
            'compare.right_goods_id as rightGoodsId',
            'if(compare.created > 0, FROM_UNIXTIME(compare.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_compare_price as compare')
            ->innerJoin('ky_user as user', 'user.id = compare.uid');

        if ($username) {
            $list->andWhere(['like', 'user.username', $username]);
        }

        if ($mobile) {
            $list->andWhere(['user.mobile' => $mobile]);
        }

        if ($goodsName) {
            $list->andWhere(['or',
                ['like', 'compare.left_goods_name', $goodsName],
                ['like', 'compare.right_goods_name', $goodsName]
            ]);
        }

        if ($beginDate) {
            $list->andWhere(['>=', 'compare.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'compare.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('compare.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 获取资讯热门词列表
     * @param string $word 热门词
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getArticleWordList($word, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id', 'word', 'sort'])
            ->from('ky_article_word');

        if ($word) {
            $list->andWhere(['like', 'word', $word]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        return ['list' => $list, 'total' => $total];
    }

    /**
     * 资讯热门词操作
     * @param string $word 热门词
     * @param string $sort 排序
     * @param int $operateType 操作类型：1-添加，2-编辑，3-删除
     * @param int $id 热门词id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithArticleWord($word, $sort, $operateType, $id)
    {
        if ($operateType != 1) {
            $articleWord = ArticleWord::findByWordId($id);

            if (!$articleWord) Helper::response(201);

            if ($operateType == 3) {
                return $articleWord->delete();
            }

            $articleWord->updated = time();
        } else {
            $articleWord = new ArticleWord();
            $articleWord->created = time();
        }

        $articleWord->word = $word;
        $articleWord->sort = $sort;

        return $articleWord->save();
    }
}
