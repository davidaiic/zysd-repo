<?php

namespace frontend\controllers\home;

use common\components\Tool;
use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 联想词
 * @description 联想词接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/associateWord
 * @param keyword 必选 string 搜索词
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"wordList": [{"word": "肺宁颗粒"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.wordList array 联想词列表
 * @return_param data.wordList[0].word string 联想词
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class AssociateWordAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $keyword = Tool::filterKeyword(Helper::getParam('keyword'));
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = HomeService::getAssociateWordList($keyword, $page);

        Helper::response(200, ['wordList' => $result]);
    }
}
