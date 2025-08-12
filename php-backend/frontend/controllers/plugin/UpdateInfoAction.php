<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 更新信息
 * @description 更新信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/updateInfo
 * @param uid 必选 int 用户uid
 * @param os 必选 string 系统类型
 * @param version 必选 string 版本号
 * @param phoneModel 必选 string 手机型号
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class UpdateInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $os = Helper::getParam('os');
        $version = Helper::getParam('version');
        $phoneModel = Helper::getParam('phoneModel');

        $result = PluginService::updateInfo($uid, $os, $version, $phoneModel);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
