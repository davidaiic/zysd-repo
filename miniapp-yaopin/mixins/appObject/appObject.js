import {
	urlConfig
} from "@/utils/config";
import {
	curPlatform
} from "@/utils/utils";
import {
	mapGetters
} from "vuex";
export default {
	computed: mapGetters(['isH5']),
	data() {
		return {
			tagtopHeight: 44,
			showModelPop: false,
			scrollViewheight: 800
		};
	},
	onShow() {
		var pages = getCurrentPages()
		var page = pages[pages.length - 1]
		// var title = page.$holder.navigationBarTitleText
		console.log(page)
	},
	onLoad() {
		this.getHeight()
		//   onPullDownRefresh() {
		//     uni.$u.sleep(1000).then(() => {
		//       uni.stopPullDownRefresh();
		//     });
	},
	methods: {
		getHeight() {
			let that = this
			let platform = "MP-WEIXIN";
			//#ifdef H5
			platform = "H5";
			//#endif
			//#ifdef MP-WEIXIN
			platform = "MP-WEIXIN";
			//#endif
			let isH5 = platform == 'H5'
			uni.getSystemInfo({
				// 获取成功
				success: (res) => {
					console.log(res)
					let scrollViewheight =
						res.windowHeight -
						res.statusBarHeight -
						(platform == 'H5' ? 0 : 44);
					that.scrollViewheight = scrollViewheight
				},
			})
		},
		/* 列表滚动 */
		scroll: function(e) {
			this.resetSwipeAction();
			this.old.scrollTopHeight = e.detail.scrollTop;
		},
		// 回到顶部
		backToTop() {
			this.scrollTopHeight = this.old.scrollTopHeight;
			this.$nextTick(() => {
				this.scrollTopHeight = 0;
			});
		},
		// 返回操作
		leftClick() {
			let pages = getCurrentPages();
			let prevPage = pages[pages.length - 2];
			console.log(prevPage)
			if (prevPage) {
				// if (prevPage.route.indexOf("mine/mine") > -1) {
				//   uni.switchTab({
				//     url: "/pages/mine/mine",
				//   });
				// } else 
				// if (prevPage.route.indexOf("circle/circle") > -1) {
				//         uni.switchTab({
				//           url: "/pages/circle/circle",
				//         });
				//       } else {
				console.log('12')
				uni.navigateBack({
					delta: 1,
				});
				// }
			} else {
				uni.switchTab({
					url: "/pages/index/index",
					success: function(e) {
						let page = getCurrentPages().pop();
						if (page == undefined || page == null) return;
						page.onLoad();
					}
				});
			}
		},
	},
};