<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 扫一扫
 * @description 扫一扫接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/scanCode
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param code 必选 string 条形码
 * @return {"code": 200,"message": "请求成功","data": {"result": 1,"goodsId": 292341,"goodsName": "盐酸金刚乙胺口服溶液","companyId": 194,"companyName": "浙江普洛康裕制药有限公司","risk": 0,"serverName": "","linkUrl": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.result int 是否有结果：0-无结果，1-有结果
 * @return_param data.goodsId int 药品id
 * @return_param data.goodsName string 药品名称
 * @return_param data.risk int 是否有风险：0-无风险，1-高风险
 * @return_param data.serverName string 跳转页面标题
 * @return_param data.linkUrl string 跳转链接
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ScanCodeAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $code = Helper::getParam('code');

        $result = QueryService::getScanCodeInfo($uid, $code);

        if ($result) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
