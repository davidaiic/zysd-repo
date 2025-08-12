<?php

namespace frontend\models\plugin;

use yii\db\ActiveRecord;

/**
 * 文案模块
 * @property mixed|string|null keyword 关键字标识
 * @property mixed|string|null title 标题
 * @property mixed|string|null content 内容
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property mixed|string|null remark 备注
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Explain extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_explain}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取文案内容
     * @param string $keyword 关键词
     * @return Explain|null
     */
    public static function findByKeyword($keyword)
    {
        return static::findOne(['keyword' => $keyword, 'enable' => 0]);
    }

    /**
     * 获取文案内容
     * @param int $explainId 文案id
     * @return Explain|null
     */
    public static function findByExplainId($explainId)
    {
        return static::findOne(['id' => $explainId]);
    }
}
