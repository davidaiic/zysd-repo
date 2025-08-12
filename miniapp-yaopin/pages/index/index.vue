<template>
	<view class="mainWrap">
		<!-- navbar -->
		<view class="contents">
			<u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=" "><view class="u-nav-slot" slot="center">识药查真伪</view></u-navbar>
		</view>
		<!-- 搜索 -->
		<view class="content_search" :style="{top:topHight+'px'}">
			<view class="content_search_back">
				<view class="serView">
					<view @click="showScan('sys')"><u-image src="/static/sys_icon@2x.png" width="36rpx" height="36rpx" /></view>
					<view class="splitLine" />
					<view class="text-container">
						<swiper style="height: 64rpx" :vertical="true" :autoplay="true" :circular="true" :interval="3000" display-multiple-items="1" @change="changeSearchName">
							<swiper-item class="left-item" v-for="item in formData.searchText" :key="item.id">
								<view class="item-text" @click="goToSearch(item)">{{ item }}</view>
							</swiper-item>
						</swiper>
					</view>
					<view @click="showScan('pz')"><u-image src="/static/pz_icon@2x.png" width="36rpx" height="36rpx" /></view>
					<view class="searchbt" @click="goToSearch(item)">搜索</view>
				</view>
			</view>
		</view>
		<scroll-view class="content" 
		 scroll-y 
		 :refresher-enabled="true"
		 :refresher-triggered="_freshing"
		  @refresherrefresh="pullRefresh" 
		:style="{ height: scrollViewheight + 'px' }">
			
			<!-- banner -->
			<view class="content_banner">
				<u-swiper :list="formData.bannerList" keyName="imageUrl" :indicator="true" indicatorMode="dot" indicatorActiveColor="#0FC8AC" @click="clickBanner"></u-swiper>
			</view>
			<u-gap bgColor="#F8F8F8" height="20rpx"></u-gap>
			<!-- 查询入口 -->
			<view class="search_port">
				<!-- 标题 -->
				<view class="port_title">
					<view>查询入口</view>
					<view class="line"></view>
				</view>
				<!-- 查询入口 -->
				<view class="port_content2">
					<u-button :customStyle="btStyle1" @click="zzcx()">
						<view class="port_content_items" style="background: linear-gradient(90deg, #0AD0B2 0%, #0FC7AB 100%)">
							<view class="items_left">
								<view class="items_icon"><u-image :src="$utils.getImgUrl('sys_inx.png')" width="72rpx" height="72rpx"></u-image></view>
							</view>
							<view class="items_right">
								<view class="items_name">扫一扫查真伪</view>
								<view class="items_nums">
									<view class="">{{ formData.scanNum || 0 }}</view>
									<view class="items_nums_font">人查询过</view>
								</view>
							</view>
						</view>
					</u-button>
					<u-button :customStyle="btStyle1" @click="rghc()">
						<view class="port_content_items" style="background: linear-gradient(90deg, #5BAEFB 0%, #4299EE 100%)">
							<view class="items_left">
								<view class="items_icon"><u-image :src="$utils.getImgUrl('port2.png')" width="72rpx" height="72rpx"></u-image></view>
							</view>
							<view class="items_right">
								<view class="items_name">人工核查</view>
								<view class="items_nums">
									<view class="">{{ formData.manualVerifyNum || 0 }}</view>
									<view class="items_nums_font">人查询过</view>
								</view>
							</view>
						</view>
					</u-button>
				</view>
				<view class="port_content">
					<u-button :customStyle="btStyle" @click="jgcx()">
						<view class="port_content_items" style="background: linear-gradient(90deg, #FFB44B 0%, #FF9F17 100%)">
							<view class="items_icon"><u-image :src="$utils.getImgUrl('port3.png')" width="60rpx" height="60rpx"></u-image></view>
							<view class="items_name">价格查询</view>
							<view class="items_nums">
								<view class="">{{ formData.priceQueryNum || 0 }}</view>
								<view class="items_nums_font">人查询过</view>
							</view>
						</view>
					</u-button>
					<u-button :customStyle="btStyle" @click="wysj">
						<view class="port_content_items" style="background: linear-gradient(90deg, #FF698C 0%, #FF7797 100%)">
							<view class="items_icon"><u-image :src="$utils.getImgUrl('sj_icon@2x.png')" width="60rpx" height="60rpx"></u-image></view>
							<view class="items_name">我要送检</view>
							<view class="items_nums">
								<view class="">{{ formData.checkNum || 0 }}</view>
								<view class="items_nums_font">人查询过</view>
							</view>
						</view>
					</u-button>
					<u-button :customStyle="btStyle" @click="wybj">
						<view class="port_content_items" style="background: linear-gradient(90deg, #5B97B7 0%, #66A4C4 100%)">
							<view class="items_icon"><u-image :src="$utils.getImgUrl('bj_icon@2x.png')" width="60rpx" height="60rpx"></u-image></view>
							<view class="items_name">我要比价</view>
							<view class="items_nums">
								<view class="">{{ formData.compareNum || 0 }}</view>
								<view class="items_nums_font">人查询过</view>
							</view>
						</view>
					</u-button>
				</view>
				<swiper class="port_whoSearch" :vertical="true" :autoplay="true" catchtouchmove="true" :circular="true" :interval="2000" display-multiple-items="2">
					<swiper-item class="port_whoSearch_items" catchtouchmove="catchTouchMove" v-for="(item, index) in formData.searchList" :key="index">
						<u-image :src="item.avatar" width="40rpx" height="40rpx"></u-image>
						<view class="whoSearch_name">{{ item.content }}</view>
					</swiper-item>
				</swiper>
			</view>
			<u-gap bgColor="#F8F8F8" height="20rpx"></u-gap>
			<!-- 热门药品 -->
			<view class="hot_sell">
				<!-- 标题 -->
				<view class="port_title">
					<view>热门药品</view>
					<view class="line"></view>
				</view>
				<view class="hot_content"><goodsList :lists="formData.goodsList"></goodsList></view>
			</view>
			<u-gap bgColor="#F8F8F8" height="20rpx"></u-gap>
			<!-- 热门评论 -->
			<view class="hot_talk">
				<!-- 标题 -->
				<view class="port_title">
					<view class="port_more">
						<view class="">热门评论</view>
						<view class="more" @click.stop="moreComment()">更多</view>
					</view>
					<view class="line"></view>
				</view>
				<view class="hot_talk_content">
					<view class="hot_talk_content_item" v-for="(items, ids) in commentList" :key="ids" @click="huifu(items)">
						<view class="talk_content_item">
							<u-image :src="items.avatar" width="70rpx" height="70rpx"></u-image>
							<view class="talk_content">
								<view class="talk_content_name">{{ items.username }}</view>
								<view class="talk_content_time">{{ items.created }}</view>
							</view>
						</view>
						<view class="talk_content_desc">{{ items.content }}</view>
						<view class="talk_content_img" v-if="items.pictures.length">
							<u-image
								radius="8rpx"
								v-for="(img, imgkey) in items.pictures"
								:height="imgWidth"
								:width="imgWidth"
								:src="img"
								:key="imgkey"
								:errorIcon="$utils.getImgUrl('empty-goods.png')"
							/>
						</view>

						<view class="talk_bottom flex-row">
							<view class="item flex-row flex-ac" @tap.stop="toCommentLike(items)">
								<u-image v-if="items.isLike" class="img" :src="$utils.getImgUrl('like.png')" width="32rpx" height="32rpx"></u-image>
								<u-image v-else class="img" :src="$utils.getImgUrl('nolike.png')" width="32rpx" height="32rpx"></u-image>
								<view class="nums">{{ items.likeNum }}</view>
							</view>
							<view class="item flex-row flex-ac">
								<u-image :src="$utils.getImgUrl('message.png')" width="32rpx" height="30rpx"></u-image>
								<view class="nums">{{ items.commentNum }}</view>
							</view>
							<!-- 分享 -->
							<view class="item flex-row flex-ac">
								<button class="share-btn" openType="share"
									@tap.stop="shareComment(items)">
									<u-image :src="$utils.getImgUrl('share.png')" width="32rpx" height="32rpx"></u-image>
								</button>
							</view>
							
						</view>
						<u-line></u-line>
					</view>
				</view>
			</view>
		</scroll-view>
		<!-- 发布帖子 -->
		<view class="fabu" @click="fatie">
			<view class="fabu_img"><u-image :src="$utils.getImgUrl('fabu.png')" width="32rpx" height="32rpx"></u-image></view>
			<view class="fabu_title">发帖</view>
		</view>
		
		<!-- 点击收藏 -->
		<!--  -->
		<view class="collection-wechat flex-row flex-ac" :style="{ top: navH+'px' }"  v-show="!isShowAdd">
			<view class="text">
				点击“<image src="../../static/images/small_wechat_set.png" class="img"></image>{{isShowAdd}}”添加到我的小程序
			</view>
			
			<view class="close" @click.stop="show_close_add">
				<image src="../../static/images/close.png" class="img"></image>
			</view>
		</view>
		<!-- 是否有包装盒子确认弹框 -->
		<view class="popView">
			<u-modal
				:show="show"
				class="zdyPop"
				showCancelButton
				closeOnClickOverlay
				confirmText="有"
				cancelText="没有"
				confirmColor="#FFFFFF"
				cancelColor="#0FC8AC"
				@confirm="confirm"
				@cancel="cancel"
				@close="close"
			>
				<view class="popContent">
					<u-image :src="$utils.getImgUrl('yaoxiang.png')" width="100rpx" height="100rpx"></u-image>
					<view class="bold">请确认是否有实物的包装盒子？</view>
				</view>
			</u-modal>
		</view>
		<!-- 是否联系客服弹框 -->
		<view class="popView">
			<u-modal
				:show="show1"
				class="zdyPop"
				showCancelButton
				closeOnClickOverlay
				confirmText="是"
				cancelText="否"
				confirmColor="#FFFFFF"
				cancelColor="#0FC8AC"
				@confirm="confirm1"
				@cancel="cancel1"
				@close="close1"
			>
				<view class="popContent"><view class="bold">是否联系客服咨询药品详情？</view></view>
			</u-modal>
		</view>
	</view>
