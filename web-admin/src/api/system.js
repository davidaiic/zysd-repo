import request from '@/utils/request'

// banner列表
export function banner(data) {
  return request({
    url: '/system/banner',
    method: 'post',
    data
  })
}

// banner操作
export function dealBanner(data) {
  return request({
    url: '/system/dealBanner',
    method: 'post',
    data
  })
}

// 文案列表
export function explain(data) {
  return request({
    url: '/system/explain',
    method: 'post',
    data
  })
}

// 文案操作
export function dealExplain(data) {
  return request({
    url: '/system/dealExplain',
    method: 'post',
    data
  })
}

// app版本列表
export function appVersion(data) {
  return request({
    url: '/system/appVersion',
    method: 'post',
    data
  })
}

// app版本操作
export function dealAppVersion(data) {
  return request({
    url: '/system/dealAppVersion',
    method: 'post',
    data
  })
}

// 公共配置
export function commonSetting(data) {
  return request({
    url: '/system/commonSetting',
    method: 'post',
    data
  })
}

// 处理公共配置
export function dealCommonSetting(data) {
  return request({
    url: '/system/dealCommonSetting',
    method: 'post',
    data
  })
}

// 意见反馈
export function feedback(data) {
  return request({
    url: '/system/feedback',
    method: 'post',
    data
  })
}

// web链接管理
export function webUrl(data) {
  return request({
    url: '/system/webUrl',
    method: 'post',
    data
  })
}

// web链接操作
export function dealWebUrl(data) {
  return request({
    url: '/system/dealWebUrl',
    method: 'post',
    data
  })
}
