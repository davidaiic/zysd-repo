<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 图片识别模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null image_url 图片
 * @property false|mixed|string|null keywords 关键词集合
 * @property mixed|string|null words 文字集合
 * @property mixed|string|null created 创建时间
 */
class ImageRecognition extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_image_recognition}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取图片识别信息
     * @param int $id 记录id
     * @return ImageRecognition|null
     */
    public static function findImageInfo($id)
    {
        return static::findOne(['id' => $id]);
    }
}
