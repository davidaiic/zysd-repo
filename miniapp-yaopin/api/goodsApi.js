import request from "@/utils/request.js";


// 获取药品列表
export function goodsListReq(data){
  return request.post("/query/goodsNameList",data);
}

//药品信息
export function goodsInfoReq(data){
  return request.post("/query/goodsInfo",data);
}

// 渠道列表接口
export function queryChannelListReq(data)
{
  return request.post("/query/channelList",data);
}

// 药厂列表接口
export function companyListReq(data)
{
  return request.post("/query/companyList",data);
}

// 价格查询接口
export function priceSearchReq(data)
{
	// getQueryPriceSearch
  return request.post("/query/priceSearch",data);
}

// 药厂防伪码查询文案接口
export function codeQueryReq(data)
{
  return request.post("/query/codeQuery",data);
}

// 规格列表接口
export function specListReq(data)
{
  return request.post("/query/specList",data);
}

// 比价接口
export function comparePriceReq(data)
{
	// comparePrice
  return request.post("/query/comparePrice",data);
}


// 新药品查询接口
export function relateGoodsNameReq(data)
{
  return request.post("/query/relateGoodsName",data);
}

//药品专题说明
export function goodsSubjectReq(data){
  return request.post("/query/goodsSubject",data);
}



// 人工核查信息接口
export function manualCheckReq(data)
{
	// getQueryManual
  return request.post("/query/manual",data);
}


// 照片查询接口
export function photoFindReq(data)
{
	// getQueryPhoto
  return request.post("/query/photo",data);
}
