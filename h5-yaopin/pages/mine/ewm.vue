<!-- 分享码页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" @leftClick="leftClick" :fixed="false" :titleStyle="{ color: '#FFF', fontSize: '18px' }">
				<view slot="center">
					<view class="tab">
						<view class="tabs seled">分享码</view>
						<view class="tabs" @click="goUserMange()">用户管理</view>
					</view>
				</view>
			</u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 20 + 'px' }">
			<!-- 码区 -->
			<view class="viewWrap">
				<view class="userPicBox">
					<u-image :src="formData.info.avatar" width="80rpx" height="80rpx"></u-image>
				</view>
				<view class="wrapBox">
					<view class="head">
						<h4>{{ formData.info.username }}</h4>
					</view>
					<view class="imgBox">
						<view class="font">
							<p class="weight">我的邀请码</p>
						</view>
						<image :src="formData.buffer"></image>
						<view class="font">
							<u-button class="lxwm_copy" @click="downLoadEwm">点击保存</u-button>
						</view>
					</view>
				</view>
			</view>
			<!-- 客服区 -->
			<u-gap height="20rpx"></u-gap>
			<view class="lxwm_content_top">
				<view class="lxwm_title">
					请加您专属的官方客服微信
				</view>
				<view class="lxwm_fac">
					<u-image :src="formData.kefu.avatar" width="140rpx" height="140rpx" shape="circle"></u-image>
					<view class="lxwm_wxh">
						微信号：{{ formData.kefu.wx }}
					</view>
					<view class="">
						<u-button class="lxwm_copy" @click="copyWx">点击复制</u-button>
					</view>
				</view>
			</view>

		</view>

	</view>
</template>

<script>
export default {
	data() {
		return {
			formData: {
				"info": {
					"username": "",
					"avatar": ""
				},
				"buffer": "",
				"kefu": {
					"avatar": "",
					"wx": ""
				}
			}
		}
	},
	onLoad() {
		this.getShareInfo()
		this.getHeight()
	},
	methods: {
		goUserMange() {
			uni.navigateTo({
				url: '/pages/mine/userMange'
			})
		},
		getShareInfo() {
			this.$store.dispatch('user/getUserShareInfo').then(res => {
				this.formData = res.data
			})
		},
		copyWx() {
			let that = this
			uni.setClipboardData({
				data: that.formData.kefu.wx,
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
		downLoadEwm() {
			let that = this
			//#ifdef H5
			bridgrCall.saveImage({ "image": that.formData.buffer }).then((res) => {
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
				url: that.formData.buffer, //图片地址
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
		}
	}
}
</script>

<style lang="scss" scoped>
.mainWrap {
	background-color: #f8f8f8;
	height: 100vh;

	.tab {
		margin-left: 40px;
		display: flex;
		color: #fff;
		align-items: center;

		.tabs {
			margin-right: 10px;
			font-size: 14px;
		}

		.seled {
			font-size: 18px;
			font-weight: 500;
		}
	}
}

.content {
	padding: 0 30rpx 30rpx;

	// 码区
	.viewWrap {
		padding-top: 25px;
		position: relative;

		.userPicBox {
			position: absolute;
			z-index: 2;
			width: 40px;
			height: 40px;
			border-radius: 100%;
			left: 50%;
			top: 15px;
			overflow: hidden;
			margin-left: -20px;
		}

		.wrapBox {
			overflow: hidden;
			position: relative;
			background-color: #fff;
			border-radius: 8px;
			margin: 20rpx auto;
			padding: 40rpx;
			text-align: center;

			.head {
				border-bottom: 1px dashed #C4C4C6;
				padding-bottom: 5px;

				h4 {
					font-size: 14px;
					color: #000;
					padding: 20px;
				}
			}

			.imgBox {
				uni-image {
					width: 400rpx;
					height: 400rpx;
					background: #F2F3F5;
					border-radius: 8px;
					padding: 10px;
					margin-top: 30rpx;
				}

				// #ifdef MP-WEIXIN
				image {
					width: 400rpx;
					height: 400rpx;
					background: #F2F3F5;
					border-radius: 8px;
					padding: 10px;
					margin-top: 30rpx;
				}

				// #endif
				.font {
					margin-top: 15px;
					position: relative;
					width: 100%;

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

					p {
						color: #999;
						font-size: 14px;
					}

					.weight {
						color: #262626;
						padding-top: 10px;
					}
				}
			}

			&::before,
			&::after {
				display: block;
				content: '';
				position: absolute;
				width: 52rpx;
				height: 52rpx;
				border-radius: 100%;
				background-color: #F5F5F5;
				z-index: 2;

				top: 76px;
			}

			&::before {
				left: -26rpx;
			}

			&::after {
				right: -26rpx;
			}

		}
	}

	// 客服区
	.lxwm_content_top {
		padding: 10px 0;
		border-radius: 8px;
		display: flex;
		justify-content: center;
		flex-direction: column;
		background-color: #ffffff;

		.lxwm_title {
			font-size: 32rpx;
			color: #333;
			font-weight: 600;
			line-height: 44rpx;
			margin: 10rpx 0 10rpx 30rpx;
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
				margin: 20rpx 0;
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
