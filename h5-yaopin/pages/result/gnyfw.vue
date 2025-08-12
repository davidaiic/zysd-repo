<!-- 国内有防伪 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="真伪鉴别" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <view class="info">
                <u-parse :content="info"></u-parse>
            </view>
        </view>
        <view class="bottomBtn">
            <u-button shape="circle" color="#0FC8AC" @click="tjkf">了解更多信息</u-button>
        </view>
    </view>
</template>

<script>
export default {
    data() {
        return {
            companyId: '',
            info: '',
            content: {}
        }
    },
    onLoad(query) {
        this.companyId = query.companyId
        this.getHeight()
        this.getContent()
    },
    methods: {
        getContent() {
            let that = this
            let params = {
                companyId: this.companyId || '1'
            }
            that.$store.dispatch('jgcx/getQueryCodeQuery', params).then(res => {
                this.info = res.data.codeQuery
            })
        },
        tjkf() {
            uni.navigateTo({
                url: "/pages/lxwm/lxwm"
            })
        },
    }
}
</script>

<style lang="scss" scoped>
.content {
    position: relative;

    .label {
        font-size: 32rpx;
        font-weight: bold;
        line-height: 44rpx;
        padding: 20rpx 30rpx;
    }

    .box-img {
        border-radius: 8rpx;
        margin: 0 30rpx;
    }

    .top-content {
        padding: 30rpx;

        .top-box {
            background-color: #F2F3F5;
            padding: 10rpx 25rpx;
            font-size: 40rpx;
            border-radius: 8rpx;
        }

        .gray {
            font-size: 28rpx;
            line-height: 40rpx;
            color: #999999;
        }
    }

    .info {
        padding: 30rpx;

        img {
            width: auto;
            height: auto;
            max-width: 100%;
            max-height: 100%;
            margin: 0 auto;
        }
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
