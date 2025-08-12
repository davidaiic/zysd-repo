<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" :title="title" :fixed="false" @leftClick="leftClick"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <u-sticky style="top: 0">
            <u-notice-bar text="该内容由识药查真伪团队搜集整理，欢迎转载！因个体差异，该内容不能作为任何用药依据，请严格按药品说明书或医嘱下购买和使用。如有不当之处欢迎指正！" bgColor="#F2F3F5"
                color="#999"></u-notice-bar>
        </u-sticky>
        <scroll-view scroll-y class="content" :style="{ height: scrollViewheight - 110 + 'px' }">

            <view class="hot_talk_content">
                <view class="hot_talk_content_item">
                    <view class="talk_content_item">
                        <u--image :src="formData.avatar" shape="circle" width="70rpx" height="70rpx">
                        </u--image>
                        <view class="talk_content">
                            <view class="talk_content_name">{{ formData.username }}</view>
                            <view class="talk_content_time">
                                <view v-for="label in formData.label" :key="label" class="icon">{{ label }}</view>
                                {{ formData.created }}
                            </view>
                        </view>
                    </view>
                    <view class="talk_content_desc">
                        <u-parse :content="formData.content"></u-parse>
                    </view>

                    <view v-if="formData.pictures && formData.pictures.length" class="talk_content_img">
                        <view v-for="(img, i) in formData.pictures" :key="i">
                            <u-image :height="parseInt(imgWidth * 3 / 4)" :width="imgWidth" :src="img"
                                :errorIcon="$utils.getImgUrl('empty-goods.png')"></u-image>
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
                            <u-image :src="items.avatar" shape="circle" width="70rpx" height="70rpx">
                            </u-image>
                            <view class="talk_content">
                                <view class="talk_content_name">
                                    <view class="talk_content_name_left">{{ items.username }}</view>
                                    <view class="talk_content_name_right" @click="toCommentLike(items)">
                                        <u-image v-if="items.isLike" class="talk_bottom_item_img"
                                            :src="$utils.getImgUrl('like.png')" width="32rpx" height="32rpx"></u-image>
                                        <u-image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')"
                                            width="32rpx" height="32rpx"></u-image>
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
                            <u-image radius="8rpx" v-for="(img, imgkey) in items.pictures" :height="imgWidth2"
                                :errorIcon="$utils.getImgUrl('empty-goods.png')" :width="imgWidth2" :src="img"
                                :key="imgkey" />
                        </view>
                        <u-line></u-line>
                    </view>
                </scroll-view>
            </view>
            <view class="hot_talk_content" v-if="isShowNoData">
                <u-empty :text='showText' mode="data"></u-empty>
            </view>
        </scroll-view>

        <!-- 评论 -->
        <view class="pl_buttom">
            <view class="pl_buttom_input">
                <!-- <u-input v-model="pinglunDetail" placeholder="写下你的评论..." confirmType="评论" adjustPosition border="surround"
                    shape="circle" @confirm="sendMessage">
                </u-input> -->
                <view class="input_bt" @click="popComment">写下您的评论～</view>
            </view>
            <view class="pl_buttom_text">
                <view class="talk_bottom_item" @click.stop="toCommentLike(formData, true)">
                    <u-image v-if="formData.isLike" class="talk_bottom_item_img" :src="$utils.getImgUrl('like.png')"
                        width="32rpx" height="32rpx"></u-image>
                    <u-image v-else class="talk_bottom_item_img" :src="$utils.getImgUrl('nolike.png')" width="32rpx"
                        height="32rpx"></u-image>
                    <view class="talk_bottom_item_nums">
                        {{ formData.likeNum }}
                    </view>
                </view>
                <view class="talk_bottom_item">
                    <u-button :customStyle="customStylea" openType="share" :icon="$utils.getImgUrl('share.png')"
                        @click.stop="shareComment(formData)">
                    </u-button>
                </view>
            </view>
        </view>
        <popComment ref="popComment" @success="success" />
    </view>
</template>

<script>
import popComment from './popComment.vue'
export default {
    components: {
        popComment
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
                commentNum: ''
            },
            title: '资讯详情',
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
            pinglunDetail: ''
        }
    },
    onLoad(option) {
        this.articleId = option.articleId
    },
    computed: {
        imgWidth() {
            return parseInt(uni.getSystemInfoSync().windowWidth - 50) + 'px'
        },
        imgWidth2() {
            return parseInt(uni.getSystemInfoSync().windowWidth - 48) / 3 + 'px'
        }
    },
    onShow() {
        this.getHeight()
        if (this.articleId) this.getCommentList()
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
        // leftClick() {
        //     uni.switchTab({
        //         url: '/pages/index/index'
        //     });
        // },
        getCommentList() {
            let params = {
                articleId: this.articleId,
                page: this.page
            }
            this.$store.dispatch('home/articleInfo', params).then(res => {
                this.formData = res.data.info
                this.commentList = res.data.commentList
                if (res.data.commentList.length < 0) this.isShowNoData = true
            })
        },
        loadMore() {
            this.page++
            this.getCommentList()
        },
        toCommentLike(item, isArticle) {
            let that = this
            let params = {}
            let type = ''
            if (isArticle) {
                params = {
                    articleId: item.articleId
                }
                type = 'home/articleLike'
            } else {
                params = {
                    commentId: item.commentId
                }
                type = 'home/articleCommentLike'
            }
            that.$store.dispatch(type, params).then(res => {
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
        /**
         * 帖子回复
         */
        sendMessage() {
            let that = this
            let params = {
                articleId: that.articleId,
                content: that.pinglunDetail
            }
            if (params.content.length < 10) {
                uni.showToast({
                    icon: 'none',
                    duration: 1500,
                    title: '请输入超过10字的内容'
                })
                return false
            }
            that.$store.dispatch('home/getHomeComment', params).then(res => {
                uni.showToast({
                    icon: 'none',
                    duration: 1500,
                    title: '已回复',
                    success() {
                        that.pinglunDetail = ''
                        uni.$u.sleep(2000).then(() => {
                            that.page = 1
                            that.getCommentList()
                        })
                    }
                })
            })
        },
        shareComment(item) {
            let that = this
            that.share = {
                title: '你收到来自朋友的一条资讯',
                path: `/pages/tieDetail/tieDetail?articleId=${that.articleId}`
            }
        },
        popComment() {
            this.$refs.popComment.init(this.articleId)
        },
        success() {
            this.getCommentList()
        }
    }
}
</script>

<style lang="scss" scoped>
.content {
    // padding: 0 30rpx;
}

.info {
    background-color: #F2F3F5;
    padding: 10rpx 30rpx;
    color: #999999;
    font-size: 24rpx;
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
                    flex-wrap: wrap;
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
            width: 100%;
            word-break: break-all;
            white-space: pre-wrap;

            /deep/ ._root {
                overflow: hidden !important;
            }

            h2 {
                padding: 5rpx 0;
            }
        }

        .talk_content_img2 {
            margin: 24rpx 0;
            display: flex;
            flex-direction: row;
            gap: 14rpx;
            flex-wrap: wrap;

            .item_img {
                border-radius: 8rpx;
            }
        }

        .talk_content_img {
            margin-bottom: 20rpx;

            .img_box {
                border-radius: 8rpx;
                margin: 20rpx;
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

.pl_buttom {
    display: inline-flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    height: 140rpx;
    width: 100vw;
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
