<?php

namespace frontend\models\user;

use yii\db\ActiveRecord;

/**
 * 用户模块
 * @property mixed|string|null username 用户名
 * @property mixed|string|null mobile 手机号
 * @property mixed|string|null openid 小程序openid
 * @property mixed|string|null avatar 头像
 * @property mixed|string|null wx 微信号
 * @property mixed|string|null qrcode 二维码
 * @property int|mixed|null add_wx 是否已添加微信：0-没有，1-已添加
 * @property int|mixed|null invite_id 邀请人id
 * @property mixed|string|null os 系统类型
 * @property mixed|string|null version 版本号
 * @property mixed|string|null phoneModel 手机型号
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class User extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_user}}';
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
     * @return User|null
     */
    public static function findIdentity($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 根据手机号码获取用户信息
     * @param string $phone 手机号码
     * @return User|null
     */
    public static function findByPhone($phone)
    {
        return static::findOne(['mobile' => $phone]);
    }

    /**
     * 根据openid获取用户信息
     * @param string $openid 小程序openid
     * @return User|null
     */
    public static function findByOpenid($openid)
    {
        return static::findOne(['openid' => $openid]);
    }

    /**
     * 获取用户总数
     */
    public static function findUserNum()
    {
        return static::find()->count();
    }
}
