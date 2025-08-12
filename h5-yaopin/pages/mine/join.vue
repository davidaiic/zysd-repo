<!-- 分享用户扫码登录界面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="登录" :fixed="false" leftIcon="home" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="box">
				<u-image :src="formData.avatar" width="176rpx" height="176rpx"></u-image>
				<view class="font">
					<p class="weight">{{ formData.username }}</p>
				</view>
				<view class="font">
					<p>邀请你加入药品真伪查询</p>
				</view>
			</view>
		</view>
		<view class="bottomBtn">
			<u-button openType="getPhoneNumber" @getphonenumber="addGroup" type="text">立即加入</u-button>
		</view>
	</view>
</template>

<script>
import {
	getUserFunc
} from '@/utils/utils.js'
export default {
	data() {
		return {
			inviteId: '',
			formData: {
				username: '',
				avatar: ''
			}
		}
	},
	onLoad(options) {
		if (Object.keys(options).length) {
			const {
				scene
			} = options
			if (scene) {
				/* 扫码进来 */
				const sceneObj = this.urlParams(scene)
				if (sceneObj.id) {
					this.inviteId = sceneObj.id /* 邀请码 */
					// this.getInviteUserInfo()
				}
			}
		}
	},
	onShow() {
		this.getHeight()
		if (this.inviteId) {
			this.getInviteUserInfo()
		}
	},
	methods: {
		urlParams(scene) {
			const str = decodeURIComponent(scene).replace('?', '&')
			let strArr = str.split('&')
			strArr = strArr.filter(item => item)
			const result = {}
			strArr.filter(item => {
				const key = item.split('=')
				result[key[0]] = key[1]
			})
			return result
		},
		getInviteUserInfo() {
			let that = this
			let params = {
				inviteId: that.inviteId
			}
			that.$store.dispatch('user/getUserInviteInfo', params).then(res => {
				that.formData = res.data.info
			})
		},
		addGroup(detail) {
			let that = this
			getUserFunc(detail, that.leftBack, that.inviteId)
		},
		leftBack() {
			uni.switchTab({
				url: '/pages/index/index'
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;

	.box {
		display: flex;
		flex-direction: column;
		align-items: center;
		margin-top: 127px;

		/deep/ uni-image {
			background: #F2F3F5;
			border-radius: 100% !important;
			overflow: hidden;
			border: 4px solid #E0E0E0;
		}

		// #ifdef MP-WEIXIN
		/deep/ image {
			background: #F2F3F5;
			border-radius: 100% !important;
			overflow: hidden;
			border: 4px solid #E0E0E0;
		}

		// #endif

		.font {
			font-size: 14px;
			color: #262626;

			.weight {
				font-weight: 600;
				margin: 20px auto 40px;
			}
		}
	}
}

.bottomBtn {
	position: fixed;
	z-index: 2;
	width: calc(100% - 28px);
	left: 14px;
	bottom: 20px;

	.submit {
		height: 44px;
		background: #0FC8AC;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}

	/deep/ .u-button {
		height: 44px;
		background: #0FC8AC;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}
}
</style>
