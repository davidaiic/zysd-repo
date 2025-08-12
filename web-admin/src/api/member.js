import request from '@/utils/request'

// 用户列表
export function userList(data) {
  return request({
    url: '/member/userList',
    method: 'post',
    data
  })
}

// 用户操作
export function dealUser(data) {
  return request({
    url: '/member/dealUser',
    method: 'post',
    data
  })
}

// 用户登录列表
export function loginList(data) {
  return request({
    url: '/member/loginList',
    method: 'post',
    data
  })
}

// 评论列表
export function commentList(data) {
  return request({
    url: '/member/commentList',
    method: 'post',
    data
  })
}

// 评论操作
export function dealComment(data) {
  return request({
    url: '/member/dealComment',
    method: 'post',
    data
  })
}

// 回复列表
export function replyList(data) {
  return request({
    url: '/member/replyList',
    method: 'post',
    data
  })
}

// 敏感词列表
export function sensitiveList(data) {
  return request({
    url: '/member/sensitiveList',
    method: 'post',
    data
  })
}

// 敏感词操作
export function dealSensitive(data) {
  return request({
    url: '/member/dealSensitive',
    method: 'post',
    data
  })
}

// 搜索列表
export function searchList(data) {
  return request({
    url: '/member/searchList',
    method: 'post',
    data
  })
}

// 热门列表
export function hotList(data) {
  return request({
    url: '/member/hotList',
    method: 'post',
    data
  })
}

// 人工核查列表
export function manualSearchList(data) {
  return request({
    url: '/member/manualSearchList',
    method: 'post',
    data
  })
}

// 核查操作
export function checkManual(data) {
  return request({
    url: '/member/checkManual',
    method: 'post',
    data
  })
}

// 短信提示
export function smsTip(data) {
  return request({
    url: '/member/smsTip',
    method: 'post',
    data
  })
}

// 防伪查询列表
export function companySearchList(data) {
  return request({
    url: '/member/companySearchList',
    method: 'post',
    data
  })
}

// 价格查询列表
export function priceSearchList(data) {
  return request({
    url: '/member/priceSearchList',
    method: 'post',
    data
  })
}

// 纠错类目
export function errorDirectory(data) {
  return request({
    url: '/member/errorDirectory',
    method: 'post',
    data
  })
}

// 标签管理
export function labelList(data) {
  return request({
    url: '/member/labelList',
    method: 'post',
    data
  })
}

// 标签操作
export function dealLabel(data) {
  return request({
    url: '/member/dealLabel',
    method: 'post',
    data
  })
}

// 所有标签
export function allLabel(data) {
  return request({
    url: '/member/allLabel',
    method: 'post',
    data
  })
}

// 资讯管理
export function articleList(data) {
  return request({
    url: '/member/articleList',
    method: 'post',
    data
  })
}

// 资讯操作
export function dealArticle(data) {
  return request({
    url: '/member/dealArticle',
    method: 'post',
    data
  })
}

// 资讯评论列表
export function articleCommentList(data) {
  return request({
    url: '/member/articleCommentList',
    method: 'post',
    data
  })
}

// 资讯评论操作
export function dealArticleComment(data) {
  return request({
    url: '/member/dealArticleComment',
    method: 'post',
    data
  })
}

// 图片识别列表
export function imageRecognition(data) {
  return request({
    url: '/member/imageRecognition',
    method: 'post',
    data
  })
}

// 扫一扫列表
export function scanLog(data) {
  return request({
    url: '/member/scanLog',
    method: 'post',
    data
  })
}

// 比价列表
export function comparePrice(data) {
  return request({
    url: '/member/comparePrice',
    method: 'post',
    data
  })
}

// 资讯热门词管理
export function articleWordList(data) {
  return request({
    url: '/member/articleWordList',
    method: 'post',
    data
  })
}

// 资讯热门词操作
export function dealArticleWord(data) {
  return request({
    url: '/member/dealArticleWord',
    method: 'post',
    data
  })
}
