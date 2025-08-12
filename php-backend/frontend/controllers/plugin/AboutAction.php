<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 关于我们
 * @description 关于我们接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/about
 * @return {"code": 200,"message": "请求成功","data": {"download": "http://zycareapi.com/uploads/qrcode/20230111/1673448744.jpeg","version": "1.0.0","mobile": "15298836561"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.download string 下载二维码
 * @return_param data.version string 版本号
 * @return_param data.mobile string 客服热线
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class AboutAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = PluginService::getAboutInfo();

        Helper::response(200, $result);
    }
}
