<!-- 自助查询--药厂查询--查询结果页 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="查询完成" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 90 + 'px' }">
			<view class="part">
				<view class="h1">一、药品防伪信息</view>
				<view class="des">
					<u-parse :content="formData.info"></u-parse>
				<!-- <view class="item">
						<view class="lab">药品名：</view>
						<view class="txt">xxxxx</view>
					</view>
					<view class="item">
						<view class="lab">厂家：</view>
						<view class="txt">xxxxxx</view>
					</view>
					<view class="item">
						<view class="lab">作用：</view>
						<view class="txt">xxxxxxxx</view>
					</view>
					<view class="item">
						<view class="lab">成分：</view>
						<view class="txt">xxxxxx</view>
						</view> -->
				</view>
			<!-- <u-empty text="当前防伪码查询不到相应的药品防伪信息" :icon="$utils.getImgUrl('暂无防伪信息.png')" width="280rpx" height="212rpx"
					:margin-top="120">
					</u-empty> -->
			</view>

			<view class="part">
				<view class="h1">二、药品注册信息（药品批准文号）</view>
				<view class="des" v-if="formData.registerInfo">
					<u-parse :content="formData.registerInfo"></u-parse>
					<view class="item">
						<view class="lab">查询时间：</view>
						<view class="txt">{{ formData.queryTime || '-' }}</view>
					</view>
					<view class="item">
						<view class="lab">查询来源：</view>
						<view class="txt">{{ formData.dataSources }}</view>
					</view>
				</view>
				<u-empty v-if="isNopwInfo" text="暂无批文信息" :icon="$utils.getImgUrl('nopwInfo.png')" width="280rpx"
					height="212rpx" :margin-top="120">
				</u-empty>
			</view>

			<view class="part">
				<view class="des" style="margin-top:10rpx">
					<view class="item">
						<view class="txt">你是今天第{{ formData.rank || 0 }}位查询用户，已有{{ formData.total || 0 }}位用户查询过</view>
					</view>
				</view>
			</view>

		</view>

		<view class="bottomBtn">
			<u-button @click="wycj()">我要查价</u-button>
			<u-button @click="lxwm()">想要了解更多信息联系我们</u-button>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			formData: {
				info: '',
				rank: 0,
				total: 0
			},
			companyId: '',
			isNopwInfo: false,
			goodsId: '',
			code: ''
		}
	},
	onLoad: function (option) {
		if (option) {
			this.companyId = option.companyId
			this.goodsId = option.goodsId
			this.goodsName = option.goodsName
			this.code = option.code
			this.yccxFunc()
		}
	},
	onShow() {
		this.getHeight()
	},
	methods: {
		yccxFunc() {
			let that = this
			let params = {
				companyId: that.companyId,
				goodsId: that.goodsId,
				goodsName: that.goodsName,
				code: that.code
			}
			uni.showLoading({
				title: '查询中'
			});
			that.$store.dispatch('home/getQueryCompanySearch', params).then(res => {
				that.formData = res.data
				if (res.data.registerInfo) {
					that.isNopwInfo = false
				} else {
					that.isNopwInfo = true
				}
				uni.hideLoading();
			})
		},
		lxwm() {
			uni.navigateTo({
				url: '/pages/lxwm/lxwm'
			})
		},
		wycj() {
			uni.navigateTo({
				url: '/pages/jgcx/index'
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.mainWrap {
	background-color: #f8f8f8;
	min-height: 10vh;
}

.content {
	.part {
		background: #fff;
		margin-bottom: 20rpx;
		padding: 40rpx 30rpx 30rpx;

		.h1 {
			height: 44rpx;
			font-size: 32rpx;
			font-family: PingFangSC-Semibold, PingFang SC;
			font-weight: 600;
			color: #333333;
			line-height: 44rpx;
		}

		.des {
			margin-top: 40rpx;
			font-size: 28rpx;

			.item {
				margin-bottom: 16rpx;
				display: flex;

				.lab {
					width: 160rpx;
					color: #999;
					line-height: 40rpx;
				}

				.txt {
					flex: 1;
					color: #333333;
					line-height: 40rpx;
					word-break: break-all;
				}
			}

			.tips {
				.txt {
					color: #0FC8AC;
				}

			}

			/deep/ .u-image {
				margin-bottom: 20rpx;
			}
		}
	}
}

.bottomBtn {
	box-shadow: 0rpx -2rpx 12rpx 0rpx rgba(157, 157, 157, 0.19);
	display: flex;
	justify-content: space-between;
	position: fixed;
	z-index: 2;
	width: calc(100% - 56rpx);
	left: 0;
	bottom: 0;
	background-color: #fff;
	padding: 40rpx 28rpx;

	/deep/ .u-button {
		height: 88rpx;
		border-radius: 44rpx;
		font-size: 32rpx;
		font-weight: 600;
	}

	/deep/ .u-button:first-child {
		margin-right: 20rpx;
		flex: .25;
		border-color: #0FC8AC;
		background: #fff;
		color: #0FC8AC;
	}

	/deep/ .u-button:last-child {
		background: #0FC8AC;
		color: #fff;
		flex: .75;
	}
}
</style>
