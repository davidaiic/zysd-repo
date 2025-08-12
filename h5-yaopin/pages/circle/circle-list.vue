<template>
    <view class="circle-content">
        <view class="contents" style="position: absolute; z-index: 20000;width: 100%;">
            <u-navbar v-if="!isH5" class="searchBars" :fixed="false" leftIcon=" ">
                <view class="u-nav-slot" slot="left">识药查真伪</view>
            </u-navbar>
        </view>

        <view class="content" :style="{ height: scrollViewheight + 'px', marginTop: topHight + 'px' }">
            <searchList ref="searchList" :searchModel.sync="keyword" @back="goHome()" @search=goToSearch>
                <view class="content_search">
                    <view class="content_search_back">
                        <u-icon v-if="!readonly" name="arrow-left" color="#fff" size="24" @click="goHome()"></u-icon>
                        <view @click="goToSearch" style="flex: 1">
                            <u-input height="72rpx" clearable :customStyle="searchInput" fontSize="28rpx"
                                :readonly="readonly" class="searchInput" placeholder="输入关键词，快速找圈找内容" v-model="keyword"
                                shape="circle" confirmType="search" @confirm="goToSearch()" @input="inputSearch">
                                <template slot="prefix">
                                    <view class="search-left">
                                        <u-icon name="search" color="#999999" size="44rpx" @click="goToSearch()" />
                                    </view>

                                </template>
                            </u-input>
                        </view>
                        <view class="search-right">
                            <view class="searchbt" @click="showSelect()">筛选</view>
                            <u-icon name="arrow-down-fill" color="#FFF" size="12"></u-icon>
                        </view>
                    </view>
                </view>
            </searchList>

            <view class="label-content">
                <u-tabs :list="tabs" lineWidth="30"
                    lineColor="linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%)" :itemStyle="itemStyle"
                    :activeStyle="port_title" :inactiveStyle="untitle" @change="tabChange">


                </u-tabs>
            </view>
            <view v-show="labelType == 2">
                <scroll-view class="hot_talk_content" v-if="zxList.length > 0"
                    :style="{ height: listHight, marginBottom: '10rpx' }" refresher-enabled="true"
                    :refresher-triggered="triggered" @refresherpulling="pullRefresh" scroll-y @refresherrefresh="onRefresh"
                    @scrolltolower="loadMore">
                    <view v-for="(items, ids) in zxList" :key="ids">
                        <zxItem :items="items" />
                    </view>
                    <u-loadmore v-if="isMore" bgColor="#ffffff" :status="moreStatus" />
                </scroll-view>
                <u-empty v-else text="暂无更多内容" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px"
                    :margin-top="50">
                </u-empty>
            </view>
            <view v-show="labelType == 1">
                <scroll-view class="hot_talk_content" v-if="commentList.length > 0" :style="{ height: listHight }"
                    refresher-enabled="true" :refresher-triggered="triggered" @refresherpulling="pullRefresh" scroll-y
                    @refresherrefresh="onRefresh" @scrolltolower="loadMoreComment">
                    <view v-for="(items, ids) in commentList" :key="ids">
                        <plItem :items="items" />
                    </view>
                    <u-loadmore v-if="isMore" bgColor="#ffffff" :status="moreStatus" />
                </scroll-view>
                <u-empty v-else text="暂无更多内容" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px"
                    :margin-top="50">
                </u-empty>
            </view>
            <!-- 发布帖子 -->
            <view class="fabu" @click="fatie">
                <view class="fabu_img">
                    <u-image :src="$utils.getImgUrl('fabu.png')" width="32rpx" height="32rpx"></u-image>
                </view>
                <view class="fabu_title">
                    发帖
                </view>
            </view>
            <u-popup :show="show" mode="top" :overlayStyle="{ top: topHight + 60 + 'px' }" @close="close"
                :customStyle="{ top: topHight + 60 + 'px' }">
                <view class="pop-content">
                    <view class="label"> 排序 </view>
                    <view class="pop-box">
                        <view v-for="pxItem in firstList" :key="pxItem.name" class="pop-item"
                            :class="{ 'pop-item-select': pxItem.pick }" @click="pickSort(pxItem)">最新</view>
                    </view>
                    <view class="label" style="margin-top: 30rpx;">筛选条件</view>
                    <view class="pop-box">
                        <view v-for="popItem in popList" :key="popItem.name" class="pop-item"
                            :class="{ 'pop-item-select': popItem.pick }" @click="pickLabel(popItem)">
                            <u--text lines="1" align="center" :text="popItem.name"></u--text>
                        </view>

                    </view>
                    <view class="footer">
                        <u-button shape="circle" plain color="#999999" text="重置" @click="resetPop"></u-button>
                        <u-button shape="circle" type="primary" text="确认" color="#0FC8AC" @click="pickConfirm"></u-button>
                    </view>
                </view>
            </u-popup>
        </view>

    </view>
