<!-- 扫码有风险 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="说明书" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <scroll-view class="content" :scroll-into-view="scrollView" scroll-with-animation
            :style="{ height: scrollViewheight - 70 + 'px' }" scroll-y @scroll="scroll">
            <view class="swiper-content" id="swiper">
                <u-swiper :list="list" :height="parseInt(imgWidth * 3 / 4) + 'px'" @change="e => currentNum = e.current"
                    :autoplay="false" indicatorStyle="right: 20px">
                    <view slot="indicator" class="indicator-num">
                        <text class="indicator-num__text">{{ currentNum + 1 }}/{{ list.length }}</text>
                    </view>
                </u-swiper>
                <view class="label-icon" @click="showSlide" :style="{ top: isH5 ? '30rpx' : slideTop + 15 + 'px' }">
                    <u-image :src="$utils.getImgUrl('sms-label.png')" width="52rpx" height="52rpx"></u-image>
                </view>
            </view>
            <view class="box-info">
                <view style=" color: #333">{{ info.commonName }}</view>
                <view style="color: #999;margin: 10rpx 0">{{ info.companyName }}</view>
                <view>
                    <view v-if="info.marketTag" class="items_icon">{{ info.marketTag }}</view>
                    <view v-if="info.medicalTag" class="items_icon">{{ info.medicalTag }}</view>
                </view>
            </view>
            <u-gap height="10" bgColor="#F8F8F8"></u-gap>
            <view class="label">说明书</view>
            <view class="info-content">
                <view class="info-top">
                    <view style="margin-bottom: 10rpx; ">
                        <text class="gray">药品名称：</text>
                        <text>{{ info.goodsName }}</text>
                    </view>
                    <view>
                        <text class="gray">英文名：</text>
                        <text>{{ info.enName }}</text>
                    </view>

                </view>
                <view class="info" v-for="(item, index) in infoList" :key="index" :id="item.keyword">
                    <view class="title">{{ item.name }}</view>
                    <view class="text-content">{{ item.content }}</view>
                </view>
            </view>

            <view class="to_top" v-if="isTop" @click="scrolltoTop">
                <u-image :src="$utils.getImgUrl('to-top.png')" width="32rpx" height="32rpx"></u-image>
                <view class="">顶部</view>
            </view>
        </scroll-view>

        <view class="bottomBtn">
            <u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" color="#0FC8AC" @click="wyjc">我要纠错</u-button>
            <u-button :customStyle="{ flex: 2, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
                @click="tjkf">了解更多信息添加客服微信</u-button>
        </view>
        <u-popup :show="show" mode="right" @close="close" :customStyle="{ width: '280rpx' }" @open="open">
            <view class="pop-content">
                <view v-if="!isH5" :style="{ 'background-color': '#0FC8AC', height: `${slideTop}px`, width: '100%' }">
                    <view style="background-color: rgba(0,0,0,0.5) ;width: 100%;height: 100%"></view>
                </view>
                <view class="label" style="margin-left: -80rpx;">目录切换</view>
                <scroll-view :style="{ height: listHeight }" scroll-y :scroll-top="scrollIntoView" @scroll="popScroll">
                    <view style="display: flex;align-items: center; flex-direction: column;">
                        <view v-for="(item, index) in infoList" :id="item.keyword" :key="index" class="pop-item"
                            :class="{ 'pop-item-select': item.pick }" @click="goItems(item)">
                            {{ item.name }}
                        </view>
                    </view>
                </scroll-view>

            </view>
        </u-popup>
    <!-- <u-modal :show="errShow" title="我要纠错" confirmText="保存" confirmButtonShape="circle" confirmColor="#0FC8AC"
            @confirm="errConfirm" closeOnClickOverlay @close="errClose">
            <view class="slot-content">
                <view v-for="(errItem, i) in errList" :key="i" class="err-item" :class="{ 'err-item-select': errItem.pick }"
                    @click="pickErr(errItem)">
                    {{ errItem.name }}
                </view>
            </view>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            </u-modal> -->
        <PopModal :show="errShow" title="我要纠错" confirmText="提交" @confirm="errConfirm" @close="errClose">
            <view class="slot-content">
                <view v-for="(errItem, i) in errList" :key="i" class="err-item" :class="{ 'err-item-select': errItem.pick }"
                    @click="pickErr(errItem)">
                    {{ errItem.name }}
                </view>
            </view>
        </PopModal>
    </view>
</template>

