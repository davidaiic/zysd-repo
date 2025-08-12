<!-- 我要比价 -->
<template>
    <view class="mainWrap" @click="outside">
        <view class="contents">
            <u-navbar v-if="!isH5" title="我要比价" @leftClick="leftClick" :fixed="false"
                :titleStyle="{ color: '#FFF', fontSize: '18px' }"></u-navbar>
        </view>
        <scroll-view class="content" scroll-y :style="{ height: scrollViewheight + 'px' }">
            <u-sticky style="top: 0">
                <view class="info">
                    <text class="spical-text">温馨提示：目前仅为用户提供肿瘤类原研药以及仿制药的价格信息查询服务！</text>
                </view>
            </u-sticky>
            <view class="main-content">
                <view class="main-box-content flex-row  flex-ac flex-jb">
                    <view class="main-box">
                        <view>
                            <searchInput  keyId="goods1"  :defaultValue="defaultValue.search_name || ''" 
								ref="goodsIput" remote
                                placeholder="输入药品" :list="goods_info_list.list" showKey="goodsName"
                                @search="goodsSearch" @complete="completeGoods"  :switchSearchRef="switch_search_refs"/>
                        </view>
                        <view style="margin: 20rpx 0;">
                            <searchInput 
								keyId="company1"
								:currentValue.sync="company1" 
								ref="companyIput" 
								placeholder="选择厂家"
								 :list="companys_info_list.list"
                                showKey="companyName" 
								:defaultValue="defaultValue.left_cname"
                                @search="companySearch" 
								@check="checkCompany" 
								@complete="completeCompany" />
                        </view>
                        <view>
                            <searchInput keyId="specs1" :currentValue.sync="specs1" ref="specsInput" placeholder="选择规格"
                                showKey="specs" :defaultValue="defaultValue.left_spec"
								:list="left_spec_list.list" 
								height="220"
                                @check="checkSpecs" @complete="completeSpecs" />
                        </view>
                    </view>
					
                    <view class="text-wrapper_2 ">
                        <text lines="1" class="text_26">VS</text>
                    </view>
                    <view class="main-box">
                        <view>
                            <searchInput  keyId="goods2" :defaultValue="defaultValue.search_name" 
								ref="goodsIput2" remote
                                placeholder="输入药品" showKey="goodsName"  :list="goods_info_list.list"
                                @search="goodsSearch" @complete="completeGoods"  :switchSearchRef="switch_search_refs"/>
                        </view>
                        <view style="margin: 20rpx 0;">
                            <searchInput keyId="company2" :currentValue.sync="company2" ref="companyIput2"
                                placeholder="选择厂家"
								:list="companys_info_list.list" 
								:defaultValue="defaultValue.right_cname" showKey="companyName"
                                @search="companySearch" @check="checkCompany" @complete="completeCompany" />
                        </view>
                        <view>
                            <searchInput keyId="specs2" :currentValue.sync="specs2" ref="specsInput2" placeholder="选择规格"
                                showKey="specs" 
								height="200"
								:defaultValue="defaultValue.right_spec" 
								:list="right_spec_list.list" 
                                @check="checkSpecs"  @complete="completeSpecs"/>
                        </view>
                    </view>
                </view>
                <view class="button-main">
                    <u-button shape="circle" color="#0FC8AC" @click="wybj">我要比价</u-button>
                </view>

            </view>
            <u-gap bgColor="#F2F3F5" height="20rpx" />
            <view v-show="goodsList && goodsList.length" class="result-content">
                <view class="port_title">
                    <view>
                        比价结果
                    </view>
                </view>
                <view class="hot_content">
					<goodsList :lists="goodsList" :contrastPrice="2" :showMaxPrice="1"></goodsList>
                </view>
            </view>
            <view class="result-content" style="line-height: 40rpx;">
                <u-parse :content="compareText"></u-parse>
            </view>
			<view class="bottom-fill"  v-if="goodsList && goodsList.length"></view>
        </scroll-view>
		
        <view v-if="goodsList && goodsList.length" class="bottomBtn flex-row">
            <u-button :customStyle="{ flex: 1 }" :plain="true" shape="circle" openType="share" color="#0FC8AC"
                @click="shareEnterPage">我要分享</u-button>
            <u-button :customStyle="{ flex: 2, 'margin-left': '20rpx ' }" shape="circle" color="#0FC8AC"
                @click="tjkf">了解更多信息添加客服微信</u-button>
        </view>
    </view>
</template>

<script>

import goodsList from '@/components/goodsInfo/goodsList.vue'
import searchInput from './search-input.vue';
import { bridgrCall } from '@/utils/bridge'

import {
	pluginContentReq,
	appShareReq
} from '@/api/home.js'
import {
	goodsInfoReq,
	companyListReq,
	specListReq,
	comparePriceReq,
	relateGoodsNameReq
} from '@/api/goodsApi.js'

