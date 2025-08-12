<?php
return [
    'adminEmail' => 'admin@example.com',
    'cryptResponse' => false,
    'checkSign' => false,
    'signKey' => 'bd12b7c7f6bd92ea8c93cfc17522d3ae',
    'pageSize' => 20,
    'applets' => [
        'appid' => 'wx5a0fc3c52d4ff72c',
        'appsecret' => '7cf4d40a3afd2ebcfd4e91d9049ca97d',
        'code2Session' => 'https://api.weixin.qq.com/sns/jscode2session',
        'accessToken' => 'https://api.weixin.qq.com/cgi-bin/token',
        'wxacodeun' => 'https://api.weixin.qq.com/wxa/getwxacodeunlimit',
        'getUserPhone' => 'https://api.weixin.qq.com/wxa/business/getuserphonenumber',
        'msgSecCheck' => 'https://api.weixin.qq.com/wxa/msg_sec_check',
        'scanQRCode' => 'https://api.weixin.qq.com/cv/img/qrcode',
    ],
    'defaultUser' => [
        'username' => '小康君',
        'platform' => '识药查真伪',
        'avatar' => 'https://shiyao.yaojk.com.cn/uploads/avatar/20230110/1673363728.png',
    ]
];
