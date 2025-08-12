<!-- 这是搜索页面 -->
<template>
    <view class="content">
        <!-- 搜索 -->
		<slot>
			<view class="content_search">
				<view class="content_search_back">
					<u-icon name="arrow-left" color="#fff" size="24" @click="goHome()" ></u-icon>
					<u-input height="60rpx" clearable :customStyle="searchInput" class="searchInput" v-model="searchModel"
						shape="circle" confirmType="search" :placeholder="placeholder" @confirm="goToSearch()">
						<template slot="prefix">
							<view class="search-left">
								<u-icon name="search" color="#999999" size="44rpx" @click="goToSearch()" />
							</view>
						</template>
						<template slot="suffix">
							<view class="search-right">
								<view class="searchbt" @click="goToSearch()">搜索</view>
							</view>
						</template>
					</u-input>
				</view>
			</view>
		</slot>
    </view>
</template>

<script>
// questUrl动态修改，现在中考虑了一种情况
import { debounce } from '@/utils/utils'
import {associateWordReq} from '@/api/home.js'
import { relateGoodsNameReq} from '@/api/goodsApi.js'
let default_placeholder = '请输入药品名称'
export default {
    props: {
        defaultValue: {
            type: String,
            default: ''
        },
		placeholder:{
			type: String,
			default: default_placeholder
		},
        questUrl: {
            type: String,
            default: ''
        },
        keyName: {
            type: String,
            default: 'word'
        }
    },
    data() {
        return {
            showIt: true,
            historyList: [],
            hotSearch: [],
            searchDesc: "",
            searchModel: '',
            searchInput: {
                color: '#333333',
                'background-color': 'white',
                padding: '4rpx',
            },
            page: 1,
            searchList: [],
            isMore: false,
            moreStatus: ""
        };
    },
    mounted() {
        this.searchModel = this.defaultValue || ''
    },
    methods: {
        goToSearch(item) {
			let search_text = ''
            if (uni.$u.trim(this.searchModel) === "") {
				uni.showToast({
					icon: "none",
					title: "请输入搜索内容",
				});
				return false;
            }else{
				search_text = item || this.searchModel 
			}
            this.$emit('update:searchModel', search_text )
            this.$emit('search')
        },

        goHome() {
            this.$emit('back')
        },
        getSearchTetx(item) {
            const word = this.searchModel
            item = item.replace(new RegExp("(" + word + ")", "ig"), `<text style="color: #0ad0b2">${word}</text>`)
            return item
        }

    },
};
</script>

<style lang="scss" scoped>
.content {
    position: relative;
    .content_search {
        z-index: 20;
		height: 122rpx;
		background-color: #0AD0B2;
		display: flex;
		align-items: center;
		justify-content: center;
		position: sticky;
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

        .content_search_back {
            z-index: 2;
            width: calc(100% - 60rpx);
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

.u-page {
    position: fixed;
    width: 100%;
    height: 100%;
    z-index: 10;
    background-color: #ffffff;
}
</style>
