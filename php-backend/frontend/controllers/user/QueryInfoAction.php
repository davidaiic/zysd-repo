<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 查询详情
 * @description 查询详情接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/queryInfo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param logId 必选 int 记录id
 * @return {"code": 200,"message": "请求成功","data": {"info": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info string 查询详情
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class QueryInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $logId = (int)Helper::getParam('logId');

        if (!$logId) {
            Helper::response(201);
        }

        $result = UserService::getQueryInfo($uid, $logId);

        Helper::response(200, $result);
    }
}
