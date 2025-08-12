/**
 * 获取文件的后缀
 * @param {string} str
 * @returns {Boolean}
 */
export function getFileExt(str) {
  return str.substring(str.lastIndexOf('.') + 1).toLowerCase()
}

/**
 * 原本：没有route.meta 或者 没有route.meta.roles 都是按照不需要权限   return true
 * Use meta.role to determine if the current user has permission
 * @param roles
 * @param route
 */
export function hasPermission(roles, route) {
  if (roles && roles.includes('admin')) {
    return true
  }
  if (route && route.meta && route.meta.roles) {
    return roles.some(role => route.meta.roles.includes(role))
  } else {
    // return true
    return false
  }
}
