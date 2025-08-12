<!--自助查询-->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="药厂查询" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px', fontWeight: '500' }"></u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<view class="hot_sell" v-if="searchList.length > 0">
				<!-- 标题 -->
				<view class="hot_content">
					<view class="hot_content_items" v-for="(its, ids) in searchList" @click="goToYccx(its)">
						<u-image :src="its.companyImage" width="100%" height="200rpx"></u-image>
						<view class="item_title">{{ its.companyName }}</view>
					</view>
				</view>
			</view>
			<view class="hot_sell" v-if="isShowData">
				<u-empty mode="data"></u-empty>
			</view>
		</view>
	</view>
</template>

<script>
export default {
	data() {
		return {
			searchList: [],
			page: 1,
			keyword: '',
			from: '',
			isShowData: false
		}
	},
	onLoad(option) {
		this.getHeight()
		this.loadCompanySearch()
	},
	methods: {
		// 跳转到药厂查询页面
		goToYccx(item) {
			if (item.companyId === 0) {
				this.goToQtcj()
			} else {
				uni.navigateTo({
					url: `/pages/zzcx/yccx?companyId=${item.companyId}`
				})
			}
		},
		// 点击其他厂家
		goToQtcj() {
			uni.navigateTo({
				url: '/pages/rghc/index'
			})
		},
		loadCompanySearch() {
			let params = {
				type: 1
			}
			this.$store.dispatch('jgcx/getQueryCompanyList', params).then(res => {
				this.searchList = res.data.companyList
				if (this.searchList.length < 1) {
					this.isShowData = true
				} else {
					this.isShowData = false
				}
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;
}

.hot_sell {
	// margin: 30rpx;

	.port_title {
		margin-bottom: 20rpx;
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

		.hot_content_items {
			width: 46%;
			margin: 0 10rpx 20rpx;
			display: flex;
			flex-direction: column;
			border: 2rpx solid #E0E0E0;
			border-radius: 8rpx;

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
		}
	}

}
</style>
