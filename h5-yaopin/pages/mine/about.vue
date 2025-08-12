<!-- 关于 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="关于掌上药店" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <view class="top-content">
                <u-image :src="info.download" width="320rpx" height="320rpx"></u-image>
                <view style="margin: 30rpx 0 50rpx 0"><text style="color: #333">{{ info.version }}</text></view>
                <view class="gray">客服热线：<text style="color: #333">{{ info.mobile }}</text></view>
            </view>
            <u-gap color="#F8F8F8" height="20rpx"></u-gap>
        </view>
    </view>
</template>

<script>
export default {
    data() {
        return {
            goodsId: '',
            info: ''
        }
    },
    onLoad(option) {
        this.goodsId = option.goodsId
        this.getHeight()
        this.getContent()
    },
    methods: {
        getContent() {
            let that = this
            let params = {}
            that.$store.dispatch('home/getAbout', params).then(res => {
                this.info = res.data
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.content {
    .top-content {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-top: 60rpx;

        .top-box {
            background-color: #F2F3F5;
            padding: 10rpx;
        }

        .gray {
            font-size: 28rpx;
            line-height: 40rpx;
            color: #999999;
        }
    }
}
</style>
