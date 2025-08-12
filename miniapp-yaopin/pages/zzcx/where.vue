<!-- 自助查询--药厂查询--防伪码在哪 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="防伪码" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight + 'px' }">
			<u-parse :content="zcInfo"></u-parse>
			<view class="bottom-fill"></view>
		</scroll-view>
	</view>
</template>

<script>
	import { codeQueryReq} from '@/api/goodsApi.js'
export default {
	data() {
		return {
			companyIds: '',
			zcInfo: ''
		}
	},
	onLoad(option) {
		console.log(option, 'sss')
		this.companyIds = option.companyId
		this.getContent()
	},
	
	onShow() {
		// #ifdef H5
		document.title = '防伪码'
		//#endif
	},
	methods: {
		getContent() {
			let that = this
			let params = {
				companyId: that.companyIds
			}
			codeQueryReq(params).then(res => {
				this.zcInfo = res.data.codeQuery
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;
	.bottom-fill{
		height: 50rpx;
	}
	.h1 {
		font-size: 32rpx;
		color: #333;
		line-height: 44rpx;
		font-weight: 600;
	}

	.part {
		margin: 20rpx 0;

		.tit {
			margin-bottom: 20rpx;
			font-size: 28rpx;
			font-family: PingFangSC-Semibold, PingFang SC;
			font-weight: 600;
			color: #0FC8AC;
			line-height: 40rpx;
		}

		.des {
			margin-bottom: 20rpx;
			font-size: 28rpx;
			font-family: PingFangSC-Regular, PingFang SC;
			font-weight: 400;
			color: #333333;
			line-height: 40rpx;
		}

		.pic {
			margin-bottom: 20rpx;
			background: #F2F3F5;
			border-radius: 8rpx;
			padding: 10rpx;

			img {
				width: auto;
				height: auto;
				max-width: 100%;
				max-height: 100%;
				margin: 0 auto;

			}
		}
	}
}
</style>
