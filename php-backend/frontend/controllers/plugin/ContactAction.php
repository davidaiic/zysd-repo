<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 联系我们
 * @description 联系我们接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/contact
 * @return {"code": 200,"message": "请求成功","data": {"avatar": "","wx": "2222","qrcode": "","icon": "","mobile": "111"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.avatar string 联系我们头像
 * @return_param data.wx string 联系我们微信号
 * @return_param data.qrcode string 联系我们二维码
 * @return_param data.icon string 联系我们电话图标
 * @return_param data.mobile string 联系我们电话
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ContactAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = PluginService::getContactInfo();

        Helper::response(200, $result);
    }
}
