<?php

namespace frontend\models\plugin;

use yii\db\ActiveRecord;

/**
 * 版本模块
 * @property mixed|string|null version_number 版本号
 * @property mixed|string|null version_code 小版本号
 * @property mixed|string|null content 更新内容
 * @property int|mixed|null is_must 更新类型：1-非强制，2-强制更新(可取消)，3-强制更新(不可取消)
 * @property int|mixed|null status 状态：1-上线，2-下线
 * @property mixed|string|null download_url 下载地址
 * @property int|mixed|null platform 系统类型：1-android，2-ios
 * @property int|mixed|null created 创建时间
 * @property int|mixed|null updated 更新时间
 */
class AppVersion extends ActiveRecord
{
    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return '{{%ky_app_version}}';
    }

    /**
     * {@inheritdoc}
     */
    public function behaviors()
    {
        return [];
    }

    /**
     * 获取版本信息
     * @param int $id 记录id
     * @return AppVersion|null
     */
    public static function findById($id)
    {
        return static::findOne(['id' => $id]);
    }

    /**
     * 获取最新的版本更新记录
     * @param string $os 系统类型
     * @param string $version 版本号
     * @return array|ActiveRecord
     */
    public static function findByVersion($os, $version)
    {
        if ($os == 'android') {
            $platform = 1;
        } else {
            $platform = 2;
        }

        return static::find()->where(['status' => 1, 'type' => 1, 'platform' => $platform])->andWhere(['>', 'version_number', $version])->orderBy('version_number desc,id desc')->limit(1)->one();
    }
}
