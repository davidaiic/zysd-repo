<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 提取文字
 * @description 提取文字接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/extractText
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param imageId 必选 int 图片id
 * @return {"code": 200,"message": "请求成功","data": {"words": [{"text": "卡"},{"text": "拉"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.words array 文字列表
 * @return_param data.words[0].text string 文字
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ExtractTextAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $imageId = (int)Helper::getParam('imageId');

        if (!$imageId) {
            Helper::response(201);
        }

        $result = QueryService::getExtractTextInfo($imageId);

        Helper::response(200, $result);
    }
}
