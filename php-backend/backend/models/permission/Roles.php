<?php

namespace backend\models\permission;

use yii\db\ActiveRecord;

/**
 * 角色模块
 * @property mixed|string|null name 角色名称
 * @property mixed|string|null alias 角色别名
 * @property mixed|string|null note 备注
 * @property int|mixed|null type 类型：0-系统预置；1-自定义
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Roles extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_roles}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取角色信息
     * @param int $roleId 角色id
     * @return Roles|null
     */
    public static function findByRoleId($roleId)
    {
        return static::findOne(['id' => $roleId]);
    }

    /**
     * 获取角色列表
     * @param string $roleName 角色名称
     * @return array
     */
    public static function findAllRoles($roleName)
    {
        return static::find()->where(['like', 'name', $roleName])->all();
    }

    /**
     * 判断角色名称是否存在
     * @param string $roleName 角色名称
     * @param int $roleId 角色id
     * @return array|ActiveRecord|null
     */
    public static function checkRoleName($roleName, $roleId = 0)
    {
        $info = static::find()->where(['name' => $roleName]);

        if ($roleId) {
            $info->andWhere(['<>', 'id', $roleId]);
        }

        return $info->one();
    }
}
