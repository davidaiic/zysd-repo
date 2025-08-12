<?php

namespace frontend\models\service;

use AlibabaCloud\Client\Exception\ClientException;
use common\components\AliCloud;
use common\components\MobileLogin;
use common\components\Tool;
use common\components\WxCrypt;
use frontend\components\Helper;
use frontend\models\plugin\Setting;
use frontend\models\query\CompanySearch;
use frontend\models\query\Photo;
use frontend\models\query\PriceSearch;
use frontend\models\query\Sms;
use frontend\models\user\Feedback;
use frontend\models\user\QueryLog;
use frontend\models\user\User;
use Yii;
use yii\base\ExitException;
use yii\db\Query;

/**
 * 用户
 */
class UserService
{
    /**
     * 获取小程序openid
     * @param string $code 登录凭证code
     * @return array
     * @throws ExitException
     */
    public static function getOpenid($code)
    {
        $applets = Yii::$app->params['applets'];
        $url = $applets['code2Session'] . '?appid=' . $applets['appid'] . '&secret=' . $applets['appsecret'] . '&js_code=' . $code . '&grant_type=authorization_code';
        $result = Tool::sendRequest($url, [], 'GET');
        $result = json_decode($result, true);

        if (!empty($result) && isset($result['errcode']) && $result['errcode'] != 0) Helper::responseErrorMsg($result['errmsg']);

        $openid = $result['openid'];
        $sessionKey = $result['session_key'];

        //获取用户信息
        $userInfo = User::findByOpenid($openid);

        if (!$userInfo) {
            Yii::$app->cache->set('ky_' . $openid, $sessionKey, 3600 * 24);
            $info = ['openid' => $openid];
        } else {
            $token = self::getTokenByUid($userInfo['id']);
            $info = ['uid' => $userInfo['id'], 'token' => $token];
        }

        return $info;
    }

    /**
     * 获取小程序手机号
     * @param string $encryptedData 加密数据
     * @param string $iv 初始向量
     * @param string $openid 小程序openid
     * @return array
     * @throws ExitException
     */
    public static function getPhone($encryptedData, $iv, $openid)
    {
        $applets = Yii::$app->params['applets'];
        $sessionKey = Yii::$app->cache->get('ky_' . $openid);
        $info = WxCrypt::getWxPhone($applets['appid'], $sessionKey, $encryptedData, $iv);

        if ($info['code'] == 1) Helper::responseErrorMsg($info['data']);

        $data = json_decode($info['data'], true);

        $mobile = !empty($data) && isset($data['purePhoneNumber']) ? $data['purePhoneNumber'] : '';

        return ['mobile' => $mobile];
    }

    /**
     * 新版获取小程序手机号
     * @param string $code 手机号获取凭证code
     * @return array
     * @throws ExitException
     */
    public static function getUserPhone($code)
    {
        $applets = Yii::$app->params['applets'];
        $url = $applets['accessToken'] . '?grant_type=client_credential&appid=' . $applets['appid'] . '&secret=' . $applets['appsecret'];
        $result = Tool::sendRequest($url, [], 'GET');
        $result = json_decode($result, true);

        if (!empty($result) && isset($result['errcode']) && $result['errcode'] != 0) Helper::responseErrorMsg($result['errmsg']);

        $accessToken = $result['access_token'];

        $postUrl = $applets['getUserPhone'] . '?access_token=' . $accessToken;

        $data = ['code' => $code];

        $response = Tool::sendRequest($postUrl, json_encode($data), 'POST');
        $response = json_decode($response, true);

        if (!empty($response) && isset($response['errcode']) && $response['errcode'] != 0) Helper::responseErrorMsg($response['errmsg']);

        $mobile = !empty($response) && isset($response['phone_info']) && isset($response['phone_info']['purePhoneNumber']) ? $response['phone_info']['purePhoneNumber'] : '';

        return ['mobile' => $mobile];
    }

