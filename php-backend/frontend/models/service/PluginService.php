<?php

namespace frontend\models\service;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\plugin\AppVersion;
use frontend\models\plugin\Explain;
use frontend\models\plugin\Setting;
use frontend\models\user\User;
use Yii;
use yii\base\ExitException;
use yii\db\Query;
use yii\web\UploadedFile;

/**
 * 通用
 */
class PluginService
{
    /**
     * 图片上传
     * @param string $type 类型：photo-照片等
     * @return string
     * @throws ExitException
     */
    public static function uploadImage($type)
    {
        $image = UploadedFile::getInstanceByName('file');
        $ext = $image->getExtension();

        //允许上传的图片格式
        $mimes = Tool::getImageType();

        if (!in_array($ext, $mimes)) Helper::responseError(1007);

        //允许上传的图片大小，最大1M
        if ($image->size > 1048576) Helper::responseError(1056);

        //创建文件
        $folderName = 'uploads/' . $type . '/' . date('Ymd');
        Tool::mkdirFolder($folderName);

        $fileName = $folderName . '/' . md5(time() . rand(1, 9999)) . '.' . $ext;
        $imageUrl = Tool::getHttpHost() . $_SERVER['HTTP_HOST'] . '/' . $fileName;

        if (!$image->saveAs($fileName)) Helper::responseError(1008);

        return $imageUrl;
    }

    /**
     * 获取内容配置
     * @param string $keyword 关键词
     * @return array
     */
    public static function getContent($keyword)
    {
        $explain = Explain::findByKeyword($keyword);

        return [
            'title'   => $explain ? $explain['title'] : '',
            'content' => $explain ? str_replace(array("/r/n", "/r", "/n", "\r\n", "\r", "\n"), '', $explain['content']) : ''
        ];
    }

    /**
     * 获取客服信息
     * @param int $uid 用户id
     * @return array
     */
    public static function getKefuInfo($uid)
    {
        //获取客服头像
        $kefuAvatar = Setting::findByKeyword('kefu_avatar');
        $avatar = $kefuAvatar ? $kefuAvatar['value'] : '';

        //获取客服电话
        $kefuMobile = Setting::findByKeyword('kefu_mobile');
        $mobile = $kefuMobile ? $kefuMobile['value'] : '';

        //获取客服微信号
        $kefuWx = Setting::findByKeyword('kefu_wx');
        $wx = $kefuWx ? $kefuWx['value'] : '';

        //获取客服二维码
        $kefuQrcode = Setting::findByKeyword('kefu_qrcode');
        $qrcode = $kefuQrcode ? $kefuQrcode['value'] : '';

        //判断登录的用户是否有邀请人信息
        if ($uid) {
            $userInfo = User::findIdentity($uid);

            if ($userInfo && $userInfo['invite_id']) {
                $inviteInfo = User::findIdentity($userInfo['invite_id']);

                if ($inviteInfo) {
                    $avatar = $inviteInfo['avatar'];
                    $mobile = $inviteInfo['mobile'];
                    $wx = $inviteInfo['wx'];
                    $qrcode = $inviteInfo['qrcode'];
                }
            }
        }

        return [
            'avatar' => $avatar,
            'mobile' => $mobile,
            'wx'     => $wx,
            'qrcode' => $qrcode
        ];
    }

    /**
     * 获取联系我们
     * @return array
     */
    public static function getContactInfo()
    {
        //获取联系我们头像
        $contactAvatar = Setting::findByKeyword('contact_avatar');

        //获取联系我们微信号
        $contactWx = Setting::findByKeyword('contact_wx');

        //获取联系我们二维码
        $contactQrcode = Setting::findByKeyword('contact_qrcode');

        //获取联系我们电话图标
        $contactMobileIcon = Setting::findByKeyword('contact_mobile_icon');

        //获取联系我们电话
        $contactMobile = Setting::findByKeyword('contact_mobile');

        return [
            'avatar' => $contactAvatar ? $contactAvatar['value'] : '',
            'wx'     => $contactWx ? $contactWx['value'] : '',
            'qrcode' => $contactQrcode ? $contactQrcode['value'] : '',
            'icon'   => $contactMobileIcon ? $contactMobileIcon['value'] : '',
            'mobile' => $contactMobile ? $contactMobile['value'] : ''
        ];
    }

