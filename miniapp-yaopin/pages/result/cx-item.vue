<!--  -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" :title="title" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
       <scroll-view scroll-y   class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
        <!-- <view class="imgContent">
                <u-image :src="info.img"></u-image>
                                                                                                                                    </view> -->
            <view class="info">
                <u-parse :content="info"></u-parse>
            </view>
        </scroll-view>
        <view class="bottomBtn">
            <u-button shape="circle" color="#0FC8AC" @click="tjkf">联系客服</u-button>
        </view>
    </view>
</template>

<script>
import {goodsSubjectReq} from '@/api/goodsApi.js'
export default {
    props: {
        title: {
            type: String,
            default: "",
        },
        content: {
            type: Object,
            default: () => { },
        }

    },
    data() {
        return {
            info: ''
        }
    },
    mounted() {
        this.getContent()
    },
    methods: {
        getContent() {
            const params = {
                ...this.content
            }
            goodsSubjectReq(params).then(res => {
                const data = res.data
                this.info = data && data.content || ''
            })
        },
        tjkf() {
            uni.navigateTo({
                url: "/pages/ptlxwm/ptlxwm?hide_phone=1"
            })
        },
    }
}
</script>

<style lang="scss" scoped>
.content {
	box-sizing: border-box;
    .imgContent {
        margin: 20rpx;
    }
}

.info {
    padding: 40rpx 30rpx 158rpx;
    img {
        width: auto;
        height: auto;
        max-width: 100%;
        max-height: 100%;
        margin: 0 auto;
    }
}

.bottomBtn {
    position: fixed;
    z-index: 2;
    width: calc(100% - 56rpx);
    left: 28rpx;
    bottom: 40rpx;
    display: flex;
    flex-direction: row;
    align-items: center;

    .submit {
        height: 88rpx;
        background: #0FC8AC;
        border-radius: 44rpx;
        color: #fff;
        font-size: 32rpx;
        font-weight: 600;
    }
}
</style>
