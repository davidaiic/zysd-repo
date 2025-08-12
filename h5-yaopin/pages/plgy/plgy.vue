<!-- 用户协议页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="发帖评论公约" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<text class="text_4">发帖评论公约</text>
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
				keyword: 'criterion'
			}
			that.$store.dispatch('home/getPluginContent', params).then(res => {
				this.zcInfo = res.data.content
			})
		},
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;

}
</style>
