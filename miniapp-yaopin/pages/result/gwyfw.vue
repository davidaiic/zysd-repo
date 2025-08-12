<!-- 国外有防伪 -->
<!-- 药厂防伪码查询文案接口 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="真伪鉴别" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
		</view>  
		<scroll-view scroll-y  class="content" :style="{ height: scrollViewheight + 'px' }">
			<view class="content-info">
				<view class="top-box">
					<view class="item info">
						<u-parse :content="info.content"></u-parse>
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
						{{info.copyText  ||'暂无'}}
					</view>
				</view>
			</view>
			<view class="bg-grey"></view>
			<view class="fw-method">
				<view class="title">防伪方法</view>
				<view class="text-info">
					当前药品注册上市合法，是否立即查询真伪信息
				</view>
			</view>
			<view class="bottom-fill"></view>
		</scroll-view>
		<view class="bottomBtn">
			<u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" color="#0FC8AC"
				@click="tjkf">了解更多信息</u-button>
			<u-button :customStyle="{ flex: 2, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
				@click="ljcx">立即查询</u-button>
		</view>
	</view>
</template>

<script>
	import {
		goodsSubjectReq,
		goodsInfoReq
	} from '@/api/goodsApi.js'
	export default {
		data() {
			return {
				goodsId: '',
				info: '',
				content: {}
			}
		},
		onLoad(option) {
			console.log(option)
			this.content = {
				goodsId: option.goodsId,
				companyId: option.companyId ,
				company:option.companyName,
				goodsName: option.goodsName,
				specs:option.specs,
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
				goodsInfoReq({ goodsId: that.content.goodsId }).then(async res => {
					const data = res.data.goodsInfo
					
					this.content = {
						goodsId:data.goodsId,
						goodsName: data.goodsName,
						companyId: data.companyId,
						companyName: data.companyName,
						specs: data.specs,
					}
				})
			},
			tjkf() {
				uni.navigateTo({
					url: "/pages/lxwm/lxwm"
				})
			},
			ljcx() {
				let that = this
				let info = that.content
				uni.navigateTo({
					url: '/pages/zzcx/yccx'+'?goodsId='+info.goodsId+
					'&companyId='+info.companyId+
					'&companyName='+info.company+
					'&goodsName='+info.goodsName+
					'&specs='+info.specs
				})
			}
		}
	}
</script>

<style lang="scss" scoped>
	.content {
		.content-info{
			padding: 20rpx 30rpx;
			.top-box {
				font-size: 36rpx;
				line-height: 56rpx;
				.desc-box{
					font-size: 28rpx;
					line-height: 36rpx;
					color: #0FC8AC;
				}
				.item{
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
		.bg-grey{
			height: 20rpx;
		}
		.fw-method{
			padding: 30rpx;
			.title{
				font-size: 32rpx;
				margin-bottom: 10rpx;
				font-weight: bold;
				color: #000;
			}
			.text-info{
				line-height: 40rpx;
				color: #333;
			}
		}
	}

	
.bottom-fill{
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