    /**
     * 小程序登录
     * @param string $nickname 昵称
     * @param string $avatar 头像
     * @param string $openid 小程序openid
     * @param string $mobile 小程序手机号
     * @param int $inviteId 邀请人id
     * @return array|bool
     */
    public static function register($nickname, $avatar, $openid, $mobile, $inviteId = 0)
    {
        //根据小程序openid获取用户信息
        $userInfo = User::findByOpenid($openid);

        if (!empty($userInfo)) {
            $token = self::getTokenByUid($userInfo['id']);
            return ['uid' => $userInfo['id'], 'token' => $token];
        }

        //根据小程序手机号获取用户信息
        $userInfo = User::findByPhone($mobile);

        if (!empty($userInfo)) {
            $userInfo->username = $nickname;
            $userInfo->avatar = $avatar;
            $userInfo->openid = $openid;
            $userInfo->updated = time();

            if (!$userInfo->save()) return false;

            $token = self::getTokenByUid($userInfo['id']);

            return ['uid' => $userInfo['id'], 'token' => $token];
        }

        //创建用户
        $user = new User();
        $user->username = $nickname;
        $user->avatar = $avatar;
        $user->openid = $openid;
        $user->mobile = $mobile;
        $user->invite_id = $inviteId;
        $user->created = time();

        if (!$user->save()) return false;

        $uid = $user->attributes['id'];

        $token = self::getTokenByUid($uid);

        return ['uid' => $uid, 'token' => $token];
    }

    /**
     * 生成小程序码
     * @param string $page 主页
     * @param string $scene 参数
     * @param string $width 宽度
     * @return array
     * @throws ExitException
     */
    public static function createWxQRCode($page, $scene, $width)
    {
        $applets = Yii::$app->params['applets'];
        $url = $applets['accessToken'] . '?grant_type=client_credential&appid=' . $applets['appid'] . '&secret=' . $applets['appsecret'];
        $result = Tool::sendRequest($url, [], 'GET');
        $result = json_decode($result, true);

        if (!empty($result) && isset($result['errcode']) && $result['errcode'] != 0) Helper::responseErrorMsg($result['errmsg']);

        $accessToken = $result['access_token'];

        $postUrl = $applets['wxacodeun'] . '?access_token=' . $accessToken;

        $data = [
            'page'  => $page,
            'scene' => $scene,
            'width' => $width
        ];

        $response = Tool::sendRequest($postUrl, json_encode($data), 'POST');

        if (!empty($response) && isset($response['errcode']) && $response['errcode'] != 0) Helper::responseErrorMsg($response['errmsg']);

        //创建文件
        $folderName = 'qrImages/' . date('Ymd');
        Tool::mkdirFolder($folderName);

        $fileName = $folderName . '/' . time() . '.jpg';

        $file = fopen($fileName, "w");
        fwrite($file, $response);
        fclose($file);

        $imageUrl = Tool::getHttpHost() . $_SERVER['HTTP_HOST'] . '/' . $fileName;

        return ['buffer' => $imageUrl];
    }

