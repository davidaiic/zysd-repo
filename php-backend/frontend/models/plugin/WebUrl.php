<?php

namespace frontend\models\plugin;

use yii\db\ActiveRecord;

/**
 * h5链接模块
 * @property mixed|string|null title 标题
 * @property mixed|string|null keyword 关键字标识
 * @property mixed|string|null link_url 链接url
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class WebUrl extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_web_url}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取web链接内容
     * @param int $id web链接id
     * @return WebUrl|null
     */
    public static function findByWebUrlId($id)
    {
        return static::findOne(['id' => $id]);
    }
}
