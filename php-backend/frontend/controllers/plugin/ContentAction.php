<?php

namespace frontend\controllers\plugin;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 内容配置
 * @description 内容配置接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/content
 * @param keyword 必选 string 关键词：protocol(用户协议)，privacy(隐私政策)，criterion(评论规范公约)，number(药品批准文号)，security(防伪码)，statute(法规解读)，cost(成本解读)，logistics(物流服务流程)，findWx(如何找微信号)，findQrCode(如何找二维码)，thirdShareInventory(第三方信息共享清单)，basicUserInfo(用户基本信息)，userUseInfo(用户使用过程信息)，deviceInfo(设备属性信息)，comparePrice(比价说明)，sendExamine(我要送检)
 * @return {"code": 200,"message": "请求成功","data": {"title": "用户协议","content": "<p>111111</p>"}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.title string 标题
 * @return_param data.content string 内容
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ContentAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Tool::filterKeyword(Helper::getParam('keyword'));

        if (!$keyword) {
            Helper::response(201);
        }

        $result = PluginService::getContent($keyword);

        Helper::response(200, $result);
    }
}
