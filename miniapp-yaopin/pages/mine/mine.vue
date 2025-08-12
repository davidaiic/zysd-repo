<template>
	<view class="mainWrap">
		<view class="contents">
		    <u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=" ">
		        <view class="u-nav-slot" slot="left">识药查真伪</view>
		    </u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight + 'px' }">
			<view class="content_avatar">
				<view class="content_avatar_icon">
					<view class="avatar_icon_inner">
						<u-image v-if="userInfo" :src="userInfo.avatar" width="60rpx" height="60rpx"></u-image>
						<u-image v-else :src="$utils.getImgUrl('myAvator.png')" width="60rpx" height="60rpx"></u-image>
					</view>
				</view>
				<view class="content_avatar_name">
					<u--text v-if="userInfo" color="#ffffff" :text="userInfo.username"></u--text>
					<view v-else @click="goNoLogin">欢迎登录</view>
					<!--   -->
				</view>
			</view>
			<view class="content_avatar_tragle"></view>
			<view class="content_tragle"></view>
			<view class="content_mine">
				<view class="content_mine_items" v-for="(t, i) in myEnity" :key="i" @click="routeTo(t)">
					<view :class="['mine_items_left', t.styleClass]">
						<u-image :src="$utils.getImgUrl(t.leftIcon)" width="60rpx" height="60rpx"></u-image>
					</view>
					<view class="mine_items_name">
						{{ t.name }}
					</view>
					<view class="mine_items_link">
						<u-image :src="$utils.getImgUrl('arrow.png')" width="32rpx" height="32rpx"></u-image>
					</view>
				</view>
				
				<!-- <view class="content_mine_items" @click="loginOut()">
					
					<view class="mine_items_name">
					退出登录
					</view>
				</view> -->
			</view>
		</view>

		<!-- 联系我们弹框 -->
		<view class="popView">
			<u-popup :show="show" mode="center" :round="10" style="width:70%" @close="close">
				<view class="tit">联系我们</view>
				<view class="flexView">
					<view class="item">
						<u-image :src="$utils.getImgUrl('wx.png')" width="100rpx" height="100rpx"></u-image>
						<view class="bold">微信</view>
					</view>
					<view class="item">
						<u-image :src="$utils.getImgUrl('mobile.png')" width="100rpx" height="100rpx"></u-image>
						<view class="bold">电话</view>
					</view>
					<view class="item san">
						<u-image :src="$utils.getImgUrl('码.png')" width="28px" height="28px"></u-image>
						<view class="bold">扫码</view>
					</view>
				</view>
			</u-popup>
		</view>
	</view>
</template>

<script>
import {shareInfoReq} from '@/api/user.js'

import {mapGetters} from "vuex";
export default {
	computed: mapGetters(['isLogin', 'userInfo']),
	data() {
		return {
			show: false,
			myEnity: [{
				leftIcon: 'lscx.png',
				name: '查询历史',
				routePath: '/pages/lscx/lscx',
				styleClass: 'background_lscx',
				need_login:true
			}, {
				leftIcon: 'fankui.png',
				name: '意见反馈',
				routePath: '/pages/yjfk/yjfk',
				styleClass: '.background_yjfk'
			}, {
				leftIcon: 'lxwm.png',
				name: '联系我们',
				routePath: '/pages/ptlxwm/ptlxwm',
				styleClass: 'background_lxwm'
			}, {
				leftIcon: 'fenxiangma.png',
				name: '分享码',
				routePath: '/pages/mine/noEwm',
				routePath2: '/pages/mine/ewm',
				styleClass: 'background_ewm'
			}, {
				leftIcon: 'yhxy.png',
				name: '用户协议',
				routePath: '/pages/mine/yhxy',
				styleClass: 'background_yhxy'
			}],
			formData: {
				username: '',
				avatar: '',
				mobile: ''
			}
		}
	},
	onLoad() {
	},
	methods: {
		loginOut(){
			this.$store.dispatch('LOGOUT').then(res=>{
				uni.showToast({
					title: '退出登录',
					duration: 1500,
					complete:()=>{
						setTimeout(function () {
							uni.switchTab({
								url:'/pages/index/index'
							})
						}, 1500);
					}
				});
			})
		},
		goNoLogin() {
			uni.navigateTo({
				url: '/pages/login/noLogin'
			})
		},
		// 页面路由跳转
		routeTo(val) {
			if(val.need_login){
				this.$utils.goOthersCheckLogin(val.routePath);
				return
			}
			if (val.name === '分享码') {
				shareInfoReq().then(res => {
					if (res.data && res.data.info && res.data.info.wx) {
						uni.navigateTo({
							url: val.routePath2
						})
					} else {
						uni.navigateTo({
							url: val.routePath
						})
					}
				})
			} else {
				uni.navigateTo({
					url: val.routePath
				})
			}
			// if (val.name === '联系我们') {
			// 	this.show=true
			// } else {
			// 	uni.navigateTo({
			// 		url: val.routePath
			// 	})
			// }
		},
		close() {
			this.show = false
		}
	}
}
</script>

