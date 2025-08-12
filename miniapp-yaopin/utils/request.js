import {
	HTTP_REQUEST_URL,
	HEADER,
	TOKENNAME,
	HEADERPARAMS
} from '@/config/app';
import {
	checkLogin
} from '../libs/login';

import store from '../store';
import {toLogin} from '@/utils/utils.js'
/**
 * 发送请求
 */
function baseRequest(url, method, data, {
	noAuth = false,
	noVerify = false
}, params) {
	let Url = HTTP_REQUEST_URL,header = HEADER
	if (store.state.app.token) header.token = store.state.app.token,header.uid = store.state.app.uid
	if(/http[s]{0,1}:\/\/([\w.]+\/?)/.test(url)) Url = ''
	
	return new Promise((reslove, reject) => {
		uni.request({
			url: Url + url,
			method: method || 'GET',
			header: header,
			data: data || {},
			success: (res) => {
				if (noVerify)
					reslove(res.data, res);
				else if (res.data.code == 200)
					reslove(res.data, res);
				else if ([410000, 410001, 410002, 401].indexOf(res.data.code) !== -1) {
					toLogin();
					return
				} else
					reject(res.data.message || '系统错误');
			},
			fail: (msg) => {
				uni.getNetworkType({
					success (res) {
						const networkType = res.networkType;
						if (networkType === 'none') {
							uni.showToast({
								title: '网络连接失败',
								//将值设置为 success 或者直接不用写icon这个参数
								icon: 'none',
								//显示持续时间为 2秒
								duration: 2000
							}) 
						} else {
							reject('请求失败');
						}
					}
				})
				
			},
			complete: (e) => {
				uni.hideLoading()
				reject()
			}
		})
	});
}

const request = {};

['options', 'get', 'post', 'put', 'head', 'delete', 'trace', 'connect'].forEach((method) => {
	request[method] = (api, data, opt, params) => baseRequest(api, method, data, opt || {}, params)
});



export default request;
