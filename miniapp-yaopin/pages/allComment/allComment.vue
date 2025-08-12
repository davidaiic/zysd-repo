<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" :title="title" @leftClick="leftClick" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px', fontWeight: '500' }"></u-navbar>
		</view>
		<view class="content hot_talk_content">
			<u-list class="hot_talk_content" v-if="commentList.length > 0" @scrolltolower="loadMore">
				<u-list-item v-for="(items, ids) in commentList" :key="ids">
					<view class="hot_talk_content_item" @click="huifu(items)">
						<view class="talk_content_item">
							<u-image :src="items.avatar" width="70rpx" height="70rpx">
							</u-image>
							<view class="talk_content">
								<view class="talk_content_name">{{ items.username }}</view>
								<view class="talk_content_time">{{ items.created }}</view>
							</view>
						</view>
						<view class="talk_content_desc">{{ items.content }}</view>
						<view class="talk_content_img">
							<u-image radius="8rpx" v-for="(img, imgkey) in items.pictures" :height="imgWidth"
								:errorIcon="$utils.getImgUrl('empty-goods.png')" :width="imgWidth" :src="img"
								:key="imgkey" />
						</view>
						<view class="talk_bottom">
							<view class="talk_bottom_item" @tap.stop="toCommentLike(items)">
								<u-image v-if="items.isLike" class="talk_bottom_item_img"
									:src="$utils.getImgUrl('like.png')" width="32rpx" height="32rpx"></u-image>
								<u-image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"
									width="32rpx" height="32rpx"></u-image>
								<view class="talk_bottom_item_nums">
									{{ items.likeNum }}
								</view>
							</view>
							<view class="talk_bottom_item">
								<u-image :src="$utils.getImgUrl('message.png')" width="32rpx" height="32rpx">
								</u-image>
								<view class="talk_bottom_item_nums">
									{{ items.commentNum }}
								</view>
							</view>
							<!-- 分享 -->
							<view class="talk_bottom_item">
								<u-button :customStyle="customStylea" openType="share" :icon="$utils.getImgUrl('share.png')"
									@tap.stop="shareComment(items)">
								</u-button>
							</view>
						</view>
						<u-line></u-line>
					</view>
				</u-list-item>
			</u-list>
			<view v-if="isShowData">
				<u-empty mode="data"></u-empty>
			</view>
		</view>
	</view>
</view></template>

<script>
import {
	commentLikeReq,
	commentListReq
} from "@/api/home.js"
export default {
	data() {
		return {
			title: '全部评论',
			commentList: [],
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
			isShowData: false,
			scrollTop: 0,
			old: {
				scrollTop: 0
			}
		}
	},
	computed: {
		imgWidth() {
			return parseInt(uni.getSystemInfoSync().windowWidth - 48) / 3 + 'px'
		}
	},
	onLoad() {
		this.getCommentList()
	},
	onPullDownRefresh() {
		this.getCommentList()
		uni.$u.sleep(1000).then(() => {
			uni.stopPullDownRefresh();
		})
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
	},
	methods: {
		scroll(e) {
			this.old.scrollTop = e.detail.scrollTop
		},
		getCommentList(flag = true) {
			let params = {
				type: 0,
				page: this.page
			}
			commentListReq(params).then(res => {
				if (flag) this.commentList = res.data.commentList
				this.commentList = this.commentList.concat(res.data.commentList)
				this.isShowData = this.commentList.length === 0;
			})
		},
		loadMore() {
			this.page++
			this.getCommentList(false)
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
							uni.$u.sleep(2000).then(() => {
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
							uni.$u.sleep(2000).then(() => {
								that.page = 1
								that.getCommentList()
							})
						}
					})
				}
			})
		},
		/**
		 * 帖子回复
		 */
		huifu(item) {
			uni.navigateTo({
				url: `/pages/circle/detail/index?commentId=${item.commentId}`
			})
		},
		shareComment(item) {
			let that = this
			that.share = {
				title: '你收到来自朋友的一条评论',
				path: `/pages/circle/detail/index?commentId=${item.commentId}`
			}
		},
		// leftClick() {
		// 	uni.switchTab({
		// 		url: '/pages/index/index'
		// 	})
		// }
	}
}
</script>

<style lang="scss" scoped>
.content {
	padding: 0 30rpx;
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

				.talk_content_name {}

				.talk_content_time {
					font-size: 22rpx;
					line-height: 32rpx;
					color: #8c8c8c;
				}

			}
		}

		.talk_content_desc {
			line-height: 40rpx;
		}

		.talk_content_img {
			margin: 24rpx 0;
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
</style>
