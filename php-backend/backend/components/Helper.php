<?php

namespace backend\components;

use Yii;
use yii\base\ExitException;
use yii\helpers\ArrayHelper;

class Helper
{
    private static $method = 'aes-128-cbc';

    private static $key = 'shkyyy1234567890';

    private static $iv = '1234567890987654';

    public static $tokenPrefix = 'token_';

    /**
     * 获取所有参数
     * @return array
     */
    public static function getAllParam()
    {
        $request = Yii::$app->request;
        $param = $request->isPost ? $request->post() : $request->get();

        //获取php://input内容
        $input = file_get_contents('php://input');
        $inputData = json_decode($input, true);

        //合并数据
        if ($inputData) {
            $param = ArrayHelper::merge($param, $inputData);
        }

        //判断是否加密参数
        if (isset($param['parameter'])) {
            return self::decrypt($param['parameter']);
        } else {
            return $param;
        }
    }

    /**
     * 格式化参数
     * @param $key
     * @return array|mixed|string
     */
    public static function getParam($key)
    {
        $param = self::getAllParam();
        return isset($param[$key]) && $param[$key] != 'null' ? $param[$key] : '';
    }

    /**
     * 获取token
     */
    public static function getToken()
    {
        $headers = Yii::$app->request->headers;
        return $headers->get('X-Token');
    }

    /**
     * 获取用户id
     * @return mixed|string
     */
    public static function getUid()
    {
        $token = self::getToken();

        if (!$token) return '';

        $uid = Yii::$app->cache->get(self::$tokenPrefix . $token);

        return $uid ? $uid : '';
    }

    /**
     * 获取页数
     */
    public static function getPage()
    {
        $page = self::getParam('page');
        return $page ? $page : Yii::$app->params['pageIndex'];
    }

    /**
     * 获取限制数量
     */
    public static function getLimit()
    {
        $limit = self::getParam('limit');
        return $limit ? $limit : Yii::$app->params['pageSize'];
    }

    /**
     * 响应状态码
     * @return array
     */
    public static function getResponseCodes()
    {
        return [
            200 => self::commonMsg(200),
            201 => self::commonMsg(201),
            401 => self::commonMsg(401),
            402 => self::commonMsg(402),
            403 => self::commonMsg(403),
            404 => self::commonMsg(404),
            405 => self::commonMsg(405),
            406 => self::commonMsg(406),
            505 => self::commonMsg(505),
            600 => self::commonMsg(600),
            601 => self::commonMsg(601),
            666 => self::commonMsg(666),
            999 => self::commonMsg(999),
        ];
    }

    /**
     * 获取语言配置
     * @param int $number key
     * @return string
     */
    public static function commonMsg($number)
    {
        return Yii::t('common', $number);
    }

    /**
     * 返回信息
     * @param int $code 状态码
     * @param array $data 数据
     * @throws ExitException
     */
    public static function response($code, $data = [])
    {
        $codes = self::getResponseCodes();
        $stateCodes = array_keys($codes);

        //直接返回
        $response = Yii::$app->response;

        //status对应main.php>>response>>data>>code
        if (!in_array($code, $stateCodes)) {
            $response->data = ['status' => 505, 'message' => $codes[505]];
            $response->send();
            Yii::$app->end();//中止输出
        }

        if (empty($data)) {
            $response->data = ['status' => $code, 'message' => $codes[$code]];
            $response->send();
            Yii::$app->end();//中止输出
        }

        $returnData = ['status' => $code, 'message' => $codes[$code], 'data' => $data];

        //判断是否开启数据加密
        if (Yii::$app->params['cryptResponse']) {
            $cryptData = openssl_encrypt(json_encode($returnData), self::$method, self::$key, 0, self::$iv);
            $returnData = ['status' => 999, 'message' => $codes[999], 'data' => $cryptData];
        }

        $response->data = $returnData;
        $response->send();
        Yii::$app->end();//中止输出
    }

    /**
     * 错误提示信息
     * @param int $number key
     * @throws ExitException
     */
    public static function responseError($number)
    {
        //直接返回，status对应main.php>>response>>data>>code
        $response = Yii::$app->response;
        $response->data = ['status' => 402, 'message' => self::commonMsg($number)];
        $response->send();
        Yii::$app->end();//中止输出
    }

    /**
     * 错误提示信息
     * @param string $msg 错误信息
     * @throws ExitException
     */
    public static function responseErrorMsg($msg)
    {
        //直接返回，status对应main.php>>response>>data>>code
        $response = Yii::$app->response;
        $response->data = ['status' => 402, 'message' => $msg];
        $response->send();
        Yii::$app->end();//中止输出
    }

    /**
     * 数据解密
     * @param $cryptData
     * @return mixed
     */
    public static function decrypt($cryptData)
    {
        if (strpos($cryptData, '%2B') || strpos($cryptData, '%0A')) {
            $cryptData = rawurldecode($cryptData);
            $cryptData = str_replace(array("\r\n", "\r", "\n"), "", $cryptData);
        }

        $param = openssl_decrypt($cryptData, self::$method, self::$key, 0, self::$iv);
        parse_str($param, $data);

        return $data;
    }

    /**
     * 签名验证
     * @return bool
     */
    public static function checkSign()
    {
        //判断是否开启签名验证
        if (!Yii::$app->params['checkSign']) {
            return true;
        }

        //对签名进行校验
        $param = self::getAllParam();
        $sign = isset($param['sign']) ? $param['sign'] : '';
        $os = isset($param['os']) ? $param['os'] : '';

        if (!$sign) {
            return false;
        }

        //签名步骤一：按字典序排序参数
        ksort($param);

        //签名步骤二：使用键值对的格式拼接成str
        $str = '';
        foreach ($param as $key => $value) {
            if ($key != "sign" && !is_array($value)) {
                if ($os == 'android') {
                    $str .= $key . "=" . str_replace('~', '%7E', rawurlencode($value)) . '&';
                } else {
                    $str .= $key . "=" . $value . '&';
                }
            }
        }

        //签名步骤三：在str后拼接key
        $signKey = Yii::$app->params['signKey'];
        $str .= 'signKey=' . $signKey;

        //签名步骤四：md5加密
        $newSign = md5($str);

        //签名步骤五：所有字符转为小写
        $newSign = strtolower($newSign);

        return $sign !== $newSign ? false : true;
    }
}
