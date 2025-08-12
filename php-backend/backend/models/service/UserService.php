<?php

namespace backend\models\service;

use backend\components\Helper;
use backend\models\user\AdminUser;
use Yii;
use yii\base\ExitException;
use yii\db\Query;

/**
 * 用户
 */
class UserService
{
    public static $tokenPrefix = 'token_';

    public static $uidPrefix = 'system_';

    public static $expires = 3600 * 24 * 30;

    /**
     * 登录
     * @param string $phone 手机号码
     * @param string $password 登录密码
     * @return array
     * @throws ExitException
     */
    public static function login($phone, $password)
    {
        //获取用户信息
        $userInfo = AdminUser::findByPhone($phone);

        if (!$userInfo) Helper::responseError(1006);

        if ($userInfo['password'] !== md5($password)) Helper::responseError(1022);

        //生成token
        $token = self::createToken($userInfo['id']);

        return ['token' => $token];
    }

    /**
     * 获取用户信息
     * @param int $uid 用户id
     * @return array
     * @throws ExitException
     */
    public static function getUserInfo($uid)
    {
        //获取用户信息
        $userInfo = AdminUser::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        //获取用户角色
        $roles = self::getUserRoles($uid);

        //获取用户角色名称
        $roleNames = self::getUserRoleNames($uid);

        return [
            'username'  => $userInfo['username'],
            'mobile'    => $userInfo['mobile'],
            'avatar'    => $userInfo['avatar'],
            'roles'     => $roles,
            'roleNames' => $roleNames
        ];
    }

    /**
     * 获取用户角色
     * @param int $uid 用户id
     * @return array
     */
    public static function getUserRoles($uid)
    {
        $query = new Query();
        $rolesInfo = $query->select(['r.alias'])
            ->from('ky_user_roles as ur')
            ->innerJoin('ky_roles as r', 'r.id = ur.role_id')
            ->where('ur.user_id = :uid')
            ->addParams([':uid' => $uid])
            ->all();

        $list = [];
        if ($rolesInfo) {
            foreach ($rolesInfo as $key => $value) {
                $list[] = $value['alias'];
            }
        }

        return $list;
    }

    /**
     * 获取用户角色
     * @param int $uid 用户id
     * @return array
     */
    public static function getUserRoleNames($uid)
    {
        $query = new Query();
        $rolesInfo = $query->select(['r.name'])
            ->from('ky_user_roles as ur')
            ->innerJoin('ky_roles as r', 'r.id = ur.role_id')
            ->where('ur.user_id = :uid')
            ->addParams([':uid' => $uid])
            ->all();

        $list = [];
        if ($rolesInfo) {
            foreach ($rolesInfo as $key => $value) {
                $list[] = $value['name'];
            }
        }

        return $list;
    }

    /**
     * 修改密码
     * @param int $uid 用户id
     * @param string $password 密码
     * @return bool
     * @throws ExitException
     */
    public static function changePassword($uid, $password)
    {
        //获取用户信息
        $userInfo = AdminUser::findIdentity($uid);

        if (!$userInfo) Helper::responseError(1006);

        $userInfo->password = md5($password);

        return $userInfo->save();
    }

    /**
     * 生成token
     * @param int $uid 用户id
     * @return string
     */
    private static function createToken($uid)
    {
        //唯一登录判断
        $token = Yii::$app->cache->get($uid);

        if ($token) {
            //删除token
            self::destroyToken($token);
        }

        //生成token
        $token = md5($uid . time());

        //保存token
        self::saveToken($token, $uid);

        return $token;
    }

    /**
     * 删除token
     * @param string $token token
     * @return boolean
     */
    public static function deleteToken($token)
    {
        //销毁token
        self::destroyToken($token);

        return self::existToken($token);
    }

    /**
     * 保存token
     * @param string $token token
     * @param int $uid 用户id
     */
    private static function saveToken($token, $uid)
    {
        Yii::$app->cache->set(self::$tokenPrefix . $token, $uid, self::$expires);
        Yii::$app->cache->set(self::$uidPrefix . $uid, $token, self::$expires);
    }

    /**
     * 销毁token
     * @param string $token token
     */
    private static function destroyToken($token)
    {
        //先获取uid
        $uid = Yii::$app->cache->get(self::$tokenPrefix . $token);

        if ($uid) {
            //销毁token
            Yii::$app->cache->delete(self::$uidPrefix . $uid);
        }

        Yii::$app->cache->delete(self::$tokenPrefix . $token);
    }

    /**
     * 判断token是否存在
     * @param string $token token
     * @return boolean
     */
    protected static function existToken($token)
    {
        return Yii::$app->cache->get(self::$tokenPrefix . $token) ? false : true;
    }
}
