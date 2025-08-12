<?php

namespace backend\models\service;

use backend\components\Helper;
use common\components\Tool;
use frontend\models\home\Banner;
use frontend\models\plugin\AppVersion;
use frontend\models\plugin\Explain;
use frontend\models\plugin\Setting;
use frontend\models\plugin\WebUrl;
use yii\base\ExitException;
use yii\db\Query;

/**
 * 系统
 */
class SystemService
{
    /**
     * 获取banner列表
     * @param string $name 名称
     * @param int $type 类型：0-静态广告，1-URL广告
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getBannerList($name, $type, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id as bannerId',
            'name',
            'notes',
            'image_url as imageUrl',
            'type',
            'link_url as linkUrl',
            'sort',
            'text1',
            'text2',
            'enable'])
            ->from('ky_banner');

        if ($name) {
            $list->andWhere(['like', 'name', $name]);
        }

        if ($type !== '') {
            $list->andWhere(['type' => $type]);
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
     * banner操作
     * @param string $name 名称
     * @param string $notes 描述
     * @param string $imageUrl 图片url
     * @param int $type 类型：0-静态广告，1-URL广告
     * @param string $linkUrl 跳转链接
     * @param string $sort 排序
     * @param string $text1 文案一
     * @param string $text2 文案二
     * @param int $enable 状态：0-正常，1-禁用
     * @param int $operateType 操作类型：1-添加，2-编辑
     * @param int $bannerId bannerId
     * @return bool
     * @throws ExitException
     */
    public static function dealWithBanner($name, $notes, $imageUrl, $type, $linkUrl, $sort, $text1, $text2, $enable, $operateType, $bannerId)
    {
        if ($operateType == 2) {
            $banner = Banner::findByBannerId($bannerId);

            if (!$banner) Helper::responseError(1032);

            $banner->updated = time();
        } else {
            $banner = new Banner();
            $banner->created = time();
        }

        $banner->name = $name;
        $banner->notes = $notes;
        $banner->image_url = $imageUrl;
        $banner->type = $type;
        $banner->link_url = $linkUrl;
        $banner->sort = $sort;
        $banner->text1 = $text1;
        $banner->text2 = $text2;
        $banner->enable = $enable;

        return $banner->save();
    }

    /**
     * 获取文案列表
     * @param string $keyword 关键字
     * @param string $title 标题
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getExplainList($keyword, $title, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id as explainId',
            'keyword',
            'title',
            'content',
            'enable',
            'remark'])
            ->from('ky_explain');

        if ($keyword) {
            $list->andWhere(['like', 'keyword', $keyword]);
        }

        if ($title) {
            $list->andWhere(['like', 'title', $title]);
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
     * 文案操作
     * @param string $keyword 关键字
     * @param string $title 标题
     * @param string $content 内容
     * @param int $enable 状态：0-正常，1-禁用
     * @param string $remark 备注
     * @param int $type 操作类型：1-添加，2-编辑，3-删除，4-改变状态
     * @param int $explainId 文案id
     * @return bool|false|int
     * @throws ExitException
     */
    public static function dealWithExplain($keyword, $title, $content, $enable, $remark, $type, $explainId)
    {
        if ($type != 1) {
            $explain = Explain::findByExplainId($explainId);

            if (!$explain) Helper::responseError(1033);

            if ($type == 3) {
                return $explain->delete();
            }

            $explain->updated = time();

            if ($type == 4) {
                $explain->enable = $enable;
                return $explain->save();
            }
        } else {
            $explain = new Explain();
            $explain->created = time();
        }

        $explain->keyword = $keyword;
        $explain->title = $title;
        $explain->content = $content;
        $explain->enable = $enable;
        $explain->remark = $remark;

        return $explain->save();
    }

