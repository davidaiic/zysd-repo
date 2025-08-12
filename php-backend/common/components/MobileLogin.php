<?php

namespace common\components;

use Yii;

class MobileLogin
{
    private $appId = null;

    private $appKey = null;

    private $appSecret = null;

    private $appUrl = null;

    private $options = null;

    private $str = 'zhangshangyaodian@.';

    const CODE = [
        'success' => '103000'
    ];

    /**
     * 初始化
     * @param $options
     */
    public function __construct($options)
    {
        $params = Yii::$app->params['chinaMobile'];
        $this->appId = $params['appId'];
        $this->appKey = $params['appKey'];
        $this->appSecret = $params['appSecret'];
        $this->appUrl = $params['appUrl'] . 'loginTokenValidate';
        $this->options = $options;
    }

    /**
     * 初始化参数
     * @return array|string
     */
    private function initParams()
    {
        $params = [
            'version' => '2.0',
            'msgid' => md5(rand(9999, 10000) . time() . $this->str),
            'systemtime' => Tool::getMillisecond(true),
            'strictcheck' => '0', //暂时填写"0"，填写“1”时，将对服务器IP白名单进行强校验（后续将强制要求IP强校验）
            'appid' => $this->appId,
            'token' => $this->options['token'],
            'encryptionalgorithm' =>'', //推荐使用。开发者如果需要使用非对称加密算法时，填写“RSA”。（当该值不设置为“RSA”时，执行MD5签名校验）
            //当encryptionalgorithm≠"RSA"时，sign = MD5(appid +
            //version + msgid + systemtime + strictcheck + token +
            //APPSecret)（注：“+”号为合并意思，不包含在被加密的字符串
            //中），输出32位大写字母；
            //当encryptionalgorithm="RSA"，开发者使用在社区配置的验
            //签公钥（应用公钥1）对应的私钥进行签名(appid+token) ，签名
            //算法为SHA256withRSA，签名后使用hex编码。
        ];
        $sign = md5($params['appid'].$params['version'].$params['msgid'].$params['systemtime'].$params['strictcheck'].$params['token'].$this->appSecret);
        return json_encode(array_merge($params, ['sign' => $sign]));
    }

    /**
     * 发送
     * @return bool|mixed
     * inresponseto 对应的请求消息中的msgid
     * systemtime 响应消息发送的系统时间，精确到毫秒，共17位，格式：20121227180001165
     * resultCode 返回码
     * msisdn
     * 表示手机号码，如果加密方式为RSA，开发者使用在社区配置的加密公钥（应用 公钥2）对应的私钥进行解密
     * taskId 话单流水
     */
    public function send()
    {
        $params = $this->initParams();
        return Curl::init($this->appUrl, $params, true, true, true);
    }

    //    返回码 返回码描述
    //    103000 返回成功
    //    103101 签名错误
    //    103113 token格式错误
    //    103119 appid不存在
    //    103133 sourceid不合法（服务端需要使用调用SDK时使用的appid去换取号码）
    //    103211 其他错误
    //    103412 无效的请求
    //    103414 参数校验异常
    //    103511 请求ip不在社区配置的服务器白名单内
    //    103811 token为空
    //    104201 token失效或不存在
    //    105018 用户权限不足（使用了本机号码校验的token去调用本接口）
    //    105019 应用未授权（开发者社区未勾选能力）
    //    105312 套餐已用完
    //    105313 非法请求
}
