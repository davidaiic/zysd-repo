<?php

namespace backend\controllers;

use backend\components\Helper;
use Yii;
use yii\base\ExitException;
use yii\rest\Controller;
use yii\web\BadRequestHttpException;

/**
 * 基础类
 */
class BaseController extends Controller
{
    public static $tokenPrefix = 'token_';

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
        if (!Yii::$app->request->isPost) {
            Helper::response(406);
        }

        //判断token是否失效
        if (!in_array($action->id, $this->getNoAction())) {
            $headers = Yii::$app->request->headers;
            $token = $headers->get('X-Token');

            if (!$token) Helper::response(401);

            $uid = Yii::$app->cache->get(self::$tokenPrefix . $token);

            if (!$uid) Helper::response(401);
        }

        //判断签名是否正确
        $isSign = Helper::checkSign();

        if (!$isSign) {
            Helper::response(403);
        }

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
        return ['login'];
    }
}
