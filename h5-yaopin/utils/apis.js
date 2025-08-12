import request from "@/utils/http.js";
import { formatGetUri } from "@/utils/utils.js";

const api = {};
const prefix = "";
// POST请求方式
// GET请求方式api.register = params => request.globalRequest(`${PORT}/mobile/signUp${formatGetUri(params)}`, 'GET //必须大写，为了兼容其他应用',{}, 1)

// 获取小程序openid接口
api.getOpenid = (params) =>
  request.globalRequest(`${prefix}/user/getOpenid`, "POST", params);
// 获取小程序手机号接口
api.getUserPhone = (params) =>
  request.globalRequest(`${prefix}/user/getUserPhone`, "POST", params);
// 小程序注册接口 即登录接口
api.getRegister = (params) =>
  request.globalRequest(`${prefix}/user/register`, "POST", params);
// 发布帖子接口
api.homeAddComment = (params) =>
  request.globalRequest(`${prefix}/home/addComment`, "POST", params);
// 帖子接口
api.homeCommentInfo = (params) =>
  request.globalRequest(`${prefix}/home/commentInfo`, "POST", params);
// 联系我们接口
api.pluginContact = (params) =>
  request.globalRequest(`${prefix}/plugin/contact`, "POST", params);
// 获取药品列表
api.getGoodsList = (params) =>
  request.globalRequest(`${prefix}/query/goodsNameList`, "POST", params);
// 首页接口
api.homeIndex = (params) =>
  request.globalRequest(`${prefix}/home/index`, "POST", params);
// 评论列表接口
api.homeCommentList = (params) =>
  request.globalRequest(`${prefix}/home/commentList`, "POST", params);
// 评论点赞接口
api.homeCommentLike = (params) =>
  request.globalRequest(`${prefix}/home/commentLike`, "POST", params);
// 热门搜索词接口
api.homeHotWord = (params) =>
  request.globalRequest(`${prefix}/home/hotWord`, "POST", params);
// 搜索接口
api.homeSearch = (params) =>
  request.globalRequest(`${prefix}/home/search`, "POST", params);
// 人工核查信息接口
api.queryManual = (params) =>
  request.globalRequest(`${prefix}/query/manual`, "POST", params);
// 照片查询接口
api.queryPhoto = (params) =>
  request.globalRequest(`${prefix}/query/photo`, "POST", params);
// 渠道列表接口
api.queryChannelList = (params) =>
  request.globalRequest(`${prefix}/query/channelList`, "POST", params);
// 药厂列表接口
api.queryCompanyList = (params) =>
  request.globalRequest(`${prefix}/query/companyList`, "POST", params);
// 价格查询接口
api.queryPriceSearch = (params) =>
  request.globalRequest(`${prefix}/query/priceSearch`, "POST", params);
// 药厂防伪码查询文案接口
api.querycodeQuery = (params) =>
  request.globalRequest(`${prefix}/query/codeQuery`, "POST", params);
// 规格列表接口
api.querySpecList = (params) =>
  request.globalRequest(`${prefix}/query/specList`, "POST", params);
// 药厂查询接口
api.queryCompanySearch = (params) =>
  request.globalRequest(`${prefix}/query/companySearch`, "POST", params);
// 客服信息接口
api.pluginKefu = (params) =>
  request.globalRequest(`${prefix}/plugin/kefu`, "POST", params);
// 内容配置接口
api.pluginContent = (params) =>
  request.globalRequest(`${prefix}/plugin/content`, "POST", params);
// 意见反馈接口
api.userFeedback = (params) =>
  request.globalRequest(`${prefix}/user/feedback`, "POST", params);
// 个人主页接口
api.userCenter = (params) =>
  request.globalRequest(`${prefix}/user/center`, "POST", params);
// 创建分享码接口
api.userCreateShare = (params) =>
  request.globalRequest(`${prefix}/user/createShare`, "POST", params);
// 邀请人信息接口
api.userInviteInfo = (params) =>
  request.globalRequest(`${prefix}/user/inviteInfo`, "POST", params);
// 查询详情接口
api.userQueryInfo = (params) =>
  request.globalRequest(`${prefix}/user/center`, "POST", params);
// 查询历史接口
api.userQueryLog = (params) =>
  request.globalRequest(`${prefix}/user/queryLog`, "POST", params);
// 分享码信息接口
api.userShareInfo = (params) =>
  request.globalRequest(`${prefix}/user/shareInfo`, "POST", params);
// 用户列表接口
api.userList = (params) =>
  request.globalRequest(`${prefix}/user/userList`, "POST", params);
// 生成小程序码接口
api.userCreateWxQRCode = (params) =>
  request.globalRequest(`${prefix}/user/createWxQRCode`, "POST", params);
//联想词接口
api.homeAssociateWord = (params) =>
  request.globalRequest(`${prefix}/home/associateWord`, "POST", params);
//热门药品
api.getHotGoods = (params) =>
  request.globalRequest(`${prefix}/home/hotGoods`, "POST", params);
//资讯列表
api.getArticleList = (params) =>
  request.globalRequest(`${prefix}/home/articleList`, "POST", params);
//筛选条件
api.getFilterCriteria = (params) =>
  request.globalRequest(`${prefix}/home/filterCriteria`, "POST", params);
//发布资讯评论
api.addArticleComment = (params) =>
  request.globalRequest(`${prefix}/home/addArticleComment`, "POST", params);
//资讯点赞
api.articleLike = (params) =>
  request.globalRequest(`${prefix}/home/articleLike`, "POST", params);
//资讯详情
api.articleInfo = (params) =>
  request.globalRequest(`${prefix}/home/articleInfo`, "POST", params);
//资讯评论点赞
api.articleCommentLike = (params) =>
  request.globalRequest(`${prefix}/home/articleCommentLike`, "POST", params);
//图片识别
api.imageRecognition = (params) =>
  request.globalRequest(`${prefix}/query/imageRecognition`, "POST", params);
//药品服务信息
api.goodsServer = (params) =>
  request.globalRequest(`${prefix}/query/goodsServer`, "POST", params);
//提取文字
api.extractText = (params) =>
  request.globalRequest(`${prefix}/query/extractText`, "POST", params);
//扫一扫
api.scanCode = (params) =>
  request.globalRequest(`${prefix}/query/scanCode`, "POST", params);
//药品风险信息
api.goodsRisk = (params) =>
  request.globalRequest(`${prefix}/query/goodsRisk`, "POST", params);
//说明书
api.instructions = (params) =>
  request.globalRequest(`${prefix}/query/instructions`, "POST", params);
//药品专题说明
api.goodsSubject = (params) =>
  request.globalRequest(`${prefix}/query/goodsSubject`, "POST", params);
//纠错
api.errorRecovery = (params) =>
  request.globalRequest(`${prefix}/query/errorRecovery`, "POST", params);
//关于我们
api.getAbout = (params) =>
  request.globalRequest(`${prefix}/plugin/about`, "POST", params);
//比价
api.comparePrice = (params) =>
  request.globalRequest(`${prefix}/query/comparePrice`, "POST", params);
//分享
api.appShare = (params) =>
  request.globalRequest(`${prefix}/plugin/appShare`, "POST", params);
//新版药品列表
api.getRelateGoodsName = (params) =>
  request.globalRequest(`${prefix}/query/relateGoodsName`, "POST", params);
//药品信息
api.getGoodsInfo = (params) =>
  request.globalRequest(`${prefix}/query/goodsInfo`, "POST", params);

let apis = Object.assign({}, api);
export default apis;
