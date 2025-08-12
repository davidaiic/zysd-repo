<!-- 人工核查 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="人工核查" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="part">
				<view class="tit">方式一<text>（服务时间：{{ formData.photoServiceTime }}）</text></view>
				<view class="des">
					<view class="pic" @click="goToPz()">
						<u-image :src="$utils.getImgUrl('picture.png')" width="156rpx" height="156rpx" />
					</view>
					<view class="p">拍照上传<text>（{{ formData.photoFeedbackTime }}）</text></view>
					<view class="tips">{{ formData.photoQueryNum || 0 }}人查询过</view>
				</view>
			</view>
			<view class="line"></view>
			<view class="part">
				<view class="tit">方式二<text>（服务时间：{{ formData.wxServiceTime }}）</text></view>
				<view class="des">
					<view class="pic" @click="goToLx()">
						<u-image :src="$utils.getImgUrl('wx.png')" width="156rpx" height="156rpx" />
					</view>
					<view class="p">加客服微信查询<text>（{{ formData.wxFeedbackTime }}）</text></view>
					<view class="tips">{{ formData.wxQueryNum || 0 }}人查询过</view>
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
				photoServiceTime: '',
				photoFeedbackTime: '',
				photoQueryNum: '',
				wxServiceTime: '',
				wxFeedbackTime: '',
				wxQueryNum: '',
			}
		}
	},
	onLoad() {
		this.getHeight()
		this.getQueryManualFunc()
	},
	methods: {
		// 拍照
		goToPz() {
			uni.navigateTo({
				url: '/pages/rghc/zpcx'
			})
		},
		// 联系我们
		goToLx() {
			uni.navigateTo({
				url: '/pages/lxwm/lxwm'
			})
		},
		getQueryManualFunc() {
			this.$store.dispatch('rghc/getQueryManual').then(res => {
				this.formData = res.data
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding-top: 40rpx;

	.part {
		padding: 15px 15px 25px;

		.tit {
			font-size: 16px;
			font-family: PingFangSC-Semibold, PingFang SC;
			font-weight: 600;
			color: #333333;
			line-height: 22px;

			text {
				font-weight: 400;
			}
		}

		.des {
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-content: center;

			.pic {
				margin: 10px auto;

				image {
					width: 78px;
					height: 78px;
				}
			}

			.p {
				text-align: center;
				font-size: 14px;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #333333;
				line-height: 20px;

				text {
					color: #999;
				}
			}

			.tips {
				margin-top: 10px;
				text-align: center;
				font-size: 14px;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #0FC8AC;
				line-height: 20px;
			}
		}
	}

	.line {
		width: 100%;
		height: 10px;
		background-color: #F8F8F8;
	}
}
</style>
