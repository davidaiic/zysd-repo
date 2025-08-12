import request from "@/utils/request.js";



// 获取小程序openid接口
export function getOpenidReq(data)
{
	// getOpenid
  return request.post("/user/getOpenid",data);
}
 // 获取小程序手机号接口
 export function getUserPhoneReq(data)
{
  return request.post("/user/getUserPhone",data);
}


// 意见反馈接口
export function userFeedbackReq(data)
{
  return request.post("/user/feedback",data);
}

// 小程序注册接口 即登录接口
export function userRegisterReq(data)
{
  return request.post("/user/register",data);
}

// 个人主页接口
export function userInfoReq(data)
{
  return request.post("/user/center",data);
}


// 创建分享码接口
export function createShareReq(data)
{
  return request.post("/user/createShare",data);
}

// 邀请人信息接口
export function inviteInfoReq(data)
{
  return request.post("/user/inviteInfo",data);
}

// 查询详情接口
export function userQueryInfoReq(data)
{
  return request.post("/user/center",data);
}

// 查询历史接口
export function queryLogReq(data)
{
  return request.post("/user/queryLog",data);
}


// 分享码信息接口
export function shareInfoReq(data)
{
	// getUserShareInfo
  return request.post("/user/shareInfo",data);
}

// 用户列表接口
export function userListReq(data)
{
	// getUserList
  return request.post("/user/userList",data);
}

// 生成小程序码接口
export function userCreateWxQRCodeReq(data)
{
  return request.post("/user/createWxQRCode",data);
}