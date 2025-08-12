<!-- 扫码无风险 -->
<template>
    <view class="mainWrap">
        <view class="contents">
            <u-navbar v-if="!isH5" title="查询详情" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '36rpx' }"></u-navbar>
        </view>
        <scroll-view scroll-y class="content" :style="{ height: scrollViewheight + 'px' }">
            <view class="label">说明书</view>
            <view class="top-box" @click="goSms" v-if="info">
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
            <!-- <view class="label"  v-if="info && info.articleList.length">资讯</view> -->
			<view class="port_title"  v-if="info && info.articleList.length">
				<view class="port_more flex flex-center">
					<view class="">资讯</view>
					<view class="more flex flex-center" @click.stop="moreComment()">更多</view>
				</view>
				<!-- <view class="line"></view> -->
			</view>
            <view class="bottom-box" v-if="info && info.articleList">
                <view v-for="(items, index) in info.articleList" :key="index">
                    <zxItem :items="items" />
                </view>
            </view>
            <view v-else>
                <u-empty text="暂无内容" icon="/static/noData.png" width="160px" height="140px" :margin-top="30">
                </u-empty>
            </view>
        </scroll-view>
    </view>
</template>

<script>
import zxItem from '../circle/zx-item.vue';
import {goodsServerReq} from '@/api/home.js'

import {mapGetters} from "vuex";

export default {
    data() {
        return {
            goodsId: '',
            info: ''
        }
    },
	computed: mapGetters(['isLogin', 'uid']),
	watch: {
		isLogin: {
			handler: function(newV, oldV) {
				let that = this;
				if (newV == true) {
					this.getContent()
				}
			},
			deep: true
		}
	},
    components: {
        zxItem
    },
    onLoad(option) {
        console.log(option, 'sss')
        this.goodsId = option.goodsId || '1'
		if(this.isLogin){
			this.getContent()
		}else{
			this.$utils.toLogin();
		}
    },
	onShow(){
		// #ifdef H5
		document.title = '查询详情'
		//#endif
	},
    methods: {
        getContent() {
            let that = this
            let params = {
                goodsId: that.goodsId || 1198
            }
            goodsServerReq(params).then(res => {
                this.info = res.data
            })
        },
        goItems(item) {
			let link = item.linkUrl
			let info = this.info.goodsInfo
			let go_url = link.slice(link.indexOf('/'))
			// .split('?')[0]+'?goodsId='+info.goodsId+
			// '&companyId='+info.companyId+
			// '&company='+info.companyName+
			// '&goodsName='+info.goodsName+
			// '&specs='+info.specs
			
			console.log(go_url)
            uni.navigateTo({
                url: go_url,
            })
        },
        goSms() {
            uni.navigateTo({
                url: '/pages/result/sms?goodsId=' + this.goodsId,
            })
        },
		moreComment() {
			let info = this.info.goodsInfo
			uni.navigateTo({
				url: '/pages/circle/zixun_list?keyword='+info.keyword
			});
		}
    }
}
</script>

<style lang="scss" scoped>
.port_title {
	padding: 20rpx 30rpx 0;
	// width: 100%;
	font-size: 32rpx;
	font-weight: 600;
	color: #333333;
	line-height: 44rpx;

	.port_more {
		display: flex;
		justify-content: space-between;
	}

	.more {
		color: #0fc8ac;
		font-size: 28rpx;
		line-height: 44rpx;
		padding: 4rpx 20rpx;
	}

	.line {
		margin-top: -6rpx;
		width: 128rpx;
		height: 6rpx;
		background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0fc7ab 100%);
	}
}
.content {
    padding: 30rpx 0;
	box-sizing: border-box;

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
