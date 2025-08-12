<!-- 国外有防伪 -->
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
            <u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" color="#0FC8AC"
                @click="tjkf">了解更多信息</u-button>
            <u-button :customStyle="{ flex: 2, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
                @click="ljcx">立即查询</u-button>
        </view>
    </view>
</template>

<script>
export default {
    data() {
        return {
            goodsId: '',
            info: '',
            content: {}
        }
    },
    onLoad(option) {
        this.content = { goodsId: option.goodsId, serverId: option.serverId || 2 }
        this.getHeight()
        this.getContent()
    },
    methods: {
        getContent() {
            let that = this
            let params = {
                ...this.content
            }
            this.$store.dispatch('home/goodsSubject', params).then(res => {
                this.info = res.data.content
            })
        },
        tjkf() {
            uni.navigateTo({
                url: "/pages/lxwm/lxwm"
            })
        },
        ljcx() {
            uni.navigateTo({
                url: "/pages/zzcx/yccx"
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.content {

    .top-content {
        padding: 30rpx;

        .top-box {
            background-color: rgba(252, 81, 30, 0.10);
            border: 1px solid #FC511E;
            padding: 15rpx 30rpx;
            font-size: 40rpx;
            line-height: 56rpx;
            font-weight: bold;
        }

        .gray {
            font-size: 28rpx;
            line-height: 40rpx;
            color: #999999;
        }
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
