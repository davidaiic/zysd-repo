<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 药品服务信息
 * @description 药品服务信息接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/goodsServer
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param goodsId 必选 int 药品id
 * @return {"code": 200,"message": "请求成功","data": {"goodsInfo": {"goodsId": 1198,"goodsName": "羟乙膦酸钠片 ","goodsImage": "","clinicalStage": "","drugProperties": "","drugPropertiesColor": "#459BF0","marketTag": "","medicalTag": ""},"serverList": [{"serverId": 1,"serverName": "价格查询","icon": "https://shiyao.yaojk.com.cn/uploads/icon/20230415/4ec53b7c14835d282542179048af7c06.png","desc": "价格透明，一键查询"},{"serverId": 2,"serverName": "真伪鉴别","icon": "https://shiyao.yaojk.com.cn/uploads/icon/20230415/a157db03f29b465ce06d805fa4a8c071.png","desc": "药品真伪，快速查询"},{"serverId": 3,"serverName": "我要比价","icon": "https://shiyao.yaojk.com.cn/uploads/icon/20230415/3d10f6125a817df1da75495d0e34f071.png","desc": "一键比价，最优选择"},{"serverId": 6,"serverName": "我要送检","icon": "https://shiyao.yaojk.com.cn/uploads/icon/20230415/e45a8a81ceca8133951c68daf9ea3ad1.png","desc": "一键送检，安心检测"}],"articleList": [{"articleId": "1","title": "一文告诉你卡瑞利珠单抗是什么药？适用什么病症？","cover": "1.jpg","label": ["医保"],"likeNum": "2","commentNum": "3","readNum": "8","created": "04-03","isLike": 1}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.goodsInfo object 药品信息
 * @return_param data.goodsInfo.goodsId int 药品id
 * @return_param data.goodsInfo.goodsName string 药品名称
 * @return_param data.goodsInfo.goodsImage string 药品图片
 * @return_param data.goodsInfo.clinicalStage string 国内临床阶段，为空不显示
 * @return_param data.goodsInfo.drugProperties string 药品属性，左上角标签，为空不显示
 * @return_param data.goodsInfo.drugPropertiesColor string 药品属性，左上角标签颜色
 * @return_param data.goodsInfo.companyId int 药厂id
 * @return_param data.goodsInfo.companyName string 药厂名称
 * @return_param data.goodsInfo.specs string 规格
 * @return_param data.goodsInfo.marketTag string 上市标签，为空不显示
 * @return_param data.goodsInfo.medicalTag string 医保标签，为空不显示
 * @return_param data.goodsInfo.keyword string 关键词，用户资讯列表关联
 * @return_param data.serverList array 服务列表
 * @return_param data.serverList[0].serverId int 服务id
 * @return_param data.serverList[0].serverName string 服务名称
 * @return_param data.serverList[0].icon string 图标
 * @return_param data.serverList[0].desc string 描述
 * @return_param data.serverList[0].linkUrl string 跳转链接
 * @return_param data.articleList array 资讯列表
 * @return_param data.articleList[0].articleId string 资讯id
 * @return_param data.articleList[0].title string 标题
 * @return_param data.articleList[0].cover string 封面
 * @return_param data.articleList[0].label array 标签集合
 * @return_param data.articleList[0].likeNum string 点赞数量
 * @return_param data.articleList[0].commentNum string 评论数量
 * @return_param data.articleList[0].readNum string 阅读数量
 * @return_param data.articleList[0].created string 发布时间
 * @return_param data.articleList[0].isLike int 是否点赞：0-否，1-是
 * @remark 更多返回错误代码请看项目描述的返回信息
 * @number 99
 */
class GoodsServerAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $uid = Helper::getUid();
        $goodsId = (int)Helper::getParam('goodsId');

        if (!$goodsId) {
            Helper::responseError(1035);
        }

        $result = QueryService::getGoodsServerInfo($uid, $goodsId);

        Helper::response(200, $result);
    }
}
