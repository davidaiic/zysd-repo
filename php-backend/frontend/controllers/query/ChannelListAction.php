<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 渠道列表
 * @description 渠道列表接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/channelList
 * @return {"code": 200,"message": "请求成功","data": {"channelList": [{"channelId": 3,"channelName": "药厂海外站直发"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.channelList array 渠道列表
 * @return_param data.channelList[0].channelId int 渠道id
 * @return_param data.channelList[0].channelName string 渠道名称
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ChannelListAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $result = QueryService::getChannelList();

        Helper::response(200, ['channelList' => $result]);
    }
}
