<?php

namespace backend\models\user;

use yii\db\ActiveRecord;

/**
 * 后台用户模块
 * @property mixed|string|null username 用户名
 * @property mixed|string|null password 登录密码
 * @property mixed|string|null mobile 手机号
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class AdminUser extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_admin_user}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 根据id获取用户信息
     * @param int $id 用户id
     * @return static|null
     */
    public static function findIdentity($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 根据手机号码获取用户信息
     * @param string $phone 手机号码
     * @return static|null
     */
    public static function findByPhone($phone)
    {
        return static::findOne(['mobile' => $phone]);
    }

    /**
     * 获取其他手机号用户信息
     * @param string $mobile 手机号码
     * @param int $uid 用户id
     * @return array|ActiveRecord|null
     */
    public static function checkMobile($mobile, $uid)
    {
        return static::find()->where(['mobile' => $mobile])->andWhere(['<>', 'id', $uid])->one();
    }
}
