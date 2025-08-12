<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;

/**
 * banner模块
 * @property mixed|string|null name 名称
 * @property mixed|string|null notes 描述
 * @property mixed|string|null image_url 图片链接
 * @property int|mixed|null type 类型：0-静态，1-URL跳转
 * @property mixed|string|null link_url 跳转链接
 * @property mixed|string|null sort 排序
 * @property mixed|string|null text1 文案一
 * @property mixed|string|null text2 文案二
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Banner extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_banner}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取所有banner
     * @return array|ActiveRecord
     */
    public static function findAllBanner()
    {
        return static::find()->where(['enable' => 0])->orderBy('sort desc')->all();
    }

    /**
     * 获取banner信息
     * @param int $bannerId bannerId
     * @return Banner|null
     */
    public static function findByBannerId($bannerId)
    {
        return static::findOne(['id' => $bannerId]);
    }
}
