<!--自助查询-->
<template>
	<view class="mainWrap">
		<view class="contents">
		    <u-navbar v-if="!isH5" title="资讯列表" :fixed="false" @leftClick="leftClick"
		        :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight + 'px' }">
			<scroll-view class="hot_sell" :style="{ height: scrollViewheight + 'px' }" @scrolltolower="scrolltolower"
				scroll-y v-if="searchList.length > 0">
				
				<!-- 标题 -->
				<view class="hot_content">
					<view v-for="(items, index) in searchList" :key="index">
					    <zxItem :items="items" />
					</view>
				</view>
				<u-loadmore  bgColor="#ffffff" :status="moreStatus" />
				<view class="bottom-fill"></view>
			</scroll-view>
			<u-loading-page :loading="loading"></u-loading-page>
		</view>
	</view>
</template>

<script>

import zxItem from './zx-item.vue';
import goodsList from '@/components/goodsInfo/goodsList.vue'
import {
	articleListReq,
} from '@/api/home.js'
export default {
	components: {
		zxItem
	},
	data() {
		return {
			searchList: [],
			page: 1,
			keyword: '',
			from: '',
			hotGoodsList: [],
			loading: true,
			defaultValue: '',
			isMore: false,
			moreStatus: 'loading',
			load_end:false,
		}
	},
	onLoad(option) {
		if (option) {
			this.keyword = option.keyword
		}
		let that = this
		this.loadmore()
	},
	methods: {
		// 点击其他厂家
		goToQtcj() {
			uni.navigateTo({
				url: '/pages/rghc/index'
			})
		},
		lxwm() {
			uni.navigateTo({
				url: '/pages/lxwm/lxwm'
			})
		},
		/**
		 * 点击便捷搜索
		 */
		loadmore() {
			// if(this.loading){
			// 	return
			// }
			// this.loading = true
			let params = {
				keyword:this.keyword,
				page: this.page
			}
			articleListReq(params).then(res => {
				let res_data = res.data.articleList
				if(res_data.length){
					this.searchList = this.page > 1 ? this.searchList.concat(res_data) : res_data
				}else{
					this.load_end = true
					// 
					this.moreStatus = 'nomore'
				}

			}).finally(() => {
				this.loading = false
				this.moreStatus = 'nomore'
				this.isMore = false
			})
		},
		scrolltolower() {
			if(this.load_end){
				return
			}
			if(this.moreStatus == 'loading'){
				return
			}
			this.page++
			this.isMore = true
			this.moreStatus = 'loading'
			this.loadmore()
		},
		goUploadImg() {
			uni.navigateTo({
				url: '/pages/rghc/zpcx'
			})
		},
		goToSearch() {
			this.page = 1
			this.loading = true
			this.loadmore()
		}
	}
}
</script>

<style lang="scss">
page {
	overflow: hidden;
}
</style>

<style lang="scss" scoped>
.bottom-fill{
	height: 40rpx;
}
.hot_sell {
	.hot_content{
		padding: 0 15px;
	}
	.port_title {
		margin-bottom: 20rpx;
		padding: 20rpx 0;
		width: 128rpx;
		font-size: 32rpx;
		font-weight: 600;
		color: #333333;
		line-height: 44rpx;

		.line {
			margin-top: -6rpx;
			width: 128rpx;
			height: 6rpx;
			background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%);
		}
	}
}

.bottomBtn {
	position: fixed;
	z-index: 2;
	width: 100%;
	background-color: #fff;
	padding: 30rpx 0;
	left: 0;
	bottom: 0;

	.p {
		font-size: 14px;
		font-weight: 400;
		color: #999999;
		line-height: 20px;
		text-align: center;
		margin-bottom: 20px;
	}

	/deep/ .u-button {
		width: calc(100% - 56rpx);
		height: 88rpx;
		background: #0FC8AC;
		border-radius: 44rpx;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
	}
}
</style>
