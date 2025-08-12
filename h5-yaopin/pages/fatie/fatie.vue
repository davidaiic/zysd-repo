<!-- 发布帖子 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="发布帖子" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="p5">
				<u-textarea v-model="formData.content" :adjustPosition="false" placeholder="写些什么和大家分享，字数不得少于10个字"
					height="25vh" border="none" />
			</view>
			<view class="picArray">
				<e-upload-item class="picArray_item" v-model="picList" maxCount='8' placeHolder="上传">
				</e-upload-item>
			</view>

			<u-gap height="20rpx" bgColor="#F8F8F8"></u-gap>
			<view class="showImport p15">
				<view class="showImport_top">
					重要提示:网友、医生言论仅代表其个人观点，不代表本站同意其说法，请谨慎发帖参阅，本站不承担由此引起的法律责任。
				</view>
				<view class="showImport_bottom" @click="guifan">
					查看《评论规范公约》
				</view>
			</view>
			<view class="bottomBtn">
				<u-button class="submit" @click="submitForm">发布</u-button>
			</view>
		</view>
	</view>
</template>

<script>
import {
	transImg
} from '@/utils/utils.js';

export default {
	data() {
		return {
			formData: {
				content: '',
			},
			commentId: '',
			picList: [],
		}
	},
	onLoad(option) {
		this.commentId = option.commentId
		this.getHeight()
	},
	methods: {
		guifan() {
			uni.navigateTo({
				url: '/pages/plgy/plgy'
			})
		},
		submitForm() {
			let that = this
			let params = {
				content: that.formData.content,
				commentId: that.commentId,
				pictures: transImg(that.picList)
			}
			if (params.content.length < 10) {
				uni.showToast({
					icon: 'none',
					title: '请填写10字以上的分享'
				})
				return false
			}
			that.$store.dispatch('home/getHomeComment', params).then(res => {
				if (res.code == 200) {
					uni.showToast({
						icon: 'none',
						title: '发布成功',
						duration: 1500,
						success() {
							uni.$u.sleep(2000).then(() => {
								that.leftClick()
							})
						}
					})
				} else {
					uni.showToast({
						icon: 'none',
						title: '发布失败'
					})
				}
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 20rpx 0 30rpx;
	background-color: #fff;

	.p15 {
		padding: 15px;
	}

	.h1 {
		height: 44rpx;
		font-size: 32rpx;
		font-family: PingFangSC-Semibold, PingFang SC;
		font-weight: 600;
		color: #333333;
		line-height: 44rpx;
	}

	.search {
		margin: 20rpx auto 60rpx;

		.where {
			margin-top: 10rpx;
			font-weight: 400;
			color: #0FC8AC;
			font-size: 28rpx;
		}
	}

	.des {
		margin-top: 20rpx;
		border-radius: 8rpx;
		border: 2rpx solid #E0E0E0;
		padding: 30rpx;
		color: #999999;
		line-height: 40rpx;
		font-size: 28rpx;
	}
}

.bottomBtn {
	position: fixed;
	width: calc(100% - 56rpx);
	left: 28rpx;
	z-index: 2;
	bottom: 60rpx;
	background-color: #fff;

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

.picArray {
	// display: flex;
	// flex-direction: row;
	padding: 30rpx;
	// flex-wrap: wrap;

	.picArray_item {
		margin: 6rpx 6rpx 0 0;
		margin-bottom: 15px;
		// width: 78rpx;
		// height: 78rpx;
		margin-right: 15px;
	}

	// .picArray_item:nth-child(4) {
	// 	margin-right: 0;
	// }
}

.showImport {
	display: flex;
	justify-content: center;
	align-items: center;
	flex-direction: column;
	margin-bottom: 120rpx;

	.showImport_top {
		display: flex;
		background: rgba(15, 200, 172, 0.1);
		border-radius: 8rpx;
		border: 2rpx solid #0FC8AC;
		padding: 20rpx;
		color: #666666;
		font-size: 28rpx;
		font-weight: 400;
	}

	.showImport_bottom {
		margin-top: 20rpx;
		font-size: 28rpx;
		font-weight: 600;
		color: #0FC8AC;
		line-height: 40rpx;
	}
}
</style>
