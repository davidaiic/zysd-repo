<script>
import {systemInfo} from '@/libs/device.js'
export default {
	globalData: {
		id: 0,
	},
	onLaunch: function() {
		systemInfo()
		
		//#ifdef MP-WEIXIN
		uni.login({
			provider: 'weixin',
			success(resLogin) {
				uni.setStorageSync('code', resLogin.code)
			}
		})
		//#endif
	},
	onShow: function() {
		console.log('App Show')
	},
	onHide: function() {
		console.log('App Hide')
	}
}
</script>

<style lang="scss">
	/* 注意要写在第一行，同时给style标签加入lang="scss"属性 */
	@import "@/uni_modules/uview-ui/index.scss";

	@import 'static/css/base.css';
	.mainWrap {
		// background-color: #f8f8f8;
		// overflow-y: auto;
		min-height: calc(100vh - 44px);

		.content {
			//margin-top: 44px;
			overflow-y: auto;
		}

		/* #ifdef MP-WEIXIN */
		.content {
			// margin-top: 64px;
		}
		/* #endif */
		
		.u-nav-slot {
			width: 180rpx;
			height: 50rpx;
			font-size: 36rpx;
			font-family: PingFangSC-Medium, PingFang SC;
			font-weight: 500;
			color: #FFFFFF;
			line-height: 50rpx;
		}
	}
</style>
