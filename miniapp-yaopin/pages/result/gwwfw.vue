<!-- 国外无防伪 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="真伪鉴别" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="content-info">
				<view class="top-box">
					<view class="item info">
						<!-- <text v-html="info.content"></text> -->
						<u-parse :content="info.content" :tag-style="html_style"></u-parse>
					</view>
					<view class="item gray" v-if="info.dataSources">
						查询来源：
						<text style="color: #333;word-break: break-all;">
							{{ info.dataSources  ||'暂无'}}
						</text>
					</view>
					<view class="item gray" v-if="info.queryTime">
						查询时间：
						<text style="color: #333">{{ info.queryTime ||'暂无' }}</text>
					</view>
					<view class="item desc-box" v-if="info.copyText">
						{{info.copyText ||'暂无'}}
					</view>
				</view>
			</view>
			<view class="bg-grey"></view>
			<view class="fw-method">
				<view class="title" v-if="info.codeQuery">防伪方法</view>
				<view class="text-info">
					<!-- 当前药品注册上市合法，是否立即查询真伪信息 -->

					<u-parse :content="info.codeQuery"></u-parse>
				</view>
			</view>
			<view class="bottom-fill"></view>
		</scroll-view>
		<view class="bottomBtn">
			<u-button shape="circle" color="#0FC8AC" @click="tjkf">了解更多信息</u-button>
		</view>
	</view>
</template>

<script>
	import {
		pluginContentReq,
	} from '@/api/home.js'
	import {
		goodsSubjectReq
	} from '@/api/goodsApi.js'
	export default {
		data() {
			return {
				goodsId: '',
				info: '',
				content: {},
				zcInfo: '',
				html_style: {
					p: "white-space:pre-wrap;word-break:break-all;"
				}
			}
		},
		onLoad(option) {
			this.content = {
				goodsId: option.goodsId,
				serverId: option.serverId || 2
			}
			this.getContent()
		},
		onShow(){
			// #ifdef H5
			document.title = '真伪鉴别'
			//#endif
		},
		methods: {
			getContent() {
				let that = this
				let params = {
					...this.content
				}
				goodsSubjectReq(params).then(res => {
					this.info = res.data
				})
				const data = {
					keyword: 'security'
				}
				pluginContentReq(data).then(res => {
					this.zcInfo = res.data
				})
			},
			tjkf() {
				uni.navigateTo({
					url: "/pages/lxwm/lxwm"
				})
			},
		}
	}
</script>

<style lang="scss" scoped>
	.content {
		.content-info {
			padding: 20rpx 30rpx;

			.top-box {
				font-size: 36rpx;
				line-height: 56rpx;

				.desc-box {
					font-size: 28rpx;
					line-height: 36rpx;
					color: #0FC8AC;
				}

				.item {
					margin-bottom: 8rpx;
				}
			}

			.info {
				img {
					width: auto;
					height: auto;
					max-width: 100%;
					max-height: 100%;
					margin: 0 auto;
				}
			}

			.gray {
				font-size: 28rpx;
				line-height: 40rpx;
				color: #999999;
			}
		}

		.bg-grey {
			height: 20rpx;
		}

		.fw-method {
			padding: 30rpx;

			.title {
				font-size: 32rpx;
				margin-bottom: 10rpx;
				font-weight: bold;
				color: #000;
			}

			.text-info {
				line-height: 40rpx;
				color: #333;
			}
		}
	}

	.label {
		font-size: 32rpx;
		font-weight: bold;
		line-height: 44rpx;
		padding: 20rpx 30rpx;
	}

	.info {
		padding: 30rpx;

		img {
			width: auto;
			height: auto;
			max-width: 100%;
			max-height: 100%;
			margin: 0 auto;
		}

		image {
			width: auto;
			height: auto;
			max-width: 100%;
			max-height: 100%;
			margin: 0 auto;
		}

		/deep/ ._img {
			width: auto;
			height: auto;
			max-width: 100%;
			max-height: 100%;
			margin: 0 auto;
		}
	}

	.bottom-fill {
		height: 138rpx;
	}

	.bottomBtn {
		position: fixed;
		z-index: 2;
		width: calc(100% - 56rpx);
		left: 28rpx;
		bottom: 40rpx;
		display: flex;
		flex-direction: row;
		align-items: center;

		.submit {
			height: 88rpx;
			background: #0FC8AC;
			border-radius: 44rpx;
			color: #fff;
			font-size: 32rpx;
			font-weight: 600;
		}
	}
</style>