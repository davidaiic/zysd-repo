<?php
return [
    'adminEmail' => 'admin@example.com',
    'supportEmail' => 'support@example.com',
    'senderEmail' => 'noreply@example.com',
    'senderName' => 'Example.com mailer',
    'user.passwordResetTokenExpire' => 3600,
    'alicloud' => [
        'accessKeyId'     => 'ALIYUN_ACCESS_KEY_ID',
        'accessKeySecret' => 'ALIYUN_ACCESS_KEY_SECRET',
        'regionId'        => 'cn-shanghai',
        'signName'        => '识药查真伪',
        'templateCode'    => 'SMS_Code',
        'templateCode1'   => 'SMS_Code1',
        'templateCode2'   => 'SMS_Code2',
    ],
    'chinaMobile' => [
        'appId'     => '300011971395',
        'appKey'    => 'chinaMobile_KEY_ID',
        'appSecret' => 'chinaMobile_KEY_SECRET',
        'appUrl'    => 'https://www.cmpassport.com/unisdk/rsapi/'
    ],
    'tencentcloud' => [
        'secretId'  => 'tencentcloud_KEY_ID',
        'secretKey' => 'tencentcloud_KEY_SECRET'
    ],
    'barCode' => [
        'url'   => 'https://route.showapi.com/66-24',
        'appid' => 'barCode_KEY_ID',
        'sign'  => 'barCode_KEY_SECRET'
    ],
];