export default {
    components: {
        searchInput,
		goodsList
    },
    data() {
        return {
			switch_search_refs:'',
			goods_info_list:{
				page:0,
				list:[],
				end:false
			},
			companys_info_list:{
				page:0,list:[],error:0//1,一条数据，失败
			},
			left_spec_list:{
				page:0,list:[]
			},
			right_spec_list:{
				page:0,list:[]
			},
            goodsList: [],
            share: {},
            goods1: {},
            company1: {},
            specs1: {},
            specs2: {},
            goods2: {},
            company2: {},
			// 搜索时的内容
            defaultValue: {
				search_name:'',
                left_cid: '',
                right_cid: '',
                left_spec: '',
				right_spec: '',
                left_cname: '',
                right_cname: '',
            },
			// 选择下拉确认的内容
			enter_value:{
				search_name:'',
				left_cid: '',
				right_cid: '',
				left_spec: '',
				right_spec: '',
				left_cname: '',
				right_cname: '',
				
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
		// 分享进入
		if(option.data){
			let defaultValue = decodeURIComponent(option.data) === 'undefined' ? {} : JSON.parse(decodeURIComponent(option.data))
			
			if (defaultValue.rightGoodsName) {
				let now_data = {
					search_name:defaultValue.rightGoodsName,
					left_cid: defaultValue.leftCompanyId,
					left_cname: defaultValue.leftCompanyName,
					left_spec: defaultValue.leftSpecs,
					right_cname: defaultValue.rightCompanyName,
					right_cid: defaultValue.rightCompanyId,
					right_spec: defaultValue.rightSpecs,
				}
				this.defaultValue = now_data
				
				this.enter_value = now_data
			    this.shareEnterPage()
			} else {
			    this.defaultValue = {}
			}
		}
        
    },
	onShow(){
		// #ifdef H5
		document.title = '我要比价'
		//#endif
	},
    methods: {
        getGoods(goodsId) {
            goodsInfoReq({ goodsId: goodsId }).then(res => {
                const data = res.data.goodsInfo
                this.defaultValue = {
					search_name:data.goodsName,
					left_cid: data.companyId,
					right_cid: '',
					left_spec: data.specs,
					right_spec: '',
					left_cname: data.companyName,
					right_cname: '',
                }
				this.enter_value = this.defaultValue
				this.loadCompanyList()
            })
        },
        goodsSearch(params,keyId) {
			let refs =  keyId == 'goods1' ? 'goodsIput' : 'goodsIput2'
			// this.switch_search_refs = keyId
			this.outside(refs)
			let main_info =  this.goods_info_list
			// if(params.page > main_info.page){
			// 	this.goods_info_list.page = params.page
			// }
			
			this.defaultValue.search_name = params.keyword
			
			this.enter_value.search_name = params.keyword
			this.defaultValue.left_cname = ''
			this.defaultValue.right_cname = ''
			this.defaultValue.left_cid = ''
			this.defaultValue.right_id = ''
			this.defaultValue.left_spec = ''
			this.defaultValue.right_spec = ''
			
			this.enter_value.left_cname = ''
			this.enter_value.right_cname = ''
			this.enter_value.left_cid = ''
			this.enter_value.right_id = ''
			this.enter_value.left_spec = ''
			this.enter_value.right_spec = ''
			
			this.companys_info_list.list = []
			this.companys_info_list.error = 0
			this.left_spec_list.list = []
			this.right_spec_list.list = []
			this.refsShowBox(refs)
			this.refsLoading(refs)
            relateGoodsNameReq(params).then(res => {
				let list = res.data.goodsNameList
				if(list.length == 0){
					this.goods_info_list.end = true
					list = main_info.list
				}
				this.refsEndLoading(refs)
				this.goods_info_list.list = list
				
            }).catch(res=>{
				this.refsEndLoading(refs)
			})
        },
		completeGoods(value) {
			this.defaultValue.left_cname = ''
			this.defaultValue.right_cname = ''
			this.defaultValue.left_cid = ''
			this.defaultValue.right_id = ''
			this.defaultValue.left_spec = ''
			this.defaultValue.right_spec = ''
			
			this.enter_value.left_cname = ''
			this.enter_value.right_cname = ''
			this.enter_value.left_cid = ''
			this.enter_value.right_id = ''
			this.enter_value.left_spec = ''
			this.enter_value.right_spec = ''
			
			this.companys_info_list.list = []
			this.companys_info_list.error = 0
			this.left_spec_list.list = []
			this.right_spec_list.list = []
			if(value && value.goodsName){
				// console.log('completegoods:'+value.goodsName)
				this.defaultValue.search_name = value.goodsName
				this.enter_value.search_name = value.goodsName
				this.$nextTick(()=>{
					this.loadCompanyList()
				})
			}
		},
		
		// 企业列表
		
		loadCompanyList(){	
			uni.showLoading({
				mask:true,
				title:'企业加载中...'
			})
			this.refsLoading('companyIput')
			this.refsLoading('companyIput2')
			const params = {
			    goodsName: this.enter_value.search_name,
			    // page: param.page,    
			    type: 2
			}
			companyListReq(params).then(res => {
				
				uni.hideLoading()
				let list = res.data.companyList
				if (list.length <= 1) {
				    uni.showToast({
				        title: '因系统中无同类商品，暂不能提供该产品的比价服务',
				        icon: 'none'
				    })
					this.companys_info_list.error = 1
					list = []
				}
				this.refsEndLoading('companyIput')
				this.refsLoading('companyIput2')
				this.companys_info_list.list = list
			})
		},
		checkCompany(keyId) {
			if(this.companys_info_list.error){
				uni.showToast({
				    title: '因系统中无同类商品，暂不能提供该产品的比价服务',
				    icon: 'none'
				})
				return
			}
			let refs = keyId == 'company1' ? 'companyIput' : 'companyIput2'
			this.outside(refs)
		    if (!this.enter_value.search_name) {
		        uni.showToast({
					icon: 'none',
					title: '请先选择药品'
				})
				return
		    }
			
			this.refsShowBox(refs)
			
			
			let main_info =  this.companys_info_list
			
			let companyId = keyId == 'company1' ? this.enter_value.right_cid : this.enter_value.left_cid
			if(main_info.list.length == 0){
				
			}else{
				let list = main_info.list
				list = list.map(_ => {
					_.is_hide = (_.companyId == companyId)
					return _ 
				})
				this.companys_info_list.list = list
			}
		},
        companySearch(param,keyId) {
			let main_info =  this.companys_info_list
            
        },
		
		completeCompany(item,keyId) {
			if(keyId == 'company1'){
				 this.enter_value.left_cid = item.companyId
				 this.enter_value.left_cname = item.companyName
				this.enter_value.left_spec = ''
				 
				this.defaultValue.left_cid = item.companyId
				this.defaultValue.left_cname = item.companyName
				this.defaultValue.left_spec = ''
				
			}else{
				 this.enter_value.right_cid = item.companyId
				 this.enter_value.right_cname = item.companyName
				 this.enter_value.right_spec = ''
				 
				 
				 this.defaultValue.right_cid = item.companyId
				 this.defaultValue.right_cname = item.companyName
				 this.defaultValue.right_spec = ''
			}
			if(keyId == 'company1'){
				this.left_spec_list.list = []
				this.searchSpecs('specs1')
			}else{
				this.right_spec_list.list = []
				this.searchSpecs('specs2')
			}
			
		},
		checkSpecs(keyId){
			
			let refs = keyId == 'specs1' ? 'specsInput' : 'specsInput2'
			const goodsName = this.enter_value.search_name
			const companyId = keyId == 'specs1' ? this.enter_value.left_cid : this.enter_value.right_cid
			if (!goodsName) {
			    uni.showToast({
			        icon: 'none',
			        title: '请先选择药品'
			    })
			    return
			}
			if (!companyId) {
			    uni.showToast({
			        icon: 'none',
			        title: '请先选择厂家'
			    })
			    return
			}
			
			this.outside(refs)
			this.refsShowBox(refs)
		},
        searchSpecs(keyId) {
			let refs = keyId == 'specs1' ? 'specsInput' : 'specsInput2'
            const goodsName = this.enter_value.search_name
            const companyId = keyId == 'specs1' ? this.enter_value.left_cid : this.enter_value.right_cid
			
           if (!goodsName) {
               uni.showToast({
                   icon: 'none',
                   title: '请先选择药品'
               })
               return
           }
           if (!companyId) {
               uni.showToast({
                   icon: 'none',
                   title: '请先选择厂家'
               })
               return
           }
			
			this.refsLoading(refs)
			const params = {
			    goodsName: goodsName,
			    companyId: companyId,
			    type: 2
			}
			specListReq( params).then(res => {
				let list =  res.data.specList
				if(keyId == 'specs1'){
					this.left_spec_list.list = list
				}else{
					this.right_spec_list.list = list
				}
			})
        },
		completeSpecs(item,keyId){
			if(keyId == 'specs1'){
				this.enter_value.left_spec = item.specs
				 
				this.defaultValue.left_spec = item.specs
			}else{
				this.enter_value.right_spec = item.specs
				 
				this.defaultValue.right_spec = item.specs
			}
		},
		wybj() {
			let enter_data = this.enter_value
		    if (!enter_data.search_name) {
		        uni.showToast({
		            icon: 'none',
		            title: '请先选择药品'
		        })
		        return
		    }
		    if (!enter_data.left_cid) {
		        uni.showToast({
		            icon: 'none',
		            title: '请先选择左侧厂家'
		        })
		        return
		    }
			if (!enter_data.left_spec) {
			    uni.showToast({
			        icon: 'none',
			        title: '请先选择左侧规格'
			    })
			    return
			}
		
		    if (!enter_data.right_cid) {
		        uni.showToast({
		            icon: 'none',
		            title: '请先选择右侧厂家'
		        })
		        return
		    }
					
			if (!enter_data.right_spec) {
			    uni.showToast({
			        icon: 'none',
			        title: '请先选择右侧规格'
			    })
			    return
			}
		    const params = {
		        leftGoodsName: enter_data.search_name,
		        leftCompanyId:enter_data.left_cid,
		        leftSpecs: enter_data.left_spec,
		        rightGoodsName: enter_data.search_name,
		        rightCompanyId: enter_data.right_cid,
		        rightSpecs: enter_data.right_spec
		    }
		    comparePriceReq(params).then(res => {
		        this.goodsList = [res.data.leftGoodsInfo, res.data.rightGoodsInfo]
		        // this.compareText = res.data.compareText || ""
		    })
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
        },
		shareEnterPage() {
			let enter_data = this.enter_value
		    const parmas = {
				leftGoodsName: enter_data.search_name,
				leftCompanyId:enter_data.left_cid,
		        leftCompanyName: enter_data.left_cname,
				leftSpecs: enter_data.left_spec,
				rightGoodsName: enter_data.search_name,
				rightCompanyId: enter_data.right_cid,
		        rightCompanyName: enter_data.right_cname,
				rightSpecs: enter_data.right_spec
		    }
		    const url = `/pages/wybj/wybj?data=${encodeURIComponent(JSON.stringify(parmas))}`
		    let title = '你的朋友分享了相同药品不同厂家的价格对比数把，赶紧去了解一下吧'
		    appShareReq({ type: 3 }).then(res => {
		        title = res.data.title
		    })
		        .catch(() => { console.log(e) })
		        .finally(() => {
		            // #ifdef H5
		            bridgrCall.goShare({ 
						path: url, 
						title ,
						img:this.goodsList[0].goodsImage
					}).then((res) => {
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
		
		},
		getCurrImage(cb) {
			let img = ''
			uni.showLoading({
				title: ''
			  })
			  let dom = document.querySelector('.uni-body')
			  const imgDom = dom.querySelectorAll('img')
			  if(imgDom) {
				Array.from(imgDom).map(_=>{
					_.crossOrigin='anonymous'
					_.crossorigin='anonymous'
				})
			  }
			  return html2canvas(dom, {
				width: dom.clientWidth, //dom 原始宽度
				height: dom.clientHeight,
				scrollY: 0,
				scrollX: 0,
				useCORS: true
			  }).then((canvas) => {
				uni.hideLoading()
				//成功后调用返回canvas.toDataURL返回图片的imageData
				img = canvas.toDataURL('image/png', 1)
			   return cb(img)
			  })
		},
		
		getCompareText() {
		    const data = {
		        keyword: 'comparePrice'
		    }
		    pluginContentReq(data).then(res => {
		        this.compareText = res.data.content
		    })
		},
		
		outside(ref_name = '') {
			let ref_names = ['goodsIput','goodsIput2','companyIput','companyIput2','specsInput','specsInput2']
			ref_names.map((item)=>{
				if(ref_name !== item){
					this.$refs[item].cancleReq()
				}
			})
		},
		refsLoading(ref_name = '') {
			ref_name && this.$refs[ref_name].startLoading()
		},
		refsEndLoading(ref_name = '') {
			ref_name && this.$refs[ref_name].endLoading()
		},
		refsShowBox(ref_name = '') {
			ref_name && this.$refs[ref_name].showBox()
		},
		tjkf() {
		    uni.navigateTo({
		        url: "/pages/lxwm/lxwm"
		    })
		},
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

        .button-main {
            padding: 40rpx 64rpx 10rpx 64rpx;
        }

        .main-box {
            padding: 20rpx;
			width: 300rpx;
            background-color: #F2F3F5;
            border-radius: 16rpx;
			box-sizing: border-box;

        }

        .text-wrapper_2 {
            background-color: rgba(255, 147, 48, 1);
            border-radius: 100%;
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
        padding:0 30rpx;
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
        }
    }
}
.bottom-fill{
	height: 148rpx;
}
.bottomBtn {
	box-sizing: border-box;
    position: fixed;
    z-index: 2;
    width: 100%;
	padding: 20rpx 28rpx 40rpx;
	box-shadow: 0rpx -2rpx 12rpx 0rpx rgba(157, 157, 157, 0.19);
    left: 0;
    bottom: 0rpx;
	background: #fff;
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
