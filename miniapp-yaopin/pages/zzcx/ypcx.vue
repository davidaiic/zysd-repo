<!--自助查询-->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="true" leftIcon=" " placeholder>
				<view class="u-nav-slot" slot="left">识药查真伪</view>
			</u-navbar>
		</view>
		<SearchList class="search-list" id="search_list" :searchModel.sync="keyword" @back="leftClick"  :defaultValue="keyword" @search="goToSearch" />
		<!-- <SearchList id="search_list" :searchModel.sync="keyword" @back="leftClick" :defaultValue="keyword" @search="goToSearch" /> -->
	
		<view class="content" :style="{ height: bottom_box_height + 'px' }">
			<scroll-view class="hot_sell" :style="{ height: bottom_box_height + 'px' }" @scrolltolower="scrolltolower"
				scroll-y>
				<view  v-if="searchList.length > 0">
					<!-- 标题 -->
					<view class="hot_content">
						<goodsList :lists="searchList"></goodsList>
					</view>
					<!-- v-if="isMore" -->
					
					<u-loadmore  bgColor="#ffffff" :status="moreStatus" />
				</view>
				
				<view class="hot_sell" v-else>
					<u-empty text="暂无商品，需要你上传照片进行数据更新" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px"
						:margin-top="30">
					</u-empty>
					<view style="margin: 55rpx">
						<u-button color="#0fc8ac" shape="circle" @click="goUploadImg">立即上传</u-button>
					</view>
					<!-- <u-gap height="20rpx" bgColor="#F8F8F8"></u-gap> -->
					<view class="port_title">
						<view>
							热门药品
						</view>
					</view>
					<view class="hot_content">
						<goodsList :lists="hotGoodsList"></goodsList>
					</view>
				</view>
				<view class="loading flex-column flex-c" :class="loading ? 'show':'hide'" v-if="searchList.length == 0">
					<u-loading-icon></u-loading-icon>
					<view>加载中...</view>
				</view>
				
				<!-- <u-loading-page :loading="loading"></u-loading-page> -->
				<view class="bottom-fill"></view>
			</scroll-view>
			
		</view>
	</view>
</template>

<script>
import SearchList from '@/components/search-list.vue'

import goodsList from '@/components/goodsInfo/goodsList.vue'
import {
	searchReq,
	hotGoodsReq
} from '@/api/home.js'
export default {
	components: {
		SearchList,
		goodsList
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
			bottom_box_height:800
		}
	},
	onLoad(option) {
		if (option) {
			this.keyword = option.keyword
			this.defaultValue = option.keyword
		}
		let that = this
		uni.createSelectorQuery().select('#search_list').boundingClientRect(function(rect){
			console.log(rect)
			  that.bottom_box_height = that.scrollViewheight - rect.height
		}).exec()
		this.loadmore()
		this.getHotList()
	},
	
	onShow() {
		// #ifdef H5
		document.title = '识药查真伪'
		//#endif
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
				keyword: this.keyword,
				page: this.page
			}
			searchReq(params).then(res => {
				let res_data = res.data.goodsList
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
		getHotList() {
			hotGoodsReq().then(res => {
				this.hotGoodsList = res.data.goodsList
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
.search-list{
	position: relative;
	z-index: 13;
}
.bottom-fill{
	height: 40rpx;
}
.hot_sell {
	position: relative;
	.loading{
		width: 100%;
		height: 100%;
		position: absolute;
		left: 0;
		top: 0;
		background: #fff;
		overflow: hidden;
		&.hide{
			height: 0;
		}
	}
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
/deep/.u-loading-page {
	width: 100%;
	height: 100%;
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
