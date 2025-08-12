<template>
    <view v-if="content.username" class="item-content" @click="huifu(content)">
        <view class="talk_content_item">
            <u-image :src="content.avatar" shape="circle" width="70rpx" height="70rpx">
            </u-image>
            <view class="talk_content">
                <view class="talk_content_name">{{ content.username }}</view>
                <view class="talk_content_time">{{ content.created }}</view>
            </view>
        </view>
        <view class="talk_content_desc">{{ content.content }}</view>
        <view class="talk_content_img">
            <u-image radius="8rpx" v-for="(img, imgkey) in content.pictures" :height="imgWidth" :width="imgWidth" :src="img"
                :errorIcon="$utils.getImgUrl('empty-goods.png')" :key="imgkey" />
        </view>
        <view class="talk_bottom">
            <view class="talk_bottom_item" @tap.stop="toCommentLike(content)">
                <u-image v-if="content.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"
                    width="32rpx" height="32rpx"></u-image>
                <u-image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')" width="32rpx"
                    height="32rpx"></u-image>
                <view class="talk_bottom_item_nums">
                    {{ content.likeNum }}
                </view>
            </view>
            <view class="talk_bottom_item">
                <u-image :src="$utils.getImgUrl('message.png')" width="32rpx" height="32rpx"></u-image>
                <view class="talk_bottom_item_nums">
                    {{ content.commentNum }}
                </view>
            </view>
            <!-- 分享 -->
            <view class="talk_bottom_item">
                <u-button :customStyle="customStylea" openType="share" :icon="$utils.getImgUrl('share.png')"
                    @tap.stop="shareComment(content)">
                </u-button>
            </view>
        </view>
        <u-line></u-line>
    </view>
</template>
<script>
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
    mounted() {
        this.content = this.items
    },
    computed: {
        imgWidth() {
            return parseInt(uni.getSystemInfoSync().windowWidth - 48) / 3 + 'px'
        }
    },
    onLoad(option) {
        this.getHeight();
    },
    methods: {
        /**
         * 点赞
         */
        toCommentLike(item) {
            let that = this
            let params = {
                commentId: item.commentId
            }
            that.$store.dispatch('home/getHomeCommentLike', params).then(res => {
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
            uni.navigateTo({
                url: `/pages/tieDetail/tieDetail?commentId=${item.commentId}`
            })
        },
        shareComment(item) {
            let that = this
            that.share = {
                title: '你收到来自朋友的一条评论',
                path: `/pages/tieDetail/tieDetail?commentId=${item.commentId}`
            }
        },
    }
};
</script>

<style lang="scss" scoped>
.item-content {
    margin: 40rpx 0 22rpx 0;
    padding: 0 30rpx;
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
</style>
