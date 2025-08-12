import store from '@/store'
export function systemInfo(){
	let platform = "MP-WEIXIN";
	//#ifdef H5
	platform = "H5";
	//#endif
	//#ifdef MP-WEIXIN
	platform = "MP-WEIXIN";
	//#endif
	let isH5 = platform =='H5'
	uni.getSystemInfo({
		// 获取成功
		success: (res) => {
			console.log(res)
			let scrollViewheight =
			  res.windowHeight -
			  res.statusBarHeight -
			  (platform == 'H5' ? 0 : 44);
			store.commit('UPDATE_DEVICE',{
				isH5,
				scrollViewheight
			})
		},
	})

}