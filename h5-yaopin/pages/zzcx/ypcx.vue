<!--自助查询-->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="true" leftIcon=" " placeholder>
				<view class="u-nav-slot" slot="left">识药查真伪</view>
			</u-navbar>
		</view>
		<SearchList :searchModel.sync="keyword" @back="leftClick" :defaultValue="keyword" @search=goToSearch />
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<scroll-view class="hot_sell" :style="{ height: scrollViewheight - 70 + 'px' }" @scrolltolower="scrolltolower"
				scroll-y v-if="searchList.length > 0">
				<!-- 标题 -->
				<view class="hot_content">
					<view class="hot_content_items" v-for="(its, ids) in searchList" @click="goToYccx(its)">
						<u-image :src="its.goodsImage" width="100%" height="200rpx"
							:errorIcon="$utils.getImgUrl('empty-goods.png')"></u-image>
						<view class="item_title">{{ its.goodsName }}</view>
						<view class="item_name">{{ its.companyName }}</view>
						<view>
							<view v-if="its.marketTag" class="items_icon">{{ its.marketTag }}</view>
							<view v-if="its.medicalTag" class="items_icon">{{ its.medicalTag }}</view>
							<view v-if="its.clinicalStage" class="items_icon">{{ its.clinicalStage }}</view>
						</view>
						<view class="item_num">{{ its.searchNum || 0 }}人查询过</view>
						<view v-if="its.drugProperties" class="left_icon"
							:style="{ backgroundColor: its.drugPropertiesColor }">{{ its.drugProperties }}</view>
						<view class="warning_icon" v-if="its.risk == 1">
							<u-image :src="$utils.getImgUrl('warning.png')" width="180rpx" height="224rpx"></u-image>
						</view>
					</view>
				</view>
				<u-loadmore v-if="isMore" bgColor="#ffffff" :status="moreStatus" />
			</scroll-view>
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
					<view class="hot_content_items" v-for="(its, ids) in hotGoodsList" @click="goToYccx(its)">
						<u-image :src="its.goodsImage" width="100%" height="200rpx"
							:errorIcon="$utils.getImgUrl('empty-goods.png')"></u-image>
						<view class="item_title">{{ its.goodsName }}</view>
						<view class="item_name">{{ its.companyName }}</view>
						<view>
							<view v-if="its.marketTag" class="items_icon">{{ its.marketTag }}</view>
							<view v-if="its.medicalTag" class="items_icon">{{ its.medicalTag }}</view>
							<view v-if="its.clinicalStage" class="items_icon">{{ its.clinicalStage }}</view>
						</view>
						<view class="item_num">{{ its.searchNum || 0 }}人查询过</view>
						<view v-if="its.drugProperties" class="left_icon"
							:style="{ backgroundColor: info.goodsInfo.drugPropertiesColor }">{{ its.drugProperties }}</view>
						<view class="warning_icon" v-if="its.risk == 1">
							<u-image :src="$utils.getImgUrl('warning.png')" width="180rpx" height="224rpx"></u-image>
						</view>
					</view>
				</view>
			</view>
			<u-loading-page :loading="loading"></u-loading-page>
		</view>
	</view>
</template>

<script>
import SearchList from '@/components/search-list.vue'

export default {
	components: {
		SearchList
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
		}
	},
	onLoad(option) {
		this.getHeight()
		if (option) {
			this.keyword = option.keyword
			this.defaultValue = option.keyword
		}
		this.loadmore()
		this.getHotList()
	},
	methods: {
		// 跳转到药厂查询页面
		goToYccx(item) {

			if (item.risk == 1) {
				uni.navigateTo({
					url: `/pages/result/smRisk?companyId=${item.companyId}&goodsId=${item.goodsId}`
				})
			} else {
				uni.navigateTo({
					url: `/pages/result/smNoRisk?companyId=${item.companyId}&goodsId=${item.goodsId}`
				})
			}

		},
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
			let params = {
				keyword: this.keyword,
				page: this.page
			}
			this.$store.dispatch('home/getHomeSearch', params).then(res => {
				this.searchList = this.page > 1 ? this.searchList.concat(res.data.goodsList) : res.data.goodsList

			}).finally(() => {
				this.loading = false
				this.moreStatus = 'nomore'
				this.isMore = false
			})
		},
		getHotList() {
			this.$store.dispatch('home/getHotGoods').then(res => {
				this.hotGoodsList = res.data.goodsList
			})
		},
		scrolltolower() {
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
.hot_sell {
	margin: 0 15px;
	width: calc(100% - 30px);

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

	.hot_content {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-between;

		.hot_content_items {
			width: 46%;
			margin: 20rpx 10rpx;
			display: flex;
			flex-direction: column;
			border: 2rpx solid #E0E0E0;
			border-radius: 8rpx;
			position: relative;

			.item_title {
				margin: 10rpx 0 0 20rpx;
				font-size: 28rpx;
				font-weight: 600;
				color: #333333;
				line-height: 40rpx;
			}

			.item_name {
				margin: 10rpx 0 0 20rpx;
				font-size: 24rpx;
				font-weight: 400;
				color: #999999;
				line-height: 34rpx;
			}

			.item_num {
				margin: 10rpx 0 20rpx 20rpx;
				font-size: 24rpx;
				font-weight: 400;
				color: #0fc8ac;
				line-height: 34rpx;
			}

			.left_icon {
				padding: 0 12rpx;
				line-height: 36rpx;
				font-size: 24rpx;
				height: 36rpx;
				border-radius: 8rpx 0 8rpx 0;
				position: absolute;
				top: 0;
				left: 0;
				color: white;
				background-color: #0FC8AC;
			}

			.items_icon {
				display: inline-block;
				margin: 12rpx 0 0 20rpx;
				height: 44rpx;
				background: rgba(255, 147, 48, 0.1);
				color: #FF9330;
				font-size: 22rpx;
				line-height: 44rpx;
				padding: 0 8rpx;
				border-radius: 8rpx;
			}

			.warning_icon {
				position: absolute;
				top: 0;
				display: flex;
				justify-content: center;
				width: 100%;
				height: 100%;
			}
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