<script>
import { throttle } from '@/utils/utils'
import PopModal from '../../components/pop-modal/pop-modal.vue';
export default {
    components: {
        PopModal
    },
    data() {
        return {
            throttle,
            list: [],
            currentNum: 0,
            info: {},
            infoList: [],
            errList: [],
            show: false,
            goodsId: "",
            scrollView: "",
            isTop: false,
            errShow: false,
            scrollIntoView: 0,
            scrollTop: 0
        };
    },
    computed: {
        imgWidth() {
            return parseInt(uni.getSystemInfoSync().windowWidth);
        },
        slideTop() {
            return this.isH5 ? 0 : uni.getSystemInfoSync().statusBarHeight + 44;
        },
        listHeight() {
            return this.scrollViewheight - 70 + 'px'
        },
    },
    onLoad(option) {
        this.goodsId = option.goodsId || "1198";
        this.getHeight();
        this.getContent();
    },
    methods: {
        open() {
            this.scrollIntoView = this.scrollTop
        },
        getContent() {
            let that = this;
            let params = {
                goodsId: that.goodsId || "1"
            };
            that.$store.dispatch("home/instructions", params).then(res => {
                this.info = res.data.goodsInfo || {};
                this.list = res.data.goodsInfo.bigImage || [];
                this.infoList = res.data.directory || [];
                const copyList = JSON.parse(JSON.stringify(res.data.directory))
                this.errList = [...copyList, { keyword: "image", name: "图片" }, { keyword: "other", name: "其他选项" }];
            });
        },
        showSlide() {
            this.show = true;
        },
        wyjc() {
            this.errShow = true;
        },
        tjkf() {
            uni.navigateTo({
                url: "/pages/lxwm/lxwm"
            });
        },
        close() {
            this.show = false;
        },
        goItems(item) {
            this.infoList.map(_ => _.pick = false);
            item.pick = true;
            this.scrollView = item.keyword;
            this.close();
            this.$nextTick(() => {
                this.scrollView = "";
            });
        },
        popScroll(e) {
            this.scrollTop = e.detail.scrollTop
        },
        scroll(e) {
            const top = parseInt(e.detail.scrollTop);
            this.isTop = top > 200;
        },
        scrolltoTop() {
            this.isTop = false;
            this.scrollView = "swiper";
            this.$nextTick(() => {
                this.scrollView = "";
            });
        },
        pickErr(item) {
            this.$set(item, "pick", !item.pick);
        },
        errClose() {
            this.errShow = false;
        },
        errConfirm() {
            const arr = this.errList.filter(_ => _.pick).map(_ => _.keyword);
            if (!arr.length) {
                if (res.code == 200) {
                    uni.showToast({
                        title: "请选择纠错类目"
                    });
                }
            }
            const params = {
                goodsId: this.goodsId,
                keywords: arr.join(",")
            };
            this.$store.dispatch("home/errorRecovery", params).then(res => {
                if (res.code == 200) {
                    uni.showToast({
                        title: "提交成功"
                    });
                    this.errClose();
                }
            });
        }
    },
}
</script>

<style lang="scss" scoped>
.content {
    .swiper-content {
        position: relative;

        .label-icon {
            position: fixed;
            top: 30rpx;
            right: 30rpx;
        }
    }

    .to_top {
        width: 96rpx;
        height: 96rpx;
        display: flex;
        position: fixed;
        z-index: 1;
        bottom: 300rpx;
        right: 30rpx;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        border-radius: 100%;
        background-color: #0FC8AC;
        color: white;
        font-size: 24rpx;
    }




    .info-content {
        font-size: 28rpx;
        line-height: 40rpx;
        padding: 0rpx 30rpx 20rpx 30rpx;

        .info-top {
            padding: 20rpx 0;
        }

        .gray {
            color: #999999
        }

        .info {
            color: #333333;
            padding: 10rpx 30rpx;

            .title {
                font-weight: bold;
                margin-bottom: 10rpx;
            }

            .text-content {
                white-space: pre-wrap;
            }
        }
    }

    .box-info {
        margin: 20rpx 30rpx;

        .items_icon {
            display: inline-block;
            margin-right: 20rpx;
            height: 44rpx;
            background: rgba(255, 147, 48, 0.1);
            color: #FF9330;
            font-size: 22rpx;
            line-height: 44rpx;
            padding: 0 8rpx;
            border-radius: 8rpx;
        }
    }


    .indicator-num {
        padding: 2px 0;
        background-color: rgba(0, 0, 0, 0.35);
        border-radius: 100px;
        width: 35px;
        @include flex;
        justify-content: center;

        &__text {
            color: #FFFFFF;
            font-size: 12px;
        }
    }
}

.slot-content {
    padding: 30rpx;
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    gap: 40rpx;
    justify-content: center;
    max-height: 500rpx;
    overflow-y: auto;

    .err-item {
        min-width: 200rpx;
        min-height: 70rpx;
        padding: 5rpx 10rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: white;
        border: 1px solid #CACACA;
        margin: 20rpx 0;
        border-radius: 8rpx;
    }

    .err-item-select {
        border: 1px solid#0fc8ac;
        color: #0fc8ac
    }
}

.label {
    font-size: 32rpx;
    font-weight: bold;
    line-height: 44rpx;
    padding: 20rpx 30rpx;
}

.pop-content {
    display: flex;
    flex-direction: column;
    align-items: center;

    .pop-item {
        width: 200rpx;
        min-height: 70rpx;
        padding: 5rpx 10rpx;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #F2F3F5;
        margin: 20rpx 0;
        border-radius: 8rpx;
    }

    .pop-item-select {
        background-color: #0fc8ac;
        color: white
    }
}

.bottomBtn {
    position: fixed;
    z-index: 1;
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
