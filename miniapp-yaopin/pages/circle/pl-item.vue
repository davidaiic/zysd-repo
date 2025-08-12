<template>
    <view v-if="content.username" class="item-content" @click="huifu(content)">
        <view class="talk_content_item">
			<image class="avatar-img" :src="content.avatar"></image>
            <view class="talk_content">
                <view class="talk_content_name">{{ content.username }}</view>
                <view class="talk_content_time">{{ content.created }}</view>
            </view>
        </view>
        <view class="talk_content_desc">{{ content.content }}</view>
        <view class="talk_content_img">
			<view class="item-img"  v-for="(img, imgkey) in content.pictures" :key="item">
				<image :src="img" mode="widthFix" class="image"/>
			</view>
        </view>
        <view class="talk_bottom">
            <view class="talk_bottom_item" @tap.stop="toCommentLike(content)">
				<image v-if="content.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"></image>
				<image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"></image>
                <view class="talk_bottom_item_nums">
                    {{ content.likeNum }}
                </view>
            </view>
            <view class="talk_bottom_item">
				<image class="talk_bottom_item_img" :src="$utils.getImgUrl('message.png')"></image>
                <view class="talk_bottom_item_nums">
                    {{ content.commentNum }}
                </view>
            </view>
			<view class="talk_bottom_item">
				<button class="wechat-btn" openType="share"
					@tap.stop="shareComment(content)">
					<u-image :src="$utils.getImgUrl('share.png')" width="32rpx" height="32rpx"></u-image>
				</button>
			</view>
        </view>
    </view>
</template>
<script>
	
import {commentLikeReq} from "@/api/home.js"
export default {
    props: {
        items: {
            type: Object,
            default: () => { }
        }
    },
    data() {
        return {
            keyword: '',
            labelType: 1,
            // items: {},
            customStylea: {
                border: 'none',
                padding: '0',
                margin: '0',
                height: '32rpx',
                width: '32rpx'
            },
            content: {}
        };
    },
	watch:{
		items: {
		  handler(val, oldval) {
		    this.content = val
		  },
		  immediate: false,
		  deep: true
		},
	},
    mounted() {
        this.content = this.items
    },
    onLoad(option) {
    },
    methods: {
        /**
         * 点赞
         */
        toCommentLike(item) {
            let that = this
			if(!this.$store.getters.isLogin){
				this.$utils.toLogin()
				return
			}
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
                            that.$set(item, 'isLike', 1)
                            item.likeNum = Number(item.likeNum) + 1

                        }
                    })
                } else {
                    uni.showToast({
                        icon: 'none',
                        duration: 1500,
                        title: '取消点赞成功',
                        success() {
                            that.$set(item, 'isLike', 0)
                            item.likeNum = Number(item.likeNum) - 1
                        }
                    })
                }
            })
        },
        getCommentList() { },
        /**
         * 帖子回复
         */
        huifu(item) {
			let url = `/pages/circle/detail/index?commentId=${item.commentId}`
			this.$utils.goOthersCheckLogin(url)
        },
        shareComment(item) {
            let that = this
            that.share = {
                title: '你的朋友分享了一个好内容给你',
                path: `/pages/circle/detail/index?commentId=${item.commentId}`
            }
        },
    }
};
</script>

<style lang="scss" scoped>
.item-content {
    margin: 0rpx 30rpx;
	padding: 40rpx 0 24rpx 0;
	border-bottom:1px solid #d6d7d9;
}

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
</style>