    /**
     * 获取h5链接列表
     */
    public static function getWebUrlList()
    {
        //获取web版本号
        $webVersionInfo = Setting::findByKeyword('web_version');
        $webVersion = $webVersionInfo ? $webVersionInfo['value'] : '';

        $query = new Query();
        return $query->select(['title', 'keyword', 'concat(link_url, "?", "' . $webVersion . '") as linkUrl'])
            ->from('ky_web_url')
            ->all();
    }

    /**
     * 获取app分享信息
     * @param int $uid 用户id
     * @param int $type 类型：1-分享评论，2-分享资讯，3-分享比价
     * @param int $thirdId 分享的数据id
     * @return array
     */
    public static function getAppShareInfo($uid, $type, $thirdId)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);
        $username = $userInfo ? $userInfo['username'] : '';

        switch ($type) {
            case 2:
                $title = $username . '分享了一篇资讯给你，赶紧点开看下吧';
                $path = '/pages/circle/zxDetail?articleId=' . $thirdId;
                break;
            case 3:
                $title = $username . '分享了相同药品不同厂家的价格对比数据，赶紧去了解一下吧';
                $path = '/pages/wybj/wybj';
                break;
            default:
                $title = $username . '分享了一个好内容给你';
                $path = '/pages/circle/detail/index?commentId=' . $thirdId;
                break;
        }

        return ['title' => $title, 'path' => $path];
    }

    /**
     * 获取关于我们信息
     */
    public static function getAboutInfo()
    {
        //下载二维码
        $qrcode = Setting::findByKeyword('download_qrcode');
        $download = $qrcode ? $qrcode['value'] : '';

        //app版本号
        $versionInfo = Setting::findByKeyword('app_version');
        $version = $versionInfo ? $versionInfo['value'] : '';

        //获取客服电话
        $kefuMobile = Setting::findByKeyword('kefu_mobile');
        $mobile = $kefuMobile ? $kefuMobile['value'] : '';

        return ['download' => $download, 'version' => $version, 'mobile' => $mobile];
    }

    /**
     * 把网络图片转存到本地
     * @param string $imageUrl 图片url
     * @param string $type 类型：photo-照片等
     * @return string
     */
    public static function changeNetImageLocal($imageUrl, $type)
    {
        $imgContent = file_get_contents($imageUrl);

        $arr = explode('.', $imageUrl);
        $ext = end($arr);

        //创建文件
        $folderName = 'uploads/' . $type . '/' . date('Ymd');
        Tool::mkdirFolder($folderName);

        $fileName = $folderName . '/' . md5(time() . rand(1, 9999)) . '.' . $ext;

        file_put_contents($fileName, $imgContent);

        return Tool::getHttpHost() . $_SERVER['HTTP_HOST'] . '/' . $fileName;
    }

    /**
     * 版本更新
     * @param int $uid 用户id
     * @param string $os 系统类型
     * @param string $version 版本号
     * @param string $phoneModel 手机型号
     * @return array
     */
    public static function getVersion($uid, $os, $version, $phoneModel)
    {
        //更新信息
        self::updateInfo($uid, $os, $version, $phoneModel);

        //获取版本更新记录
        $version = AppVersion::findByVersion($os, $version);

        $isUpdate = 0;
        $info = [];
        if ($version) {
            $isUpdate = 1;
            $info = [
                'isMust'      => $version['is_must'],
                'content'     => $version['content'],
                'downloadUrl' => $version['download_url'],
                'file'        => $version['download_url'] ? md5_file($version['download_url']) : '',
            ];
        }

        return ['isUpdate' => $isUpdate, 'info' => (object)$info];
    }

    /**
     * 更新信息
     * @param int $uid 用户id
     * @param string $os 系统类型
     * @param string $version 版本号
     * @param string $phoneModel 手机型号
     * @return bool
     */
    public static function updateInfo($uid, $os, $version, $phoneModel)
    {
        if ($uid) {
            //获取用户信息
            $userInfo = User::findIdentity($uid);

            if ($userInfo) {
                $userInfo->os = $os;
                $userInfo->version = $version;
                $userInfo->phoneModel = $phoneModel;
                $userInfo->updated = time();

                return $userInfo->save();
            }
        }

        return true;
    }
}
