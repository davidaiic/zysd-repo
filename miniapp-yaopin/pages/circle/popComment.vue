<!-- 资讯评论 -->
<template>
    <u-popup :show="show" mode="bottom" @close="close">
        <view class="pop-content">
            <u--textarea v-model="inputValue" placeholder="请输入内容" height="90" :cursorSpacing="space"
                adjustPosition></u--textarea>
            <view class="picArray">
                <e-upload-item class="picArray_item" v-model="picList" maxCount='3' width="100rpx" height="100rpx"
                    placeHolder="上传">
                </e-upload-item>
            </view>
            <view class="showImport p15">
                <view class="showImport_top">
                    重要提示:网友、医生言论仅代表其个人观点，不代表本站同意其说法，请谨慎发帖参阅，本站不承担由此引起的法律责任。
                </view>
                <view class="showImport_bottom" @click="guifan">
                    查看《评论规范公约》
                </view>
            </view>
            <view class="bottom-bt">
                <u-button shape="circle" color="#0FC8AC" @click="confirm">发布</u-button>
            </view>
        </view>
    </u-popup>
</template>

<script>
import {
    transImg
} from '@/utils/utils.js';
import {addArticleCommentReq} from '@/api/home.js'

export default {
    data() {
        return {
            show: false,
            inputValue: '',
            picList: [],
            articleId: '',
        };
    },
    computed: {
        space() {
            return this.picList.length > 6 ? 320 : 270
        }
    },
    methods: {
        init(articleId) {
            this.show = true
            this.articleId = articleId
        },
        close() {
            this.show = false
        },
        guifan() {
            uni.navigateTo({
                url: '/pages/plgy/plgy'
            })
        },
        confirm() {
            const that = this;
            if (!this.inputValue) {
                uni.showToast({
                    icon: 'none',
                    title: '请输入内容'
                })
                return false
            }
            if (this.inputValue.length < 10) {
                uni.showToast({
                    icon: 'none',
                    title: '请输入不少于10个字的内容'
                })
                return false
            }
            const params = {
                articleId: that.articleId,
                content: that.inputValue,
                pictures: transImg(that.picList)
            }

            addArticleCommentReq(params).then(res => {
                if (res.code == 200) {
                    uni.showToast({
                        icon: 'none',
                        title: '发布成功',
                        duration: 1500,
                        success() {
                            that.$emit('success')
                            that.inputValue = ''
                            that.picList = []
                            that.close()
                        }
                    })
                } else {
                    uni.showToast({
                        icon: 'none',
                        title: res.message || '发布失败'
                    })
                }
            })

        }
    }
};
</script>

<style lang="scss" scoped>
.pop-content {
    padding: 20rpx 30rpx;

    .picArray {
        margin-top: 20rpx;
    }

    .showImport {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        flex-direction: column;
        margin-bottom: 20rpx;

        .showImport_top {
            display: flex;
            // background: rgba(15, 200, 172, 0.1);
            border-radius: 8rpx;
            // border: 2rpx solid #0FC8AC;
            padding: 20rpx;
            color: #666666;
            font-size: 24rpx;
            font-weight: 400;
        }

        .showImport_bottom {
            // margin-top: 20rpx;
            margin: 0 20rpx;
            font-size: 24rpx;
            font-weight: 600;
            color: #0FC8AC;
            line-height: 40rpx;
        }
    }

    .bottom-bt {
        margin-bottom: 20rpx;
    }
}
</style>
