<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药品专题说明
 * @description 药品专题说明接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/goodsSubject
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 必选 int 药品id
 * @param serverId 必选 int 服务id，2-真伪鉴别，4-患者招募，5-慈善救助，6-我要送检，7-基因检测
 * @return {"code": 200,"message": "请求成功","data": {"content": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.content string 内容
 * @return_param data.dataSources string 查询来源
 * @return_param data.queryTime string 查询时间
 * @return_param data.copyText string 文案
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GoodsSubjectAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $goodsId = (int)Helper::getParam('goodsId');
        $serverId = (int)Helper::getParam('serverId');

        if (!$serverId) {
            Helper::responseError(1051);
        }

        if ($serverId != 6 && !$goodsId) {
            Helper::responseError(1035);
        }

        $result = QueryService::getGoodsSubjectInfo($goodsId, $serverId);

        Helper::response(200, $result);
    }
}
