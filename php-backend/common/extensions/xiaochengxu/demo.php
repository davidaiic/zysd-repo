<?php

include_once "wxBizDataCrypt.php";


$appid = 'DEMO_appid';
$sessionKey = 'DEMO_sessionKey';

$encryptedData="DEMO_EncryptedData";

$iv = 'DEMO_iv';

$pc = new WXBizDataCrypt($appid, $sessionKey);
$errCode = $pc->decryptData($encryptedData, $iv, $data );

if ($errCode == 0) {
    print($data . "\n");
} else {
    print($errCode . "\n");
}
