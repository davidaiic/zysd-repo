<?php

namespace frontend\controllers\query;

use frontend\components\Helper;
use frontend\models\service\QueryService;
use yii\base\Action;
use yii\base\ExitException;

/**
 * showdoc
 * @catalog 查询
 * @title 分类药品
 * @description 分类药品接口
 * @method post
 * @url https://shiyao.yaojk.com.cn/query/classGoods
 * @param uid 必选 int 用户uid
 * @param token 必选 string 身份授权token
 * @param classId 必选 int 分类id
 * @param page 必选 int 页数
 * @return {"code": 200,"message": "请求成功","data": {"goodsList": [{"goodsId": "1","goodsName": "克唑替尼","goodsImage": "https://shiyao.yaojk.com.cn/uploads/goods/20230103/1672727222.jpg","companyId": "1","companyName": "老挝二厂"}]}}
 * @return_param code int 状态码
 * @return_param message string 提示信息
 * @return_param data object 返回数据
 * @return_param data.goodsList array 药品列表
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
class ClassGoodsAction extends Action
{
    /**
     * @throws ExitException
     */
    public function run()
    {
        $classId = (int)Helper::getParam('classId');
        $page = Helper::getParam('page');
        $page = $page ? $page : 1;

        $result = QueryService::getClassGoodsList($classId, $page);

        Helper::response(200, ['goodsList' => $result]);
    }
}