</template>

<script>
import {
    getUserFunc
} from '@/utils/utils.js';
import searchList from '../../components/search-list.vue';
import zxItem from './zx-item.vue';
import plItem from './pl-item.vue';
export default {
    props: {
        readonly: {
            type: Boolean,
            default: true
        },
        defaultWord: {
            type: String,
            default: ''
        }
    },
    components: {
        zxItem,
        plItem,
        searchList
    },
    data() {
        return {
            keyword: '',
            labelType: 1,
            searchInput: {
                color: '#333333',
                'background-color': 'white',
                padding: '4rpx',
                height: '60rpx'
            },
            popList: [],
            firstList: [],
            zxList: [],
            commentList: [],
            commentPage: 1,
            tabs: [{ name: '评论' }, { name: "资讯" }],
            page: 1,
            untitle: {
                'font-size': '30rpx',
                color: '#666666',
                'font-weight': 100,
                lineHeight: '46rpx',

            },
            itemStyle: {
                height: '46rpx',
                padding: '0 20rpx',
            },
            port_title: {
                'font-size': '34rpx',
                'font-weight': 600,
                color: '#333333',
                lineHeight: '46rpx',
            },
            line: {
                'margin-top': '-6rpx',
                width: '64rpx',
                height: '6rpx',
                background: 'linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%)'
            },
            show: false,
            isMore: false,
            moreStatus: '',
            isCancle: false,
            triggered: false,
        };
    },
    computed: {
        topHight() {
            const systemInfo = uni.getSystemInfoSync();
            return systemInfo.statusBarHeight + 44
        },
        listHight() {
            // label search 减去 
            return this.scrollViewheight - 90 + 'px'
        },
        labelId() {
            return this.popList.filter(_ => _.pick).map(_ => _.labelId).join(',')
        },
        sortId() {
            return this.firstList.filter(_ => _.pick).map(_ => _.sortId).join(',')
        }
    },
    watch: {
        defaultWord: {
            handler(newVal, oldVal) {
                this.keyword = newVal
            },
            immediate: true,
        }
    },
    mounted() {
        this.getHeight();
        this.getCommentList();
        this.getZxList()
        this.getSxtjList()
    },
    onPullDownRefresh() {
        this.restList()
        uni.$u.sleep(1000).then(() => {
            uni.stopPullDownRefresh();
        })
    },
    methods: {
        onRefresh() {
            this.restList()
        },
        pullRefresh() {
            this.triggered = true
        },
        getCommentList() {
            let params = {
                type: 0,
                keyword: this.keyword || '',
                sortId: this.ortId || '',
                labelId: this.labelId || '',
                page: this.commentPage
            }
            this.$store.dispatch('home/getHomeCommentList', params).then(res => {
                this.commentList = this.commentPage > 1 ? this.commentList.concat(res.data.commentList) : res.data.commentList
            }).finally(() => {
                this.isMore = false
                this.triggered = false
                this.moreStatus = 'nomore'
            })
        },
        getZxList() {
            let params = {
                sortId: this.ortId || '',
                labelId: this.labelId || '',
                page: this.page,
                keyword: this.keyword || '',
            }
            this.$store.dispatch('home/getArticleList', params).then(res => {
                this.zxList = this.page > 1 ? this.zxList.concat(res.data.articleList) : res.data.articleList
            }).finally(() => {
                this.isMore = false
                this.triggered = false
                this.moreStatus = 'nomore'
            })

        },

        tabChange({ index }) {
            this.labelType = index + 1
        },

        getSxtjList() {
            let params = {
                sortId: 0,
                labelId: 0,
                page: this.page
            }
            this.$store.dispatch('home/getFilterCriteria', params).then(res => {
                this.popList = res.data.labelList || []
                this.firstList = res.data.sortList || []
            })
        },

        pickLabel(popItem) {
            this.$set(popItem, 'pick', !popItem.pick)
        },

        pickSort(pxItem) {
            this.$set(pxItem, 'pick', !pxItem.pick)
        },
        fatie() {
            uni.navigateTo({
                url: `/pages/fatie/fatie?commentId=${''}`
            })
        },

        pickConfirm() {
            this.restList()
            this.close()
        },

        loadMore() {
            this.page++
            this.isMore = true
            this.moreStatus = 'loading'
            this.getZxList()
        },
        loadMoreComment() {
            this.commentPage++
            this.isMore = true
            this.moreStatus = 'loading'
            this.getCommentList()
        },
        restList() {
            if (this.labelType === 1) {
                this.commentPage = 1
                this.getCommentList()
            } else {
                this.page = 1
                this.getZxList()
            }
            this.$refs.searchList.show = false
        },
        scrolltoupper() {
            this.restList()
        },
        //搜索
        goToSearch(item) {
            if (this.readonly) {
                uni.navigateTo({
                    url: `/pages/searchPage/searchPage?keyword=${item}&isCircle=true`
                })
            } else {
                this.$refs.searchList.show = false
                this.isCancle = true
                this.triggered = true
                this.restList()
            }
        },
        inputSearch(text) {
            this.$refs.searchList.searchModel = text
            if (this.isCancle) {
                return this.isCancle = false
            }
            this.$refs.searchList.inputSearch(text)
        },
        goHome() {
            uni.navigateBack({
                delta: 1,
            });
        },
        showSelect() {
            this.show = true
        },
        close() {
            this.show = false
        },
        resetPop() {
            this.popList.map(_ => _.pick = false)
            this.pxItem = false
        }
    }
};
</script>
<style lang="scss">
page {
    overflow: hidden;
}
</style>
<style lang="scss" scoped>
.circle-content {
    overflow: hidden;
    position: relative;

    .u-nav-slot {
        width: 180rpx;
        height: 50rpx;
        font-size: 36rpx;
        font-family: PingFangSC-Medium, PingFang SC;
        font-weight: 500;
        color: #ffffff;
        line-height: 50rpx;
    }

    .content {
        overflow: hidden;
    }

    .label-content {
        display: flex;
        position: sticky;
        background-color: #ffffff;
        top: 120rpx;
        z-index: 1;
        flex-direction: row;
        padding: 20rpx 10rpx;



        .port_title {
            margin-bottom: 20rpx;
            width: 100rpx;
            font-size: 32rpx;
            font-weight: 600;
            color: #333333;
            line-height: 44rpx;

            .line {
                margin-top: -6rpx;
                width: 64rpx;
                height: 6rpx;
                background: linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%);
            }
        }

        .untitle {
            color: #666666;
            font-weight: 100;
        }
    }

    .content_search {
        position: sticky;
        top: 0;
        z-index: 20000;
        height: 120rpx;
        background-color: #0ad0b2;
        // position: relative;

        .search-left {
            display: flex;
            flex-direction: row;
            align-items: center;
            padding-left: 26rpx;

            .splitLine {
                display: inline-block;
                width: 2rpx;
                height: 24rpx;
                background-color: #0fc8ac;
                margin: 0 8rpx;
            }
        }



        .searchInput {
            color: #333333;
            background-color: white;
            padding: 4rpx !important;
        }

        .search-right {
            display: flex;
            flex-direction: row;
            align-items: center;
            margin-left: 50rpx;

            .searchbt {
                line-height: 56rpx;
                color: white;
                text-align: center;
            }
        }

        .content_search_back {
            position: absolute;
            z-index: 2;
            width: calc(100% - 60rpx);
            left: 30rpx;
            top: 20rpx;
            margin: 0 auto;
            display: flex;
            align-items: center;

            /deep/ .u-icon {
                padding-right: 10rpx;
            }

            .content_search_input {
                background-color: white;
                margin-top: -36rpx;
                box-shadow: 0 4rpx 6rpx 0 rgba(57, 186, 167, 0.1);
            }
        }
    }

    .pop-content {
        display: flex;
        flex-direction: column;
        padding: 30rpx;
        font-size: 28rpx;

        .label {
            color: #333333;
            margin: 10rpx 0;
            font-weight: bold;
        }

        .pop-box {
            display: flex;
            flex-direction: row;
            flex-wrap: wrap;
            gap: 16rpx;
        }

        .pop-item {
            width: 160rpx;
            height: 70rpx;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #F2F3F5;
            border-radius: 8rpx;
        }

        .pop-item-select {
            background-color: #0fc8ac;
            color: white
        }

        .footer {
            margin-top: 80rpx;
            display: flex;
            flex-direction: row;
            justify-content: space-between;
            gap: 20rpx
        }
    }
}

.fabu {
    width: 96rpx;
    height: 96rpx;
    position: fixed;
    right: 20rpx;
    bottom: 180rpx;
    border-radius: 100%;
    background: linear-gradient(180deg, #0AD0B2 0%, #0FC7AB 100%);
    box-shadow: 0rpx 4rpx 6rpx 0rpx rgba(0, 141, 120, 0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: column;

    .fabu_title {
        margin-top: 10rpx;
        font-size: 24rpx;
        font-weight: 400;
        color: #FFFFFF;
        line-height: 34rpx;
    }
}
</style>
