<?php

namespace common\components;

use Yii;

class BarCode
{
    /**
     * 根据条形码获取药品信息
     * @param string $code 条形码
     * @return bool|string
     */
    public static function getGoodsInfo($code)
    {
        $params = Yii::$app->params['barCode'];

        $data = [
            'code'              => $code,
            'showapi_appid'     => $params['appid'],
            'showapi_timestamp' => time(),
            'showapi_sign'      => $params['sign']
        ];

        return Tool::sendRequest($params['url'], $data, 'GET');
    }
}
