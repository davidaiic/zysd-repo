<?php

namespace frontend\controllers;

use frontend\components\Helper;
use Yii;
use yii\base\ExitException;
use yii\rest\Controller;
use yii\web\BadRequestHttpException;

/**
 * 基础类
 */
class BaseController extends Controller
{
    /**
     * 程序执行前预支处理
     * @param $action
     * @return bool
     * @throws BadRequestHttpException|ExitException
     */
    public function beforeAction($action)
    {
        //设置语言
        $this->setLanguage();

        //限制请求方法
        if (!Yii::$app->request->isPost && !Yii::$app->request->isOptions) {
            Helper::response(406);
        }

        $route = $action->controller->id . '/' . $action->id;

        //判断token是否失效
        if (!in_array($route, $this->getNoAction())) {
            $headers = Yii::$app->request->headers;
            $uid = $headers->get('uid');
            $token = $headers->get('token');
            $localToken = Yii::$app->cache->get((int)$uid);//存的时候是int类型，这边必须为int

            if (!$localToken || !$token || $localToken !== $token) {
                Helper::response(401);
            }
        }

        //判断签名是否正确
        if (!in_array($route, $this->getNoSignAction())) {
            $isSign = Helper::checkSign();

            if (!$isSign) {
                Helper::response(403);
            }
        }

        //参数写入日志
        $info = Helper::getAllParam();
        $path = 'debug.txt';
        $hasInfo = file_get_contents($path);
        file_put_contents($path, $hasInfo . 'time：' . date('Y-m-d H:i:s') . '，params：' . json_encode($info) . PHP_EOL);

        return parent::beforeAction($action);
    }

    /**
     * 设置语言
     */
    private function setLanguage()
    {
        $language = Helper::getParam('language');

        switch ($language) {
            case 'en':
                Yii::$app->language = 'en';
                break;
            case 'zh-tw':
                Yii::$app->language = 'zh-tw';
                break;
            default:
                Yii::$app->language = 'zh-cn';
                break;
        }
    }

    /**
     * 不需要token验证的action
     * @return array
     */
    private function getNoAction()
    {
        return [
            'home/articleInfo',
            'home/articleList',
            'home/associateWord',
            'home/commentInfo',
            'home/commentList',
            'home/filterCriteria',
            'home/hotGoods',
            'home/hotWord',
            'home/index',
            'home/search',
            'plugin/about',
            'plugin/appShare',
            'plugin/checkVersion',
            'plugin/contact',
            'plugin/content',
            'plugin/kefu',
            'plugin/updateInfo',
            'plugin/upload',
            'plugin/webUrl',
            'query/channelList',
            'query/classGoods',
            'query/classList',
            'query/codeQuery',
            'query/companyList',
            'query/goodsNameList',
            'query/hotCompany',
            'query/manual',
            'query/photo',
            'query/relateGoodsName',
            'query/specList',
            'user/createWxQRCode',
            'user/getOpenid',
            'user/getPhone',
            'user/getUserPhone',
            'user/inviteInfo',
            'user/oneLogin',
            'user/register',
            'user/sendSms',
            'user/smsLogin',
        ];
    }

    /**
     * 不需要判断签名的action
     * @return array
     */
    private function getNoSignAction()
    {
        return [
            'plugin/about',
            'plugin/appShare',
            'plugin/checkVersion',
            'plugin/contact',
            'plugin/content',
            'plugin/kefu',
            'plugin/updateInfo',
            'plugin/upload',
            'plugin/webUrl',
            'user/createWxQRCode',
            'user/getOpenid',
            'user/getPhone',
            'user/getUserPhone',
            'user/oneLogin',
            'user/register',
            'user/sendSms',
            'user/smsLogin',
        ];
    }
}