</template>

<script>
import goodsList from '@/components/goodsInfo/goodsList.vue';
import { homeIndexReq, commentListReq, commentLikeReq } from '@/api/home';
import {mapGetters} from "vuex";
export default {
	components: {
		goodsList
	},
	data() {
		return {
			txtList: [],
			title: 'Hello',
			searchModel: '',
			searchPlace: '卡博替尼',
			show: false, //是否有包装盒子确认弹框
			show1: false, //是否联系客服弹框

			search_key: '',
			formData: {
				bannerList: [],
				searchList: [],
				searchText: ''
			},
			share: {
				title: '',
				path: '',
				imageUrl: ''
			},
			commentList: [],
			customStylea: {
				border: 'none',
				padding: '0',
				margin: '0',
				height: '32rpx',
				width: '32rpx'
			},
			btStyle: {
				flex: '1',
				height: '240rpx',
				'border-radius': '16rpx',
				margin: '0 10rpx',
				padding: '0',
				fontSize: '28rpx',
				borderWidth: 0
			},
			btStyle1: {
				flex: '1',
				height: '180rpx',
				'border-radius': '16rpx',
				margin: '0 10rpx',
				padding: '0',
				fontSize: '28rpx',
				borderWidth: 0
			},
			isLogin: false,
			_freshing:false,
			navH:0,
		};
	},

	computed: {
		...mapGetters(['isShowAdd']),
		imgWidth() {
			return parseInt(uni.getSystemInfoSync().windowWidth - 48) / 3 + 'px';
		},
		topHight() {
			const systemInfo = uni.getSystemInfoSync();
			return systemInfo.statusBarHeight + 44
		},
	},

	// 1.发送给朋友
	onShareAppMessage(res) {
		return {
			title: this.share.title,
			path: this.share.path,
			imageUrl: this.share.imageUrl
		};
	},
	//2.分享到朋友圈
	onShareTimeline(res) {
		return {
			title: this.share.title,
			path: this.share.path,
			imageUrl: this.share.imageUrl
		};
	},
	onLoad() {
		// uni.startPullDownRefresh()
		let menuButtonInfo = uni.getMenuButtonBoundingClientRect();
		console.log(menuButtonInfo)
		this.navH = menuButtonInfo.top  + menuButtonInfo.height+10;
		console.log(this.navH)
		
		this.getIndex();
		this.getCommentList();
	},
	onShow() {
		// #ifdef H5
		document.title = '识药查真伪'
		//#endif
		// const keywords = [{ name: '1234567890qwertyuiopasdfghjklzxcvbnm' }]
		// uni.navigateTo({
		// 	url: `/pages/sbjg/tqwz/tqwz?keywords=${encodeURIComponent(JSON.stringify(keywords))}`
		// })
	},
	catchTouchMove() {
		return false;
	},
	methods: {
		pullRefresh(){
			if(this._freshing){
				return 
			}
			let that = this
			this._freshing = true
			this.getIndex();
			this.getCommentList();
			uni.$u.sleep(1000).then(() => {
				
				that._freshing = false
			});
		},
		
		getLoginStatus() {
			this.isLogin = !!uni.getStorageSync('token') || false;
		},
		getIndex() {
			this.getLoginStatus();
			homeIndexReq().then(res => {
				let new_data = res.data;
				new_data.searchText = new_data.searchText.split(',');
				this.formData = new_data;
			});
		},
		getCommentList() {
			let params = {
				type: 1
			};
			commentListReq(params).then(res => {
				this.commentList = res.data.commentList;
			});
		},
		//自助查询
		zzcx() {
			// this.show = true
			this.showScan('sys', 'scanZhenWei');
			//
		},
		confirm() {
			this.show = false;
			uni.navigateTo({
				url: '/pages/zzcx/index'
			});
		},
		cancel() {
			this.show = false;
			this.show1 = true;
		},
		close() {
			this.show = false;
		},

		//联系客服弹框的打开与关闭
		confirm1() {
			uni.navigateTo({
				url: '/pages/lxwm/lxwm'
			});
		},
		cancel1() {
			this.show1 = false;
		},
		close1() {
			this.show1 = false;
		},
		// 人工核查
		rghc() {
			let url = '/pages/rghc/index';

			this.$utils.goOthersCheckLogin(url);
		},
		// 价格查询
		jgcx() {
			let url = '/pages/jgcx/index';

			this.$utils.goOthersCheckLogin(url);
		},
		//我要送检
		wysj() {
			let url = '/pages/wysj/wysj';

			this.$utils.goOthersCheckLogin(url);
		},
		//我要比价
		wybj() {
			let url = '/pages/wybj/wybj';
			this.$utils.goOthersCheckLogin(url);
		},
		changeSearchName(c, s) {
			let current = c.target.current;
			let key = this.formData.searchText[current];
			this.search_key = key;
		},
		// 进入搜索页
		goToSearch() {
			uni.navigateTo({
				url: `/pages/searchPage/searchPage?keyword=${this.search_key}`
			});
		},
		/**
		 * banner点击跳转
		 * @param {Object} index
		 */
		clickBanner(index) {
			let p = this.formData.bannerList[index];
			
			if (p.type === 1 && p.linkUrl) {
				
				let link_url = p.linkUrl
				if(link_url.indexOf('shiyao/articleInfo') >=0){
					// 跳转文章
					let articleId = this.$utils.getUrlParams(link_url,'id')
					console.log(articleId)
					let go_url = `/pages/circle/zxDetail?articleId=${articleId}`
					this.$utils.goOthersCheckLogin(go_url)
				}else{
					// 跳转路径
					uni.navigateTo({
						url: `/pages/webView/webView?webUrl=${encodeURIComponent(p.linkUrl)}&title=${p.name}`
					});
				}
				
			}
		},
		/**
		 * 点赞
		 */
		toCommentLike(item) {
			let that = this;
			if (!this.$store.getters.isLogin) {
				this.$utils.toLogin();
				return;
			}
			let params = {
				commentId: item.commentId
			};
			commentLikeReq(params).then(res => {
				if (item.isLike === 0) {
					uni.showToast({
						icon: 'none',
						duration: 1500,
						title: '点赞成功',
						success() {
							uni.$u.sleep(2000).then(() => {
								that.getCommentList();
							});
						}
					});
				} else {
					uni.showToast({
						icon: 'none',
						duration: 1500,
						title: '取消点赞成功',
						success() {
							uni.$u.sleep(2000).then(() => {
								that.getCommentList();
							});
						}
					});
				}
			});
		},
		fatie(commentId) {
			let url = `/pages/fatie/fatie?commentId=${commentId}`;
			this.$utils.goOthersCheckLogin(url);
		},
		moreComment() {
			this.$store.dispatch('ChangeCircleTab', 1).then(res => {
				uni.switchTab({
					url: '/pages/circle/circle'
				});
			});
		},
		shareComment(item) {
			let that = this;
			that.share = {
				title: '你的朋友分享了一个好内容给你',
				path: `/pages/circle/detail/index?commentId=${item.commentId}`
			};
		},
		/**
		 * 帖子回复
		 */
		huifu(item) {
			let url = `/pages/circle/detail/index?commentId=${item.commentId}`;
			this.$utils.goOthersCheckLogin(url);
		},
		showScan(type, status = '') {
			// status:scanZhenWei 扫码后跳转
			let url = `/pages/camera/camera?type=${type}&nextPageType=${status}`;
			this.$utils.goOthersCheckLogin(url);
		},
		
		
		show_close_add(){
			console.log('123')
			// 关闭收藏提示
			this.$store.commit('UPDATE_ISSHOWADD');
		},
	}
};
</script>

