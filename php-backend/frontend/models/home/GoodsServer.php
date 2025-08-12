<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * 药品服务模块
 * @property mixed|string|null name 名称
 * @property mixed|string|null icon 图标
 * @property mixed|string|null desc 描述
 * @property mixed|string|null link_url 跳转链接
 * @property mixed|string|null sort 排序
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class GoodsServer extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_goods_server}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取药品服务信息
     * @param int $id 服务id
     * @return GoodsServer|null
     */
    public static function findByServerId($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 获取所有数据
     * @return array|ActiveRecord
     */
    public static function findAllGoodsServer()
    {
        return static::find()->where(['enable' => 0])->orderBy('sort desc,id desc')->all();
    }
}
