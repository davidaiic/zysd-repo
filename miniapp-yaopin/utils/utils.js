import store from "@/store";

import Cache from '@/utils/cache';
function prePage(){
	let pages = getCurrentPages();
	let prePage = pages[pages.length - 1];
	return prePage.route;
}
// 函数防抖 (只执行最后一次点击)
function insetDebounce(fn, delay = 1000) {
	let timer = null;
	return function() {
		let self = this;
		let args = arguments;
		timer && clearTimeout(timer);
		timer = setTimeout(function() {
			timer = null
			fn.apply(self, args);
		}, delay);
	};
}
const insetToLogin = insetDebounce(_toLogin,300)
export const Debounce = insetDebounce()
export const toLogin = insetDebounce(_toLogin,300)

export function _toLogin(pathLogin) {
	
	store.commit("LOGOUT");
	let path = '/'+prePage();
	
	Cache.set('login_back_url',pathLogin ||path);
	
	// if (['pages/user/index','/pages/user/index'].indexOf(login_back_url) == -1) {

	uni.navigateTo({
		url: '/pages/login/noLogin',
	})
	// }
}
// 跳转需要登录的页main
export function goOthersCheckLogin(url){
	if(store.getters.isLogin){
		uni.navigateTo({
			url
		})
	}else{
		insetToLogin(url)
	}
}
// url &?
export function formatGetUri(obj) {
	let temp = [];
	Object.keys(obj).forEach((key) => {
		let value = obj[key];
		if (typeof value !== "undefined" || value !== null) {
			temp.push([key, value].join("="));
		}
	});
	return "?" + temp.join("&");
}

export function getImgUrl(val) {
	return `/static/${val}`;
}

export function transImg(img) {
	return img
		.map((item) => {
			return item.url;
		})
		.join(",");
}

// 节流函数
export function throttle(fn, delay) {
	let timer = null;

	return function() {
		if (timer) {
			return;
		}
		timer = setTimeout(() => {
			fn.apply(this, arguments);
			timer = null;
		}, delay);
	};
}
// 函数防抖 (只执行最后一次点击)
export function debounce(fn, delay = 1000) {
	let timer = null;
	return function() {
		let self = this;
		let args = arguments;
		timer && clearTimeout(timer);
		timer = setTimeout(function() {
			timer = null
			fn.apply(self, args);
		}, delay);
	};
}


export function dsBridgeAsyn(event, cb) {
	if (dsBridge) {
		dsBridge.call("asynCallNative", event, cb);
	}
}
export function dsBridgeSyn(data, cb) {
	if (dsBridge) {
		return cb(dsBridge.call("synCallNative", data));
	}
}
export function curPlatform() {
	let platform = "MP-WEIXIN";
	//#ifdef H5
	platform = "H5";
	//#endif

	//#ifdef MP-WEIXIN
	platform = "MP-WEIXIN";
	//#endif
	return platform;
}

export function Tips(opt, to_url){
	/**
	 * opt  object | string
	 * to_url object | string
	 * 例:
	 * this.Tips('/pages/test/test'); 跳转不提示
	 * this.Tips({title:'提示'},'/pages/test/test'); 提示并跳转
	 * this.Tips({title:'提示'},{tab:1,url:'/pages/index/index'}); 提示并跳转值table上
	 * tab=1 一定时间后跳转至 table上
	 * tab=2 一定时间后跳转至非 table上
	 * tab=3 一定时间后返回上页面
	 * tab=4 关闭所有页面跳转至非table上
	 * tab=5 关闭当前页面跳转至table上
	 */
	if (typeof opt == 'string') {
		to_url = opt;
		opt = {};
	}
	let title = opt.title || '',
		icon = opt.icon || 'none',
		endtime = opt.endtime || 2000,
		success = opt.success;
	if (title) uni.showToast({
		title: title,
		icon: icon,
		duration: endtime,
		success
	})
	if (to_url != undefined) {
		if (typeof to_url == 'object') {
			let tab = to_url.tab || 1,
				url = to_url.url || '';
			switch (tab) {
				case 1:
					//一定时间后跳转至 table
					setTimeout(function() {
						uni.switchTab({
							url: url
						})
					}, endtime);
					break;
				case 2:
					//跳转至非table页面
					setTimeout(function() {
						uni.navigateTo({
							url: url,
						})
					}, endtime);
					break;
				case 3:
					//返回上页面
					setTimeout(function() {
						// #ifndef H5
						uni.navigateBack({
							delta: parseInt(url),
						})
						// #endif
						// #ifdef H5
						history.back();
						// #endif
					}, endtime);
					break;
				case 4:
					//关闭当前所有页面跳转至非table页面
					setTimeout(function() {
						uni.reLaunch({
							url: url,
						})
					}, endtime);
					break;
				case 5:
					//关闭当前页面跳转至非table页面
					setTimeout(function() {
						uni.redirectTo({
							url: url,
						})
					}, endtime);
					break;
			}

		} else if (typeof to_url == 'function') {
			setTimeout(function() {
				to_url && to_url();
			}, endtime);
		} else {
			//没有提示时跳转不延迟
			setTimeout(function() {
				uni.navigateTo({
					url: to_url,
				})
			}, title ? endtime : 0);
		}
	}
}

export function getUrlParams(param,key, k, p) {
	if (typeof param != 'string') return {};
	k = k ? k : '&'; //整体参数分隔符
	p = p ? p : '='; //单个参数分隔符
	var value = {};
	let result = {}
	var strParams  = param.split('?')[1];
	var arrParams = strParams.split('&');
	//然后进行for循环，这里直接用了forEach
	arrParams.forEach((item) => {
		var temKey = item.split('=')[0];
		var temVal = item.split('=')[1];
		result[temKey] = temVal
	})
	
	return key ? result[key] : result
}

export function parseQuery() {
	const res = {};

	const query = (location.href.split("?")[1] || "")
		.trim()
		.replace(/^(\?|#|&)/, "");

	if (!query) {
		return res;
	}

	query.split("&").forEach(param => {
		const parts = param.replace(/\+/g, " ").split("=");
		const key = decodeURIComponent(parts.shift());
		const val = parts.length > 0 ? decodeURIComponent(parts.join("=")) : null;

		if (res[key] === undefined) {
			res[key] = val;
		} else if (Array.isArray(res[key])) {
			res[key].push(val);
		} else {
			res[key] = [res[key], val];
		}
	});

	return res;
}