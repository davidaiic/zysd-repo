<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 筛选条件
 * @description 筛选条件接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/filterCriteria
 * @return {"code": 200,"message": "请求成功","data": {"sortList": [{"sortId": "1","name": "最新"}],"labelList": [{"labelId": "1","name": "医保"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.sortList array 排序列表
 * @return_param data.sortList[0].sortId string 排序id
 * @return_param data.sortList[0].name string 排序名称
 * @return_param data.labelList array 标签列表
 * @return_param data.labelList[0].labelId string 标签id
 * @return_param data.labelList[0].name string 标签名称
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class FilterCriteriaAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        //获取排序列表
        $sortList = HomeService::getSortByList();

        //获取标签列表
        $labelList = HomeService::getLabelList();

        Helper::response(200, ['sortList' => $sortList, 'labelList' => $labelList]);
    }
}
