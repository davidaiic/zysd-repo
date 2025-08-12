<?php

namespace frontend\controllers\query;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 照片查询
 * @description 照片查询接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/photo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param positive 必选 string 正面
 * @param leftSide 必选 string 左侧面
 * @param rightSide 必选 string 右侧面
 * @param back 必选 string 背面
 * @param other 必选 string 其余照片，多张照片以,拼接的字符串，例如：1.jpg,2.jpg
 * @param mobile 必选 string 手机号码
 * @return {"code": 200,"message": "请求成功","data": {"text": "我们会在48小时内以短信形式反馈结果","rank": 212,"total": 2222}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.text string 反馈文案
 * @return_param data.rank int 今日查询排名
 * @return_param data.total int 总共查询次数
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class PhotoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $positive = Helper::getParam('positive');
        $leftSide = Helper::getParam('leftSide');
        $rightSide = Helper::getParam('rightSide');
        $back = Helper::getParam('back');
        $other = Helper::getParam('other');
        $mobile = Helper::getParam('mobile');

        if (!$positive && !$leftSide && !$rightSide && !$back && !$other) {
            Helper::responseError(1011);
        }

        if (!$mobile) {
            Helper::responseError(1005);
        }

        if (!Tool::checkPhone($mobile)) {
            Helper::responseError(1031);
        }

        $result = QueryService::uploadPhoto($uid, $positive, $leftSide, $rightSide, $back, $other, $mobile);

        if ($result) {
            Helper::response(200, $result);
        } else {
            Helper::response(405);
        }
    }
}
