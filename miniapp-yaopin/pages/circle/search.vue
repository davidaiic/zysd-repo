<!-- 这是搜索页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=""  @leftClick="leftClick">
			    <view class="u-nav-slot" slot="left">识药查真伪</view>
			</u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight + 'px' }">
			<SearchBox :searchModel.sync="searchModel" @back="goHome()" :placeholder="default_placeholder" :defaultValue="defaultValue" @search="goToSearch">
	
			</SearchBox>

			<view class="tips" v-if="showIt">
				{{ searchDesc }}
				<u-icon class="gb" name="close-circle-fill" color="#0FC8AC" size="20" @click="showIt = false"></u-icon>
			</view>
			<!-- 历史搜索 -->
			<view class="part his" v-if="historyList.length > 0">
				<view class="tit">
					<view class="blod">历史搜索</view>
					<text @click="clear()">清空</text>
				</view>
				<view class="list">
					<view class="item" v-for="(item, index) in historyList" :key="index" @click="directSearch(item)">
						{{ item }}</view>
				</view>
			</view>
			<!-- 热门搜索 -->
			<view class="part hot">
				<view class="tit">
					<view class="blod">热门搜索</view>
				</view>
				<view class="list">
					<view class="itemWrap" v-for="(item, index) in hotSearch" :key="index" @click="directSearch(item.word)">
						<view class="icon">{{ index + 1 }}</view>
						<view class="item">{{ item.word }}</view>
					</view>
				</view>
			</view>
		</view>
	</view>
</template>

<script>
import SearchBox from './components/search';
import {
	hotWordReq,
	associateWordReq
} from '@/api/home.js'
export default {
	components: {
		SearchBox
	},
	data() {
		return {
			showIt: false,
			historyList: [],
			hotSearch: [],
			searchDesc: "",
			searchModel: "",
			searchInput: {
				color: '#333333',
				'background-color': 'white',
				padding: '4rpx',
			},
			searchList: [],
			defaultValue:'',
			default_placeholder:'输入关键词，快速找圈找内容'
		};
	},
	onLoad(options) {
		this.default_placeholder = options.keyword || "输入关键词，快速找圈找内容";
		this.historyList = uni.getStorageSync("CircleHistoryList") || [];
		this.getHotWordList();
	},
	methods: {
		goToSearch() {
			if (uni.$u.trim(this.searchModel) === "") {
				uni.showToast({
					icon: "none",
					title: "请输入药品搜索",
				});
				return false;
			}
			let p = this.historyList.some((item) => item === this.searchModel);
			if (!p) {
				this.historyList.push(this.searchModel);
				uni.setStorageSync("CircleHistoryList", this.historyList);
			}
			uni.navigateTo({
				url: `/pages/circle/circle-search?keyword=${this.searchModel}`,
			})
		},
		directSearch(item) {
			let p = this.historyList.some((h) => h === item);
			if (!p) {
				this.historyList.push(item);
				uni.setStorageSync("CircleHistoryList", this.historyList);
			}
			uni.navigateTo({
				url: `/pages/circle/circle-search?keyword=${item}`,
			})
		},
		getHotWordList() {
			let params = {
				type:1
			};
			hotWordReq(params).then((res) => {
				this.hotSearch = res.data.wordList;
				this.searchDesc = res.data.searchTip;
			});
		},
		goHome() {
			uni.switchTab({
				url: "/pages/circle/circle",
			});
		},
		showScan(type) {
			uni.navigateTo({
				url: `/pages/camera/camera?type=${type}`,
			});
		},
		inputSearch() {
			associateWordReq(params).then(res => {
				this.searchList = res.data.wordList
			})
		},
		scrolltolower() {
			console.log('加载更多！！')
			// this.loadmore()
		},
		clear() {
			this.historyList = [];
			uni.setStorageSync("CircleHistoryList", this.historyList);
		},
	},
};
</script>

<style lang="scss" scoped>

.content {
	position: relative;
	.u-page {
		position: absolute;
		width: 100%;
		z-index: 10;
		background-color: #ffffff;
	}
	.tips {
		position: relative;
		margin: 40rpx 30rpx 30rpx;
		// width: 100%;
		padding: 20rpx;
		background: rgba(15, 200, 172, 0.1);
		border-radius: 8rpx;
		border: 2rpx solid #0fc8ac;
		font-size: 28rpx;
		font-family: PingFangSC-Regular, PingFang SC;
		font-weight: 400;
		color: #666666;
		line-height: 40rpx;

		/deep/ .u-icon {
			position: absolute;
			z-index: 2;
			right: -20rpx;
			top: -20rpx;
			width: 38rpx;
			height: 38rpx;
			background-color: #fff;
			border-radius: 100%;
		}
	}

	.part {
		margin: 30rpx;

		.tit {
			display: flex;
			justify-content: space-between;
			margin-bottom: 20rpx;

			.blod {
				font-size: 32rpx;
				font-family: PingFangSC-Semibold, PingFang SC;
				font-weight: 600;
				color: #333333;
				line-height: 44rpx;
			}

			font {
				font-size: 28rpx;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #999999;
				line-height: 40rpx;
			}
		}

		.list {
			display: flex;
			flex-wrap: wrap;

			.item {
				background: #f6f7f8;
				border-radius: 28rpx;
				line-height: 56rpx;
				padding: 0 30rpx;
				font-size: 24rpx;
				font-family: PingFangSC-Regular, PingFang SC;
				font-weight: 400;
				color: #666666;
				margin-right: 30rpx;
				margin-bottom: 20rpx;
			}

			.itemWrap {
				margin-bottom: 40rpx;
				width: 50%;
				display: flex;
				align-items: center;

				.item {
					margin-bottom: 0 !important;
				}

				.icon {
					margin-right: 20rpx;
					width: 40rpx;
					text-align: center;
					line-height: 40rpx;
					border-radius: 100%;
					height: 40rpx;
					background: #fc511e;
					color: #fff;
					font-size: 28rpx;
				}

				.icon:nth-child(1) {
					background: #fc511e;
				}

				.icon:nth-child(2) {
					background: #ff9330;
				}
			}

			.itemWrap:nth-child(4n + 1) {
				.icon {
					background: #fc511e;
				}
			}

			.itemWrap:nth-child(4n + 2) {
				.icon {
					background: #ff9330;
				}
			}

			.itemWrap:nth-child(4n + 3) {
				.icon {
					background: #fdd986;
				}
			}

			.itemWrap:nth-child(4n + 4) {
				.icon {
					background: #999999;
				}
			}
		}
	}
}
</style>
