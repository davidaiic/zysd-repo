<template>
	<page-meta :page-style="'overflow:' + 'hidden'">

		<view class="mainWrap">
			<view class="contents">
				<u-navbar v-if="!isH5" :title="title" :fixed="false" @leftClick="leftClick"
					:titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
			</view>
			<scroll-view scroll-y class="content-box" :style="{ height: scrollViewheight+ 'px' }">
				<u-sticky style="top: 0">
					<u-notice-bar text="凡涉及治疗方案/用药等内容均存在个体差异，请勿盲目效仿." bgColor="#F2F3F5" color="#999"></u-notice-bar>
				</u-sticky>
				<view class="hot_talk_content">
					<view class="hot_talk_content_item">
						<view class="talk_content_item">
							<image class="avatar-img" :src="formData.avatar"></image>
							<view class="talk_content">
								<view class="talk_content_name">{{ formData.username }}</view>
								<view class="talk_content_time">
									<view v-for="label in formData.label" :key="label" class="icon">{{ label }}</view>
									{{ formData.created }}
								</view>
							</view>
						</view>
						<view class="talk_content_desc">{{ formData.content }}</view>

						<view v-if="formData.pictures && formData.pictures.length" class="talk_content_img2">
							<view class="item-img"  v-for="(img, imgkey) in formData.pictures" :key="item">
								<image :src="img" mode="widthFix" class="image"/>
							</view>
						</view>
					</view>
				</view>
				<u-gap height="20rpx" bgColor="#F8F8F8"></u-gap>
				<view class="hot_talk_title">
					评论（{{ commentList.length || 0 }}）
				</view>
				<view class="hot_talk_content" v-if="commentList.length > 0">
					<scroll-view class="hot_sell" @scrolltolower="loadMore()">
						<view class="hot_talk_content_item" v-for="(items, ids) in commentList" :key="ids">
							<view class="talk_content_item">
								<image  class="avatar-img"  :src="items.avatar"></image>
								<view class="talk_content">
									<view class="talk_content_name">
										<view class="talk_content_name_left">{{ items.username }}</view>
										<view class="talk_content_name_right" @click="toCommentLike(items)">
											<image v-if="items.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"></image>
											<image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"></image>
											<view class="talk_bottom_item_nums">
												{{ items.likeNum }}
											</view>
										</view>
									</view>
									<view class="talk_content_time">{{ items.created }}</view>
								</view>
							</view>
							<view class="talk_content_desc">{{ items.content }}</view>
							<view v-if="items.pictures && items.pictures.length" class="talk_content_img2">
								<u-image radius="8rpx" v-for="(img, imgkey) in items.pictures" :height="imgWidth"
									:errorIcon="$utils.getImgUrl('empty-goods.png')" :width="imgWidth" :src="img"
									:key="imgkey"  @click="clickImg(img,items.pictures)"/>
							</view>
							<u-line></u-line>
						</view>
					</scroll-view>
				</view>
				<view class="hot_talk_content" v-if="isShowNoData">
					<u-empty :text='showText' mode="data"></u-empty>
				</view>
				<view class="bottom-fill"></view>
			</scroll-view>

			<!-- 评论 -->
			<view class="bottomBtn flex-row flex-c">
				<view class="pl_buttom_input">
					<!-- <u-input v-model="pinglunDetail" placeholder="写下你的评论..." confirmType="评论" adjustPosition border="surround"
                    shape="circle" @confirm="sendMessage">
                </u-input> -->
					<view class="input_bt" @click="popComment">写下您的评论～</view>
				</view>
				<view class="pl_buttom_text">
					<view class="talk_bottom_item" @click.stop="toCommentLike(formData, true)">
						<image v-if="formData.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"></image>
						<image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"></image>
						<view class="talk_bottom_item_nums">
							{{ formData.likeNum }}
						</view>
					</view>
					<view class="talk_bottom_item">
						<button class="wechat-btn" openType="share"
							@tap.stop="shareComment(formData)">
							<image class="talk_bottom_item_img" :src="$utils.getImgUrl('share.png')"></image>
						</button>
					</view>
					
				</view>
			</view>
		</view>
	</page-meta>
	<popTie :pop.sync="pop" ref="popComment" @success="success" />
</template>

<script>
import popTie from './pop-tie.vue'

