<?php

namespace backend\models\permission;

use yii\db\ActiveRecord;

/**
 * 角色权限模块
 * @property int|mixed|null permission_id 权限id
 * @property int|mixed|null role_id 角色id
 */
class RolePermissions extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_role_permissions}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取权限列表
     * @param int $roleId 角色id
     * @return array
     */
    public static function findByRoleId($roleId)
    {
        return static::findAll(['role_id' => $roleId]);
    }
}
