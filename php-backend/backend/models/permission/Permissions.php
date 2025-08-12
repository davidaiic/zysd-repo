<?php

namespace backend\models\permission;

use yii\db\ActiveRecord;

/**
 * 权限模块
 * @property mixed|string|null name 名称
 * @property mixed|string|null alias 别名
 * @property mixed|string|null route 路由
 * @property mixed|string|null icon 图标
 * @property int|mixed|null parent_id 父级id
 * @property int|mixed|null is_menu 是否菜单：0-否；1-是
 * @property int|mixed|null sort 排序
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Permissions extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_permissions}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取权限信息
     * @param int $perId 权限id
     * @return Permissions|null
     */
    public static function findByPerId($perId)
    {
        return static::findOne(['id' => $perId]);
    }

    /**
     * 获取所有的权限列表
     */
    public static function findAllPermission()
    {
        return static::find()->orderBy('parent_id asc, sort desc, created desc')->all();
    }

    /**
     * 判断路由是否重复
     * @param string $route 路由
     * @param int $parentId 父id
     * @param int $perId 权限id
     * @return array|ActiveRecord|null
     */
    public static function checkRoute($route, $parentId = 0, $perId = 0)
    {
        $info = static::find()->where(['route' => $route, 'parent_id' => $parentId]);

        if ($perId) {
            $info->andWhere(['<>', 'id', $perId]);
        }

        return $info->one();
    }
}
