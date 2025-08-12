<?php

namespace backend\models\service;

use backend\components\Helper;
use backend\models\permission\Permissions;
use backend\models\permission\RolePermissions;
use backend\models\permission\Roles;
use backend\models\permission\UserRoles;
use backend\models\user\AdminUser;
use common\components\Tool;
use Exception;
use yii\base\ExitException;
use yii\db\Query;

/**
 * 权限
 */
class PermissionService
{
    /**
     * 获取权限列表
     * @param string $menuName 菜单名称
     * @param string $name 权限名称
     * @param string $alias 别名
     * @param string $route 路由
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getPermissionsList($menuName, $name, $alias, $route, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取列表
        $query = new Query();
        $list = $query->select(['p.id as perId',
            'p.name',
            'p.alias',
            'p.route',
            'p.icon',
            'p.parent_id as menuId',
            'ifnull(sp.name, "") as menuName',
            'p.is_menu as isMenu',
            'p.sort',
            'FROM_UNIXTIME(p.created, "%Y-%m-%d %H:%i") as created'])
            ->from('ky_permissions as p')
            ->leftJoin('ky_permissions as sp', 'sp.id = p.parent_id')
            ->where(['p.parent_id' => 0]);

        if ($menuName) {
            $list->andWhere(['like', 'sp.name', $menuName]);
        }

        if ($name) {
            $list->andWhere(['like', 'p.name', $name]);
        }

        if ($alias) {
            $list->andWhere(['like', 'p.alias', $alias]);
        }

        if ($route) {
            $list->andWhere(['like', 'p.route', $route]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->orderBy('p.sort desc, p.created desc')
            ->offset($offset)
            ->limit($limit)
            ->all();

        if ($list) {
            foreach ($list as $key => &$value) {
                $value['children'] = self::getChildMenu($value['perId']);
            }
        }

        return ['permissionList' => $list, 'total' => $total];
    }

    /**
     * 获取二级权限列表
     * @param string $perId 权限id
     * @return array
     */
    public static function getChildMenu($perId)
    {
        $query = new Query();
        return $query->select(['p.id as perId',
            'p.name',
            'p.alias',
            'p.route',
            'p.icon',
            'p.parent_id as menuId',
            'ifnull(sp.name, "") as menuName',
            'p.is_menu as isMenu',
            'p.sort',
            'FROM_UNIXTIME(p.created, "%Y-%m-%d %H:%i") as created'])
            ->from('ky_permissions as p')
            ->leftJoin('ky_permissions as sp', 'sp.id = p.parent_id')
            ->where(['p.parent_id' => $perId])
            ->orderBy('p.sort desc, p.created desc')
            ->all();
    }

    /**
     * 获取角色列表
     * @param string $roleName 角色名称
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getRoleList($roleName, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取角色列表
        $query = new Query();
        $list = $query->select(['id as roleId',
            'name as roleName',
            'alias',
            'note',
            'type',
            'FROM_UNIXTIME(created, "%Y-%m-%d %H:%i") as created'])
            ->from('ky_roles');

        if ($roleName) {
            $list->andWhere(['like', 'name', $roleName]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->offset($offset)->limit($limit)->all();

        return ['roleList' => $list, 'total' => $total];
    }

    /**
     * 获取全部角色
     * @param string $roleName 角色名称
     * @return array
     */
    public static function getRoleAll($roleName)
    {
        //获取全部角色
        $roles = Roles::findAllRoles($roleName);

        $roleList = [];
        if ($roles) {
            foreach ($roles as $key => $value) {
                $roleList[] = [
                    'roleId'   => $value['id'],
                    'roleName' => $value['name'],
                ];
            }
        }

        return $roleList;
    }

    /**
     * 获取用户列表
     * @param string $username 用户名
     * @param int $roleId 角色id
     * @param int $page 页数
     * @param int $limit 数量
     * @return array
     */
    public static function getUserList($username, $roleId, $page, $limit)
    {
        $offset = Tool::getOffset($page, $limit);

        //获取用户列表
        $query = new Query();
        $list = $query->select(['au.id as uid',
            'au.username',
            'au.mobile',
            'r.id as roleId',
            'r.name as roleName'])
            ->from('ky_admin_user as au')
            ->innerJoin('ky_user_roles as ur', 'ur.user_id = au.id')
            ->innerJoin('ky_roles as r', 'r.id = ur.role_id');

        if ($username) {
            $list->andWhere(['like', 'au.username', $username]);
        }

        if ($roleId) {
            $list->andWhere(['r.id' => $roleId]);
        }

        //获取总数量
        $total = $list->count();

        $list = $list->offset($offset)->limit($limit)->all();

        return ['userList' => $list, 'total' => $total];
    }

