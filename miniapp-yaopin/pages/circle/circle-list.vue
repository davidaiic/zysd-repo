<template>
    <view class="circle-content">
        <view class="content" :style="{ height: scrollViewheightProp+'px'}">
            <searchList ref="searchList" :searchModel.sync="keyword" @back="goHome()" :defaultValue="keyword" @search="goToSearch">
               <view class="content_search  flex-row flex-c">
                    <view class="content_search_back">
                        <u-icon v-if="!readonly" name="arrow-left" color="#fff" size="24" @click="goHome()"></u-icon>
                        <view @click="goToSearch" style="flex: 1">
                            <u-input height="72rpx" clearable :customStyle="searchInput" fontSize="28rpx"
                                :readonly="readonly" class="searchInput" placeholder="输入关键词，快速找圈找内容" v-model="keyword"
                                shape="circle"  confirmType="search" @confirm="goToSearch()" @input="inputSearch">
                                <template slot="prefix">
                                    <view class="search-left">
                                        <u-icon name="search" color="#999999" size="44rpx" @click.stop="goToSearch()" />
                                    </view>
                                </template>
								<template slot="suffix" v-if="from !== 'maintab'">
									<view class="search-right flex-row flex-c">
										<view class="searchbt" @click.stop="goToSearch()">搜索</view>
									</view>
								</template>
                            </u-input>
                        </view>
                        <view class="search-right-box flex-row flex-c">
                            <view class="searchbt" @click="showSelect()">筛选</view>
                            <u-icon name="arrow-down-fill" color="#FFF" size="12"></u-icon>
                        </view>
                    </view>
                </view>
            </searchList>

            <view class="label-content">
                <u-tabs :list="tabs" lineWidth="30"
                    lineColor="linear-gradient(270deg, rgba(10, 208, 178, 0) 0%, #0FC7AB 100%)" :itemStyle="itemStyle"
                    :activeStyle="port_title" :inactiveStyle="untitle"  :current="select_tab"  @change="tabChange">
                </u-tabs>
            </view>
            <view class="list-box" v-show="select_tab == 0">
                <scroll-view class="hot_talk_content"
                    refresher-enabled="true" :refresher-triggered="triggered" @refresherpulling="pullRefresh" scroll-y
                    @refresherrefresh="restList" @scrolltolower="loadMoreComment">
                    <view v-for="(items, ids) in commentList" :key="ids">
                        <plItem :items="items" />
                    </view>
                    <u-loadmore  bgColor="#ffffff" :status="moreStatus" />
					<view class="bottom-fill"></view>
                </scroll-view>
            </view>
			
			<view  class="list-box"  v-show="select_tab == 1">
			    <scroll-view class="hot_talk_content" refresher-enabled="true"
			        :refresher-triggered="triggered2" @refresherpulling="pullRefresh" scroll-y @refresherrefresh="restList"
			        @scrolltolower="loadMore2">
			        <view v-for="(items, ids) in zxList" :key="ids">
			            <zxItem :items="items" />
			        </view>
			        <u-loadmore  bgColor="#ffffff" :status="moreStatus2" />
					<!-- <u-empty v-if="zxList.length == 0" text="暂无更多内容" :icon="$utils.getImgUrl('noData.png')" width="160px" height="140px"
					    :margin-top="50">
					</u-empty> -->
					
					<view class="bottom-fill"></view>
			    </scroll-view>
			</view>
        </view>
		<!-- 发布帖子 -->
		<view class="fabu" @click="fatie">
		    <view class="fabu_img">
		        <u-image :src="$utils.getImgUrl('fabu.png')" width="32rpx" height="32rpx"></u-image>
				
				    <!-- <image :src="$utils.getImgUrl('fabu.png')" style="width:32rpx;height:32rpx"></image> -->
		    </view>
		    <view class="fabu_title" >
		        发帖
		    </view>
		</view>
		<u-popup :show="show" mode="top" :overlayStyle="{ top: topHeight + 60 + 'px' }" @close="close"
		    :customStyle="{ top: topHeight + 60 + 'px' }">
		    <view class="pop-content">
		        <view class="label"> 排序 </view>
		        <view class="pop-box">
		            <view v-for="(item,index) in firstList" :key="item.name" class="pop-item  flex-row flex-c line1"
		                :class="item.pick ? 'pop-item-select' : ''" @click="pickSort(index)">
						{{item.name}}
					</view>
		        </view>
		        <view class="label" style="margin-top: 30rpx;">筛选条件</view>
		        <view class="pop-box">
		            <view v-for="(item,index) in popList" :key="item.name" class="pop-item flex-row flex-c line1"
		                :class="item.pick ? 'pop-item-select' : ''" @click="pickLabel(index)">
							{{item.name}}
		            </view>
		        </view>
		        <view class="footer">
		            <u-button shape="circle" plain color="#999999" text="重置" @click="resetPop"></u-button>
		            <u-button shape="circle" type="primary" text="确认" color="#0FC8AC" @click="pickConfirm"></u-button>
		        </view>
		    </view>
		</u-popup>
    </view>
