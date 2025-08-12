import request from '@/utils/request'

// 药厂列表
export function companyList(data) {
  return request({
    url: '/resource/companyList',
    method: 'post',
    data
  })
}

// 药厂操作
export function dealCompany(data) {
  return request({
    url: '/resource/dealCompany',
    method: 'post',
    data
  })
}

// 渠道列表
export function channelList(data) {
  return request({
    url: '/resource/channelList',
    method: 'post',
    data
  })
}

// 渠道操作
export function dealChannel(data) {
  return request({
    url: '/resource/dealChannel',
    method: 'post',
    data
  })
}

// 药品列表
export function goodsList(data) {
  return request({
    url: '/resource/goodsList',
    method: 'post',
    data
  })
}

// 药品操作
export function dealGoods(data) {
  return request({
    url: '/resource/dealGoods',
    method: 'post',
    data
  })
}

// 全部药厂
export function allCompany(data) {
  return request({
    url: '/resource/allCompany',
    method: 'post',
    data
  })
}

// 药品说明书
export function instructions(data) {
  return request({
    url: '/resource/instructions',
    method: 'post',
    data
  })
}

// 临床招募
export function recruit(data) {
  return request({
    url: '/resource/recruit',
    method: 'post',
    data
  })
}

// 同步临床招募
export function syncRecruit(data) {
  return request({
    url: '/resource/syncRecruit',
    method: 'post',
    data
  })
}

// 分类管理
export function classList(data) {
  return request({
    url: '/resource/classList',
    method: 'post',
    data
  })
}

// 分类操作
export function dealClass(data) {
  return request({
    url: '/resource/dealClass',
    method: 'post',
    data
  })
}

// 药品服务
export function goodsServer(data) {
  return request({
    url: '/resource/goodsServer',
    method: 'post',
    data
  })
}

// 药品服务操作
export function dealGoodsServer(data) {
  return request({
    url: '/resource/dealGoodsServer',
    method: 'post',
    data
  })
}
