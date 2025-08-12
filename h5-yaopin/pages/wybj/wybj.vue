<!-- 我要比价 -->
<template>
    <view class="mainWrap" @click="outside">
        <view class="contents">
            <u-navbar v-if="!isH5" title="我要比价" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <view class="content" :style="{ height: scrollViewheight - 60 + 'px' }">
            <u-sticky style="top: 0">
                <view class="info">
                    <text class="spical-text">温馨提示：目前仅为用户提供肿瘤类原研药及仿制药的比价信息服务！</text>
                </view>
            </u-sticky>

            <view class="main-content">
                <view class="main-box-content">
                    <view class="main-box">
                        <view>
                            <searchInput keyId="goods1" :currentValue.sync="goods1" ref="goodsIput" remote
                                placeholder="输入药品" :defaultValue="defaultValue.leftGoodsName || ''" showKey="goodsName"
                                @search="goodsSearch" @complete="completeGoods" />
                        </view>
                        <view style="margin: 20rpx 0;">
                            <searchInput keyId="company1" :currentValue.sync="company1" ref="companyIput" placeholder="选择厂家"
                                showKey="companyName" :defaultValue="defaultValue.leftCompanyName || ''"
                                @search="companySearch" @check="checkGoods" @complete="completeCompany" />
                        </view>
                        <view>
                            <searchInput keyId="specs1" :currentValue.sync="specs1" ref="specsInput1" placeholder="选择规格"
                                showKey="specs" :defaultValue="defaultValue.leftSpecs || ''" @search="formatSearch"
                                @check="checkCompany" />
                        </view>
                    </view>
                    <view class="text-wrapper_2">
                        <text lines="1" class="text_26">VS</text>
                    </view>
                    <view class="main-box">
                        <view>
                            <searchInput keyId="goods2" :currentValue.sync="goods2" ref="goodsIput2" remote
                                placeholder="输入药品" :defaultValue="defaultValue.rightGoodsName || ''" showKey="goodsName"
                                @search="goodsSearch2" @complete="completeGoods2" />
                        </view>
                        <view style="margin: 20rpx 0;">
                            <searchInput keyId="company2" :currentValue.sync="company2" ref="companyIput2"
                                placeholder="选择厂家" :defaultValue="defaultValue.rightCompanyName || ''" showKey="companyName"
                                @search="companySearch2" @check="checkGoods2" @complete="completeCompany2" />

                        </view>
                        <view>
                            <searchInput keyId="specs2" :currentValue.sync="specs2" ref="specsInput2" placeholder="选择规格"
                                showKey="specs" :defaultValue="defaultValue.rightSpecs || ''" @search="formatSearch2"
                                @check="checkCompany2" />
                        </view>
                    </view>
                </view>
                <view class="button-main">
                    <u-button shape="circle" color="#0FC8AC" @click="wybj">我要比价</u-button>
                </view>

            </view>
            <u-gap bgColor="#F2F3F5" height="20rpx" />
            <view v-if="goodsList && goodsList.length" class="result-content">
                <view class="port_title">
                    <view>
                        比价结果
                    </view>
                </view>
                <view class="hot_content">
                    <view class="hot_content_items" v-for="(its, ids) in goodsList" @click="goGoods(its)">
                        <u-image :src="its.goodsImage" width="100%" height="200rpx"
                            :errorIcon="$utils.getImgUrl('empty-goods.png')"></u-image>
                        <view class="item_title">{{ its.goodsName }}</view>
                        <view class="item_name">{{ its.companyName }}</view>
                        <view>
                            <view v-if="its.marketTag" class="items_icon">{{ its.marketTag }}</view>
                            <view v-if="its.medicalTag" class="items_icon">{{ its.medicalTag }}</view>
                            <view v-if="its.clinicalStage" class="items_icon">{{ its.clinicalStage }}</view>
                        </view>
                        <view class="item_num" style="color: red">价格：¥{{ its.minPrice }}</view>
                        <view class="item_num" style="margin-bottom: 12rpx;">所在地区： {{ its.marketPlace }}</view>

                        <view v-if="its.drugProperties" class="left_icon"
                            :style="{ backgroundColor: its.drugPropertiesColor }">{{ its.drugProperties }}</view>
                        <view class="warning_icon" v-if="its.risk == 1">
                            <u-image :src="$utils.getImgUrl('warning.png')" width="180rpx" height="224rpx"></u-image>
                        </view>
                    </view>
                </view>
            </view>
            <view class="result-content" style="line-height: 40rpx; padding-top: 0;">
                <u-parse :content="compareText"></u-parse>
            </view>
        </view>
        <view v-if="goodsList && goodsList.length" class="bottomBtn">
            <u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" openType="share" color="#0FC8AC"
                @click="wyfx">我要分享</u-button>
            <u-button :customStyle="{ flex: 2, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
                @click="tjkf">了解更多信息添加客服微信</u-button>
        </view>
    </view>