import {
	commentLikeReq,
	homeCommentInfoReq,
	pluginContactReq
} from "@/api/home.js"
export default {
	components: {
		popTie
	},
	data() {
		return {
			formData: {
				avatar: '',
				isLike: '',
				username: '',
				created: '',
				content: '',
				isLike: '',
				likeNum: '',
				commentNum: '',
				pictures: []
			},
			title: '帖子详情',
			showText: '暂无评论',
			commentList: [],
			isShowNoData: false,
			page: 1,
			share: {
				title: '',
				path: '',
				imageUrl: ''
			},
			customStylea: {
				border: 'none',
				padding: '0',
				margin: '0',
				height: '32rpx',
				width: '32rpx'
			},
			pinglunDetail: '',
			pop: false
		}
	},
	onLoad(option) {
		this.commentId = option.commentId
	},
	computed: {
		imgWidth() {
			return parseInt(uni.getSystemInfoSync().windowWidth - 48) / 3 + 'px'
		}
	},
	onShow() {
		if (this.commentId) this.getCommentList()
	},
	methods: {
		clickImg(url,urls) {
			console.log(url)
			// let currentUrl = event.currentTarget.dataset.src
			uni.previewImage({
			  current: url, // 当前显示图片的http链接
			  urls: urls // 需要预览的图片http链接列表
			})
		},
		popComment() {
			this.$refs.popComment.init(this.commentId)
		},
		getCommentList() {
			let params = {
				commentId: this.commentId,
				page: this.page
			}
			homeCommentInfoReq(params).then(res => {
				this.formData = res.data.info
				this.commentList = res.data.commentList
				if (res.data.commentList.length < 0) this.isShowNoData = true
			})
		},
		loadMore() {
			this.page++
			this.getCommentList()
		},
		toCommentLike(item) {
			let that = this
			let params = {
				commentId: item.commentId
			}
			commentLikeReq(params).then(res => {
				if (item.isLike === 0) {
					uni.showToast({
						icon: 'none',
						duration: 1500,
						title: '点赞成功',
						success() {
							uni.$u.sleep(1000).then(() => {
								that.page = 1
								that.getCommentList()
							})
						}
					})
				} else {
					uni.showToast({
						icon: 'none',
						duration: 1500,
						title: '取消点赞成功',
						success() {
							uni.$u.sleep(1000).then(() => {
								that.page = 1
								that.getCommentList()
							})
						}
					})
				}
			})
		},
		shareComment(item) {
			let that = this
			that.share = {
				title: '你收到来自朋友的一条评论',
				path: `/pages/circle/detail/index?commentId=${that.commentId}`
			}
		},
		success() {
			let that = this
			that.getCommentList()
		}
	},
	
	// 1.发送给朋友
	onShareAppMessage(res) {
		return {
			title: this.share.title,
			path: this.share.path,
			imageUrl: this.share.imageUrl,
		}
	},
	//2.分享到朋友圈
	onShareTimeline(res) {
		return {
			title: this.share.title,
			path: this.share.path,
			imageUrl: this.share.imageUrl,
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
/deep/.u-sticky__content .u-notice-bar{
	padding: 6rpx 10rpx;
}
.content-box {
	// padding: 0 30rpx;
}

.hot_talk_title {
	height: 44rpx;
	font-size: 32rpx;
	font-weight: 500;
	color: #333333;
	line-height: 44rpx;
	margin: 30rpx;
}

.hot_talk_content {
	margin: 0 30rpx;

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
				flex: 1;

				.talk_content_name {
					width: 100%;
					display: flex;
					justify-content: space-between;
					align-items: center;

					.talk_content_name_left {}

					.talk_content_name_right {
						width: 60rpx;
						display: inline-flex;
						align-items: center;
						justify-content: space-between;
						color: #999999;
					}
				}

				.talk_content_time {

					display: flex;
					flex-direction: row;
					align-items: center;
					font-size: 22rpx;
					line-height: 32rpx;
					color: #8c8c8c;

					.icon {
						padding: 4rpx 8rpx;
						background-color: rgba(15, 200, 172, 0.1);
						border: 4rpx;
						margin-right: 20rpx;
						color: #0FC8AC;
						font-size: 22rpx;
					}
				}


			}


		}

		.talk_content_desc {
			line-height: 40rpx;
			margin-bottom: 20rpx;
		}

		.talk_content_img2 {
			margin: 24rpx 0;
			display: flex;
			flex-direction: row;
			gap: 14rpx;
			flex-wrap: wrap;

			.item-img {
				width: 320rpx;
				height: 200rpx;
			    border-radius: 8rpx;
				overflow: hidden;
				margin-right: 10rpx;
				margin-bottom: 10rpx;
				&:nth-child(2){
					margin-right: 0;
				}
				.image{
					width: 100%;
				}
			}
		}

		.talk_content_img {
			margin-bottom: 20rpx;

			.item-img {
				width: 320rpx;
				height: 200rpx;
			    border-radius: 8rpx;
				overflow: hidden;
				margin-right: 10rpx;
				margin-bottom: 10rpx;
				&:nth-child(2){
					margin-right: 0;
				}
				.image{
					width: 100%;
				}
			}
		}

		.talk_bottom {
			width: calc(100% - 200rpx);
			display: flex;
			flex-direction: row;

			.talk_bottom_item {
				flex: 1;
				display: inline-flex;

				.talk_bottom_item_img {
					// border: 2rpx dashed #f9f9f9;
				}

				.talk_bottom_item_nums {
					margin-left: 6rpx;
					color: #999999;
					font-size: 28rpx;
					line-height: 40rpx;
				}
			}
		}
	}
}

.bottom-fill{
	height: 140rpx;
}
.bottomBtn {
	position: fixed;
	height: 140rpx;
	width: 100%;
	bottom: 0;
	background-color: #fff;
	box-shadow: 4rpx 0rpx 8rpx 0rpx rgba(216, 216, 216, 0.5);

	.pl_buttom_input {
		margin: 0 20rpx;
		flex: 1;

		.input_bt {
			background-color: #F2F3F5;
			width: 100%;
			border-radius: 32rpx;
			color: #999999;
			padding: 12rpx 30rpx;
			font-size: 28rpx;

		}
	}

	.pl_buttom_text {
		display: flex;
		flex-direction: row;
		align-items: center;
		// justify-content: space-around;
		// width: 200rpx;
		margin-left: 40rpx;
		height: 40rpx;
		font-size: 28rpx;
		font-weight: 600;
		line-height: 40rpx;

		.talk_bottom_item {
			display: flex;
			flex-direction: row;
			align-items: center;
			margin: 0 30rpx;

			.talk_bottom_item_nums {
				margin-left: 6rpx;
				color: #999999;
				font-size: 28rpx;
				line-height: 40rpx;
			}
		}
	}
}
</style>
