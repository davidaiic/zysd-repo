<!-- 我要送检 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="我要送检" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <scroll-view scroll-y class="content" :style="{ height: scrollViewheight -70 +'px' }">
            <view class="info">
                <u-parse :content="info"></u-parse>
            </view>

        </scroll-view>
        <view class="bottomBtn flex-row flex-c" @click="submitForm">
			联系客服，协助送检
        </view>
    </view>
</template>

<script>
import {goodsSubjectReq} from '@/api/goodsApi.js'
export default {
    data() {
        return {
            info: ''
        }
    },
    onLoad(option) {
        this.content = { goodsId: option.goodsId, serverId: option.serverId || 6 }
        this.getContent()
    },
	onShow() {
		// #ifdef H5
		document.title = '我要送检'
		//#endif
	},
    methods: {
        getContent() {
            const params = {
                serverId: this.content.serverId
            }
            if (this.content.goodsId) {
                params.goodsId = this.content.goodsId
            }
            goodsSubjectReq(params).then(res => {
                const data = res.data
                this.info = data && data.content || ''
            })
        },
        submitForm() {
            uni.navigateTo({
                url: "/pages/ptlxwm/ptlxwm?hide_phone=1"
            })
        }

    }
}
</script>

<style lang="scss" scoped>
.content {
	box-sizing: border-box;
	.info{
		padding: 30rpx 30rpx 168rpx;
	}
}
/deep/._root{
	overflow: hidden;
}
.bottomBtn {
    width: 694rpx;
	height: 88rpx;
    position: fixed;
    left: 28rpx;
    bottom: 40rpx;
    z-index: 2;
	background: #0FC8AC;
	border-radius: 44rpx;
	color: #fff;
	font-size: 32rpx;
	font-weight: 600;

    /deep/ .u-button {
        height: 88rpx;
        background: #0FC8AC;
        border-radius: 44rpx;
        color: #fff;
        font-size: 32rpx;
        font-weight: 600;
    }
}
</style>
