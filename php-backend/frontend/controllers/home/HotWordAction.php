<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 热门搜索词
 * @description 热门搜索词接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/hotWord
 * @param type 必选 类型 默认0-药品，1-资讯
 * @return {"code": 200,"message": "请求成功","data": {"searchTip": "识药查真伪小程序仅为用户提供国外仿制药品的真伪鉴别、注册信息查询、价格查询服务！","wordList": [{"word": "克唑替尼"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.searchTip string 搜索提示
 * @return_param data.wordList array 热门搜索词列表
 * @return_param data.wordList[0].word string 搜索词
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class HotWordAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $type = (int)Helper::getParam('type');

        //获取搜索提示
        $searchTip = HomeService::getSearchTip();

        if ($type == 1) {
            $result = HomeService::getArticleHotWordList();
        } else {
            $result = HomeService::getHotWordList();
        }

        Helper::response(200, ['searchTip' => $searchTip, 'wordList' => $result]);
    }
}
