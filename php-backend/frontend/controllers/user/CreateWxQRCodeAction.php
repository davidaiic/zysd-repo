<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 生成小程序码
 * @description 生成小程序码接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/createWxQRCode
 * @param page 必选 string 主页
 * @param scene 必选 string 参数
 * @param width 必选 string 宽度
 * @return {"code": 200,"message": "请求成功","data": {"buffer": "http://shiyao.yaojk.com.cn/qrImages/20221230/1633856564.jpg"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.buffer string 二维码图片url
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CreateWxQRCodeAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $page = Helper::getParam('page');
        $scene = Helper::getParam('scene');
        $width = Helper::getParam('width');

        $result = UserService::createWxQRCode($page, $scene, $width);

        Helper::response(200, $result);
    }
}
