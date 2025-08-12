<?php

namespace frontend\models\home;

use yii\db\ActiveRecord;
use yii\db\Expression;
use yii\db\Query;

/**
 * 资讯模块
 * @property int|mixed|null uid 用户id
 * @property mixed|string|null title 标题
 * @property mixed|string|null cover 封面
 * @property mixed|string|null publish_date 发布日期
 * @property mixed|string|null label 标签，多个标签以,隔开
 * @property mixed|string|null content 内容
 * @property int|mixed|null is_top 是否置顶：0-否，1-是
 * @property mixed|string|null sort 排序
 * @property int|mixed|null enable 状态：0-正常，1-禁用
 * @property int|mixed|null is_delete 是否删除：0-否，1-是
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class Article extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_article}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取资讯列表
     * @param string $keyword 搜索词
     * @param string $sortId 排序id
     * @param array $labelNameList 标签名称列表
     * @param int $offset 起始位置
     * @param int $pageSize 数量
     * @return array
     */
    public static function findArticleList($keyword, $sortId, $labelNameList, $offset, $pageSize)
    {
        $condition = 'enable = 0 and is_delete = 0';
        $params = [];

        //搜索词
        if ($keyword) {
            $condition .= ' and (title like :keyword or label like :keyword or content like :keyword)';
            $params = [':keyword' => '%' . $keyword . '%'];
        }

        //标签筛选
        if (!empty($labelNameList)) {
            $label = '';

            foreach ($labelNameList as $key => $value) {
                $label .= "label like '%" . $value . "%' or ";
            }

            if ($label) {
                $condition .= ' and (' . rtrim($label, ' or ') . ')';
            }
        }

        //排序
        if ($sortId == '1') {
            $orderBy = 'created desc,id desc';
        } else {
            $orderBy = [new Expression('is_top desc,sort = 0,sort asc,created desc,id desc')];
        }

        $query = new Query();
        return $query->select(['id as articleId',
            'title',
            'cover',
            'label',
            'like_num as likeNum',
            'comment_num as commentNum',
            'if(read_num > 0, read_num * 7, 0) as readNum',
            'created'])
            ->from('ky_article')
            ->where($condition)
            ->addParams($params)
            ->orderBy($orderBy)
            ->offset($offset)
            ->limit($pageSize)
            ->all();
    }

    /**
     * 根据药品名称获取相关资讯
     * @param string $goodsName 药品名称
     * @param string $enName 英文药品名称
     * @param int $offset 起始位置
     * @param int $pageSize 数量
     * @return array
     */
    public static function findByGoodsName($goodsName, $enName, $offset, $pageSize)
    {
        $condition = 'enable = 0 and is_delete = 0';

        $otherCondition = '';

        //药品名称筛选
        if ($goodsName) {
            $otherCondition .= "title like '%" . $goodsName . "%' or content like '%" . $goodsName . "%' or ";
        }

        //英文药品名称筛选
        if ($enName) {
            $otherCondition .= "title like '%" . $enName . "%' or content like '%" . $enName . "%'";
        }

        if ($otherCondition) {
            $condition .= ' and (' . rtrim($otherCondition, ' or ') . ')';
        }

        $query = new Query();
        return $query->select(['id as articleId',
            'title',
            'cover',
            'label',
            'like_num as likeNum',
            'comment_num as commentNum',
            'if(read_num > 0, read_num * 7, 0) as readNum',
            'created'])
            ->from('ky_article')
            ->where($condition)
            ->orderBy([new Expression('is_top desc,sort = 0,sort asc,created desc,id desc')])
            ->offset($offset)
            ->limit($pageSize)
            ->all();
    }

    /**
     * 根据资讯id获取资讯信息
     * @param int $articleId 资讯id
     * @return Article|null
     */
    public static function findByArticleId($articleId)
    {
        return static::findOne(['id' => $articleId]);
    }
}
