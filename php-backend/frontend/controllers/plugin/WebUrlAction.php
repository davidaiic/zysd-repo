<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title web链接
 * @description web链接接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/webUrl
 * @return {"code": 200,"message": "请求成功","data": {"urlList": [{"title": "","keyword": "","linkUrl": ""}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.urlList array 链接列表
 * @return_param data.urlList[0].title string 标题
 * @return_param data.urlList[0].keyword string 关键字标识
 * @return_param data.urlList[0].linkUrl string 链接
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class WebUrlAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = PluginService::getWebUrlList();

        Helper::response(200, ['urlList' => $result]);
    }
}