    /**
     * 获取全部权限
     */
    public static function getPermissionAll()
    {
        //获取全部权限
        $query = new Query();
        $list = $query->select(['id as perId',
            'name',
            'route',
            'icon',
            'parent_id as parentId',
            'is_menu as isMenu'])
            ->from('ky_permissions')
            ->orderBy('parent_id asc, sort desc, created desc')
            ->all();

        $result = [];
        if ($list) {
            foreach ($list as $key => $value) {
                if (!$value['parentId']) {
                    //一级分类
                    $result[$value['perId']]['name'] = $value['route'];
                    $result[$value['perId']]['isMenu'] = $value['isMenu'];
                    $result[$value['perId']]['meta']['title'] = $value['name'];
                    $result[$value['perId']]['meta']['icon'] = $value['icon'];
                    $result[$value['perId']]['meta']['roles'] = self::getPermissionRolesList($value['perId']);

                    //判断有没有定义数组
                    if (!isset($result[$value['perId']]['children'])) {
                        $result[$value['perId']]['children'] = [];
                    }
                } else {
                    //子分类
                    $result[$value['parentId']]['children'][] = [
                        'name'   => $value['route'],
                        'isMenu' => $value['isMenu'],
                        'meta'   => [
                            'title' => $value['name'],
                            'icon'  => $value['icon'],
                            'roles' => self::getPermissionRolesList($value['perId'])
                        ]
                    ];
                }
            }
        }

        return ['deployList' => array_values($result)];
    }

    /**
     * 根据权限id获取角色列表
     * @param string $perId 权限id
     * @return array
     */
    public static function getPermissionRolesList($perId)
    {
        //获取角色信息
        $query = new Query();
        $rolesInfo = $query->select(['r.alias'])
            ->from('ky_roles as r')
            ->innerJoin('ky_role_permissions as rp', 'rp.role_id = r.id')
            ->where('rp.permission_id = :perId')
            ->addParams([':perId' => $perId])
            ->all();

        $arr = [];
        if ($rolesInfo) {
            foreach ($rolesInfo as $key => $value) {
                $arr[] = $value['alias'];
            }
        }

        if (!in_array('admin', $arr)) {
            $arr = array_merge(['admin'], $arr);
        }

        return $arr;
    }

    /**
     * 获取菜单列表
     */
    public static function getMenuList()
    {
        //获取菜单列表
        $query = new Query();
        return $query->select(['id as menuId', 'name as menuName'])
            ->from('ky_permissions')
            ->where(['parent_id' => 0, 'is_menu' => 1])
            ->orderBy('sort desc')
            ->all();
    }

    /**
     * 权限操作
     * @param int $menuId 父id
     * @param string $name 名称
     * @param string $alias 别名
     * @param string $route 路由
     * @param string $icon 图标
     * @param int $isMenu 是否菜单：0-否，1-是
     * @param int $sort 排序
     * @param int $type 操作类型：1-新建，2-更新
     * @param int $perId 权限id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithPermission($menuId, $name, $alias, $route, $icon, $isMenu, $sort, $type, $perId)
    {
        //判断路由是否重复
        $exist = Permissions::checkRoute($route, $menuId, $perId);

        if ($exist) Helper::responseError(1023);

        if ($type == 2) {
            $permission = Permissions::findByPerId($perId);

            if (!$permission) Helper::responseError(1024);

            $permission->updated = time();
        } else {
            $permission = new Permissions();
            $permission->created = time();
        }

        $permission->name = $name;
        $permission->alias = $alias;
        $permission->route = $route;
        $permission->icon = $icon;
        $permission->parent_id = $menuId;
        $permission->is_menu = $isMenu;
        $permission->sort = $sort;

        return $permission->save();
    }

    /**
     * 角色操作
     * @param string $roleName 名称
     * @param string $alias 别名
     * @param string $note 备注
     * @param int $type 操作类型：1-新建，2-更新，3-删除
     * @param int $roleId 角色id
     * @return bool|false|int
     * @throws ExitException
     */
    public static function dealWithRole($roleName, $alias, $note, $type, $roleId)
    {
        //判断角色名称是否存在
        $exist = Roles::checkRoleName($roleName, $roleId);

        if ($exist) Helper::responseError(1026);

        if ($type != 1) {
            $roles = Roles::findByRoleId($roleId);

            if (!$roles) Helper::responseError(1025);

            if ($type == 3) {
                return $roles->delete();
            }

            $roles->updated = time();
        } else {
            $roles = new Roles();
            $roles->type = 1;
            $roles->created = time();
        }

        $roles->name = $roleName;
        $roles->alias = $alias;
        $roles->note = $note;

        return $roles->save();
    }

