<?php

namespace frontend\controllers\user;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use frontend\models\service\UserService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 用户
 * @title 更换头像
 * @description 更换头像接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/user/updateAvatar
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param file 必选 array 文件内容
 * @return {"code": 200,"message": "请求成功"}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.avatar string 头像url
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class UpdateAvatarAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        //上传头像
        $avatarUrl = PluginService::uploadImage('avatar');

        //保存头像
        $uid = Helper::getUid();

        $result = UserService::saveAvatar($uid, $avatarUrl);

        if ($result) {
            Helper::response(200, ['avatar' => $avatarUrl]);
        } else {
            Helper::response(405);
        }
    }
}
