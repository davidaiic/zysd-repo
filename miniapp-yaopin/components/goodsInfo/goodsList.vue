<template>
	<view class='goodList'>
		<block  v-for="(its, ids) in lists" :key="ids">
			<view class="item" @click.stop="goDetail(ids)">
				<view class="img-box">
					<img :src="its.goodsImage" class="img"/>
				</view>
				<view class="item_title line1">{{ its.goodsName }} </view>
				<view class="item_name line2">{{ its.companyName }}</view>
				<view>
					<view v-if="its.marketTag" class="items_icon">{{ its.marketTag }}</view>
					<view v-if="its.medicalTag" class="items_icon">{{ its.medicalTag }}</view>
					<view v-if="its.clinicalStage" class="items_icon">{{ its.clinicalStage }}</view>
				</view>
				<view v-if="contrastPrice == 2">
					<view class="item_num" style="color: red"  v-if="!showMaxPrice">价格：
						<text>￥{{ its.minPrice }}</text>
					</view>
					<view class="item_num" style="color: red" v-else>
						价格：
						<text class="red" v-if="its.minPrice != '0.00'">
							¥{{ its.minPrice }}
						</text>
						<text class="red" v-if="its.minPrice != '0.00' && its.maxPrice != '0.00'">
							~
						</text>
						<text class="red" v-if="its.maxPrice != '0.00'">
							￥{{ its.maxPrice }}
						</text>
					</view>
					<view class="item_num" style="margin-bottom: 12rpx;">所在地区： {{ its.marketPlace }}</view>
				</view>
				<view v-else>
					<view class="item_num" >{{ its.searchNum || 0 }}人查询过</view>
				</view>
				
				<view v-if="its.drugProperties" class="left_icon"
					:style="{ backgroundColor: its.drugPropertiesColor }">
					{{ its.drugProperties }}</view>
				<view class="warning_icon" v-if="its.risk == 1">
					<u-image :src="$utils.getImgUrl('warning.png')" width="180rpx" height="224rpx"></u-image>
				</view>
			</view>
		</block>
	</view>
</template>

<script>
export default {
	props: {
		contrastPrice:{
			type:Number,
			default:1//是否比价，1 否，2是
		},
		lists: {
			type: Array,
			default: function() {
				return [];
			}
		},
		showMaxPrice:{
			type: Number,
			default: 0
		},
		
	},
	data() {
		return {
		};
	},
	methods: {
		// 跳转到药厂查询页面
		goDetail(index) {
			let item = this.lists[index]
			// console.log(item)
			let url = (item.risk == 1 ? '/pages/result/smRisk':'/pages/result/smNoRisk')
				+`?companyId=${item.companyId}&goodsId=${item.goodsId}`
				console.log(url)
			this.$utils.goOthersCheckLogin(url)
		}
	}
}
</script>

<style scoped lang="scss">
	.goodList{
		width: 690rpx;
		display: flex;
		flex-wrap: wrap;
	}
	.item {
		width: 46%;
		margin: 20rpx 2%;
		box-sizing: border-box;
		display: flex;
		flex-direction: column;
		border: 2rpx solid #E0E0E0;
		border-radius: 8rpx;
		position: relative;
		.img-box{
			height: 220rpx;
			overflow: hidden;
			.img{
				width: 100%;
				height: 100%;
				display: block;
			}
		}
		.item_title {
			margin: 10rpx 20rpx 0;
			font-size: 28rpx;
			font-weight: 600;
			color: #333333;
			line-height: 40rpx;
		}

		.item_name {
			margin: 10rpx 20rpx 0;
			font-size: 24rpx;
			height: 68rpx;
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
</style>
