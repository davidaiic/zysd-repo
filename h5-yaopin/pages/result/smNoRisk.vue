<!-- 扫码无风险 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="查询详情" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
            <view class="label">说明书</view>
            <view class="top-box" @click="goSms">
                <view class="box-left">
                    <u-image :src="info.goodsInfo.goodsImage" width="240rpx" height="180rpx"></u-image>
                    <view v-if="info.goodsInfo.drugProperties" class="left_icon"
                        :style="{ backgroundColor: info.goodsInfo.drugPropertiesColor }">{{ info.goodsInfo.drugProperties }}
                    </view>
                </view>
                <view class="box-right" style="margin-left: 20rpx;">
                    <u--text lines="2" color="#333" :text="info.goodsInfo.goodsName"></u--text>
                    <view>
                        <u--text size="28rpx" lines="1" color="#999" :text="info.goodsInfo.companyName"></u--text>
                    </view>
                    <view>
                        <view v-if="info.goodsInfo.marketTag" class="items_icon">{{ info.goodsInfo.marketTag }}</view>
                        <view v-if="info.goodsInfo.medicalTag" class="items_icon">{{ info.goodsInfo.medicalTag }}</view>
                        <view v-if="info.goodsInfo.clinicalStage" class="items_icon">{{ info.goodsInfo.clinicalStage }}
                        </view>
                    </view>
                </view>
            </view>
            <u-gap height="10" bgColor="#F8F8F8"></u-gap>
            <view class="label">服务</view>
            <view class="center-box">
                <view v-for="(item, index) in info.serverList" :key="index">
                    <u-cell :title="item.serverName" :iconStyle="{ width: '60rpx', height: '60rpx', marginRight: '30rpx' }"
                        :icon="item.icon" isLink :label="item.desc" @click="goItems(item)">
                    </u-cell>
                </view>
            </view>
            <u-gap height="10" bgColor="#F8F8F8"></u-gap>
            <view class="label">资讯</view>
            <view class="bottom-box" v-if="info && info.articleList">
                <view v-for="(items, index) in info.articleList" :key="index">
                    <zxItem :items="items" />
                </view>
            </view>
            <view v-else>
                <u-empty text="暂无内容" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px" :margin-top="30">
                </u-empty>
            </view>
        </view>
    </view>
</template>

<script>
import zxItem from '../circle/zx-item.vue';

export default {
    data() {
        return {
            goodsId: '',
            info: ''
        }
    },
    components: {
        zxItem
    },
    onLoad(option) {
        console.log(option, 'sss')
        this.goodsId = option.goodsId || '1'
        this.getHeight()
        this.getContent()
    },
    methods: {
        getContent() {
            let that = this
            let params = {
                goodsId: that.goodsId || 1198
            }
            that.$store.dispatch('home/goodsServer', params).then(res => {
                this.info = res.data
            })
        },
        goItems(item) {
            uni.navigateTo({
                url: item.linkUrl.split('#')[1],
            })
        },
        goSms() {
            uni.navigateTo({
                url: '/pages/result/sms?goodsId=' + this.goodsId,
            })
        }
    }
}
</script>

<style lang="scss" scoped>
.content {
    padding: 30rpx 0;

    .label {
        font-size: 32rpx;
        font-weight: bold;
        line-height: 44rpx;
        padding: 20rpx 30rpx;
    }

    .top-box {
        display: flex;
        flex-direction: row;
        padding: 0 30rpx 20rpx 30rpx;


        .box-left {
            width: 240rpx;
            height: 180rpx;
            position: relative;

            .left_icon {
                padding: 0 12rpx;
                line-height: 36rpx;
                font-size: 24rpx;
                height: 36rpx;
                border-radius: 8rpx 0 8rpx 0;
                position: absolute;
                top: 0;
                left: 0;
                color: white;
                background-color: #0FC8AC;
            }


        }

        .box-right {
            margin-left: 20rpx;

            .items_icon {
                display: inline-block;
                margin: 12rpx 20rpx 0 0;
                height: 44rpx;
                background: rgba(255, 147, 48, 0.1);
                color: #FF9330;
                font-size: 22rpx;
                line-height: 44rpx;
                padding: 0 8rpx;
                border-radius: 8rpx;
            }
        }

    }

    .center-box {
        display: flex;
        flex-direction: column;
        padding: 0 30rpx 20rpx 30rpx;
    }

    .bottom-box {
        padding: 0 30rpx 20rpx 30rpx;

    }
}
</style>
