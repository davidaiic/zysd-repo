<?php

namespace frontend\models\user;

use yii\db\ActiveRecord;

/**
 * 意见反馈模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null content 内容
 * @property mixed|string|null image_url 图片
 * @property mixed|string|null mobile 手机号
 * @property int|mixed|null created 创建时间
 */
class Feedback extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_feedback}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }
}
