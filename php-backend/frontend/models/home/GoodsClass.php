<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;
use yii\db\Query;

/**
 * 药品分类模块
 * @property mixed|string|null class_name 分类名称
 * @property int|mixed|null parent_id 上级分类id
 * @property false|mixed|string|null pid_list 上级分类集合
 * @property mixed|string|null sort 排序
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class GoodsClass extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_goods_class}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取分类信息
     * @param int $id 分类id
     * @return GoodsClass|null
     */
    public static function findByClassId($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 获取分类
     * @param int $classId 分类id
     * @return array|ActiveRecord
     */
    public static function findAllClass($classId = 0)
    {
        $query = new Query();
        return $query->select(['id as classId', 'class_name as className'])
            ->from('ky_goods_class')
            ->where(['parent_id' => $classId, 'enable' => 0, 'is_delete' => 0])
            ->orderBy('sort desc,id desc')
            ->all();
    }

    /**
     * 获取分类集合
     * @param string $keyword 搜索词
     * @return array
     */
    public static function findAllByKeyword($keyword)
    {
        return static::find()->where(['like', 'class_name', $keyword])->all();
    }
}
