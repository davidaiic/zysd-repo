import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'/'el-icon-x' the icon show in the sidebar
    noCache: true                if set true, the page will no be cached(default is false)
    affix: true                  if set true, the tag will affix in the tags-view
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path(.*)',
        component: () => import('@/views/redirect/index')
      }
    ]
  },
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },
  {
    path: '/auth-redirect',
    component: () => import('@/views/login/auth-redirect'),
    hidden: true
  },
  {
    path: '/404',
    component: () => import('@/views/error-page/404'),
    hidden: true
  },
  {
    path: '/401',
    component: () => import('@/views/error-page/401'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        component: () => import('@/views/dashboard/index'),
        name: 'Dashboard',
        meta: { title: '首页', icon: 'dashboard', affix: true }
      }
    ]
  },
  {
    path: '/profile',
    component: Layout,
    redirect: '/profile/index',
    hidden: true,
    children: [
      {
        path: 'index',
        component: () => import('@/views/profile/index'),
        name: 'Profile',
        meta: { title: '个人中心', icon: 'user', noCache: true }
      }
    ]
  }
]

/**
 * asyncRoutes
 * the routes that need to be dynamically loaded based on user roles
 */
export const asyncRoutes = [
  {
    path: '/resource',
    component: Layout,
    redirect: '/resource/companyList',
    alwaysShow: true, // will always show the root menu
    name: 'Resource',
    meta: {
      title: '基础资料',
      icon: 'el-icon-s-data',
      roles: ['admin', 'editor']
    },
    children: [
      {
        path: 'companyList',
        component: () => import('@/views/resource/companyList'),
        name: 'ResourceCompanyList',
        meta: {
          title: '药厂管理',
          roles: ['admin']
        }
      },
      {
        path: 'channelList',
        component: () => import('@/views/resource/channelList'),
        name: 'ResourceChannelList',
        meta: {
          title: '渠道管理',
          roles: ['admin']
        }
      },
      {
        path: 'classList',
        component: () => import('@/views/resource/classList'),
        name: 'ResourceClassList',
        meta: {
          title: '分类管理',
          roles: ['admin']
        }
      },
      {
        path: 'goodsList',
        component: () => import('@/views/resource/goodsList'),
        name: 'ResourceGoodsList',
        meta: {
          title: '药品管理',
          roles: ['admin']
        }
      },
      {
        path: 'goodsServer',
        component: () => import('@/views/resource/goodsServer'),
        name: 'ResourceGoodsServer',
        meta: {
          title: '药品服务',
          roles: ['admin']
        }
      }
    ]
  },
  {
    path: '/member',
    component: Layout,
    redirect: '/member/userList',
    alwaysShow: true, // will always show the root menu
    name: 'Member',
    meta: {
      title: '用户管理',
      icon: 'el-icon-user-solid',
      roles: ['admin', 'editor']
    },
    children: [
      {
        path: 'userList',
        component: () => import('@/views/member/userList'),
        name: 'MemberUserList',
        meta: {
          title: '用户列表',
          roles: ['admin']
        }
      },
      {
        path: 'labelList',
        component: () => import('@/views/member/labelList'),
        name: 'MemberLabelList',
        meta: {
          title: '标签管理',
          roles: ['admin']
        }
      },
      {
        path: 'commentList',
        component: () => import('@/views/member/commentList'),
        name: 'MemberCommentList',
        meta: {
          title: '评论列表',
          roles: ['admin']
        }
      },
      {
        path: 'articleWord',
        component: () => import('@/views/member/articleWord'),
        name: 'MemberArticleWord',
        meta: {
          title: '资讯热门词',
          roles: ['admin']
        }
      },
      {
        path: 'articleList',
        component: () => import('@/views/member/articleList'),
        name: 'MemberArticleList',
        meta: {
          title: '资讯列表',
          roles: ['admin']
        }
      },
      {
        path: 'sensitive',
        component: () => import('@/views/member/sensitive'),
        name: 'MemberSensitive',
        meta: {
          title: '敏感词库',
          roles: ['admin']
        }
      },
      {
        path: 'searchList',
        component: () => import('@/views/member/searchList'),
        name: 'MemberSearchList',
        meta: {
          title: '搜索列表',
          roles: ['admin']
        }
      },
      {
        path: 'hotList',
        component: () => import('@/views/member/hotList'),
        name: 'MemberHotList',
        meta: {
          title: '热门列表',
          roles: ['admin']
        }
      },
      {
        path: 'manualSearchList',
        component: () => import('@/views/member/manualSearchList'),
        name: 'MemberManualSearchList',
        meta: {
          title: '人工核查',
          roles: ['admin']
        }
      },
      {
        path: 'companySearchList',
        component: () => import('@/views/member/companySearchList'),
        name: 'MemberCompanySearchList',
        meta: {
          title: '防伪查询',
          roles: ['admin']
        }
      },
      {
        path: 'priceSearchList',
        component: () => import('@/views/member/priceSearchList'),
        name: 'MemberPriceSearchList',
        meta: {
          title: '价格查询',
          roles: ['admin']
        }
      },
      {
        path: 'imageRecognition',
        component: () => import('@/views/member/imageRecognition'),
        name: 'MemberImageRecognition',
        meta: {
          title: '图片识别',
          roles: ['admin']
        }
      },
      {
        path: 'scanLog',
        component: () => import('@/views/member/scanLog'),
        name: 'MemberScanLog',
        meta: {
          title: '扫一扫',
          roles: ['admin']
        }
      },
      {
        path: 'comparePrice',
        component: () => import('@/views/member/comparePrice'),
        name: 'MemberComparePrice',
        meta: {
          title: '比价',
          roles: ['admin']
        }
      },
      {
        path: 'errorDirectory',
        component: () => import('@/views/member/errorDirectory'),
        name: 'MemberErrorDirectory',
        meta: {
          title: '纠错类目',
          roles: ['admin']
        }
      }
    ]
  },
  {
    path: '/system',
    component: Layout,
    redirect: '/system/banner',
    alwaysShow: true, // will always show the root menu
    name: 'System',
    meta: {
      title: '系统设置',
      icon: 'el-icon-setting',
      roles: ['admin', 'editor']
    },
    children: [
      {
        path: 'banner',
        component: () => import('@/views/system/banner'),
        name: 'SystemBanner',
        meta: {
          title: 'banner管理',
          roles: ['admin']
        }
      },
      {
        path: 'explain',
        component: () => import('@/views/system/explain'),
        name: 'SystemExplain',
        meta: {
          title: '文案管理',
          roles: ['admin']
        }
      },
      {
        path: 'appVersion',
        component: () => import('@/views/system/appVersion'),
        name: 'SystemAppVersion',
        meta: {
          title: 'APP版本管理',
          roles: ['admin']
        }
      },
      {
        path: 'webUrl',
        component: () => import('@/views/system/webUrl'),
        name: 'SystemWebUrl',
        meta: {
          title: 'web链接',
          roles: ['admin']
        }
      },
      {
        path: 'commonSetting',
        component: () => import('@/views/system/commonSetting'),
        name: 'SystemCommonSetting',
        meta: {
          title: '公共配置',
          roles: ['admin']
        }
      },
      {
        path: 'feedback',
        component: () => import('@/views/system/feedback'),
        name: 'SystemFeedback',
        meta: {
          title: '意见反馈',
          roles: ['admin']
        }
      }
    ]
  },
  {
    path: '/permission',
    component: Layout,
    redirect: '/permission/list',
    alwaysShow: true, // will always show the root menu
    name: 'Permission',
    meta: {
      title: '权限设置',
      icon: 'el-icon-set-up',
      roles: ['admin', 'editor']
    },
    children: [
      {
        path: 'list',
        component: () => import('@/views/permission/list'),
        name: 'ListPermission',
        meta: {
          title: '权限列表',
          roles: ['admin']
        }
      },
      {
        path: 'role',
        component: () => import('@/views/permission/role'),
        name: 'RolePermission',
        meta: {
          title: '角色列表',
          roles: ['admin']
        }
      },
      {
        path: 'roleSetting/:id(\\d+)',
        component: () => import('@/views/permission/roleSetting'),
        name: 'RoleSettingPermission',
        meta: {
          title: '配置权限',
          roles: ['admin'],
          activeMenu: '/permission/role'
        },
        hidden: true
      },
      {
        path: 'userList',
        component: () => import('@/views/permission/userList'),
        name: 'UserListPermission',
        meta: {
          title: '用户列表',
          roles: ['admin']
        }
      }
    ]
  }

  // 404 page must be placed at the end !!!  现在放在动态路由的后面加载了
  // { path: '*', redirect: '/404', hidden: true }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRoutes
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
