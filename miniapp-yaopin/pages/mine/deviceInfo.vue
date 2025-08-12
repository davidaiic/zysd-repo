<!-- 设备属性信息 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="设备属性信息" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <scroll-view scroll-y  class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <u-parse :content="zcInfo"></u-parse>
        </scroll-view>
    </view>
</template>

<script>
import {pluginContentReq} from '@/api/home.js'
export default {
    data() {
        return {
            zcInfo: ''
        }
    },
    onLoad() {
        this.getContent()
    },
	onShow() {
		// #ifdef H5
		document.title = '设备属性信息'
		//#endif
	},
    methods: {
        getContent() {
            let that = this
            let params = {
                keyword: 'deviceInfo'
            }
            pluginContentReq(params).then(res => {
                this.zcInfo = res.data.content
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.content {
    padding: 40rpx 30rpx 30rpx;
	box-sizing: border-box;

}
</style>
