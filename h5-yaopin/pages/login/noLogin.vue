<!-- 未登录页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="未登录" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<u-empty text="登录后才能查看，请前往登录" :icon="$utils.getImgUrl('noLogin.png')" width="160px" height="140px"
				:margin-top="120"></u-empty>
		</view>
		<view class="bottomBtn">
			<!-- #ifdef H5 -->
			<u-button type="text" @click="getUser">
				登录
			</u-button>
			<!-- #endif -->
			<!-- #ifndef H5 -->
			<u-button openType="getPhoneNumber" @getphonenumber="getUser" type="text">
				登录
			</u-button>
			<!-- #endif -->
		</view>
	</view>
</template>

<script>
import {
	getUserFunc
} from '@/utils/utils.js';
export default {
	data() {
		return {};
	},
	onLoad(option) {
		this.getHeight();
	},
	methods: {
		// 获取用户信息, 登录
		getUser(detail) {
			let that = this
			getUserFunc(detail, that.leftClick);
		}
	}
};
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;
}

.bottomBtn {
	position: fixed;
	z-index: 2;
	width: calc(100% - 28px);
	left: 14px;
	bottom: 20px;

	.submit {
		height: 44px;
		background: #0fc8ac;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}

	/deep/ .u-button {
		height: 44px;
		background: #0fc8ac;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}
}
</style>