<style lang="scss" scoped>
.content {
	background-color: #f8f8f8;
	margin-top: 0;

	.content_avatar {
		display: flex;
		background-color: #0AD0B2;
		align-items: center;

		.content_avatar_icon {
			margin: 30rpx;
			background-color: #0dcaad;
			width: 108rpx;
			height: 108rpx;
			border-radius: 100%;
			display: flex;
			align-items: center;
			justify-content: center;

			.avatar_icon_inner {
				background-color: #ffffff;
				width: 96rpx;
				height: 96rpx;
				border-radius: 100%;
				display: flex;
				align-items: center;
				justify-content: center;
			}
		}

		.content_avatar_name {
			font-size: 32rpx;
			color: #ffffff;
			font-weight: 600;

			/deep/ .u-button {
				font-size: 32rpx;
				font-weight: 600;
			}
		}
	}

	.content_avatar_tragle {
		height: 30rpx;
		background-color: #0dcaad;
	}

	.content_tragle {
		margin-top: -30rpx;
		height: 30rpx;
		background-color: #f8f8f8;
		border-radius: 40rpx 40rpx 0 0;
	}

	.content_mine {
		margin: 30rpx;
		.content_mine_items {
			background-color: #ffffff;
			display: flex;
			align-items: center;
			height: 140rpx;
			border-radius: 16rpx;
			margin-bottom: 20rpx;
			padding: 0 30rpx;

			.mine_items_left {
				display: flex;
				align-items: center;
				justify-content: center;
				margin-right:30rpx;
				width: 80rpx;
				height: 80rpx;
				border-radius: 16rpx;
			}

			.mine_items_name {
				flex: 1;
			}
		}
	}
}

.background_lscx {
	background: linear-gradient(90deg, #5BAEFB 0%, #4299EE 100%)
}

.background_yjfk {
	background: linear-gradient(90deg, #0AD0B2 0%, #0FC7AB 100%)
}

.background_lxwm {
	background: linear-gradient(90deg, #FF9F17 0%, #FFB44B 100%)
}

.background_ewm {
	background: linear-gradient(90deg, #727FFF 0%, #96A0FF 100%)
}

.background_yhxy {
	background: linear-gradient(90deg, #FF7D9B 0%, #FF527B 100%)
}

.popView {
	.tit {
		font-size: 16px;
		font-weight: 600;
		color: #333333;
		line-height: 22px;
		padding: 30px 0 0;
		text-align: center;
	}

	.flexView {
		display: flex;
		justify-content: space-around;
		padding: 20px;
		width: 320px;

		.item {
			display: flex;
			flex-direction: column;
			justify-content: center;
			align-items: center;
			margin: 34px auto;

			.bold {
				font-size: 14px;
				font-weight: 400;
				color: #333333;
				line-height: 20px;
				margin-top: 10px;
			}
		}

		.san {
			/deep/ .u-image {
				width: 50px !important;
				height: 50px !important;
				border-radius: 100% !important;
				background-color: rgba(15, 200, 172, 0.15) !important;
				display: flex;
				justify-content: center;
				align-items: center;
			}
		}
	}
}</style>
