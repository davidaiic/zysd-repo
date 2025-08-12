<!-- 用户管理页面 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" @leftClick="leftClick" :fixed="false" :titleStyle="{ color: '#FFF', fontSize: '18px' }">
				<view slot="center">
					<view class="tab">
						<view class="tabs" @click="goEwm()">分享码</view>
						<view class="tabs seled">用户管理</view>
					</view>
				</view>
			</u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight  + 'px' }">
			<view class="listWrap" v-if="list.length > 0">
				<scroll-view @scrolltolower="loadMore">
					<view class="listItem" v-for="(item, index) in list" :key="index">
						<view class="userInfo">
							<u-image :src="item.avatar" width="70rpx" height="70rpx">
							</u-image>
							<view class="userDes">
								<view class="p weight">{{ item.username }}</view>
								<view class="grey">{{ item.created }}</view>
								<view class="p copy">
									<view>手机号：{{ item.mobile }}</view>
									<u-button @click="copyMobile(item.mobile)">复制</u-button>
								</view>
							</view>
						</view>
						<view class="recordList"  :class="item.is_hide_more ? '':'small'">
							<view class="recordListItem" v-for="(items, ids) in item.queryList" :key="ids">
								<view class="recordTit">
									<view class="titTxt">
										<font></font>查询记录
									</view>
									<view :class="['tips', `type${items.type}`]">{{ getTransType(items.type) }}</view>
								</view>
								<view class="recordDes">
									<view class="p">
										<view class="lab">药品名：</view>
										<view class="span">{{ items.goodsName }}</view>
									</view>
									<view class="p">
										<view class="lab">厂家：</view>
										<view class="span">{{ items.companyName }}</view>
									</view>
									<view class="p">
										<view class="lab">查询时间：</view>
										<view class="span">{{ items.created }}</view>
									</view>
								</view>
							</view>
						</view>
						
						<view class="more"   :class="item.is_hide_more ? '':'small'" @click="showMore(index)">
							{{item.is_hide_more ?'收起':'展开'}}
							<u-icon name="arrow-left-double" color="#0FC8AC"></u-icon>
						</view>
					</view>
				</scroll-view>
			</view>

			<!-- 无数据 -->
			<u-empty v-else text="暂无邀请成功用户" :icon="$utils.getImgUrl('无用户.png')" width="320rpx" height="280rpx"
				:margin-top="120">
			</u-empty>
			<view class="bottom-fill"></view>
		</scroll-view>
		<view class="bottomBtn">
			<u-button class="submit" @click="join()">立即邀请用户</u-button>
		</view>
	</view>
</template>

<script>
import {userListReq} from '@/api/user.js'
export default {
	data() {
		return {
			list: [],
			share: {
				title: '',
				path: '',
				imageUrl: ''
			},
			page: 1
		}
	},
	onLoad() {
		this.getUserList()
	},
	
	onShow() {
		// #ifdef H5
		document.title = '分享码'
		//#endif
	},
	methods: {
		showMore(index){
			let this_data = this.list[index]
			this.$set(this.list[index],'is_hide_more', !this_data.is_hide_more)
		},
		goEwm() {
			uni.navigateTo({
				url: '/pages/mine/ewm'
			})
		},

		// 立即加入页面的跳转引导
		join() {
			uni.navigateTo({
				url: '/pages/mine/ewm'
			})
		},
		getUserList() {
			uni.showLoading({
				title:'数据加载中...'
			})
			let params = {
				page: this.page
			}
			userListReq(params).then(res => {
				this.list = res.data.userList
				this.$nextTick(()=>{
					uni.hideLoading()
				})
			})
		},
		loadMore() {
			this.page++
			this.getUserList()
		},
		getTransType(type) {
			let pList = [{
				type: 1,
				name: '人工核查'
			},
			{
				type: 2,
				name: '自助查询'
			},
			{
				type: 3,
				name: '价格查询'
			}
			]
			let p = pList.find(item => item.type == type)
			return p ? p.name : ''
		},
		copyMobile(data) {
			let that = this
			uni.setClipboardData({
				data: data,
				success() {
					uni.showToast({
						icon: 'none',
						title: '复制成功'
					})
				},
				fail() {
					uni.showToast({
						icon: 'none',
						title: '复制失败'
					})
				}
			})
		}
	}
}
</script>

<style lang="scss" scoped>
.mainWrap {
	background-color: #f8f8f8;
	height: 100vh;

	.tab {
		margin-left: 80rpx;
		display: flex;
		color: #fff;
		align-items: center;

		.tabs {
			margin-right: 20rpx;
			font-size: 28rpx;
		}

		.seled {
			font-size: 36rpx;
			font-weight: 500;
		}
	}
}

.content {
	padding: 40rpx 30rpx 30rpx;
	
	box-sizing: border-box;
	.bottom-fill{
		height: 168rpx;
	}
	.listWrap {
		.listItem {
			background-color: #fff;
			border-radius: 16rpx;
			margin-bottom: 20rpx;
			padding: 20rpx;

			.userInfo {
				display: flex;
				border-bottom: 2rpx solid #F2F3F5;
				padding-bottom: 40rpx;

				.userDes {
					margin-left: 30rpx;
					flex: 1;

					.p {
						color: #262626;
						font-size: 28rpx;
					}

					.weight {
						font-weight: 600;
					}

					.grey {
						color: #8C8C8C;
						font-size: 22rpx;
						margin: 10rpx 0 16rpx;
					}

					.copy {
						display: flex;
						align-items: center;

						/deep/ .u-button {
							width: 100rpx;
							height: 48rpx;
							background: #0FC8AC;
							border-radius: 8rpx;
							color: #fff;
							font-size: 24rpx;
						}
					}
				}
			}

			.recordList {
				.recordListItem {
					border-bottom: 2rpx dashed #F2F3F5;
					padding: 20rpx 0;
					margin-bottom: 20rpx;

					.recordTit {
						margin-bottom: 20rpx;
						display: flex;
						align-items: center;
						justify-content: space-between;
						font-size: 28rpx;
						font-weight: 600;
						color: #333333;

						.titTxt {
							display: flex;
							align-items: center;

							font {
								width: 4rpx;
								height: 28rpx;
								background: #0FC8AC;
								border-radius: 4rpx;
								margin-right: 20rpx;
							}
						}

						.tips {
							width: 120rpx;
							height: 48rpx;
							border-radius: 8rpx;
							font-size: 24rpx;
							font-weight: 400;
							line-height: 48rpx;
							text-align: center;
						}

						.type1 {
							background: rgba(69, 155, 240, 0.1);
							color: #459BF0;
						}

						.type2 {
							background: rgba(15, 200, 172, 0.1);
							color: #0FC8AC;
						}

						.type3 {
							background: rgba(255, 147, 48, 0.1);
							color: #FF9330;
						}
					}

					.recordDes {
						.p {
							font-size: 28rpx;
							font-weight: 400;
							line-height: 50rpx;
							display: flex;

							.lab {
								width: 160rpx;
								color: #999999;
							}

							.span {
								color: #333333;
							}
						}
					}

					&:last-child {
						border-bottom: 0;
					}
				}
				&.small{
					height: 300rpx;
					overflow: hidden;
				}
			}
			
			.more {
				color: #0FC8AC;
				font-size: 28rpx;
				display: flex;
				justify-content: center;
			
				/deep/ .u-icon {
					transform: rotate(90deg);
				}
				&.small{
					/deep/ .u-icon {
						transform: rotate(-90deg);
					}
				}
			}
		}
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
