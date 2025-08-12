<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 药品纠错类目模块
 * @property int|mixed|null uid 用户id
 * @property int|mixed|null goods_id 药品id
 * @property mixed|string|null keywords 关键词标识
 * @property int|mixed|null created 创建时间
 */
class GoodsErrorDirectory extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_goods_error_directory}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }
}
