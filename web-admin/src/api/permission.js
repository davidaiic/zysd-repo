import request from '@/utils/request'

export function fetchList(data) {
  return request({
    url: '/permission/permissionList',
    method: 'post',
    data
  })
}

export function deal(data) {
  return request({
    url: '/permission/dealPermission',
    method: 'post',
    data
  })
}

export function fetchRoleList(data) {
  return request({
    url: '/permission/roleList',
    method: 'post',
    data
  })
}

export function dealRole(data) {
  return request({
    url: '/permission/dealRole',
    method: 'post',
    data
  })
}

export function fetchRoleSettingList(data) {
  return request({
    url: '/permission/permissionDeploy',
    method: 'post',
    data
  })
}

export function dealRoleSetting(data) {
  return request({
    url: '/permission/keepDeploy',
    method: 'post',
    data
  })
}

export function fetchUserList(data) {
  return request({
    url: '/permission/userList',
    method: 'post',
    data
  })
}

export function fetchRoleAllList(data) {
  return request({
    url: '/permission/roleAll',
    method: 'post',
    data
  })
}

export function dealUser(data) {
  return request({
    url: '/permission/setRole',
    method: 'post',
    data
  })
}

// 获取权限
export function permissionAll(data) {
  return request({
    url: '/permission/permissionAll',
    method: 'post',
    data
  })
}

// 菜单列表
export function menuList(data) {
  return request({
    url: '/permission/menuList',
    method: 'post',
    data
  })
}
