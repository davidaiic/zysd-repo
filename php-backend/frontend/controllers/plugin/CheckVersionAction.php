<?php

namespace frontend\controllers\plugin;

use frontend\components\Helper;
use frontend\models\service\PluginService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 通用
 * @title 版本更新
 * @description 版本更新接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/plugin/checkVersion
 * @param os 必选 string 系统类型
 * @param version 必选 string 版本号
 * @return {"code": 200,"message": "请求成功","data": {"isUpdate": 1,"info": {"isMust": 1,"content": "1、优化界面，2、修改BUG","downloadUrl": ""}}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.isUpdate int 是否有更新：0-否，1-是
 * @return_param data.info object 版本更新信息
 * @return_param data.info.isMust int 更新类型：1-非强制，2-强制更新(可取消)，3-强制更新(不可取消)
 * @return_param data.info.content string 更新内容
 * @return_param data.info.downloadUrl string 下载地址
 * @return_param data.info.file string 判断文件是否篡改
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class CheckVersionAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $os = Helper::getParam('os');
        $version = Helper::getParam('version');
        $phoneModel = Helper::getParam('phoneModel');

        if (!$os || !$version) {
            Helper::response(201);
        }

        $result = PluginService::getVersion($uid, $os, $version, $phoneModel);

        Helper::response(200, $result);
    }
}
