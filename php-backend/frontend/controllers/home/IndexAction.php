<?php

namespace frontend\controllers\home;

use frontend\components\Helper;
use frontend\models\service\HomeService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 首页
 * @title 首页
 * @description 首页接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/home/index
 * @return {"code": 200,"message": "请求成功","data": {"searchText": "卡博替尼","bannerList": [{"bannerId": 1,"name": "轮播1","notes": "用药之前查一查","imageUrl": "https://shiyao.yaojk.com.cn/uploads/banner/20230103/1672726782.png","type": 0,"linkUrl": "","text1": "累计查询数","text2": "12346"}],"selfQueryNum": 0,"manualVerifyNum": 0,"priceQueryNum": 0,"searchList": [{"avatar": "1.jpg","content": "陈*晓5分钟前查询过老挝元素制药的卡马替"},{"avatar": "2.jpg","content": "张*莉10分钟前查询过老挝元素制药的卡马"}],"goodsList": [{"goodsId": 4,"goodsName": "卡博替尼","goodsImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230103/1672727387.png","companyName": "老挝元素","searchNum": 60}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.searchText string 搜索配置文案
 * @return_param data.bannerList array banner列表
 * @return_param data.bannerList[0].bannerId int bannerId
 * @return_param data.bannerList[0].name string banner名称
 * @return_param data.bannerList[0].notes string banner描述
 * @return_param data.bannerList[0].imageUrl string 图片url
 * @return_param data.bannerList[0].type int 类型：0-静态的banner，1-需要跳转的banner
 * @return_param data.bannerList[0].linkUrl string 跳转url，type=1时有值需跳转
 * @return_param data.bannerList[0].text1 string 补充内容1
 * @return_param data.bannerList[0].text2 string 补充内容2
 * @return_param data.scanNum int 扫一扫查真伪人数
 * @return_param data.selfQueryNum int 自助查询人数
 * @return_param data.manualVerifyNum int 人工核查人数
 * @return_param data.priceQueryNum int 价格查询人数
 * @return_param data.checkNum int 我要送检人数
 * @return_param data.compareNum int 我要比价人数
 * @return_param data.searchList array 搜索列表
 * @return_param data.searchList[0].avatar string 用户头像
 * @return_param data.searchList[0].content string 搜索内容
 * @return_param data.goodsList array 热门药品列表
 * @return_param data.goodsList[0].goodsId string 药品id
 * @return_param data.goodsList[0].goodsName string 药品名称
 * @return_param data.goodsList[0].goodsImage string 药品图片
 * @return_param data.goodsList[0].clinicalStage string 国内临床阶段，为空不显示
 * @return_param data.goodsList[0].drugProperties string 药品属性，左上角标签，为空不显示
 * @return_param data.goodsList[0].drugPropertiesColor string 药品属性，左上角标签颜色
 * @return_param data.goodsList[0].risk string 药品风险等级，为1显示高风险，为0不显示
 * @return_param data.goodsList[0].companyId string 药厂id
 * @return_param data.goodsList[0].companyName string 药厂名称
 * @return_param data.goodsList[0].searchNum int 查询人数
 * @return_param data.goodsList[0].marketTag string 上市标签，为空不显示
 * @return_param data.goodsList[0].medicalTag string 医保标签，为空不显示
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class IndexAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        //获取首页搜索配置内容
        $searchText = HomeService::getSearchText();

        //获取首页banner列表
        $bannerList = HomeService::getBannerList();

        //获取扫一扫查真伪人数
        $scanNum = HomeService::getScanNum();

        //获取自助查询人数
        $selfQueryNum = HomeService::getSelfQueryNum();

        //获取人工核查人数
        $manualVerifyNum = HomeService::getManualVerifyNum();

        //获取价格查询人数
        $priceQueryNum = HomeService::getPriceQueryNum();

        //获取我要送检人数
        $checkNum = HomeService::getCheckNum();

        //获取我要比价人数
        $compareNum = HomeService::getCompareNum();

        //获取搜索列表
        $searchList = HomeService::getSearchList();

        //获取热门药品列表
        $goodsList = HomeService::getHotGoodsList();

        Helper::response(200, [
            'searchText'      => $searchText,
            'bannerList'      => $bannerList,
            'scanNum'         => $scanNum,
            'selfQueryNum'    => $selfQueryNum,
            'manualVerifyNum' => $manualVerifyNum,
            'priceQueryNum'   => $priceQueryNum,
            'checkNum'        => $checkNum,
            'compareNum'      => $compareNum,
            'searchList'      => $searchList,
            'goodsList'       => $goodsList
        ]);
    }
}