    /**
     * 获取app版本列表
     * @param int $platform 系统类型：1-android，2-ios
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getAppVersionList($platform, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id',
            'version_number',
            'version_code',
            'content',
            'is_must',
            'status',
            'download_url',
            'platform',
            'if(created > 0, FROM_UNIXTIME(created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_app_version');

        if ($platform !== '') {
            $list->andWhere(['platform' => $platform]);
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
     * app版本操作
     * @param int $platform 系统类型：1-android，2-ios
     * @param string $version_number 版本名称
     * @param string $version_code 版本号
     * @param string $download_url 下载地址
     * @param int $is_must 更新类型：1-非强制，2-强制更新(可取消)，3-强制更新(不可取消)
     * @param string $content 更新内容
     * @param int $status 状态：1-上线，2-下线
     * @param int $type 操作类型：1-添加，2-编辑，3-改变状态
     * @param int $id 版本id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithAppVersion($platform, $version_number, $version_code, $download_url, $is_must, $content, $status, $type, $id)
    {
        if ($type != 1) {
            $appVersion = AppVersion::findById($id);

            if (!$appVersion) Helper::responseError(1057);

            $appVersion->updated = time();

            if ($type == 3) {
                $appVersion->status = $status;
                return $appVersion->save();
            }
        } else {
            $appVersion = new AppVersion();
            $appVersion->created = time();
        }

        $appVersion->version_number = $version_number;
        $appVersion->version_code = $version_code;
        $appVersion->content = $content;
        $appVersion->is_must = $is_must;
        $appVersion->status = $status;
        $appVersion->download_url = $download_url;
        $appVersion->platform = $platform;

        return $appVersion->save();
    }

    /**
     * 获取公共配置列表
     */
    public static function getCommonSetting()
    {
        $setting = Setting::findAllSetting();

        $arr = [];
        if ($setting) {
            foreach ($setting as $key => $value) {
                $arr[] = [
                    'name'    => $value['name'],
                    'keyword' => $value['keyword'],
                    'value'   =>  $value['value']
                ];
            }
        }

        return $arr;
    }

    /**
     * 处理公共配置
     * @param string $keyword 关键字
     * @param string $value 内容
     * @return bool
     * @throws ExitException
     */
    public static function dealWithCommonSetting($keyword, $value)
    {
        $info = Setting::findByKeyword($keyword);

        if (!$info) Helper::response(201);

        $info->value = $value;

        return $info->save();
    }

    /**
     * 获取意见反馈列表
     * @param string $beginDate 开始日期
     * @param string $endDate 结束日期
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getFeedbackList($beginDate, $endDate, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['feedback.id as feedbackId',
            'feedback.content',
            'feedback.image_url as imageUrl',
            'feedback.mobile',
            'ifnull(user.username, "") as username',
            'if(feedback.created > 0, FROM_UNIXTIME(feedback.created, "%Y-%m-%d %H:%i"), "") as created'])
            ->from('ky_feedback as feedback')
            ->leftJoin('ky_user as user', 'user.id = feedback.uid');

        if ($beginDate) {
            $list->andWhere(['>=', 'feedback.created', strtotime($beginDate)]);
        }

        if ($endDate) {
            $list->andWhere(['<=', 'feedback.created', strtotime($endDate) + 24 * 3600]);
        }

        //获取总数量
        $total = $list->count();

        //获取导出数据
        $excelList = $list->orderBy('feedback.id desc')->all();

        $list = $list->orderBy('feedback.id desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                $value['imageList'] = $value['imageUrl'] ? explode(',', $value['imageUrl']) : [];
            }
        }

        return ['list' => $list, 'excelList' => $excelList, 'total' => $total];
    }

    /**
     * 获取web链接列表
     * @param string $title 标题
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getWebUrlList($title, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['id', 'title', 'keyword', 'link_url as linkUrl'])
            ->from('ky_web_url');

        if ($title) {
            $list->andWhere(['like', 'title', $title]);
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
     * web链接操作
     * @param string $title 标题
     * @param string $keyword 关键字标识
     * @param string $linkUrl 链接url
     * @param int $operateType 操作类型：1-添加，2-编辑
     * @param int $id web链接id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithWebUrl($title, $keyword, $linkUrl, $operateType, $id)
    {
        if ($operateType != 1) {
            $web = WebUrl::findByWebUrlId($id);

            if (!$web) Helper::response(201);

            $web->updated = time();
        } else {
            $web = new WebUrl();
            $web->created = time();
        }

        $web->title = $title;
        $web->keyword = $keyword;
        $web->link_url = $linkUrl;

        return $web->save();
    }
}