</template>

<script>
import searchInput from './search-input.vue';
import { bridgrCall } from '@/utils/bridge'

export default {
    components: {
        searchInput
    },
    data() {
        return {
            goodsList: [],
            share: {},
            goods1: {},
            company1: {},
            specs1: {},
            specs2: {},
            goods2: {},
            company2: {},
            defaultValue: {
                leftGoodsName: '',
                leftCompanyId: '',
                leftSpecs: '',
                rightGoodsName: '',
                rightCompanyId: '',
                rightSpecs: '',
                leftCompanyName: '',
                rightCompanyName: '',
            },
            compareText: ''
        }
    },
    computed: {
        price() {
            return function (item) {
                // if (item.minPrice === item.maxPrice) {
                //     return `￥${item.minPrice}`
                // } else {
                //     return `¥${item.minPrice}～¥${item.maxPrice}`
                // }
            }
        }
    },

    onLoad(option) {
        this.getCompareText()
        if (option.goodsId) {
            this.getGoods(option.goodsId)
            return
        }
        this.defaultValue = decodeURIComponent(option.data) === 'undefined' ? {} : JSON.parse(decodeURIComponent(option.data))
        if (this.defaultValue.rightGoodsName) {
            wyfx()
        } else {
            this.defaultValue = {}
        }
    },
    // 1.发送给朋友
    onShareAppMessage(res) {
        return {
            title: this.share.title,
            path: this.share.path,
            imageUrl: this.share.imageUrl,
        }
    },
    //2.分享到朋友圈
    onShareTimeline(res) {
        return {
            title: this.share.title,
            path: this.share.path,
            imageUrl: this.share.imageUrl,
        }
    },
    methods: {
        getGoods(goodsId) {
            this.$store.dispatch('home/getGoodsInfo', { goodsId: goodsId }).then(res => {
                const data = res.data.goodsInfo
                this.defaultValue = {
                    leftGoodsName: data.goodsName,
                    leftCompanyId: data.companyId,
                    leftSpecs: data.specs,
                    rightGoodsName: data.goodsName,
                    rightCompanyId: '',
                    rightSpecs: '',
                    leftCompanyName: data.companyName,
                    rightCompanyName: '',
                }
            })
        },
        getCompareText() {
            const data = {
                keyword: 'comparePrice'
            }
            this.$store.dispatch('home/getPluginContent', data).then(res => {
                this.compareText = res.data.content
            })
        },

        outside() {
            this.$refs.goodsIput.cancleReq()
            this.$refs.goodsIput2.cancleReq()
            this.$refs.companyIput.cancleReq()
            this.$refs.specsInput1.cancleReq()
            this.$refs.specsInput2.cancleReq()
            this.$refs.companyIput2.cancleReq()
        },
        wyfx() {
            const goods1 = this.goods1
            const company1 = this.company1
            const goods2 = this.goods2
            const company2 = this.company2
            const specs1 = this.specs1
            const specs2 = this.specs2
            const parmas = {
                leftGoodsName: goods1.goodsName,
                leftCompanyId: company1.companyId,
                leftSpecs: specs1.specs,
                rightGoodsName: goods2.goodsName,
                rightCompanyId: company2.ompanyId,
                rightSpecs: specs2.specs,
                leftCompanyName: company1.ompanyName,
                rightCompanyName: company2.ompanyName
            }
            const url = `/pages/wybj/wybj?data=${encodeURIComponent(JSON.stringify(parmas))}`
            let title = '你收到来自朋友的一条比价'
            this.$store.dispatch('home/appShare', { type: 3 }).then(res => {
                title = res.data.title
            })
                .catch(() => { console.log(e) })
                .finally(() => {
                    // #ifdef H5
                    bridgrCall.goShare({ path: url, title }).then((res) => {
                        // if (res.data) {
                        //     uni.showToast({
                        //         icon: "none",
                        //         title: "分享成功！",
                        //     })
                        // } else {
                        //     uni.showToast({
                        //         icon: "none",
                        //         title: "分享失败！",
                        //     })
                        // }
                    })
                    return
                    //#endif 
                    let that = this
                    that.share = {
                        title: title,
                        path: url
                    }
                })
            console.log(url)

        },
        wybj() {
            console.log('diao')
            const goods1 = this.goods1
            const company1 = this.company1
            const goods2 = this.goods2
            const company2 = this.company2
            const specs1 = this.specs1
            const specs2 = this.specs2
            if (!goods1.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择左侧侧药品'
                })
                return
            }
            if (!company1.companyName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择左侧厂家'
                })
                return
            }

            if (!goods2.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择右侧药品'
                })
                return
            }
            if (!company2.companyName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择右侧厂家'
                })
                return
            }
            const params = {
                leftGoodsName: goods1.goodsName,
                leftCompanyId: company1.companyId || this.defaultValue.leftCompanyId,
                leftSpecs: specs1.specs,
                rightGoodsName: goods2.goodsName,
                rightCompanyId: company2.companyId || this.defaultValue.rightCompanyId,
                rightSpecs: specs2.specs
            }
            this.$store.dispatch('jgcx/comparePrice', params).then(res => {
                this.goodsList = [res.data.leftGoodsInfo, res.data.rightGoodsInfo]
                // this.compareText = res.data.compareText || ""
            })
        },
        tjkf() {
            uni.navigateTo({
                url: "/pages/lxwm/lxwm"
            })
        },
        goodsSearch(cb, params) {

            this.$store.dispatch('jgcx/getRelateGoodsName', params).then(res => {
                cb(res.data.goodsNameList)
            })
        },
        goodsSearch2(cb, params) {

            this.$store.dispatch('jgcx/getRelateGoodsName', params).then(res => {
                cb(res.data.goodsNameList)
            })
        },
        companySearch(cb, param) {
            const item = this.goods1
            const params = {
                goodsName: item.goodsName,
                page: param.page,
                type: 2
            }
            this.$store.dispatch('jgcx/getQueryCompanyList', params).then(res => {
                cb(res.data.companyList)
            })
        },
        companySearch2(cb, param) {
            const item = this.goods2
            const company = this.company1 || {}
            const params = {
                goodsName: item.goodsName,
                page: param.page,
                type: 2
            }
            this.$store.dispatch('jgcx/getQueryCompanyList', params).then(res => {
                //去一下左边重复

                if (res.data.companyList.length === 1 && res.data.companyList[0].companyId == company.companyId) {
                    uni.showToast({
                        title: '因系统中无同类商品，暂不能提供该产品的比价服务',
                        icon: 'none'
                    })
                    cb([])
                    return
                }
                const list = res.data.companyList.filter(_ => _.companyId !== company.companyId)
                cb(list)
            })
        },
        formatSearch(cb, parma) {
            const goods = this.goods1
            const company = this.company1
            const params = {
                goodsName: goods.goodsName,
                companyId: company.companyId,
                page: parma.page,
                type: 2
            }
            this.$store.dispatch('jgcx/getSpecList', params).then(res => {
                cb(res.data.specList)
            })
        },
        formatSearch2(cb, parma) {
            const goods = this.goods2
            const company = this.company2
            const params = {
                goodsName: goods.goodsName,
                companyId: company.companyId,
                page: parma.page,
                type: 2
            }
            this.$store.dispatch('jgcx/getSpecList', params).then(res => {
                cb(res.data.specList)
            })
        },
        checkGoods(cb) {
            const item = this.goods1
            if (!item.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择药品'
                })
                cb(false)
                return
            }
            cb(true)
        },
        checkGoods2(cb) {
            const item = this.goods2
            if (!item.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择药品'
                })
                cb(false)
                return
            }
            cb(true)
        },
        checkCompany(cb) {
            const goods = this.goods1
            const company = this.company1

            if (!goods.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择药品'
                })
                cb(false)
                return
            }
            if (!company.companyId) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择厂家'
                })
                cb(false)
                return
            }
            cb(true)

        },
        checkCompany2(cb) {
            const goods = this.goods2
            const company = this.company2

            if (!goods.goodsName) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择药品'
                })
                cb(false)
                return
            }
            if (!company.companyId) {
                uni.showToast({
                    icon: 'none',
                    title: '请先选择厂家'
                })
                cb(false)
                return
            }
            cb(true)
        },
        completeGoods() {
            this.$refs.companyIput.selectValue = ''
            this.$refs.specsInput1.selectValue = ''
            if (this.company1) {
                this.company1.companyId = ''
            }
            this.defaultValue.rightGoodsName = this.goods1.goodsName
        },
        completeCompany() {
            this.$refs.specsInput1.selectValue = ''
        },
        completeGoods2() {
            this.$refs.specsInput2.selectValue = ''
            this.$refs.companyIput2.selectValue = ''
            if (this.company2) {
                this.company2.companyId = ''
            }
        },
        completeCompany2() {
            this.$refs.specsInput2.selectValue = ''
        },
        goGoods(item) {
            // #ifdef H5
            bridgrCall.goodsDetail({
                "goodsId": item.goodsId,
                "risk": item.risk
            })
            return
            //#endif
            if (item.risk == 1) {
                uni.navigateTo({
                    url: `/pages/result/smRisk?goodsId=${item.goodsId}`
                })
            } else {
                uni.navigateTo({
                    url: `/pages/result/smNoRisk?goodsId=${item.goodsId}`
                })
            }
        }
    }
}
</script>

