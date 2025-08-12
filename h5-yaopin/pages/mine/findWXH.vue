<!-- 我的--分享码--防伪码在哪 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="分享码" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="h1">微信号在哪里？</view>
			<u-parse :content="zcInfo"></u-parse>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			zcInfo: ''
		}
	},
	onLoad() {
		this.getHeight()
		this.getContent()
	},
	methods: {
		getContent() {
			let that = this
			let params = {
				keyword: 'findWx'
			}
			that.$store.dispatch('home/getPluginContent', params).then(res => {
				this.zcInfo = res.data.content
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;

	.h1 {
		font-size: 16px;
		color: #333;
		line-height: 22px;
		font-weight: 600;
	}

	.part {
		margin: 10px 0;

		.tit {
			margin-bottom: 10px;
			font-size: 14px;
			font-family: PingFangSC-Semibold, PingFang SC;
			font-weight: 600;
			color: #0FC8AC;
			line-height: 20px;
		}

		.des {
			margin-bottom: 10px;
			font-size: 14px;
			font-family: PingFangSC-Regular, PingFang SC;
			font-weight: 400;
			color: #333333;
			line-height: 20px;
		}

		.pic {
			margin-bottom: 10px;
			background: #F2F3F5;
			border-radius: 4px;
			padding: 5px;

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
