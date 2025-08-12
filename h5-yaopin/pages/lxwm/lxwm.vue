<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="添加客服微信" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<!-- <u-navbar v-if="!isH5" title="添加客服微信" @leftClick="leftClick"  :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
			<view class="content"> -->
			<view class="lxwm_content">
				<u-gap height="20rpx"></u-gap>
				<view class="lxwm_content_top">
					<view class="lxwm_title">
						方式一：复制微信号
					</view>
					<view class="lxwm_fac">
						<u-image :src="formData.avatar" width="140rpx" height="140rpx"></u-image>
						<view class="lxwm_wxh">
							微信号: {{ formData.wx }}
						</view>
						<view class="">
							<u-button class="lxwm_copy" @click="copy">点击复制</u-button>
						</view>
					</view>
				</view>
				<u-gap height="20rpx" bgColor="#f8f8f8"></u-gap>
				<view class="lxwm_content_top">
					<view class="lxwm_title">
						方式二：扫码加微信
					</view>
					<view class="lxwm_fac">
						<u-image :src="formData.qrcode" width="320rpx" height="320rpx"></u-image>
						<view class="lxwm_wxh">
							扫一扫加微信
						</view>
						<view class="">
							<u-button class="lxwm_copy" @click="downLoadEwm">点击保存</u-button>
						</view>
					</view>
				</view>
			</view>
			<!-- </view> -->
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			formData: {
				avatar: '',
				wx: '',
				qrcode: '',
				mobile: ''
			}
		}
	},
	onLoad() {
		this.getKefuFunc()
		this.getHeight()
	},
	methods: {
		getKefuFunc() {
			this.$store.dispatch('home/getPluginKefu').then(res => {
				this.formData = res.data
			})
		},
		copy() {
			let that = this
			uni.setClipboardData({
				data: that.formData.wx,
				success() {
					uni.showToast({
						icon: 'none',
						title: '复制成功'
					})
				},
				fail() {
					uni.showToast({
						icon: 'none',
						title: '复制失败'
					})
				}
			})
		},
		callPhone() {
			let that = this
			uni.makePhoneCall({
				phoneNumber: that.form.mobile, //仅为示例，并非真实的电话号码
				success: function () {
					console.log("拨打电话成功！")
				},
				fail: function () {
					console.log("拨打电话失败！")
				}
			})
		},
		downLoadEwm() {
			let that = this
			//#ifdef H5
			bridgrCall.saveImage({ "image": that.formData.qrcode }).then((res) => {
				if (res.data) {
					uni.showToast({
						icon: "none",
						title: "保存成功",
					})
				} else {
					uni.showToast({
						icon: "none",
						title: "保存失败！",
					})
				}
			})
			return
			//#endif
			uni.downloadFile({
				url: that.formData.qrcode, //图片地址
				success: function (res) {
					//图片保存到本地
					uni.saveImageToPhotosAlbum({
						filePath: res.tempFilePath,
						success: function (data) {
							uni.hideLoading()
							uni.showModal({
								title: '提示',
								content: '您的二维码已保存到相册，赶快识别二维码吧',
								showCancel: false,
							})
						},
						fail: function (err) {
							if (err.errMsg === "saveImageToPhotosAlbum:fail:auth denied" || err
								.errMsg === "saveImageToPhotosAlbum:fail auth deny" || err
									.errMsg === "saveImageToPhotosAlbum:fail authorize no response"
							) {
								// 这边微信做过调整，必须要在按钮中触发，因此需要在弹框回调中进行调用
								uni.showModal({
									title: '提示',
									content: '需要您授权保存相册',
									showCancel: false,
									success: modalSuccess => {
										uni.openSetting({
											success(settingdata) {
												console.log("settingdata",
													settingdata)
												if (settingdata
													.authSetting[
													'scope.writePhotosAlbum'
												]) {
													uni.showModal({
														title: '提示',
														content: '获取权限成功,再次点击图片即可保存',
														showCancel: false,
													})
												} else {
													uni.showModal({
														title: '提示',
														content: '获取权限失败，将无法保存到相册哦~',
														showCancel: false,
													})
												}
											},
											fail(failData) {
												console.log("failData",
													failData)
											},
											complete(finishData) {
												console.log("finishData",
													finishData)
											}
										})
									}
								})
							}
						},
						complete(res) {
							uni.hideLoading()
						}
					})
				}
			})
		},
		tel(val) {
			uni.makePhoneCall({
				phoneNumber: val
			});
		}
	}
}
</script>

<style lang="scss" scoped>
.lxwm_content {
	.lxwm_content_top {
		display: flex;
		justify-content: center;
		flex-direction: column;
		background-color: #ffffff;

		.lxwm_title {
			font-size: 32rpx;
			color: #333;
			font-weight: 600;
			line-height: 44rpx;
			margin: 20rpx 0 10rpx 30rpx;
		}

		.lxwm_fac {
			display: flex;
			flex-direction: column;
			align-items: center;
			margin: 20rpx 0;

			.lxwm_wxh {
				font-size: 28rpx;
				font-weight: 400;
				color: #333333;
				margin: 20rpx 0 30rpx;
			}

			.lxwm_copy {
				width: 280rpx;
				background-color: #0fc8ac;
				border-radius: 36rpx;
				color: #ffffff;
			}

			/deep/ .u-button {
				width: 280rpx;
				background-color: #0fc8ac;
				border-radius: 36rpx;
				color: #ffffff;
			}

		}
	}
}
</style>