    /**
     * 获取配置权限列表
     * @param int $roleId 角色id
     * @return array
     */
    public static function getPermissionDeploy($roleId)
    {
        //获取权限列表
        $list = Permissions::findAllPermission();

        $result = [];
        $checkList = [];
        if ($list) {
            //获取该角色拥有的权限
            $roleHasPermissions = self::getRolePermissionsList($roleId);

            foreach ($list as $key => $value) {
                if (!$value['parent_id']) {
                    //一级分类
                    $result[$value['id']]['perId'] = $value['id'];
                    $result[$value['id']]['name'] = $value['name'];
                    $result[$value['id']]['isMenu'] = $value['is_menu'];

                    //判断有没有定义数组
                    if (!isset($result[$value['id']]['menuList'])) {
                        $result[$value['id']]['menuList'] = [];
                    }
                } else {
                    //子分类
                    $result[$value['parent_id']]['menuList'][] = [
                        'perId'  => $value['id'],
                        'name'   => $value['name'],
                        'isMenu' => $value['is_menu'],
                    ];
                }

                //判断是否拥有权限
                if (in_array($value['id'], $roleHasPermissions)) {
                    $checkList[] = $value['id'];
                }
            }
        }

        return ['deployList' => array_values($result), 'checkList' => $checkList];
    }

    /**
     * 根据角色id获取权限列表
     * @param string $roleId 角色id
     * @return array
     */
    public static function getRolePermissionsList($roleId)
    {
        $rolePermissionsList = RolePermissions::findByRoleId($roleId);

        $arr = [];
        if (!empty($rolePermissionsList)) {
            foreach ($rolePermissionsList as $key => $value) {
                $arr[] = $value['permission_id'];
            }
        }

        return $arr;
    }

    /**
     * 保存配置权限
     * @param string $roleId 角色id
     * @param array $perIdArr 权限id集合
     * @return bool
     */
    public static function getKeepDeploy($roleId, $perIdArr)
    {
        //开启事务
        $transaction = RolePermissions::getDb()->beginTransaction();
        try {
            RolePermissions::deleteAll(['role_id' => $roleId]);

            foreach ($perIdArr as $key => $value) {
                $rolePermissions = new RolePermissions();
                $rolePermissions->permission_id = $value;
                $rolePermissions->role_id = $roleId;
                $rolePermissions->save();
            }

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }

    /**
     * 用户操作
     * @param string $mobile 手机账号
     * @param string $username 姓名
     * @param int $roleId 角色id
     * @param int $type 操作类型：1-新建，2-更新，3-删除，4-重置密码
     * @param int $uid 用户id
     * @return bool
     * @throws ExitException
     */
    public static function dealWithUserInfo($mobile, $username, $roleId, $type, $uid)
    {
        if ($type != 1) {
            //获取用户信息
            $userInfo = AdminUser::findIdentity($uid);

            if (!$userInfo) Helper::responseError(1006);

            //删除用户
            if ($type == 3) {
                //开启事务
                $transaction = AdminUser::getDb()->beginTransaction();
                try {
                    $userInfo->delete();
                    UserRoles::deleteAll(['user_id' => $uid]);

                    $transaction->commit();
                    return true;
                } catch(Exception $e) {
                    $transaction->rollBack();
                    return false;
                } catch(\Throwable $e) {
                    $transaction->rollBack();
                    return false;
                }
            }

            //重置密码
            if ($type == 4) {
                $userInfo->password = md5('12345a');
                return $userInfo->save();
            }

            $userInfo->updated = time();
        } else {
            $userInfo = new AdminUser();
            $userInfo->password = md5('12345a');
            $userInfo->created = time();
        }

        //判断手机号是否已有
        $phoneExist = AdminUser::checkMobile($mobile, $uid);

        if ($phoneExist) Helper::responseError(1027);

        //开启事务
        $transaction = AdminUser::getDb()->beginTransaction();
        try {
            $userInfo->username = $username;
            $userInfo->mobile = $mobile;
            $userInfo->save();

            $uid = $userInfo->attributes['id'];

            //先删除用户角色关联
            UserRoles::deleteAll(['user_id' => $uid]);

            //再插入新角色
            $userRoles = new UserRoles();
            $userRoles->role_id = $roleId;
            $userRoles->user_id = $uid;
            $userRoles->save();

            $transaction->commit();
            return true;
        } catch(Exception $e) {
            $transaction->rollBack();
            return false;
        } catch(\Throwable $e) {
            $transaction->rollBack();
            return false;
        }
    }
}