<style lang="scss" scoped>
.collection-wechat{
	font-size: 22rpx;
	line-height: 34rpx;
	width: 330rpx;
	padding: 16rpx 20rpx;
	background: #fff;
	border-radius: 20rpx;
	color: #666;
	position: fixed;
	right: 40rpx;
	z-index: 11;
	box-shadow: 3rpx 4rpx 5rpx #ccc;
	.text{
		width: 294rpx;
		margin-right: 6rpx;
		.img{
			width: 30rpx;
			height: 15rpx;
		}
	}
	.close{
		font-size: 30rpx;
		.img{
			width: 30rpx;
			height: 30rpx;
			display: block;
		}
	}
}
.mainWrap {
	// background-color: #f8f8f8;
}

.u-nav-slot {
	width: 100%;
	display: flex;
	flex-direction: row;
	justify-content: center;
	height: 50rpx;
	font-size: 36rpx;
	font-family: PingFangSC-Medium, PingFang SC;
	font-weight: 500;
	color: #ffffff;
	line-height: 50rpx;
}
.content_search {
	width: 100%;
	height: 122rpx;
	background-color: #0ad0b2;
	display: flex;
	align-items: center;
	justify-content: center;
	position: fixed;
	z-index: 2;
	top: 0;
	margin: 0 auto;

	.content_search_back {
		width: calc(100% - 60rpx);

		// .content_search_input {
		// 	background-color: white;
		// 	margin-top: -36rpx;
		// 	box-shadow: 0 4rpx 6rpx 0 rgba(57, 186, 167, 0.1);
		// }

		.serView {
			height: 64rpx;
			display: flex;
			align-items: center;
			background: #ffffff;
			box-shadow: 0rpx 4rpx 6rpx 0rpx rgba(57, 186, 167, 0.1);
			border-radius: 40rpx;
			padding: 0 4rpx 0 40rpx;

			.splitLine {
				width: 2rpx;
				height: 24rpx;
				background-color: #0fc8ac;
				margin: 0 8rpx;
			}

			.text-container {
				flex: 1;
				height: 64rpx;

				.item-text {
					white-space: nowrap;
					overflow: hidden !important;
					text-overflow: ellipsis !important;
					line-height: 64rpx;
					color: #999;
					font-size: 28rpx;
				}
			}

			/deep/ .u-icon {
				margin-left: 20rpx;
				margin-right: 6rpx;

				.uicon-search {
					font-size: 48rpx !important;
				}
			}

			.searchbt {
				width: 128rpx;
				height: 56rpx;
				line-height: 56rpx;
				background: #0fc8ac;
				border-radius: 28rpx;
				margin-left: 8rpx;
				color: white;
				text-align: center;
			}
		}
	}
}
.content {
	padding-top: 122rpx;
	box-sizing: border-box;
	

	.content_banner {
		margin: 30rpx;
		margin-top: 20rpx;
	}

	.search_port {
		margin: 0 30rpx;

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
				background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0fc7ab 100%);
			}
		}

		.port_content2 {
			display: flex;
			flex-direction: row;
			margin-bottom: 20rpx;

			.port_content_items {
				flex: 1;
				height: 180rpx;
				border-radius: 16rpx;
				// margin: 0 10rpx;
				display: flex;
				flex-direction: row;
				align-items: center;
				justify-content: space-around;
				color: #ffffff;

				.items_left {
					display: flex;
					height: 180rpx;
					align-items: center;
					justify-content: center;

					.items_icon {
						margin: 32rpx 0 16rpx 0;
					}
				}

				.items_right {
					display: flex;
					height: 180rpx;
					flex-direction: column;
					align-items: center;
					justify-content: center;

					.items_name {
						margin-bottom: 20rpx;
						font-weight: 600;
						line-height: 40rpx;
					}

					.items_nums {
						font-size: 36rpx;
						display: flex;
						align-items: baseline;

						.items_nums_font {
							font-size: 28rpx;
							line-height: 60rpx;
						}
					}
				}
			}
		}

		.port_content {
			display: flex;
			flex-direction: row;
			margin-bottom: 20rpx;

			.port_content_items {
				flex: 1;
				height: 240rpx;
				border-radius: 16rpx;
				// margin: 0 10rpx;
				display: flex;
				flex-direction: column;
				align-items: center;
				justify-content: center;
				color: #ffffff;

				.items_icon {
					margin: 32rpx 0 16rpx 0;
				}

				.items_name {
					margin-bottom: 20rpx;
					font-weight: 600;
					line-height: 40rpx;
				}

				.items_nums {
					font-size: 36rpx;
					display: flex;
					align-items: baseline;

					.items_nums_font {
						font-size: 28rpx;
						line-height: 60rpx;
					}
				}
			}
		}

		.port_whoSearch {
			height: 120rpx;
			padding-bottom: 20rpx;

			.port_whoSearch_items {
				display: flex;
				// margin: 20rpx 0;
				align-items: center;

				.whoSearch_name {
					margin-left: 20rpx;
					color: #666666;
					height: 34rpx;
					line-height: 34rpx;
					font-size: 24rpx;
					overflow: hidden;
				}
			}
		}
	}

	.hot_sell {
		margin: 30rpx;

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
				background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0fc7ab 100%);
			}
		}
	}

	.hot_talk {
		margin: 30rpx;

		.port_title {
			margin-bottom: 20rpx;
			width: 100%;
			font-size: 32rpx;
			font-weight: 600;
			color: #333333;
			line-height: 44rpx;

			.port_more {
				display: flex;
				justify-content: space-between;
			}

			.more {
				color: #0fc8ac;
				font-size: 28rpx;
				padding: 4rpx 20rpx;
			}

			.line {
				margin-top: -6rpx;
				width: 128rpx;
				height: 6rpx;
				background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0fc7ab 100%);
			}
		}

		.hot_talk_content {
			.hot_talk_content_item {
				margin: 40rpx 0 22rpx 0;
				display: flex;
				flex-direction: column;

				.talk_content_item {
					display: flex;
					flex-direction: row;
					margin-bottom: 24rpx;

					.talk_content {
						margin-left: 28rpx;
						color: #262626;
						font-size: 28rpx;
						font-weight: 400;

						.talk_content_name {
						}

						.talk_content_time {
							font-size: 22rpx;
							line-height: 32rpx;
							color: #8c8c8c;
						}
					}
				}

				.talk_content_desc {
					line-height: 40rpx;
					margin-bottom: 24rpx;
				}

				.talk_content_img {
					margin-bottom: 24rpx;
					display: flex;
					flex-direction: row;
					gap: 14rpx;
					flex-wrap: wrap;
					.item_img {
						border-radius: 8rpx;
					}
				}

				.talk_bottom {
					width: calc(100% - 200rpx);
					padding-bottom: 20rpx;
					.item {
						flex: 1;
						.img {
							// border: 2rpx dashed #f9f9f9;
						}
						.nums {
							margin-left: 6rpx;
							color: #999999;
							font-size: 28rpx;
							line-height: 40rpx;
						}
						.share-btn{
							background: #fff;
							padding: 0;
							margin: 0;
							&::after{
								border:none;
							}
						}
					}
				}
			}
		}
	}
}

