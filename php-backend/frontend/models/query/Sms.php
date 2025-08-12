<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 短信模块
 * @property mixed|null mobile 手机号
 * @property mixed|string|null sms_text 短信内容
 * @property int|mixed|null type 类型：0-默认，1-短信登录
 * @property int|mixed|null status 状态：0-有效，1-失效
 * @property int|mixed|null created 创建时间
 */
class Sms extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_sms}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 根据手机号码和类型获取验证码信息
     * @param string $phone 手机号码
     * @param string $type 类型：1-验证码登录
     * @return array|ActiveRecord
     */
    public static function findByPhone($phone, $type)
    {
        return static::find()->where(['mobile' => $phone, 'type' => $type])->orderBy('id desc')->limit(1)->one();
    }
}
