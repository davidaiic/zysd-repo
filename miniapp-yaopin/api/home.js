import request from "@/utils/request.js";

// 首页接口
export function homeIndexReq()
{
  return request.post("/home/index");
}

// 评论列表接口
export function commentListReq(data)
{
  return request.post("/home/commentList",data);
}

// 评论点赞接口
export function commentLikeReq(data)
{
  return request.post("/home/commentLike",data);
}

// 热门搜索词接口
export function hotWordReq(data){
  return request.post("/home/hotWord",data);
}

// 搜索接口
export function searchReq(data){
  return request.post("/home/search",data);
}

// 药厂查询接口
export function companySearchReq(data){
  return request.post("/query/companySearch",data);
}

// 客服信息接口
export function pluginKefuReq(data){
  return request.post("/plugin/kefu",data);
}

// 内容配置接口
export function pluginContentReq(data){
  return request.post("/plugin/content",data);
}

// 发布帖子接口
export function addCommentReq(data){
  return request.post("/home/addComment",data);
}

// 帖子接口
export function homeCommentInfoReq(data){
  return request.post("/home/commentInfo",data);
}

// 联系我们接口
export function pluginContactReq(data){
  return request.post("/plugin/contact",data);
}

//联想词接口
export function associateWordReq(data){
  return request.post("/home/associateWord",data);
}

//热门药品
export function hotGoodsReq(data){
  return request.post("/home/hotGoods",data);
}
//资讯列表
export function articleListReq(data){
  return request.post("/home/articleList",data);
}

//筛选条件
export function filterCriteriaReq(data){
  return request.post("/home/filterCriteria",data);
}

 // 发布资讯评论
 export function addArticleCommentReq(data){
  return request.post("/home/addArticleComment",data);
}

 //资讯点赞
 export function articleLikeReq(data){
  return request.post("/home/articleLike",data);
}

//资讯详情
export function articleInfoReq(data){
  return request.post("/home/articleInfo",data);
}

//资讯评论点赞
export function articleCommentLikeReq(data){
  return request.post("/home/articleCommentLike",data);
}

//药品服务信息
export function goodsServerReq(data){
  return request.post("/query/goodsServer",data);
}

//扫一扫
export function scanCodeReq(data){
  return request.post("/query/scanCode",data);
}

//药品风险信息
export function goodsRiskReq(data){
  return request.post("/query/goodsRisk",data);
}

//说明书
export function instructionsReq(data){
	// instructions
  return request.post("/query/instructions",data);
}

//药品专题说明
export function goodsSubjectReq(data){
  return request.post("/query/goodsSubject",data);
}


//纠错
export function errorRecoveryReq(data){
  return request.post("/query/errorRecovery",data);
}

//关于我们
export function aboutUsReq(data){
  return request.post("/plugin/about",data);
}
//分享
export function appShareReq(data){
  return request.post("/plugin/appShare",data);
}
// 扫码识别
export function scanQRCodeReq(data){
  return request.post("/query/scanQRCode",data);
}

// 未使用


//提取文字
export function extractTextReq(data){
  return request.post("/query/extractText",data);
}