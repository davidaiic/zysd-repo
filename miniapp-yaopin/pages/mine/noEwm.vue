<!-- 没有分享码页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="创建分享码" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight + 'px' }">
			<view class="yjfk_textarea">
				<!-- 微信号 -->
				<view class="yjfk_textarea_title">
					方式一：微信号
				</view>
				<view class="">
					<u-input v-model="form.wx" placeholder="输入微信号"></u-input>
				</view>
				<view class="yjfk_textarea_tips" @click="goWXH()">
					如何找微信号？
				</view>
				<!-- 图片 -->
				<view class="yjfk_textarea_title">
					方式二：上传二维码
				</view>
				<view class="">
					<e-upload-item v-model="form.qrcode" maxCount='1' placeHolder="上传二维码"></e-upload-item>
				</view>
				<view class="yjfk_textarea_tips" @click="goEWM()">
					如何找二维码？
				</view>
			</view>

			<view class="bottomBtn">
				<u-button class="submit" @click="goEwm()">提交生成分享码</u-button>
			</view>
			<view class="bottom-fill"></view>
		</scroll-view>
	</view>
</template>

<script>
import {createShareReq} from '@/api/user.js'
export default {
	data() {
		return {
			form: {
				qrcode: [],
				wx: ''
			}
		}
	},
	onLoad() {
	},
	
	onShow() {
		// #ifdef H5
		document.title = '创建分享码'
		//#endif
	},
	methods: {
		goEwm() {
			let parmas = {
				wx: this.form.wx,
				qrcode: this.transImg(this.form.qrcode)
			}
			if (!parmas.wx) {
				uni.showToast({
					icon: 'none',
					title: '请输入微信号'
				})
				return
			}
			if (!parmas.qrcode) {
				uni.showToast({
					icon: 'none',
					title: '请上传二维码'
				})
				return
			}
			createShareReq(parmas).then(res => {
				uni.navigateTo({
					url: '/pages/mine/ewm'
				})
			})
		},
		transImg(img) {
			return img.map(item => {
				return item.url
			}).join(',')
		},
		goWXH() {
			uni.navigateTo({
				url: '/pages/mine/findWXH'
			})
		},
		goEWM() {
			uni.navigateTo({
				url: '/pages/mine/findEWM'
			})
		},
	}
}
</script>

<style lang="scss" scoped>
.content {
	background-color: #fff;
	padding-top: 15px;
	box-sizing: border-box;
	.bottom-fill{
		height: 100rpx;
	}
}

.yjfk_textarea {
	margin: 0 30rpx;

	.yjfk_textarea_title {
		font-size: 32rpx;
		line-height: 44rpx;
		font-weight: 600;
		color: #333;
		margin: 40rpx 0 25rpx 0;
	}

	.yjfk_textarea_tips {
		margin-top: 5px;
		font-weight: 400;
		color: #0FC8AC;
		font-size: 14px;
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