</template>

<script>
import searchList from './components/search.vue';
import zxItem from './zx-item.vue';
import plItem from './pl-item.vue';
import {
	articleListReq,
	filterCriteriaReq,
	commentListReq
} from '@/api/home.js'
export default {
    props: {
        readonly: {
            type: Boolean,
            default: true
        },
        defaultWord: {
            type: String,
            default: ''
        },
		filterInfo:{
			type:Object,
			default:()=>{
				return {}
			}
		},
		navSelect:{
            type: [Number],
            default: 1//1，评论，2，资讯
        },
		from:{
			type:String,
			default:''
		},
		scrollViewheightProp:{
			type:[String,Number],
			default:800
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
			select_tab:0,
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
            moreStatus: 'loading',
			moreStatus2:'loading',
			load_end:false,
			load_end2:false,
            isCancle: false,
            triggered: false,
            triggered2: false,
			isLoading:false,
			isLoading2:false,
			labelId:'',
			sortId:'',
        };
    },
    computed: {
        topHeight() {
            const systemInfo = uni.getSystemInfoSync();
            return systemInfo.statusBarHeight + 44
        },
    },
    watch: {
        defaultWord: {
            handler(newVal, oldVal) {
				
				this.keyword = newVal
				
            },
            immediate: true,
        },
		navSelect(newVal,oldVal){
			console.log(newVal)
			if(newVal && newVal !== oldVal){
				this.select_tab = newVal == 1 ? 0 : 1
			}
		}
    },
    mounted() {
		this.getZxList()
		this.getCommentList()
		this.getSxtjList()
		this.close()
    },
    methods: {
		
		tabChange({ index }) {
			this.select_tab = index;
			this.$store.dispatch('ChangeCircleTab',index == 0 ? 1 :2)
		},
        pullRefresh() {
			if (this.select_tab === 0) {
				this.triggered = true
			}else{
				this.triggered2 = true
			}
        },
        getCommentList() {
			this.isLoading = true

            let params = {
                type: 0,    
                keyword: this.keyword || '',
                sortId: this.sortId || '',
                labelId: this.labelId || '',
                page: this.commentPage
            }
            commentListReq(params).then(res => {
				let res_data = res.data.commentList
				if(res_data.length){
					this.commentList = this.commentPage > 1 ? this.commentList.concat(res_data) : res_data
					this.$nextTick(()=>{
						this.moreStatus = 'loadmore'
					})
				}else{
					this.load_end = true
					this.moreStatus = 'nomore'
				}
            }).finally(() => {
				this.$nextTick(()=>{
				
					this.isLoading = false
					this.triggered = false
				})
            })
        },
        getZxList() {
			console.log('123')
			this.isLoading2 = true
            let params = {
                sortId: this.ortId || '',
                labelId: this.labelId || '',
                page: this.page,
                keyword: this.keyword || '',
            }
            articleListReq(params).then(res => {
				let res_data = res.data.articleList
				if(res_data.length){
					this.zxList = this.page > 1 ? this.zxList.concat(res_data) : res_data
					this.$nextTick(()=>{
						this.moreStatus2 = 'loadmore'
					})
				}else{
					this.load_end2 = true
					this.moreStatus2 = 'nomore'
				}
            }).finally(() => {
				this.$nextTick(()=>{
					
					this.isLoading2 = false
					this.triggered2 = false
				})
            })

        },

        getSxtjList() {
            let params = {
                sortId: 0,
                labelId: 0
            }
            filterCriteriaReq(params).then(res => {
                let popList = res.data.labelList || []
                let sortList = res.data.sortList || []
				if(this.filterInfo.labelId){
					let label_ids = this.filterInfo.labelId.split(',')
					popList.forEach((item,index) =>{
						if(label_ids.indexOf(item.labelId) >= 0){
							item.pick = true
						}
						return item
					})
				}
				if(this.filterInfo.sortId){
					let sort_ids = this.filterInfo.sortId.split(',')
					sortList.forEach((item,index) =>{
						if(sort_ids.indexOf(item.sortId) >= 0){
							item.pick = true
						}
						return item
					})
				}
				
				this.popList = popList
				this.firstList = sortList
            })
        },
        pickLabel(index) {
			let item = JSON.parse(JSON.stringify(this.popList[index]))
            this.$set(this.popList[index], 'pick', !item.pick)
			// this.$nextTick(()=>{
			// 	console.log(this.popList)
			// })
        },
        pickSort(index) {
			let item = JSON.parse(JSON.stringify(this.firstList[index]))
			this.$set(this.firstList[index], 'pick', !item.pick)
			// this.$nextTick(()=>{
			// 	console.log(this.firstList)
			// })
        },
        fatie() {
			let url = `/pages/fatie/fatie?commentId=`
			this.$utils.goOthersCheckLogin(url)
        },

        pickConfirm() {
			
			this.labelId =  this.popList.filter(_ => _.pick).map(_ => _.labelId).join(',')
			this.sortId = this.firstList.filter(_ => _.pick).map(_ => _.sortId).join(',') 
			
			this.$store.dispatch('ChangeFilterInfo',{
				sortId: this.sortId || '',
				labelId: this.labelId || ''
			})
            this.restList()
            this.close()
        },

        loadMore2() {
			if(this.load_end2){
				return
			}
			if(this.isLoading2){
				return
			}
            this.page++
            this.moreStatus2 = 'loading'
            this.getZxList()
        },
        loadMoreComment() {
			if(this.load_end){
				return
			}
			if(this.isLoading){
				return
			}
            this.commentPage++
            this.moreStatus = 'loading'
            this.getCommentList()
        },
        restList() {
			console.log(this.select_tab)
			// if()
            if (this.select_tab === 0) {
                this.commentPage = 1
                this.getCommentList()
            } else {
                this.page = 1
                this.getZxList()
            }
            this.$refs.searchList.show = false
        },
        //搜索
        goToSearch(item) {
			console.log(this.readonly)
            if (this.readonly) {
                uni.navigateTo({
                    url: `/pages/circle/search`
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
            this.show = this.show ? false : true
        },
        close() {
            this.show = false
        },
        resetPop() {
			
			// let popList = JSON.parse(JSON.stringify(this.popList))
			
			// let firstList = JSON.parse(JSON.stringify(this.firstList))
            this.popList.forEach((_,index) => {
				if(_.pick){
					this.$set(this.popList[index],'pick',false)
				}
			})
			this.firstList.forEach((_,index) => {
				if(_.pick){
					this.$set(this.firstList[index],'pick',false)
				}
			})
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
.list-box{
	height: calc(100% - 164rpx);
	.hot_talk_content{
		height: 100%;
	}
}
.bottom-fill{
	height: 40rpx;
}

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
		box-sizing: border-box;
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
            .searchbt {
				width: 128rpx;
				height: 56rpx;
				line-height: 56rpx;
				background: #0fc8ac;
				border-radius: 28rpx;
				margin-left: 8rpx;
				color: white;
				text-align: center;
            }
        }
		.search-right-box{
			margin-left: 50rpx;
			.searchbt {
				line-height: 56rpx;
				margin-right: 10rpx;
				color: white;
				text-align: center;
			}
		}

        .content_search_back {
            width: 690rpx;
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
		min-width: 100rpx;
		padding: 0 20rpx;
		height: 70rpx;
		display: flex;
		align-items: center;
		justify-content: center;
		background-color: #F2F3F5;
		border-radius: 8rpx;
		color:#333;
		&.pop-item-select {
			background-color: #0fc8ac;
			color: white
		}
	}
	.footer {
		margin-top: 80rpx;
		display: flex;
		flex-direction: row;
		justify-content: space-between;
		gap: 20rpx
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
