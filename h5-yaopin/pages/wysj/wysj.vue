<!-- 我要送检 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="我要送检" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
        <!-- <view class="box_2 flex-col">
                <view class="text-wrapper_2">
                    <text class="paragraph_1">
                        2022年国家癌症中心发布报告中国有约4820000例新发癌症病例，以及有3210000例癌症死亡。
                        <br />
                        中国是全世界病发率和死亡率是世界最高的国家。
                        <br />
                        所以在中国仿制药的需求也是最大的。
                        <br />
                        但是由于各个国家的仿制水平以及有作假存在，对中国的患者是极其不友好。
                        <br />
                        所以我们提供一份药品检测服务。
                        <br />
                        只要你心存怀疑，都可以联系我们邮寄送检。
                        <br />
                    </text>
                    <view class="text_4">1.送样要求</view>
                    <text class="paragraph_2">
                        <br />
                        样品可以将完整包装的或者用洁净袋子包好一片/粒。快递时注意保护，避免被压碎。检测会把样品全部消耗掉，故无法退回。
                        <br />
                        请提供完整的包装盒照片（如为盒装的，应有药盒的六面照片，有清晰可见的批号信息），以及样品内包装照片。
                        <br />
                    </text>
                    <view class="text_5">2.我们可以做到</view>
                    <text class="paragraph_3">
                        <br />
                        通过专业检测，我们可以确认送检药品中是否含有效药品成分，以及送检药品中有效成分的含量数值，同时，我们也将定期发布送检样品的检测结果。
                    </text>
                </view>
                                                </view> -->
            <view class="info">
                <u-parse :content="info"></u-parse>
            </view>

        </view>
        <view class="bottomBtn">
            <u-button class="submit" @click="submitForm">联系客服，协助送检</u-button>
        </view>
    </view>
</template>

<script>
export default {
    data() {
        return {
            info: ''
        }
    },
    onLoad(option) {
        this.content = { goodsId: option.goodsId, serverId: option.serverId || 6 }
        this.getHeight()
        this.getContent()
        this.getContent()
    },
    methods: {
        getContent() {
            const params = {
                serverId: this.content.serverId
            }
            if (this.content.goodsId) {
                params.goodsId = this.content.goodsId
            }
            this.$store.dispatch('home/goodsSubject', params).then(res => {
                const data = res.data
                this.info = data && data.content || ''
            })
        },
        submitForm() {
            uni.navigateTo({
                url: "/pages/ptlxwm/ptlxwm"
            })
        }

    }
}
</script>

<style lang="scss" scoped>
.content {
    padding: 30rpx;
}

.bottomBtn {
    position: fixed;
    z-index: 2;
    width: calc(100% - 56rpx);
    left: 28rpx;
    bottom: 40rpx;

    .submit {
        height: 88rpx;
        background: #0FC8AC;
        border-radius: 44rpx;
        color: #fff;
        font-size: 32rpx;
        font-weight: 600;
    }

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
