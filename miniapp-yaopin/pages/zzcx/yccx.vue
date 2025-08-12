<!-- 自助查询,药厂查询 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="药厂查询" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight + 'px' }">
			<view class="h1">一、查询药品防伪信息</view>
			<view class="search">
				<view class="flex">
					<u--input placeholder="请输入防伪码" border="none" v-model="value" @change="change">
					</u--input>
					<img :src="$utils.getImgUrl('scanOne.png')" @click="scanEwm" />
				</view>
				<view class="where" @click="where()">防伪码在哪里？</view>
			</view>
			<view v-if="goodsId > 0">
				<view class="h1">二、查询药品注册信息（药品批准文号）</view>
				<view class="des">
					<u-parse :content="zcInfo"></u-parse>
				</view>
			</view>
			<view v-else>
				<view class="h1">二、选择药品名称</view>
				<view class="search" @click="showSel = true">
					<view class="flex">
						<u-input v-model="goodsName" disabled disabledColor="#ffffff" placeholder="选择药品名称" border="none">
						</u-input>
					</view>
				</view>
				<view class="h1">三、查询药品注册信息（药品批准文号）</view>
				<view class="des">
					<u-parse :content="zcInfo"></u-parse>
				</view>
			</view>
		</scroll-view>
		<view class="bottomBtn">
			<u-button class="submit" @click="submitForm">提交查询</u-button>
		</view>

		<!-- 药品名称展示 -->
		<u-picker :show="showSel" :columns="goodsList" keyName="goodsName" @confirm="selSelect" @cancel="showSel = false">
		</u-picker>
	</view>
</template>

<script>
import { bridgrCall } from '../../utils/bridge'
import {
	pluginContentReq
} from '@/api/home.js'
import{
	goodsListReq
} from '@/api/goodsApi.js'
import resultVue from './result.vue'
export default {
	data() {
		return {
			value: '',
			companyId: '',
			goodsId: '',
			zcInfo: '',
			goodsList: [],
			goodsName: '',
			showSel: false
		}
	},
	onLoad(option) {
		console.log(option, 'sss')
		this.companyId = option.companyId
		this.goodsId = option.goodsId
		this.goodsName = option.goodsName
		this.getContent()
		console.log(uni.getSystemInfoSync(), 'sssss')
		this.getGoodsList()
	},
	
	onShow() {
		// #ifdef H5
		document.title = '药厂查询'
		//#endif
	},
	methods: {
		getGoodsList() {
			let that = this
			if (that.companyId) {
				let params = {
					companyId: that.companyId
				}
				goodsListReq(params).then(res => {
					this.goodsList[0] = res.data.goodsNameList
				})
			}
		},
		selSelect(e) {
			let p = e.value[0]
			this.goodsName = p.goodsName;
			this.showSel = false;
		},
		scanEwm() {
			const that = this
			// #ifdef H5
			bridgrCall.scan({}).then(res => {
				let val = that.$utils.getUrlParams(res.data,'code')
				that.value = val
			})
			return
			//#endif
			uni.scanCode({
				scanType: ["qrCode"],
				success: (res) => {
					console.log(res)
					if (res.result) {
						let val = that.$utils.getUrlParams(res.result,'code')
						this.value = val
						
					} else {
						return false
					}
				},
				fail: (res) => {
					uni.showToast({
						icon: 'none',
						title: '未识别到二维码，请重新识别'
					})
				}
			})
		},
		change(e) {
			console.log('change', e);
		},
		where() {
			let that = this
			uni.navigateTo({
				url: `/pages/zzcx/where?companyId=${that.companyId}`
			})
		},
		getContent() {
			let that = this
			let params = {
				keyword: 'number'
			}
			pluginContentReq(params).then(res => {
				this.zcInfo = res.data.content
			})
		},
		submitForm() {
			let that = this
			uni.showLoading({
				title: '数据查询中'
			});
			if (!that.value) {
				uni.showToast({
					icon: 'none',
					title: '请输入防伪码'
				})
				return false
			}

			if (that.goodsId < 1 && !that.goodsName) {
				uni.showToast({
					icon: 'none',
					title: '请选择药品名称'
				})
				return false
			}
			// let token = uni.getStorageSync('token')
			// if (token) {
				console.log(that.goodsName)
				uni.$u.sleep(1000).then(() => {
					uni.hideLoading();
					uni.navigateTo({
						url: `/pages/zzcx/result?companyId=${that.companyId}&goodsId=${that.goodsId}&goodsName=${that.goodsName}&code=${that.value}`
					})
				});
			// } else {
			// 	uni.$u.sleep(1000).then(() => {
			// 		uni.hideLoading();
			// 		uni.navigateTo({
			// 			url: '/pages/login/noLogin'
			// 		})
			// 	});
			// }
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;
	box-sizing: border-box;
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

		.flex {
			display: flex;
			align-items: center;
			border-width: 0.5px !important;
			border-color: #dadbde !important;
			border-style: solid;
			padding: 5px;
			border-radius: 4px;

			image {
				width: 20px;
				height: 20px;
			}
		}

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
