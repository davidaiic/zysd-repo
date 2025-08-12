<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title app分享
 * @description app分享接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/appShare
 * @param type 必选 int 类型：1-分享评论，2-分享资讯，3-分享比价
 * @param thirdId 否 int 分享的数据id，不需要的可以不传
 * @return {"code": 200,"message": "请求成功","data": {"title": "分享了一个好内容给你","path": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.title string 分享标题
 * @return_param data.path string 跳转路径
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class AppShareAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $type = (int)Helper::getParam('type');
        $thirdId = (int)Helper::getParam('thirdId');
        $type = $type ? $type : 1;

        $result = PluginService::getAppShareInfo($uid, $type, $thirdId);

        Helper::response(200, $result);
    }
}
