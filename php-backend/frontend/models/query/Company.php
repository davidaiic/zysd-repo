<?php

namespace frontend\models\query;

use yii\db\ActiveRecord;

/**
 * 药厂模块
 * @property mixed|string|null company_name 药厂名称
 * @property mixed|string|null en_name 英文药厂名称
 * @property mixed|string|null company_image 药厂图片
 * @property mixed|string|null code_query 防伪码查询方法
 * @property mixed|string|null request_url 药厂查询url
 * @property mixed|string|null request_method 请求方式
 * @property mixed|string|null element 标识元素
 * @property mixed|string|null result_field 结果字段标识
 * @property mixed|string|null sort 排序
 * @property mixed|string|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null hot_type 热门类型：0-非热门，1-国外仿制药热门，2-其他热门
 * @property mixed|string|null is_delete 是否删除：0-否，1-是
 * @property mixed|string|null created 创建时间
 * @property mixed|string|null updated 更新时间
 */
class Company extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_company}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取所有药厂
     * @param int $type 类型：0-全部，1-对接了第三方查询的药厂
     * @param int $offset 起始位置
     * @param int $pageSize 数量
     * @return array|ActiveRecord
     */
    public static function findAllCompany($type, $offset, $pageSize)
    {
        $list = static::find()->where(['enable' => 0, 'is_delete' => 0]);

        if ($type == 1) {
            $list->andWhere(['<>', 'request_url', '']);
        }

        return $list->orderBy('sort desc,id desc')->offset($offset)->limit($pageSize)->all();
    }

    /**
     * 获取所有热门药厂
     * @param int $type 类型：1-国外仿制药热门厂家，2-其他热门药厂
     * @return array|ActiveRecord
     */
    public static function findAllHotCompany($type)
    {
        return static::find()->where(['enable' => 0, 'is_delete' => 0, 'hot_type' => $type])->orderBy('sort desc,id desc')->all();
    }

    /**
     * 获取药厂信息
     * @param int $companyId 药厂id
     * @return Company|null
     */
    public static function findByCompanyId($companyId)
    {
        return static::findOne(['id' => $companyId]);
    }

    /**
     * 获取药厂信息
     * @param string $companyName 药厂名称
     * @return Company|null
     */
    public static function findByCompanyName($companyName)
    {
        return static::findOne(['company_name' => $companyName]);
    }

    /**
     * 获取药厂信息
     * @param int $companyId 药厂id
     * @return Company|null
     */
    public static function findCompanyDetail($companyId)
    {
        return static::findOne(['id' => $companyId, 'enable' => 0, 'is_delete' => 0]);
    }
}
