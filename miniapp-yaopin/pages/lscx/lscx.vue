<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="查询历史" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content"  @scrolltolower="loadMore" :style="{ height: scrollViewheight + 'px' }">
			<view class="lscx_items" v-if="list.length > 0">
				<u-gap height="20rpx" bgColor="#F8F8F8"></u-gap>
				<view class="lscx_items" v-for="(item, index) in list" :key="index">
					<view class="lscx_items_top">
						<view class="lscx_items_top_icon">
							<u-image :src="item.avatar" width="70rpx" height="70rpx">
							</u-image>
						</view>
						<view class="lscx_items_top_name">
							<view class="lscx_inner">
								<view class="lscx_inner_name">
									{{ item.username }}
								</view>
								<view class="lscx_inner_icon">
									{{ getTransType(item.type) }}
								</view>
							</view>
							<view class="lscx_time">
								{{ item.created }}
							</view>
						</view>
					</view>
					<view class="lscx_items_buttom">
						<view class="lscx_items_buttom_top">
							<view class="lscx_top_left">
								药品名：
							</view>
							<view class="lscx_top_right">
								{{ item.goodsName }}
							</view>
						</view>
						<view class="lscx_items_buttom_top">
							<view class="lscx_top_left">
								厂家：
							</view>
							<view class="lscx_top_right">
								{{ item.companyName }}
							</view>
						</view>
					</view>
					<u-gap height="20rpx" bgColor="#F8F8F8"></u-gap>
				</view>
			</view>
			<u-empty v-if="isShowNoData" mode="data"></u-empty>
		</scroll-view>
	</view>
</template>

<script>
import { queryLogReq} from '@/api/user.js'
export default {
	data() {
		return {
			list: [],
			page: 1,
			isShowNoData: false
		}
	},
	onLoad() {
		// this.getlscx()
	},
	
	onShow() {
		this.getlscx()
		// #ifdef H5
		document.title = '查询历史'
		//#endif
	},
	methods: {
		getlscx() {
			let params = {
				page: this.page
			}
			queryLogReq(params).then(res => {
				let res_data = res.data.queryList
				if(res_data.length){
					this.list = this.page > 1 ? this.list.concat(res_data) : res_data
				}else{
					this.load_end = true
					// 
					this.moreStatus = 'nomore'
				}
				if (this.list.length < 0) {
					this.isShowNoData = true
				} else {
					this.isShowNoData = false
				}
			})
		},
		loadMore() {
			this.page++
			this.getlscx()
		},
		getTransType(type) {
			let pList = [{
				type: 1,
				name: '人工核查'
			},
			{
				type: 2,
				name: '防伪查询'
			},
			{
				type: 3,
				name: '价格查询'
			}
			]
			let p = pList.find(item => item.type == type)
			return p ? p.name : ''
		}
	}
}
</script>

<style lang="scss" scoped>
.lscx_items {
	// margin: 0 30rpx 20rpx 30rpx;
	background-color: #ffffff;
	border-radius: 16rpx;

	.lscx_items_top {
		display: flex;
		flex-direction: row;
		padding: 20rpx 0;

		.lscx_items_top_icon {
			width: 120rpx;
			display: flex;
			justify-content: center;
		}

		.lscx_items_top_name {
			flex: 1;

			.lscx_inner {
				display: flex;
				justify-content: space-between;

				.lscx_inner_name {
					color: #333333;
					font-size: 24rpx;
				}

				.lscx_inner_icon {
					margin-right: 20rpx;
					font-size: 24rpx;
					font-weight: 400;
					color: #459BF0;
				}
			}

			.lscx_time {
				font-size: 22rpx;
				font-weight: 400;
				color: #8C8C8C;
				line-height: 32rpx;
			}
		}
	}

	.lscx_items_buttom {
		border-width: 2rpx 0 0 0;
		border-style: solid;
		border-color: #f8f8f8;
		padding-bottom: 20rpx;

		.lscx_items_buttom_top {
			margin-top: 10rpx;
			display: flex;

			.lscx_top_left {
				margin-left: 20rpx;
				font-size: 28rpx;
				font-weight: 400;
				color: #999999;
				width: 120rpx;
				text-align-last: justify;
			}

			.lscx_top_right {
				font-size: 28rpx;
				font-weight: 400;
				color: #333333;
			}
		}
	}
}
</style>
