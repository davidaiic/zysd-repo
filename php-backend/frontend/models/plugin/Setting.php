<?php

namespace frontend\models\plugin;

use yii\db\ActiveRecord;

/**
 * 配置模块
 * @property mixed|string|null value 内容
 */
class Setting extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_setting}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取配置内容
     * @param string $keyword 关键词
     * @return Setting|null
     */
    public static function findByKeyword($keyword)
    {
        return static::findOne(['keyword' => $keyword]);
    }

    /**
     * 获取公共配置
     */
    public static function findAllSetting()
    {
        return static::find()->orderBy('id asc')->all();
    }
}
