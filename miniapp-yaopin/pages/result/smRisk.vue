<!-- 扫码有风险 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="查询完成" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <view class="top-content">
                <view class="top-box">非常抱歉！暂时未查询到该药品的注册信息，该药品可能存在非法上市的风险！</view>
            <!-- <view class="gray">查询时间：<text style="color: #333">{{ info.queryTime }}</text></view>
                <view class="gray">
                    查询来源：<text style="color: #333;word-break: break-all;">{{ info.dataSources
                    }}</text>
                        </view> -->
            </view>
            <u-gap bgColor="#F8F8F8" height="20rpx"></u-gap>
            <view class="info">
                <u-parse :content="info.solutionText"></u-parse>
            </view>
        </view>
        <view class="bottomBtn">
            <u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" color="#0FC8AC" @click="ljsc">立即上传</u-button>
            <u-button :customStyle="{ flex: 1, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
                @click="wysj">我要送检</u-button>
        </view>
    </view>
</template>

<script>
import {goodsRiskReq} from '@/api/home.js'
export default {
    data() {
        return {
            goodsId: '',
            info: ''
        }
    },
    onLoad(option) {
        this.goodsId = option.goodsId || 100
        this.getContent()
    },
	onShow(){
		// #ifdef H5
		document.title = '查询完成'
		//#endif
	},
    methods: {
        getContent() {
            let that = this
            let params = {
                goodsId: that.goodsId
            }
            goodsRiskReq(params).then(res => {
                this.info = res.data
            })
        },
        ljsc() {
            uni.navigateTo({
                url: "/pages/rghc/zpcx"
            })
        },
        wysj() {
            uni.navigateTo({
                url: "/pages/wysj/wysj"
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
            color: #FC511E;
            padding: 15rpx 30rpx;
            font-size: 40rpx;
            line-height: 56rpx;
            font-weight: bold;
            margin-bottom: 30rpx;
        }

        .gray {
            font-size: 28rpx;
            line-height: 40rpx;
            color: #999999;
        }
    }

    .info {
        padding: 30rpx;
        line-height: 40rpx;

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
