<!-- 人工核查--照片查询 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="照片查询" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }">
			</u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="yjfk_textarea">
				<!-- 图片 -->
				<view class="yjfk_textarea_title">
					上传照片<text class="orange">（至少包括正反左右四个方位照片）</text>
				</view>
				<view class="picArray">
					<!-- positive 正面-->
					<e-upload-item class="picArray_item" v-model="form.positive" maxCount='1' placeHolder="正面">
					</e-upload-item>
					<!-- leftSide 左侧面-->
					<e-upload-item class="picArray_item" v-model="form.leftSide" maxCount='1' placeHolder="左侧面">
					</e-upload-item>
					<!-- rightSide 右侧面-->
					<e-upload-item class="picArray_item" v-model="form.rightSide" maxCount='1' placeHolder="右侧面">
					</e-upload-item>
					<!-- back 背面-->
					<e-upload-item class="picArray_item" v-model="form.back" maxCount='1' placeHolder="背面">
					</e-upload-item>
					<!-- other 更多-->
					<e-upload-item class="picArray_item" v-model="form.other" maxCount='5' placeHolder="更多">
					</e-upload-item>
				</view>
				<u-gap height="26px"></u-gap>
				<!-- 手机号码 -->
				<view class="yjfk_textarea_title">
					手机号码
				</view>
				<view class="">
					<u-input type="number" maxlength="11" v-model="form.mobile" :placeholder="teleHolder"></u-input>
				</view>

				<u-gap height="36px"></u-gap>
				<!-- 示例 -->
				<view class="yjfk_textarea_title">
					示例
				</view>
				<view class="shili">
					<view class="shili_item">
						<img class="shili_item_top" :src="$utils.getImgUrl('up.png')" />
						<view class="shili_item_buttom">
							<img class="inner_img" :src="$utils.getImgUrl('ok.png')" />
							正面
						</view>
					</view>
					<view class="shili_item">
						<img class="shili_item_top" :src="$utils.getImgUrl('left.png')" />
						<view class="shili_item_buttom">
							<img class="inner_img" :src="$utils.getImgUrl('ok.png')" />
							左侧面
						</view>
					</view>
					<view class="shili_item">
						<img class="shili_item_top" :src="$utils.getImgUrl('right.png')" />
						<view class="shili_item_buttom">
							<img class="inner_img" :src="$utils.getImgUrl('ok.png')" />
							右侧面
						</view>
					</view>
					<view class="shili_item">
						<img class="shili_item_top" :src="$utils.getImgUrl('back.png')" />
						<view class="shili_item_buttom">
							<img class="inner_img" :src="$utils.getImgUrl('ok.png')" />
							背面
						</view>
					</view>
				</view>
			</view>

			<view class="bottomBtn">
				<u-button class="submit" @click="submitForm">确定</u-button>
			</view>
		</view>
	</view>
</template>

<script>
import { bridgrCall } from '@/utils/bridge'
import {photoFindReq} from '@/api/goodsApi.js'
export default {
	data() {
		return {
			teleHolder: '输入手机号码',
			form: {
				positive: [],
				leftSide: [],
				rightSide: [],
				back: [],
				other: [],
				tele: ''
			}
		}
	},
	onLoad() {
		
	},
	
	onShow() {
		// #ifdef H5
		document.title = '照片查询'
		//#endif
	},
	methods: {
		submitForm() {
			let params = {
				positive: this.transImg(this.form.positive),
				leftSide: this.transImg(this.form.leftSide),
				rightSide: this.transImg(this.form.rightSide),
				back: this.transImg(this.form.back),
				other: this.transImg(this.form.other),
				mobile: this.form.mobile
			}
			if (!params.positive) {
				uni.showToast({
					icon: 'none',
					title: '请上传正面'
				})
				return false
			}
			if (!params.leftSide) {
				uni.showToast({
					icon: 'none',
					title: '请上传左侧面'
				})
				return false
			}
			if (!params.rightSide) {
				uni.showToast({
					icon: 'none',
					title: '请上传右侧面'
				})
				return false
			}
			if (!params.back) {
				uni.showToast({
					icon: 'none',
					title: '请上传背面'
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
			photoFindReq(params).then(res => {
				uni.showToast({
					icon: 'success',
					duration: 1500,
					title: '我们将在48小时内以短信的形式通知你，请注意查看',
					success() {
						uni.$u.sleep(2000).then(() => {
							
							//#ifdef H5
							bridgrCall.goPrevPage()
							return
							//#endif
							uni.switchTab({
								url: '/pages/index/index'
							})
						})
					}
				})
			})
		},
		transImg(img) {
			return img.map(item => {
				return item.url
			}).join(',')
		},
		phoneCheck(mobile) {
			if (!(/^1(3|4|5|6|7|8|9)\d{9}$/.test(mobile))) {
				uni.showToast({
					icon: 'none',
					title: '请填写正确的手机号码'
				})
				return
			}
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	background-color: #fff;
	padding-top: 40rpx;
}

.yjfk_textarea {
	margin: 0 30rpx;

	.yjfk_textarea_title {
		font-size: 32rpx;
		line-height: 44rpx;
		font-weight: 600;
		color: #333;
		margin: 0 0 25rpx 0;
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

.orange {
	font-size: 24rpx;
	font-family: PingFangSC-Regular, PingFang SC;
	font-weight: 400;
	color: #FC511E;
	line-height: 34rpx;
}

.picArray {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;

	.picArray_item {
		margin: 6rpx 15rpx 15rpx 0;
	}

	.picArray_item:nth-child(4) {
		margin-right: 0;
	}
}

.shili {
	display: flex;
	flex-direction: row;

	.shili_item {
		flex: 1;

		.shili_item_top {
			width: 140rpx;
			height: 140rpx;
			// border: 2rpx solid #999999;
			display: flex;
			justify-content: center;
			align-items: center;

			.inner_img {
				width: 62rpx;
				height: 104rpx;
			}
		}

		.shili_item_buttom {
			width: 140rpx;
			color: #999999;
			font-size: 24rpx;
			display: flex;
			justify-content: center;
			align-items: center;
			margin-top: 10rpx;

			.inner_img {
				width: 24rpx;
				height: 24rpx;
			}
		}
	}
}
</style>
