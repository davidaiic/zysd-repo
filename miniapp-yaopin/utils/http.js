import urlConfig from './config.js'
import {
	abortRequest,
	isNoLogin
} from '@/utils/utils.js';

import store from '../store';
const request = {}
let headers = {
	'Content-Type': 'application/x-www-form-urlencoded'
}
let requestTree = {}

// 添加拦截器
uni.addInterceptor('request', {
	invoke(args) {
		// if (!(args.data && args.data.loadingHide) && headers.isShowLoading && args.url) {
		// 	uni.showLoading({
		// 		title: "正在加载中..."
		// 	})
		// }
	},
	success(args) {
		uni.hideLoading()
		if (!(args && args.statusCode === 200)) {
			// console.log('interceptor-success', args)
		}
	},
	fail() {
		uni.hideLoading()
	},
	complete(res) {
		uni.hideLoading()
		// 回到登录页面
		if (res.statusCode === 403 || res.statusCode === 401) {}
	}
})


/**
 * isToken是否需要传Authorization
 */
request.globalRequest = (url, method, data = {}, isToken = true, power, ifUrlConfig = true, isShowLoading = true) => {
	// 获取token
	let responseType = ""
	// token sqllite 判断token不存在情况
	// 权限判断 因为有的接口请求头可能需要添加的参数不一样，所以这里做了区分
	// 1 == 文件下载接口列表
	switch (power) {
		case 1:
			responseType = "arraybuffer"
			break;
		case 2:
			responseType = "text"
			break;
		default:
			if (store.state.app.token) headers.token = store.state.app.token,headers.uid = store.state.app.uid
			break;
	}
	return new Promise((resolve, reject) => {
		requestTree[url] = uni.request({
			url: ifUrlConfig ? urlConfig + url : url,
			data: data,
			header: headers,
			method: method,
			responseType: responseType,
			success: res => {
				if (res.data.code === 500) {
					let msg = '系统异常，请联系管理员'
					uni.showToast({
						icon: "none",
						title: msg
					})
					reject({
						state: false,
						message: msg
					})
					return false
				}
				if (res.data.code === 401) {
					uni.clearStorageSync('token')
					uni.clearStorageSync('uid')
					uni.showToast({
						icon: "none",
						duration: 1500,
						title: '该用户没有登录, 请授权登录',
						success() {
							uni.$u.sleep(2000).then(() => {
								uni.navigateTo({
									url: '/pages/login/noLogin'
								})
							})
						}
					})
					reject({
						state: false
					})
					return false
				}
				if (res.data.code === 400) {
					let msg = ""
					uni.showToast({
						icon: "none",
						title: msg
					})
					reject({
						state: false,
						message: msg
					})
					return false
				}
				if (res.data) {
					resolve(res.data)
				} else {
					resolve(res)
				}
			},
			fail: error => {
				console.log(error)
			},
			complete: (e) => {
				uni.hideLoading()
				reject()
			}
		})
	})
}




export default request
