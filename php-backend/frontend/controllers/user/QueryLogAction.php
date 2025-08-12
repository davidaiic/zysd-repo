<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 查询历史
 * @description 查询历史接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/queryLog
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"queryList": [{"logId": "1","goodsName": "克唑替尼","companyName": "老挝二厂","type": "2","created": "01-05 11:22","username": "阳*","avatar": "1.jpg"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.queryList array 查询历史列表
 * @return_param data.queryList[0].logId string 记录id
 * @return_param data.queryList[0].goodsName string 药品名称
 * @return_param data.queryList[0].companyName string 药厂名称
 * @return_param data.queryList[0].type string 查询类型：1-人工核查，2-自助查询，3-价格查询
 * @return_param data.queryList[0].created string 查询时间
 * @return_param data.queryList[0].username string 用户名
 * @return_param data.queryList[0].avatar string 用户头像
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class QueryLogAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = UserService::getQueryLog($uid, $page);

        Helper::response(200, ['queryList' => $result]);
    }
}
