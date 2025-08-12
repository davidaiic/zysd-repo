<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 纠错目录
 * @description 纠错目录接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/errorRecovery
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 必选 int 药品id
 * @param keywords 必选 string 类目，多个类目以,拼接的字符串，例如：specs,ability
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ErrorRecoveryAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $goodsId = (int)Helper::getParam('goodsId');
        $keywords = Helper::getParam('keywords');

        if (!$goodsId) {
            Helper::responseError(1035);
        }

        if (!$keywords) {
            Helper::responseError(1052);
        }

        $result = QueryService::saveGoodsErrorRecovery($uid, $goodsId, $keywords);

        if ($result) {
            Helper::response(200);
        } else {
            Helper::response(405);
        }
    }
}