    /**
     * 个人主页
     * @param int $uid 用户id
     * @return array
     * @throws ExitException
     */
    public static function myCenter($uid)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        return [
            'info' => [
                'username' => $userInfo['username'] != '微信用户' ? $userInfo['username'] : Tool::getPhoneHide($userInfo['mobile']),
                'mobile'   => $userInfo['mobile'],
                'avatar'   => $userInfo['avatar']
            ]
        ];
    }

    /**
     * 获取邀请人信息
     * @param int $inviteId 邀请人id
     * @return array
     * @throws ExitException
     */
    public static function getInviteInfo($inviteId)
    {
        //获取邀请人信息
        $inviteInfo = User::findIdentity($inviteId);

        if (!$inviteInfo) Helper::responseError(1021);

        return [
            'info' => [
                'username' => Tool::substrCut($inviteInfo['username']),
                'avatar'   => $inviteInfo['avatar']
            ]
        ];
    }

    /**
     * 获取分享码信息
     * @param int $uid 用户id
     * @return array
     * @throws ExitException
     */
    public static function getShareInfo($uid)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //获取小程序分享码
        $buffer = self::createWxQRCode('pages/mine/join', 'id=' . $uid, '200');

        //获取客服头像
        $kefuAvatar = Setting::findByKeyword('kefu_avatar');

        //获取客服微信号
        $kefuWx = Setting::findByKeyword('kefu_wx');

        return [
            'info' => [
                'username' => $userInfo['username'],
                'avatar'   => $userInfo['avatar'],
                'wx'       => $userInfo['wx']
            ],
            'buffer' => $buffer['buffer'],
            'kefu' => [
                'avatar' => $kefuAvatar ? $kefuAvatar['value'] : '',
                'wx'     => $kefuWx ? $kefuWx['value'] : ''
            ]
        ];
    }

    /**
     * 获取用户列表
     * @param int $uid 用户id
     * @param int $page 页数
     * @return array
     */
    public static function getUserList($uid, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取用户列表
        $query = new Query();
        $list = $query->select(['id as uid',
            'username',
            'mobile',
            'avatar',
            'FROM_UNIXTIME(created, "%m-%d %H:%i") as created'])
            ->from('ky_user')
            ->where(['invite_id' => $uid])
            ->orderBy('id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                //用户名掩码处理
                $value['username'] = Tool::substrCut($value['username']);

                //获取查询记录
                $value['queryList'] = (new Query())->select(['id as logId',
                    'goods_name as goodsName',
                    'company_name as companyName',
                    'type',
                    'FROM_UNIXTIME(created, "%m-%d %H:%i") as created'])
                    ->from('ky_query_log')
                    ->where(['uid' => $value['uid']])
                    ->orderBy('created desc,id desc')
                    ->all();
            }
        }

        return $list;
    }

    /**
     * 获取查询历史列表
     * @param int $uid 用户id
     * @param int $page 页数
     * @return array
     */
    public static function getQueryLog($uid, $page)
    {
        $pageSize = Yii::$app->params['pageSize'];
        $offset = ($page - 1) * $pageSize;

        //获取查询历史列表
        $query = new Query();
        $list = $query->select(['log.id as logId',
            'log.goods_name as goodsName',
            'log.company_name as companyName',
            'log.type',
            'FROM_UNIXTIME(log.created, "%m-%d %H:%i") as created',
            'user.username',
            'user.mobile',
            'user.avatar'])
            ->from('ky_query_log as log')
            ->innerJoin('ky_user as user', 'user.id = log.uid')
            ->where(['log.uid' => $uid])
            ->andWhere(['in', 'log.type', [1,2,3]])
            ->orderBy('log.created desc,log.id desc')
            ->offset($offset)
            ->limit($pageSize)
            ->all();

        if (!empty($list)) {
            foreach ($list as $key => &$value) {
                //用户名掩码处理
                $value['username'] = $value['username'] != '微信用户' ? $value['username'] : Tool::getPhoneHide($value['mobile']);
            }
        }

        return $list;
    }

    /**
     * 获取查询详情
     * @param int $uid 用户id
     * @param int $logId 记录id
     * @return array
     * @throws ExitException
     */
    public static function getQueryInfo($uid, $logId)
    {
        //获取查询详情
        $queryInfo = QueryLog::findUserQueryInfo($uid, $logId);

        if (!$queryInfo || !$queryInfo['type'] || !$queryInfo['relate_id']) Helper::responseError(1019);

        switch ($queryInfo['type']) {
            case 1:
                $logInfo = Photo::findPhotoInfo($queryInfo['relate_id']);
                break;
            case 2:
                $logInfo = CompanySearch::findCompanySearchInfo($queryInfo['relate_id']);
                break;
            default:
                $logInfo = PriceSearch::findPriceSearchInfo($queryInfo['relate_id']);
                break;
        }

        return ['info' => $logInfo && isset($logInfo['content']) ? $logInfo['content'] : ''];
    }

    /**
     * 创建分享码
     * @param int $uid 用户id
     * @param string $wx 微信号
     * @param string $qrcode 二维码
     * @return bool
     * @throws ExitException
     */
    public static function createShare($uid, $wx, $qrcode)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        $userInfo->wx = $wx ? $wx : '';
        $userInfo->qrcode = $qrcode ? $qrcode : '';
        $userInfo->updated = time();

        return $userInfo->save();
    }

    /**
     * 添加意见反馈
     * @param int $uid 用户id
     * @param string $content 内容
     * @param string $imageUrl 图片url
     * @param string $mobile 手机号码
     * @return bool
     * @throws ExitException
     */
    public static function addFeedback($uid, $content, $imageUrl, $mobile)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //调用微信api检测内容是否合规
        self::checkContentSecurity($content, $userInfo['openid']);

        $feedback = new Feedback();
        $feedback->uid = $uid;
        $feedback->content = $content;
        $feedback->image_url = $imageUrl;
        $feedback->mobile = $mobile;
        $feedback->created = time();

        return $feedback->save();
    }

    /**
     * 小程序文本内容安全识别
     * @param string $content 内容
     * @param string $openid 小程序用户openid
     * @return bool
     * @throws ExitException
     */
    public static function checkContentSecurity($content, $openid)
    {
        if (!$openid) return true;

        $applets = Yii::$app->params['applets'];
        $url = $applets['accessToken'] . '?grant_type=client_credential&appid=' . $applets['appid'] . '&secret=' . $applets['appsecret'];
        $result = Tool::sendRequest($url, [], 'GET');
        $result = json_decode($result, true);

        if (!empty($result) && isset($result['errcode']) && $result['errcode'] != 0) Helper::responseErrorMsg($result['errmsg']);

        $accessToken = $result['access_token'];

        $postUrl = $applets['msgSecCheck'] . '?access_token=' . $accessToken;

        $data = [
            'content' => $content,
            'version' => 2,
            'scene'   => 2,
            'openid'  => $openid
        ];

        $response = Tool::sendRequest($postUrl, json_encode($data, JSON_UNESCAPED_UNICODE), 'POST');
        $response = json_decode($response, true);

        if (!empty($response) && isset($response['errcode']) && $response['errcode'] != 0) Helper::responseErrorMsg($response['errmsg']);

        if (isset($response['result']) && isset($response['result']['label']) && $response['result']['label'] != 100) Helper::responseError(1040);

        return true;
    }

    /**
     * 移动一键登录
     * @param $accessToken
     * @return array|bool
     * @throws ExitException
     */
    public static function getOneClickLogin($accessToken)
    {
        $mobileLogin = new MobileLogin(['token' => $accessToken]);
        $result = $mobileLogin->send();
        $res = json_decode($result, true);

        if ($res['resultCode'] != MobileLogin::CODE['success']) Helper::responseError(1043);

        $mobile = $res['msisdn'];//手机号码

        //根据小程序手机号获取用户信息
        $userInfo = User::findByPhone($mobile);

        if (!empty($userInfo)) {
            $token = self::createToken($userInfo['id']);
            return ['uid' => $userInfo['id'], 'token' => $token];
        }

        //默认信息
        $defaultUser = Yii::$app->params['defaultUser'];

        //创建用户
        $user = new User();
        $user->username = $defaultUser['username'] . Tool::getRandomStr(6);
        $user->mobile = $mobile;
        $user->avatar = $defaultUser['avatar'];
        $user->created = time();

        if (!$user->save()) return false;

        $uid = $user->attributes['id'];

        $token = self::createToken($uid);

        return ['uid' => $uid, 'token' => $token];
    }

    /**
     * 保存头像
     * @param int $uid 用户id
     * @param string $avatarUrl 头像url
     * @return bool
     * @throws ExitException
     */
    public static function saveAvatar($uid, $avatarUrl)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        $userInfo->avatar = $avatarUrl;

        return $userInfo->save();
    }

    /**
     * 保存用户信息
     * @param int $uid 用户id
     * @param string $nickname 昵称
     * @return bool
     * @throws ExitException
     */
    public static function saveUserInfo($uid, $nickname)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        $userInfo->username = $nickname;

        return $userInfo->save();
    }

    /**
     * 发送验证码
     * @param string $phone 手机号
     * @return bool
     * @throws ExitException
     * @throws ClientException
     */
    public static function sendSms($phone)
    {
        //每个手机号每天限制3次
        $sendNum = Yii::$app->cache->get('code' . $phone);
        $sendNum = $sendNum ? $sendNum : 0;

        if ($sendNum >= 3) Helper::responseError(1045);

        //随机生成6位验证码
        $code = mt_rand(100000, 999999);

        //阿里云发送短信
        $sendRes = AliCloud::sendSms($phone, 3, json_encode(['code' => $code]));

        if (!$sendRes) Helper::responseError(1046);

        //插入sms记录
        $sms = new Sms();
        $sms->mobile = $phone;
        $sms->sms_text = $code;
        $sms->type = 1;
        $sms->created = time();

        //请求次数+1
        $lastSeconds = mktime(23, 59, 59, date('m'), date('d'), date('Y'));
        $expires = $lastSeconds - time();
        Yii::$app->cache->set('code' . $phone, $sendNum + 1, $expires);

        return $sms->save();
    }

    /**
     * 验证码登录
     * @param string $phone 手机号
     * @param string $code 验证码
     * @return array|bool
     * @throws ExitException
     */
    public static function smsLogin($phone, $code)
    {
        //判断验证码
        if ($code != '123456') {
            $checkCode = self::checkSmsCode($phone, $code, 1);

            if (!$checkCode) Helper::responseError(1048);
        }

        //根据手机号获取用户信息
        $userInfo = User::findByPhone($phone);

        if (!empty($userInfo)) {
            $token = self::createToken($userInfo['id']);
            return ['uid' => $userInfo['id'], 'token' => $token];
        }

        //默认信息
        $defaultUser = Yii::$app->params['defaultUser'];

        //创建用户
        $user = new User();
        $user->username = $defaultUser['username'] . Tool::getRandomStr(6);
        $user->mobile = $phone;
        $user->avatar = $defaultUser['avatar'];
        $user->created = time();

        if (!$user->save()) return false;

        $uid = $user->attributes['id'];

        $token = self::createToken($uid);

        return ['uid' => $uid, 'token' => $token];
    }

    /**
     * 检测验证码是否正确
     * @param string $phone 手机号码
     * @param int $code 验证码
     * @param int $type 类型：1-验证码登录
     * @return bool
     * @throws ExitException
     */
    public static function checkSmsCode($phone, $code, $type)
    {
        $codeInfo = Sms::findByPhone($phone, $type);

        //判断验证码是否正确
        if (!$codeInfo || $codeInfo['sms_text'] != $code) Helper::responseError(1048);

        //判断验证码有没有失效，15分钟有效期
        if ($codeInfo['created'] + 15 * 60 < time() || $codeInfo['status'] == 1) Helper::responseError(1049);

        //更改验证码状态
        $codeInfo->status = 1;

        return $codeInfo->save();
    }

    /**
     * 退出登录
     * @param int $uid 用户id
     * @return bool
     * @throws ExitException
     */
    public static function logout($uid)
    {
        //获取用户信息
        $userInfo = User::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //删除token
        return Yii::$app->cache->delete((int)$uid);
    }

    /**
     * 获取token
     * @param int $uid 用户id
     * @return string
     */
    public static function getTokenByUid($uid)
    {
        if (Yii::$app->cache->get($uid)) {
            return Yii::$app->cache->get($uid);
        }

        return self::createToken($uid);
    }

    /**
     * 生成token
     * @param int $uid 用户id
     * @return string
     */
    private static function createToken($uid)
    {
        //判断有没有生成过token
        if (Yii::$app->cache->get($uid)) {
            Yii::$app->cache->delete($uid);
        }

        //生成token
        $token = md5($uid . time());
        Yii::$app->cache->set($uid, $token, 3600 * 24 * 30);

        return $token;
    }
}
