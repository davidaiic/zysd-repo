<template>
    <view :id="keyId" class="select-content" :style="styleObj || ''">
        <u-input fontSize="14" placeholderStyle="color: #b2b2b2 " v-if="remote" :customStyle="searchInput" height="60rpx"
            class="searchInput" v-model="selectValue" confirmType="search" :placeholder="placeholder" @input="inputSearch"
            @focus="focus" @burl="burl">
        </u-input>
        <view v-else class="select-box" @click.stop="selectSearch">
			<text class="line1 flex-one" :style="{color:!selectValue ? '#b2b2b2' : '#333'}"> {{selectValue ||placeholder}} </text>
            <u-icon name="arrow-down" color="#999" size="14"></u-icon>
        </view>
        <view v-if="isShow" class="u-page" :style="{height:height+'rpx'}">
            <u-loading-icon v-if="loading" :show="loading"></u-loading-icon>
            <block v-else>
				
				<!--  @scrolltolower="scrolltolower" -->
                <u-list v-if="searchList && searchList.length" height="100%">
                    <u-list-item v-for="(item, index) in searchList" :key="index">
						<block v-if="!item.is_hide">
							<u-cell @click="goSelect(item)">
							    <view slot="title">
							        <view>{{ item[showKey] }}</view>
							    </view>
							</u-cell>
						</block>
                    </u-list-item>
                    <u-loadmore v-if="isMore" bgColor="#ffffff" :status="moreStatus" />
                </u-list>
                <u-empty v-else mode="search">
                </u-empty>
            </block>
        </view>
    </view>
</template>

<script>
import { debounce } from '@/utils/utils'
export default {
    props: {
        styleObj: {
            type: Object,
            default: () => { }
        },
        remote: {
            type: Boolean,
            default: false,
        },
		list:{
			type:Array,
			default:()=>{
				return []
			}
		},
        url: {
            type: String,
            default: ""
        },
        placeholder: {
            type: String,
            default: ''
        },
        defaultValue: {
            type: String,
            default: ""
        },
        showKey: {
            type: String,
            default: "goodsName"
        },
        currentValue: {
            type: Object,
            default: () => { }
        },
        keyId: {
            type: String,
            default: ""
        },
		height:{
			type:String,
			default:'500'
		}
    },

    data() {
        return {
            searchInput: {
                color: '#333333',
                'background-color': 'white',
                padding: '4rpx 10rpx',
            },
            selectValue: '',
            searchList: [],
            page: 1,
            isShow: false, // 是否展示搜索
            isSelected: false, //是否选择
            loading: false,
            moreStatus: '', //加载更多
            isMore: false, //是否是加载更多
            isCancle: false, // 是否取消搜索
            isFocus: '' //是否是聚焦搜索
        }
    },
    watch: {
        defaultValue: {
            handler(newVal, oldVal) {
                this.selectValue = newVal
                //不知道为什么小程序右侧得选择药品不会触发input方法手动去更新一下
                if (this.remote) {
                    // this.$emit('update:currentValue', { [this.showKey]: newVal })
                    // this.$emit('complete')
                }
            },
            immediate: true,
			deep:true
        },
		list:{
			handler(newVal, oldVal) {
				
				this.loading = false
			    if(newVal.length > 0){
					let list = newVal
					// if(list.length > 1 && this.isFocus){
					// 	this.isShow = true
					// }
					if (!this.remote && list && list.length === 1) {
						this.goSelect(list[0])
					}
					this.searchList = list
					this.loading = false
				}
			},
			immediate: true,
			deep:true
		}
    },
    methods: {
        focus() {
            this.isShow = true
            // this.loading = true
            this.isFocus = true
        },
        burl() {
            this.isShow = false
            this.loading = false
            this.isCancle = false
        },
        outSide(e) {
            const dom = document.getElementById(this.keyId)
            if (dom && !dom.contains(e.target)) {
                this.isShow = false;
            }
        },
        closeDialog() {
            this.isShow = false;
        },
        scrolltolower() {
			if(this.moreStatus =='loading' ){
				return
			}
            this.page++
            this.moreStatus = 'loading'
            this.isMore = true
            this.loadmore()
        },
		//搜索框 
        inputSearch: debounce(function (text) {
			if(!this.isFocus){
				return
			}
            // if (this.remote) {
            //     this.$emit('complete',text)
            // }
            if (this.isSelected) {
                this.isSelected = false
                return
            }

            // this.isCancle = false
            // if (!text) {
            //     return
            // }
            // this.loading = true
            // this.isShow = this.isFocus
            this.page = 1
            this.search()
        }),
		search() {
		    const that = this
		    const params = {
		        keyword: this.selectValue,
		        page: this.page
		    }
		    this.$emit('search',params,this.keyId)
		},
        loadmore() {
            let params = {
                keyword: this.selectValue,
                page: this.page
            }
            this.search()
        },
		
		// 下拉框搜索
		selectSearch() {
		    this.$emit('check',this.keyId)
		},
		// 下拉框选中
        goSelect(item) {
            this.selectValue = item[this.showKey]
            // this.$emit('update:currentValue', item)
            this.$emit('complete',item,this.keyId)
            this.isShow = false
            this.isSelected = true
        },
		showBox() {
		    this.isShow = true
		},
        cancleReq() {
            this.isShow = false
            this.isCancle = true
        },
		startLoading(){
			this.loading = true
		},
		endLoading(){
			this.loading = false
		}
    }
}
</script>

<style lang="scss" scoped>
.select-content {
    position: relative;
    width: 100%;

    .searchInput {
        color: #333333;
        background-color: white;
        padding: 4rpx !important;
    }

    .select-box {
        height: 60rpx;
        display: flex;
        flex-direction: row;
        background: #FFFFFF;
        font-size: 24rpx;
        border-radius: 8rpx;
        border: 2rpx solid #E0E0E0;
        align-items: center;
        padding: 0 10rpx;
    }

    .u-page {
        position: absolute;
        width: 100%;
        // max-height: 500rpx;
        // min-height: 50rpx;
		height: 500rpx;
        z-index: 10;
        background-color: #ffffff;
    }
}
</style>