<style lang="scss" scoped>
.content {
    font-size: 28rpx;

    .spical-text {
        color: #FC511E;
        line-height: 40rpx;
    }

    .info {
        background-color: #F2F3F5;
        padding: 10rpx 30rpx;
    }

    .main-content {
        background-color: white;
        padding: 30rpx;

        .main-box-content {
            display: flex;
            flex-direction: row;
            align-items: center;
        }

        .button-main {
            padding: 40rpx 64rpx 10rpx 64rpx;
        }

        .main-box {
            padding: 20rpx;
            flex: 1;
            background-color: #F2F3F5;
            border-radius: 16rpx;

        }

        .text-wrapper_2 {
            background-color: rgba(255, 147, 48, 1);
            border-radius: 100%;
            margin: 0 14rpx;
            padding: 10rpx 10rpx 10rpx 12rpx;
        }

        .text_26 {
            overflow-wrap: break-word;
            color: rgba(255, 255, 255, 1);
            font-size: 28rpx;
            font-family: PingFangSC-Semibold;
            font-weight: 600;
            text-align: left;
            white-space: nowrap;
            line-height: 40rpx;
        }
    }

    .result-content {
        background-color: white;
        padding: 30rpx;
        margin-top: 20rpx;

        .port_title {
            padding: 20rpx 0;
            width: 128rpx;
            font-size: 32rpx;
            font-weight: 600;
            color: #333333;
            line-height: 44rpx;

            .line {
                margin-top: -6rpx;
                width: 128rpx;
                height: 6rpx;
                background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%);
            }
        }

        .hot_content {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;

            .hot_content_items {
                width: 46%;
                margin: 20rpx 10rpx;
                display: flex;
                flex-direction: column;
                border: 2rpx solid #E0E0E0;
                border-radius: 8rpx;
                position: relative;

                .item_title {
                    margin: 10rpx 0 0 20rpx;
                    font-size: 28rpx;
                    font-weight: 600;
                    color: #333333;
                    line-height: 40rpx;
                }

                .item_name {
                    margin: 10rpx 0 0 20rpx;
                    font-size: 24rpx;
                    font-weight: 400;
                    color: #999999;
                    line-height: 34rpx;
                }

                .item_num {
                    margin: 10rpx 0 0 20rpx;
                    font-size: 24rpx;
                    font-weight: 400;
                    color: #666666;
                    line-height: 34rpx;
                }

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

                .items_icon {
                    display: inline-block;
                    margin: 12rpx 0 0 20rpx;
                    height: 44rpx;
                    background: rgba(255, 147, 48, 0.1);
                    color: #FF9330;
                    font-size: 22rpx;
                    line-height: 44rpx;
                    padding: 0 8rpx;
                    border-radius: 8rpx;
                }

                .warning_icon {
                    position: absolute;
                    top: 0;
                    display: flex;
                    justify-content: center;
                    width: 100%;
                    height: 100%;
                }
            }
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

    // /deep/ .u-button {
    //     height: 88rpx;
    //     background: #0FC8AC;
    //     border-radius: 44rpx;
    //     color: #fff;
    //     font-size: 32rpx;
    //     font-weight: 600;
    // }
}
</style>
