<!-- 这是搜索页面 -->
<template>
    <view class="mainWrap">
        <!-- navbar -->
        <view class="contents">
            <u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=" ">
                <view class="u-nav-slot" slot="left">识药查真伪</view>
            </u-navbar>
        </view>
		<view class="content_top">
		    <view>
		        <u-image :src="$utils.getImgUrl('left-icon.png')" width="48rpx" height="48rpx" @click="leftClick" />
		    </view>
		    <view class="right">图片识别结果</view>
		    <view @click="showScan('pz')">重拍</view>
		</view>
		<view class="main-content" :style="{ height: scrollViewheight + 'px' }">
			<scroll-view class="content" @scrolltolower="scrolltolower" scroll-y>
			    
			    <view class="result-content">
			        <u-image :src="resultData.imageUrl" class="content-img" />
			        <view class="result-bt" @click="tqwz">
			            <u-image :src="$utils.getImgUrl('tqwz_icon.png')" width="32rpx" height="32rpx" />
			            <view style="color: #0FC8AC;margin-left: 5rpx;">提取文字</view>
			        </view>
			    </view>
			    <u-gap bgColor="#F6F7F8" height="20rpx" />
			    <view class="result-word-content">
			        <view class="blod">搜索词推荐</view>
			        <view class="result-word" v-if="keywords && keywords.length">
			            <view class="word-item line1" :class="{ 'item-select': item.select }" v-for="item in keywords"
			                :key="item.name" @click="selectItem(item)">
							{{item.name}}
			                <!-- <u--text lines="1" align="center" :text="item.name"
			                    :color="item.select ? 'white' : '#333'"></u--text> -->
			            </view>
			
			        </view>
			        <u-empty marginTop="20rpx" v-else :icon="$utils.getImgUrl('empty.png')" width="100rpx" height="96rpx"
			            text="暂无搜索词">
			        </u-empty>
			    </view>
			    <u-gap bgColor="#F6F7F8" height="20rpx" />
			    <!-- 热门搜索 -->
			    <view class="search-result">
			        <view class="port_title">
			            <view>
			                搜索到以下结果
			            </view>
			        </view>
			        <view v-if="searchList && searchList.length"class="hot_content">
						<goodsList :lists="searchList"></goodsList>
			        </view>
			        <view v-else class="search-result">
			            <u-empty text="暂无商品" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px"
			                :margin-top="30">
			            </u-empty>
			        </view>
			        <u-loadmore v-if="isMore" bgColor="#ffffff" :status="moreStatus" />
			    </view>
			
			</scroll-view>
		</view>
        
    </view>
</template>

<script>
import goodsList from '@/components/goodsInfo/goodsList.vue'

import {searchReq} from '@/api/home.js'
export default {
	components:{
		goodsList
	},
    data() {
        return {
            searchInput: {
                color: '#333333',
                'background-color': 'white',
                padding: '4rpx',
            },
            searchList: [],
            resultData: {},
            keywords: [],
            loading: false,
            keyword: '',
            isMore: false,
            page: 1,
            moreStatus: 'loading'
        };
    },
    onLoad(option) {
        this.resultData = decodeURIComponent(option.result) === 'undefined' ? {} : JSON.parse(decodeURIComponent(option.result))
        this.keywords = this.resultData.keywords || []
    },
	
	onShow() {
		// #ifdef H5
		document.title = '识药查真伪'
		//#endif
	},
    mounted() {
        if (this.keywords[0]) {
            this.$set(this.keywords[0], 'select', true)
            this.keyword = this.keywords[0].name || ''
        }
        uni.showLoading({
            title: '正在搜索...',
        })
        this.getHotWordList()
    },
    methods: {
        /**
         * 点击便捷搜索
         */
        getHotWordList() {
            console.log('this.keyword', this.keyword)

            if (!this.keyword) {
                uni.hideLoading()
                return
            }
            console.log('this.2', this.keyword)

            let params = {
                keyword: this.keyword,
                page: this.page
            }
            searchReq(params).then(res => {
                this.searchList = this.page > 1 ? this.searchList.concat(res.data.goodsList) : res.data.goodsList
            }).finally(() => {
                this.loading = false
                this.isMore = false
                uni.hideLoading()
            })
        },
        scrolltolower() {
            this.page++
            this.isMore = true
            this.getHotWordList()
        },
        goHome() {
            uni.switchTab({
                url: "/pages/index/index",
            });
        },
        showScan(type) {
            uni.navigateTo({
                url: `/pages/camera/camera?type=${type}`,
            });
        },
        selectItem(item) {
            this.keywords.map(_ => _.select = false)
            this.$set(item, 'select', true)
            this.keyword = item.name
            this.page = 1
            uni.showLoading({
                title: '正在搜索...',
            })
            this.getHotWordList()
        },
        tqwz() {
            uni.navigateTo({
                url: `/pages/sbjg/tqwz/tqwz?keywords=${encodeURIComponent(JSON.stringify(this.keywords))}`
            })
        },
        goToYccx(item) {
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
    },
};
</script>

<style lang="scss" scoped>
.u-nav-slot {
    width: 180rpx;
    height: 50rpx;
    font-size: 36rpx;
    font-family: PingFangSC-Medium, PingFang SC;
    font-weight: 500;
    color: #ffffff;
    line-height: 50rpx;
}


.content_top {
	position: sticky;
	left: 0;
	top: 0;
	z-index: 20;
	// height: 40rpx;
	background-color: #0ad0b2;
	display: flex;
	flex-direction: row;
	padding: 30rpx 20rpx;
	align-items: center;
	justify-content: space-between;
	font-size: 28rpx;
	font-weight: 400;
	color: #FFFFFF;
	line-height: 40rpx;

	.right {
		font-size: 36rpx;

	}
}
.main-content{
	.content{
		height: calc(100% - 84rpx);
	}
}
.content {
    position: relative;
    background-color: #ffffff;

    .u-page {
        position: absolute;
        width: 100%;
        z-index: 10;
        background-color: #ffffff;
    }

    .result-content {
        background-color: #FFFFFF;
        display: flex;
        flex-direction: column;
        padding: 40rpx 94rpx;
        align-items: center;

        .content-img {
            border-radius: 16rpx;
        }

        .result-bt {
            display: flex;
            flex-direction: row;
            align-items: center;
            color: '#0FC8AC';
            font-size: 28rpx;
            margin-left: 5rpx;
            margin-top: 30rpx;
        }

    }

    .result-word-content {
        background-color: #FFFFFF;
        padding: 20rpx 30rpx;

        .result-word {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;

            .word-item {
                width: 40%;
                border-radius: 28rpx;
                padding: 10rpx 20rpx;
				text-align:center;
                background-color: #F6F7F8;
                color: #666666;
                margin-top: 30rpx;
            }

            .item-select {
                background-color: #0FC8AC;
                color: #FFFFFF;
            }
        }
    }


    .blod {
        font-size: 32rpx;
        font-family: PingFangSC-Semibold, PingFang SC;
        font-weight: 600;
        color: #333333;
        line-height: 44rpx;
    }

    .search-result {
        padding: 20rpx 30rpx;
        background-color: #FFFFFF;

        .port_title {
            margin-bottom: 20rpx;
            background-color: white;
            padding: 20rpx 0;
            width: 100%;
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
        }
    }


}
</style>
