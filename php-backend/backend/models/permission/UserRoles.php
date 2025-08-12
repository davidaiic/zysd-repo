<?php

namespace backend\models\permission;

use yii\db\ActiveRecord;

/**
 * 用户角色关联模块
 * @property int|mixed|null role_id 角色id
 * @property int|mixed|null user_id 用户id
 */
class UserRoles extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_user_roles}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }
}
