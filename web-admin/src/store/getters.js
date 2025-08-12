const getters = {
  sidebar: state => state.app.sidebar,
  language: state => state.app.language,
  size: state => state.app.size,
  device: state => state.app.device,
  visitedViews: state => state.tagsView.visitedViews,
  cachedViews: state => state.tagsView.cachedViews,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  username: state => state.user.username,
  mobile: state => state.user.mobile,
  roles: state => state.user.roles,
  roleNames: state => state.user.roleNames,
  permission_routes: state => state.permission.routes,
  permission_list: state => state.permission.permissionList,
  errorLogs: state => state.errorLog.logs
}
export default getters
