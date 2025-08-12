import { asyncRoutes, constantRoutes } from '@/router'
import { deepClone } from '@/utils'
import { permissionAll } from '@/api/permission'

const clientRoutes = deepClone(asyncRoutes)

/**
 * 原本：没有route.meta 或者 没有route.meta.roles 都是按照不需要权限   return true
 * Use meta.role to determine if the current user has permission
 * @param roles
 * @param route
 */
function hasPermission(roles, route) {
  if (route.meta && route.meta.roles) {
    return roles.some(role => route.meta.roles.includes(role))
  } else {
    // return true
    return false
  }
}

/**
 *
 * @param {arr} clientAsyncRoutes 前端保存动态路由
 * @param {arr} serverRouter 后端保存动态路由
 */
function makePermissionRouters(serverRouter, clientAsyncRoutes) {
  const res = []
  clientAsyncRoutes.forEach(route => {
    const tmp = { ...route }
    for (let i = 0; i < serverRouter.length; i++) {
      const element = serverRouter[i]
      // 名字相同且是菜单
      if (tmp.name === element.name) {
        route.meta.title = element.meta.title
        route.meta.roles = element.meta.roles
        route.meta.icon = element.meta.icon

        tmp.hidden = element.isMenu !== '1'
        if (tmp.children && element.children) {
          tmp.children = makePermissionRouters(element.children, tmp.children)
        }
        res.push(tmp)
      }
    }
  })
  return res
}

/**
 *如果是admin用户,更改meta属性
 * @param {arr} clientAsyncRoutes 前端保存动态路由
 * @param {arr} serverRouter 后端保存动态路由
 */
function handleAdminRouterSetting(serverRouter, clientAsyncRoutes) {
  clientAsyncRoutes.forEach(route => {
    for (let i = 0; i < serverRouter.length; i++) {
      const element = serverRouter[i]
      // 名字相同且是菜单
      if (route.name === element.name) {
        route.meta.title = element.meta.title
        route.meta.roles = element.meta.roles
        route.meta.icon = element.meta.icon

        if (route.children && element.children) {
          route.children = handleAdminRouterSetting(element.children, route.children)
        }
      }
    }
  })
  return clientAsyncRoutes
}

/**
 * Filter asynchronous routing tables by recursion
 * @param routes asyncRoutes
 * @param roles
 */
export function filterAsyncRoutes(routes, roles) {
  const res = []

  routes.forEach(route => {
    const tmp = { ...route }
    if (hasPermission(roles, tmp)) {
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, roles)
      }
      res.push(tmp)
    }
  })

  return res
}

const state = {
  routes: [],
  addRoutes: [],
  permissionList: []
}

const mutations = {
  SET_ROUTES: (state, routes) => {
    state.addRoutes = routes
    state.routes = constantRoutes.concat(routes)
  },
  PERMISSION_LIST: (state, permissionList) => {
    state.permissionList = permissionList
  }
}

const actions = {
  async  generateRoutes({ commit }, roles) {
    const serverRouterAll = await permissionAll().then((res) => {
      return res.data.deployList
    }).catch(() => {
      return []
    })

    // 平铺展开成一位数组
    const permissionList = serverRouterAll.reduce((result, item) => {
      if (item.children && item.children.length > 0) {
        result = [...result, item, ...item.children]
      } else {
        result = [...result, item]
      }
      return result
    }, [])

    commit('PERMISSION_LIST', permissionList)

    return new Promise(resolve => {
      let accessedRoutes
      if (roles.includes('admin')) {
        accessedRoutes = handleAdminRouterSetting(serverRouterAll, clientRoutes) || []
      } else {
        const permissionRouters = makePermissionRouters(serverRouterAll, clientRoutes)
        accessedRoutes = filterAsyncRoutes(permissionRouters, roles)
      }
      // 注意事项 这里有一个需要非常注意的地方就是 404 页面一定要最后加载，如果放在 constantRoutes 一同声明了 404 ，
      // 后面的所有页面都会被拦截到404
      // https://github.com/vuejs/vue-router/issues/1176
      const notfoundPage = { path: '*', redirect: '/404', hidden: true }
      accessedRoutes = [...accessedRoutes, notfoundPage]
      commit('SET_ROUTES', accessedRoutes)
      resolve(accessedRoutes)
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
