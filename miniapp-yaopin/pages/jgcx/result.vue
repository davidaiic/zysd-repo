<!-- 价格查询--查询结果页 -->
<template>
	<view>
		<!--  class="mainWrap" -->
		<view class="contents">
			<u-navbar v-if="!isH5" title="价格查询" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
		</view>
		<scroll-view scroll-y class="content-box" :style="{ height: scrollViewheight + 'px' }">
			<view class="content"  v-if="formData.goodsId">
				<view class="part">
					<view class="des">
						<u-image :src="formData.goodsImage" width="100%" height="376rpx"></u-image>
					</view>
				</view>
				<view class="part">
					<!-- <view class="h1">{{ formData.goodsName }} {{ formData.enName }} </view> -->
					<view class="des">
						<view class="item" v-if="formData.goodsName">
							<view class="txt">药品中文名称：{{ formData.goodsName }}</view>
						</view>
						<view class="item" v-if="formData.enName">
							<view class="txt">药品英文名：{{ formData.enName }}</view>
						</view>
						<view class="item" v-if="formData.commonName">
							<view class="txt">商品名：{{ formData.commonName }}</view>
						</view>
						<view class="item" v-if="formData.otherName">
							<view class="txt">其他名称：{{ formData.otherName }}</view>
						</view>
						<view class="item" v-if="formData.specs">
							<view class="txt">规格：{{ formData.specs }}</view>
						</view>
						<view class="item" v-if="formData.companyName">
							<view class="txt">药厂名称：{{ formData.companyName }}</view>
						</view>
						<view class="item" v-if="formData.minPrice!= '0.00' || formData.maxPrice!= '0.00'">
							<view class="txt">
								单价(元/盒)：
								<text class="red" v-if="formData.minPrice != '0.00'">
									¥{{ formData.minPrice }}
								</text>
								<text class="red" v-if="formData.minPrice != '0.00' && formData.maxPrice != '0.00'">
									~
								</text>
								<text class="red" v-if="formData.maxPrice != '0.00'">
									￥{{ formData.maxPrice }}
								</text>
							</view>
						</view>
						<view class="item" v-if="formData.minCostPrice!= '0.00' || formData.maxCostPrice!= '0.00'">
							<view class="txt">
								月花费：
								<text class="red" v-if="formData.minCostPrice != '0.00'">
									¥{{ formData.minCostPrice }}
								</text>
								<text class="red"
									v-if="formData.minCostPrice != '0.00' && formData.maxCostPrice != '0.00'">
									~
								</text>
								<text class="red" v-if="formData.maxCostPrice != '0.00'">
									￥{{ formData.maxCostPrice }}
								</text>
							</view>
						</view>
						<view class="item tips">
							<view class="txt">
								<p>
									您输入的价格：
									<font class="compareText">{{ formData.compareText }}</font>
								</p>
								<p>请注意辨别药品真伪</p>
							</view>
							<view class="btn" @click="queryPrice()">立即查询</view>
						</view>
					</view>
				</view>
				<view class="part" v-if="formData.priceTrend.priceList">
					<view class="h1">近6个月价格趋势图</view>
					<view class="charts-box">
						<qiun-data-charts type="line" :chartData="chartData" />
					</view>
				</view>
				<view class="part detail">
					<view class="h1">药品详情</view>
					<view class="des">
						<view class="item" v-if="formData.composition">
							<view class="lab">主要成份：</view>
							<view class="txt">
								<u-parse :content="formData.composition"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.character">
							<view class="lab">性状：</view>
							<view class="txt">
								<u-parse :content="formData.character"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.indication">
							<view class="lab">适应症：</view>
							<view class="txt">
								<u-parse :content="formData.indication"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.usageDosage">
							<view class="lab">用法用量：</view>
							<view class="txt">
								<u-parse :content="formData.usageDosage"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.reaction">
							<view class="lab">不良反应：</view>
							<view class="txt">
								<u-parse :content="formData.reaction"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.taboo">
							<view class="lab">禁忌：</view>
							<view class="txt">
								<u-parse :content="formData.taboo"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.attention">
							<view class="lab">注意事项：</view>
							<view class="txt">
								<u-parse :content="formData.attention"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.womanDosage">
							<view class="lab">孕妇用药：</view>
							<view class="txt">
								<u-parse :content="formData.womanDosage"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.elderlyDosage">
							<view class="lab">老年患者用药：</view>
							<view class="txt">
								<u-parse :content="formData.elderlyDosage"></u-parse>
							</view>
						</view>
						<view class="item" v-if="formData.unit">
							<view class="lab">包装单位：</view>
							<view class="txt">{{ formData.unit }}</view>
						</view>
						<view class="item" v-if="formData.storage">
							<view class="lab">贮藏</view>
							<view class="txt">{{ formData.storage }}</view>
						</view>
						<view class="item" v-if="formData.period">
							<view class="lab">有效期：</view>
							<view class="txt">{{ formData.period }}</view>
						</view>
						<view class="item" v-if="formData.number">
							<view class="lab">批准文号：</view>
							<view class="txt">{{ formData.number }}</view>
						</view>
					</view>
					<view class="bottom-fill"></view>
				</view>
			</view>

			<!-- 无结果 -->
			<view class="part" v-if="isShowNoPrice">
				<u-empty :text="showText" :icon="$utils.getImgUrl('noPriceInfo.png')" width="320rpx" height="280rpx"
					:margin-top="120"></u-empty>
			</view>
			<!-- 查询次数 -->
		</scroll-view>

		<view class="bottomBtn" id="bottom_box_end">
			<view class="content">
				<view class="part">
					<view class="des" style="margin-top:10rpx">
						<view class="item">
							<view class="txt center">
								你是今天第{{ rank || 0 }}位查询用户，已有{{
									total || 0
								}}位用户查询过
							</view>
						</view>
					</view>
				</view>
			</view>
			<u-button class="submit" @click="lxwm()">想要了解更多信息联系我们</u-button>
		</view>
	</view>
