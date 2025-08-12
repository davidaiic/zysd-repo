<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 图片识别
 * @description 图片识别接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/imageRecognition
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param file 必选 array 文件内容
 * @return {"code": 200,"message": "请求成功","data": {"imageId": 1,"imageUrl": "e81feb593167a4ad97cfc5c9b5162142.jpeg","keywords": [{"name": "卡马替尼"},{"name": "劳拉替尼"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.imageId int 图片id
 * @return_param data.imageUrl string 图片url
 * @return_param data.keywords array 搜索词推荐列表
 * @return_param data.keywords[0].name string 搜索词
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ImageRecognitionAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        //上传图片
        $imageUrl = PluginService::uploadImage('photo');

        //识别图片
        $uid = Helper::getUid();

        $result = QueryService::getImageRecognitionInfo($uid, $imageUrl);

        if ($result) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
