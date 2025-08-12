<?php

namespace common\components;

use WXBizDataCrypt;

require_once "../../common/extensions/xiaochengxu/wxBizDataCrypt.php";

class WxCrypt
{
    /**
     * 获取数据
     * @param string $appid appid
     * @param string $sessionKey 密钥
     * @param string $encryptedData 加密数据
     * @param string $iv 初始向量
     * @return array
     */
    public static function getWxPhone($appid, $sessionKey, $encryptedData, $iv)
    {
        $pc = new WXBizDataCrypt($appid, $sessionKey);
        $errCode = $pc->decryptData($encryptedData, $iv, $data);

        if ($errCode != 0) {
            return ['code' => 1, 'data' => $errCode];
        }

        return ['code' => 0, 'data' => $data];
    }
}
