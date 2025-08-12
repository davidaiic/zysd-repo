<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="意见反馈" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="yjfk_textarea">
				<!-- 问题和意见 -->
				<view class="yjfk_textarea_title">
					问题和意见
				</view>
				<view class="">
					<u-textarea v-model="form.content" :placeholder="placeHolder" count height="320rpx"
						maxlength="200"></u-textarea>
				</view>
				<!-- 图片 -->
				<view class="yjfk_textarea_title">
					图片（{{ form.imageUrl.length || 0 }}/ 4）
				</view>
				<view class="">
					<e-upload-item v-model="form.imageUrl" maxCount='4' placeHolder="上传图片"></e-upload-item>
				</view>
				<!-- 联系电话 -->
				<view class="yjfk_textarea_title">
					联系电话
				</view>
				<view class="">
					<u-input type="number" maxlength="11" v-model="form.mobile" :placeholder="teleHolder"></u-input>
				</view>
			</view>


			<view class="bottomBtn">
				<u-button class="submit" @click="submitForm">提交</u-button>
			</view>
		</view>
	</view>
</template>

<script>
import {userFeedbackReq} from '@/api/user.js'

import { bridgrCall } from '@/utils/bridge';
export default {
	data() {
		return {
			placeHolder: '请填写10字以上的问题描述以便我们提供更好的帮助',
			teleHolder: '请输入联系电话',
			form: {
				content: '',
				imageUrl: [],
				mobile: ''
			}
		}
	},
	onLoad() {
		
	},
	onShow() {
		// #ifdef H5
		document.title = '意见反馈'
		//#endif
	},
	methods: {
		transImg(img) {
			return img.map(item => {
				return item.url
			}).join(',')
		},
		submitForm() {
			let params = {
				content: this.form.content,
				imageUrl: this.transImg(this.form.imageUrl),
				mobile: this.form.mobile
			}
			if (params.content.length < 10) {
				uni.showToast({
					icon: 'none',
					title: '请填写10字以上的问题描述'
				})
				return false
			}
			if (!(/^1(3|4|5|6|7|8|9)\d{9}$/.test(params.mobile))) {
				uni.showToast({
					icon: 'none',
					title: '请填写正确的手机号码'
				})
				return false
			}
			userFeedbackReq(params).then(res => {
				uni.showToast({
					icon: 'none',
					duration: 1500,
					title: '反馈成功',
					success: () => {
						uni.$u.sleep(2000).then(() => {
							//#ifdef H5
							bridgrCall.goPrevPage()
							return
							//#endif
							uni.navigateBack({
								delta: 1
							})
						})
					}
				})
			})
		},
		phoneCheck(mobile) {
			if (!(/^1(3|4|5|6|7|8|9)\d{9}$/.test(mobile))) {
				uni.showToast({
					icon: 'none',
					title: '请填写正确的手机号码'
				})
				return false
			}
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	background-color: #fff;
	//margin-top: 176rpx;
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
}

.bottomBtn {
	position: fixed;
	z-index: 2;
	width: calc(100% - 56rpx);
	left: 28rpx;
	bottom: 40rpx;

	.submit {
		height: 88rpx;
		background: #0FC8AC;
		border-radius: 44rpx;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
	}

	/deep/ .u-button {
		height: 88rpx;
		background: #0FC8AC;
		border-radius: 44rpx;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
	}
}
</style>
