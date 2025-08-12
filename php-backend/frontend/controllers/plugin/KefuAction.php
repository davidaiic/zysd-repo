<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 客服信息
 * @description 客服信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/kefu
 * @return {"code": 200,"message": "请求成功","data": {"avatar": "https://shiyao.yaojk.com.cn/uploads/avatar/20230104/1672810200.png","mobile": "","wx": "76543088","qrcode": "https://shiyao.yaojk.com.cn/uploads/image/20230104/1672810236.png"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.avatar string 客服头像
 * @return_param data.mobile string 客服电话
 * @return_param data.wx string 客服微信号
 * @return_param data.qrcode string 客服二维码
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class KefuAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();

        $result = PluginService::getKefuInfo($uid);

        Helper::response(200, $result);
    }
}