.popContent {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;

	.bold {
		display: block;
		height: 40rpx;
		font-size: 28rpx;
		font-family: PingFangSC-Semibold, PingFang SC;
		font-weight: 600;
		color: #333333;
		line-height: 40rpx;
		margin: 40rpx auto;
	}
}

.zdyPop {
	/deep/ .u-modal__button-group__wrapper--cancel {
		background-color: #dbf7f3;
	}

	/deep/ .u-modal__button-group__wrapper--confirm {
		background-color: #0fc8ac;
	}

	/deep/ .u-line {
		display: none;
	}
}

.popView {
	/deep/ .u-modal__button-group__wrapper--cancel {
		background-color: #dbf7f3;
	}

	/deep/ .u-modal__button-group__wrapper--confirm {
		background-color: #0fc8ac;
	}

	/deep/ .u-line {
		display: none;
	}
}

.fabu {
	width: 96rpx;
	height: 96rpx;
	position: fixed;
	right: 20rpx;
	bottom: 150rpx;
	border-radius: 100%;
	background: linear-gradient(180deg, #0ad0b2 0%, #0fc7ab 100%);
	box-shadow: 0rpx 4rpx 6rpx 0rpx rgba(0, 141, 120, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	flex-direction: column;

	.fabu_title {
		margin-top: 10rpx;
		font-size: 24rpx;
		font-weight: 400;
		color: #ffffff;
		line-height: 34rpx;
	}
}
</style>
