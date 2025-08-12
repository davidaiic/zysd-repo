<template>
    <view class="item-content" v-if="content.title" @click="goDetail(content)">
        <view class="left-content">
            <u--text lines="2" bold color="#333" :text="content.title"></u--text>
            <view class="label-box">
                <view v-for="label in content.label" :key="label" class="icon">{{ label }}</view>
				<br>
				<view class="text">{{ content.created }}</view>
				<view class="text">{{ content.readNum }}人阅读</view>
            </view>
            <view class="bottom-box">
                <view class="talk_bottom">
                    <view class="talk_bottom_item" @tap.stop="toCommentLike(content)">
						<image v-if="content.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"></image>
						<image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"></image>
                        <view class="talk_bottom_item_nums">
                            {{ content.likeNum }}
                        </view>
                    </view>
                    <view class="talk_bottom_item">
                        <u-image :src="$utils.getImgUrl('message.png')" width="32rpx" height="32rpx">
                        </u-image>
                        <view class="talk_bottom_item_nums">
                            {{ content.commentNum }}
                        </view>
                    </view>
                    <!-- 分享 -->
					<view class="talk_bottom_item">
						<button class="share-btn" openType="share"
							@tap.stop="shareComment(content)">
							<u-image :src="$utils.getImgUrl('share.png')" width="32rpx" height="32rpx"></u-image>
						</button>
					</view>
                </view>
            </view>
        </view>
        <view class="right-content">
            <u-image radius="16rpx" :src="content.cover" width="180rpx" height="180rpx"
                :errorIcon="$utils.getImgUrl('empty-goods.png')" />
        </view>
    </view>
</template>

<script>
import {articleLikeReq} from '@/api/home.js'
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
        toCommentLike(item) {
			if(!this.$store.getters.isLogin){
				this.$utils.toLogin()
				return
			}
            let that = this
            let params = {}
            params = {
                articleId: item.articleId
            }

            articleLikeReq(params).then(res => {
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
        shareComment(item) {
            let that = this
            that.share = {
                title: '你的朋友分享了一篇资讯给你，赶紧点开看下吧',
                path: `/pages/circle/zxDetail?articleId=${item.articleId}`
            }
        },
        goDetail(item) {
			this.content.readNum = parseInt(this.content.readNum) +1
			let url = `/pages/circle/zxDetail?articleId=${item.articleId}`
			this.$utils.goOthersCheckLogin(url)
        }
    }
};
</script>

<style lang="scss" scoped>
.item-content {
    position: relative;
    min-height: 180rpx;
    padding: 30rpx 0 ;
    margin: 0 30rpx;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1rpx solid #F2F3F5;

    .right-content {
        width: 180rpx;
        height: 180rpx;
        border-radius: 16rpx;
    }

    .left-content {
        display: flex;
        flex-direction: column;
        flex: 1;
        height: 100%;
        padding-right: 50rpx;
        justify-content: space-between;

        .title {
            color: #333333;
            font-weight: 600;
        }

        .label-box {
            display: flex;
            flex-direction: row;
            align-items: center;
            flex-wrap: wrap;
            gap: 20rpx;
            margin: 10rpx 0 15rpx 0;

            .icon {
                padding: 4rpx 8rpx;
                background-color: rgba(15, 200, 172, 0.1);
                border: 4rpx;
                color: #0FC8AC;
                font-size: 22rpx;
            }


            .text {
                font-size: 24rpx;
                color: #999999;
                line-height: 34rpx;
            }

        }

        .bottom-box {
            .talk_bottom {
                // width: calc(100% - 200rpx);
                display: flex;
                flex-direction: row;
                align-items: center;

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
</style>