</template>

<script>
	import {
		bridgrCall
	} from '@/utils/bridge';
	import {
		priceSearchReq
	} from '@/api/goodsApi.js'
	export default {
		data() {
			return {
				formData: {
					goodsId: '',
					goodsName: '',
					goodsImage: '',
					minPrice: '',
					maxPrice: '',
					minCostPrice: '',
					maxCostPrice: '',
					compareText: '',
					priceTrend: {},
					specs: '',
					fullName: '',
					usageDosage: '',
					indication: ''
				},
				isShowNoPrice: false,
				rank: 0,
				total: 0,
				showText: '',
				optionData: {
					goodsName: ''
				},
				bottom_box_height: 800,
				chartData: {}
			};
		},
		onLoad: function(option) {
			let that = this;
			uni.createSelectorQuery().select('#bottom_box_end').boundingClientRect(function(rect) {
				console.log(rect)
				that.bottom_box_height = that.scrollViewheight - rect.height
			}).exec()
			if (option) {
				let params = Object.assign({}, option);
				priceSearchReq(params).then(resp => {
					let goodsInfo = resp.data.goodsInfo;
					goodsInfo.companyId = params.companyId
					that.formData = goodsInfo

					that.rank = resp.data.rank;
					that.total = resp.data.total;
					that.isShowNoPrice = !that.formData.goodsId;
					console.log('12')
					if (that.isShowNoPrice) {
						that.showText = `当前药品暂无价格信息`;
						return
					}
					console.log('34')
					that.getServerData(resp.data.goodsInfo);
				});
			}
		},
		onShow() {
			// #ifdef H5
			document.title = '价格查询'
			//#endif
		},
		methods: {
			getServerData(val) {
				console.log(val.priceTrend)
				let that = this;
				if (val.priceTrend.priceList.length > 0) {
					// && val.priceTrend.priceList.length > 0
					that.chartData = {
						categories: val.priceTrend.dateList,
						series: [{
							name: '价格',
							data: val.priceTrend.priceList
						}]
					};
				}
			},
			queryPrice() {
				//立即查询
				let info = this.formData
				let link = info.linkUrl
				let go_url = link.slice(link.indexOf('/')).split('?')[0] + '?goodsId=' + info.goodsId +
					'&companyId=' + info.companyId +
					'&company=' + info.companyName +
					'&goodsName=' + info.goodsName +
					'&specs=' + info.specs
				uni.navigateTo({
					url: go_url
					// url: '/pages/result/gwwfw?goodsId='+this.formData.goodsId
				});
			},
			lxwm() {
				uni.navigateTo({
					url: '/pages/lxwm/lxwm'
				});
			}
		}
	};
