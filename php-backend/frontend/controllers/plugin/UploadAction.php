<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 图片上传
 * @description 图片上传接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/upload
 * @param file 必选 array 文件内容
 * @param type 否 string 类型：photo(照片)，avatar(头像)，banner(轮播图)，goods(药品图)，company(药厂图)，icon(图标)，qrcode(二维码)，feedback(意见反馈)
 * @return {"code": 200,"message": "请求成功","data": {"url": ""}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.url string 图片url
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class UploadAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $type = Helper::getParam('type');
        $type = $type ? $type : 'image';

        $result = PluginService::uploadImage($type);

        Helper::response(200, ['url' => $result]);
    }
}
