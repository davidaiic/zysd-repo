<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 分享码信息
 * @description 分享码信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/shareInfo
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @return {"code": 200,"message": "请求成功","data": {"info": {"username": "阳阳","avatar": "1.jpg"},"buffer": "","kefu": {"avatar": "https://shiyao.yaojk.com.cn/uploads/avatar/20230104/1672810200.png","wx": "76543088"}}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.info object 用户信息
 * @return_param data.info.username string 用户名
 * @return_param data.info.avatar string 头像
 * @return_param data.info.wx string 用户微信号
 * @return_param data.buffer string 二维码图片url
 * @return_param data.kefu object 客服信息
 * @return_param data.kefu.avatar string 客服头像
 * @return_param data.kefu.wx string 客服微信号
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class ShareInfoAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();

        $result = UserService::getShareInfo($uid);

        Helper::response(200, $result);
    }
}