</script>

<style lang="scss" scoped>
	.mainWrap {
		background-color: #f8f8f8;

		// height: calc(100vh - 168rpx);
		// padding-bottom: 168rpx;
		// overflow-y: auto;
		.ee {
			// overflow-y: auto;
		}
	}

	.content-box {
		background: #f8f8f8;
		.content {
		}
	}

	.charts-box {
		margin: 20px 0 0 0;
		width: 100%;
		height: 170px;
		position: relative;
	}

	.content {
		.part {
			background: #fff;
			margin-bottom: 20rpx;
			padding: 30rpx;

			.h1 {
				height: 44rpx;
				font-size: 32rpx;
				font-family: PingFangSC-Semibold, PingFang SC;
				font-weight: 600;
				color: #333333;
				line-height: 44rpx;
			}

			.des {
				font-size: 28rpx;

				.item {
					margin-bottom: 16rpx;
					display: flex;

					.lab {
						// width: 160rpx;
						color: #999;
						line-height: 40rpx;
					}

					.red {
						font-weight: 600;
						color: #fc511e;
						line-height: 44rpx;
					}

					.txt {
						flex: 1;
						color: #333333;
						line-height: 40rpx;

						.compareText {
							font-size: 18px;
							font-weight: 600;
						}
					}
				}

				.tips {
					justify-content: space-between;
					align-items: center;
					background: rgba(255, 147, 48, 0.1);
					border-radius: 8rpx;
					padding: 20rpx;

					.txt {
						font-size: 28rpx;
						font-weight: 400;
						color: #e98122;
						line-height: 40rpx;

						font {
							color: #fc511e;
						}
					}

					/deep/ .btn {
						width: 180rpx;
						height: 64rpx;
						background: #ff9330;
						border-radius: 32rpx;
						color: #fff;
						font-size: 28rpx;
						line-height: 64rpx;
						text-align: center;
					}
				}

				/deep/ .u-image {
					margin-bottom: 20rpx;
				}
			}

			.dd {
				.item:last-child {
					margin-bottom: 0;
				}
			}
		}

		.detail {
			.item {
				margin-bottom: 30rpx !important;
				display: flex;
				flex-direction: column;

				.lab {
					width: 100% !important;
					font-weight: bold;
					color: #333333 !important;
					line-height: 40rpx;
				}

				.txt {
					color: #333333 !important;
					line-height: 48rpx !important;
				}
			}
		}
	}

	.bottom-fill {
		height: 234rpx;
	}

	.bottomBtn {
		width: 100%;
		box-sizing: border-box;
		height: 234rpx;
		box-shadow: 0rpx -2rpx 12rpx 0rpx rgba(157, 157, 157, 0.19);
		position: fixed;
		z-index: 1000;
		left: 0;
		bottom: 0;
		background-color: #fff;
		padding: 0 28rpx 40rpx;

		.part {
			padding: 10px 0;
			margin: 0;
		}

		.submit {
			height: 88rpx;
			background: #0fc8ac;
			border-radius: 44rpx;
			color: #fff;
			font-size: 32rpx;
			font-weight: 600;
		}

		/deep/ .u-button {
			width: calc(100% - 56rpx);
			height: 88rpx;
			background: #0fc8ac;
			border-radius: 44rpx;
			color: #fff;
			font-size: 32rpx;
			font-weight: 600;
		}
	}

	.center {
		text-align: center;
	}
</style>