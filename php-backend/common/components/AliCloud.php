<?php

namespace common\components;

use AlibabaCloud\Client\AlibabaCloud;
use AlibabaCloud\Client\Exception\ClientException;
use AlibabaCloud\Client\Exception\ServerException;
use AlibabaCloud\Dysmsapi\Dysmsapi;
use Yii;

class AliCloud
{
    /**
     * 发送短信
     * @param string $mobile 手机号
     * @param int $type 类型：1-通过，2-失败，3-发送验证码
     * @param string $data 参数，json格式
     * @return bool
     * @throws ClientException
     */
    public static function sendSms($mobile, $type, $data)
    {
        $params = Yii::$app->params['alicloud'];

        AlibabaCloud::accessKeyClient($params['accessKeyId'], $params['accessKeySecret'])
            ->regionId($params['regionId'])
            ->asDefaultClient();

        switch ($type) {
            case 1:
                $templateCode = $params['templateCode1'];
                break;
            case 2:
                $templateCode = $params['templateCode'];
                break;
            default:
                $templateCode = $params['templateCode2'];
                break;
        }

        try {
            Dysmsapi::v20170525()->sendSms()
                ->withPhoneNumbers($mobile)
                ->withSignName($params['signName'])
                ->withTemplateCode($templateCode)
                ->withTemplateParam($data)
                ->request();
            return true;
        } catch (ClientException $exception) {
            // echo $exception->getErrorMessage() . PHP_EOL;
            return false;
        } catch (ServerException $exception) {
            // echo $exception->getErrorMessage() . PHP_EOL;
            return false;
        }
    }
}
