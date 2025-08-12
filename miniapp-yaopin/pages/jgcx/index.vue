<!-- 价格查询 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="价格查询" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }">
			</u-navbar>
		</view>
		<scroll-view scroll-y class="content" :style="{ height: scrollViewheight + 'px' }">
			<u-sticky style="top: 0">
			    <view class="info">
			        <text class="spical-text">温馨提示：目前仅为用户只支持肿瘤靶向药的查价！</text>
			    </view>
			</u-sticky>
			<!-- 表单 -->
			<view class="form">
				<u--form ref="form1">
					<u-form-item prop="goodsName" borderBottom>
						<searchList class="search-name-box" ref="searchList" :searchModel.sync="goodsInfo.goodsName" keyName="goodsName"
							questUrl="getRelateGoodsName" @search="goToSearch">
							<u--input v-model="goodsInfo.goodsName" disabledColor="#ffffff" placeholder="输入药品名称"
								border="none" @input="inputSearch"></u--input>
						</searchList>
					</u-form-item>
					<u-form-item prop="companyId" borderBottom @click="showPop2">
						<u--input v-model="goodsInfo.companyName" disabled disabledColor="#ffffff" placeholder="选择厂家"
							border="none"></u--input>
						<u-icon slot="right" name="arrow-down"></u-icon>
					</u-form-item>
					<u-form-item prop="specs" borderBottom  @click="showPop3">
						<u--input v-model="goodsInfo.specs" disabled disabledColor="#ffffff" placeholder="选择规格"
							border="none"></u--input>
						<u-icon slot="right" name="arrow-down"></u-icon>
					</u-form-item>
					<u-form-item prop="price" borderBottom>
						<u--input type="digit" placeholder="输入您购买药品的价格" v-model="goodsInfo.price" border="none">
						</u--input>
					</u-form-item>
					<u-form-item prop="channelId" borderBottom @click="showSel = true">
						<u--input v-model="goodsInfo.channelName" disabled disabledColor="#ffffff" placeholder="选择购买渠道"
							border="none"></u--input>
						<u-icon slot="right" name="arrow-down"></u-icon>
					</u-form-item>
				</u--form>
			</view>

			<!-- 文案 -->
			<view class="part">
				<view class="h1">{{ part1Tit }}</view>
				<u-read-more ref="uReadMore1" :shadowStyle="shadowStyle" :toggle="true" closeText="查看更多" color="#0FC8AC"
					showHeight="100">
					<u-parse :content="content1" @load="load"></u-parse>
				</u-read-more>
			</view>
			<view class="part">
				<view class="h1">{{ part2Tit }}</view>
				<u-read-more ref="uReadMore2" :shadowStyle="shadowStyle" :toggle="true" closeText="查看更多" color="#0FC8AC"
					showHeight="60">
					<u-parse :content="content2" @load="load"></u-parse>
				</u-read-more>
			</view>
			<view class="part part3">
				<view class="h1">{{ part3Tit }}</view>
				<!-- <u-read-more ref="uReadMore3" :shadowStyle="shadowStyle" :toggle="true" closeText="查看更多" color="#0FC8AC"
					showHeight="170"> -->
					<u-parse :content="content3" @ready="load"></u-parse>
				<!-- </u-read-more> -->
			</view>
			<view class="bottom-fill"></view>
		</scroll-view>

		<view class="bottomBtn">
			<u-button class="submit" @click="submitForm">立即查询</u-button>
		</view>
		<u-action-sheet :show="showSel" :actions="channelList" @close="showSel = false" @select="selSelect" cancelText="取消"
			:round="10"></u-action-sheet>

		<u-picker :show="showSel2" :columns="companyList" keyName="companyName" @confirm="selSelect2"
			@cancel="showSel2 = false"></u-picker>

		<u-picker :show="showSel3" :columns="specList" keyName="specs" @confirm="selSelect3" @cancel="showSel3 = false">
		</u-picker>
		<!-- 药品名称展示 -->
		<u-picker :show="showSel4" :columns="goodsList" keyName="goodsName" @confirm="selSelect4"
			@cancel="showSel4 = false">
		</u-picker>
	</view>
</template>

<script>
import {
	formatGetUri
} from '@/utils/utils.js';
import searchList from './components/search-list.vue';
import {
	pluginContentReq
} from '@/api/home.js'
import { 
	queryChannelListReq,
	goodsInfoReq,
	companyListReq,
	specListReq,
	relateGoodsNameReq
} from '@/api/goodsApi.js'

export default {
	components: {
		searchList
	},
	data() {
		return {
			goodsInfo: {
				goodsName: '',
				price: '',
				companyId: '',
				companyName: '',
				specs: '',
				channelId: '',
				channelName: ''
			},
			loading: false,
			showSel: false,
			showSel2: false,
			showSel3: false,
			showSel4: false,
			channelList: [],
			companyList: [],
			specList: [],
			goodsList: [],
			shadowStyle: {
				backgroundImage: 'none',
				paddingTop: '0',
				marginTop: '20rpx'
			},
			part1Tit: '',
			part2Tit: '',
			part3Tit: '',
			// 这是一段很长的文字，也可能包含有HTML标签等内容
			content1: ``,
			content2: ``,
			content3: ``,
			isCancle: false,
			default_goodsname:''
		};
	},
	onLoad(option) {
		this.getAllChannal();
		this.getContentStatute();
		this.getContentCost();
		this.getContentLogistics()
		
		if (option.goodsId) {
			
			this.getGoods(option.goodsId)
		}
	},
	
	onShow() {
		// #ifdef H5
		document.title = '价格查询'
		//#endif
	},
	methods: {
		load() {
			this.$nextTick(() => {
				this.$refs.uReadMore1 && this.$refs.uReadMore1.init();
				this.$refs.uReadMore2 && this.$refs.uReadMore2.init();
				this.$refs.uReadMore3 && this.$refs.uReadMore3.init();
			})
		},
		getGoods(goodsId) {
			goodsInfoReq({ goodsId: goodsId }).then(async res => {
				const data = res.data.goodsInfo
				
				this.default_goodsname = data.goodsName
				this.goodsInfo = {
					goodsId:data.goodsId,
					goodsName: data.goodsName,
					price: '',
					companyId: data.companyId,
					companyName: data.companyName,
					specs: data.specs,
					channelId: '',
					channelName: ''
				}
				await this.getAllCompanyList()
				this.getSpecList()
			})
		},
		
		getGoodsList(hasGoods) {
			let that = this
			let params = {
				keyword: that.goodsInfo.goodsName,
				page:1
			}
			this.loading = true
			if (!hasGoods) {
				this.goodsInfo.companyId = '';
				this.goodsInfo.companyName = '';
				this.goodsInfo.specs = ''
			}
			relateGoodsNameReq(params).then(res => {
				this.$set(this.goodsList, 0, res.data.goodsNameList)
				this.loading = false
			}).finally(() => {
				if (!hasGoods) {
					this.getAllCompanyList()
				}
				this.loading = false
			}
			)
		},
		getAllCompanyList() {
			const params = {
				type: 2,
				goodsName: this.goodsInfo.goodsName
			}
			companyListReq(params).then(res => {
				if (res.data.companyList.length === 1) {
					const p = res.data.companyList[0]
					this.goodsInfo.companyId = p.companyId;
					this.goodsInfo.companyName = p.companyName;
					this.getSpecList()
				}
				this.$set(this.companyList, 0, res.data.companyList)
			});
		},
		//规格列表
		getSpecList() {
			let that = this
			if (that.goodsInfo.goodsName && that.goodsInfo.companyId) {
				let params = {
					goodsName: that.goodsInfo.goodsName,
					companyId: that.goodsInfo.companyId
				}
				specListReq(params).then(res => {
					if (res.data.specList.length === 1) {
						const p = res.data.specList[0]
						this.goodsInfo.specs = p.specs
					}
					this.$set(this.specList, 0, res.data.specList)
					// console.log(this.specList, 'this.specListthis.specList')
				})
			}
		},
		selSelect(e) {
			this.goodsInfo.channelId = e.channelId;
			this.goodsInfo.channelName = e.channelName;
		},
		selSelect2(e) {
			let p = e.value[0]
			this.goodsInfo.companyId = p.companyId;
			this.goodsInfo.companyName = p.companyName;
			this.showSel2 = false;
			
			this.goodsInfo.specs = ''
			this.goodsInfo.price = ''
			this.goodsInfo.channelName = ''
			this.getSpecList()
		},

		showPop2() {
			let that = this
			if (!that.goodsInfo.goodsName) {
				uni.showToast({
					icon: 'none',
					title: '请先输入药品名称'
				});
			} else {
				this.showSel2 = true
			}
		},

		showPop3() {
			let that = this
			if (!that.goodsInfo.goodsName || !that.goodsInfo.companyId) {
				uni.showToast({
					icon: 'none',
					title: '请输入药品名称和选择厂家'
				});
			} else {
				this.showSel3 = true
			}
		},
		// showPop4() {
		// 	let that = this
		// 	// if (!that.goodsInfo.companyId) {
		// 	// 	uni.showToast({
		// 	// 		icon: 'none',
		// 	// 		title: '请先选择厂家'
		// 	// 	});
		// 	// } else {
		// 	// 	this.showSel4 = true
		// 	// }
		// 	this.showSel4 = true
		// },
		
		goToSearch() {
			this.isCancle = true
			this.getAllCompanyList()
			this.$refs.searchList.show = false
		},

		inputSearch(text) {
			this.$refs.searchList.searchModel = text
			if (this.isCancle) {
				return this.isCancle = false
			}
			
			if(text &&( text == this.default_goodsname)){
				this.default_goodsname = ''
				return
			}
			this.$refs.searchList.inputSearch(text)
			this.goodsInfo.companyId = '';
			this.goodsInfo.companyName = '';
			this.goodsInfo.specs = ''
			if(!text){
				this.goodsInfo.price = ''
				this.goodsInfo.channelName = ''
			}
			
		},

		selSelect3(e) {
			let p = e.value[0]
			this.goodsInfo.specs = p.specs;
			// this.$refs.form1.validateField('goodsInfo.specs');
			this.showSel3 = false;
		},
		selSelect4(e) {
			let p = e.value[0]
			this.goodsInfo.goodsName = p.goodsName;
			// this.getSpecList()
			// this.getGoodsList()
			this.getAllCompanyList()
			// this.$refs.form1.validateField('goodsInfo.specs');
			this.showSel4 = false;
			this.goodsInfo.specs = ''
		},
		submitForm() {
			let that = this;
			let params = Object.assign({}, this.goodsInfo);
			if (!params.goodsName) {
				uni.showToast({
					icon: 'none',
					title: '请选择药品名称'
				});
				return false;
			}
			if (!params.companyName) {
				uni.showToast({
					icon: 'none',
					title: '请先选择厂家'
				});
				return false;
			}
			if (!params.specs) {
				uni.showToast({
					icon: 'none',
					title: '请选择规格'
				});
				return false;
			}
			if (!params.price) {
				uni.showToast({
					icon: 'none',
					title: '请输入药品价格'
				});
				return false;
			}
			if (!params.channelName) {
				uni.showToast({
					icon: 'none',
					title: '请选择渠道'
				});
				return false;
			}
			uni.showLoading({
				title: '数据查询中'
			});
			uni.$u.sleep(1000).then(() => {
				uni.hideLoading();
				delete params.companyName
				delete params.channelName
				uni.navigateTo({
					url: `/pages/jgcx/result${formatGetUri(params)}`
				});
			})

		},
		
		getAllChannal() {
			queryChannelListReq().then(res => {
				this.channelList = res.data.channelList.map(items => {
					items.name = items.channelName;
					return items;
				});
			});
		},
		getContentStatute() {
			let that = this;
			let params = {
				keyword: 'statute'
			};
			pluginContentReq(params).then(res => {
				this.part1Tit = res.data.title;
				this.content1 = res.data.content;
			});
		},
		getContentCost() {
			let that = this;
			let params = {
				keyword: 'cost'
			};
			pluginContentReq(params).then(res => {
				this.part2Tit = res.data.title;
				this.content2 = res.data.content;
			});
		},
		getContentLogistics() {
			let that = this;
			let params = {
				keyword: 'logistics'
			};
			pluginContentReq(params).then(res => {
				this.part3Tit = res.data.title;
				this.content3 = res.data.content;
			});
		}
	}
};
</script>

<style lang="scss" scoped>
.mainWrap {
	background-color: #f8f8f8;
}
.search-name-box{
	display: flex;
	flex: 1;
}

.content {
	//background-color: #F8F8F8;
	.info {
	    background-color: #F2F3F5;
	    padding: 10rpx 30rpx;
		
		.spical-text {
		    color: #FC511E;
		    line-height: 40rpx;
		}
	}
	.form {
		margin-bottom: 20rpx;
		background-color: #fff;

		/deep/ .u-form-item__body {
			padding-left: 30rpx;
			padding-right: 30rpx;
		}
	}

	.part {
		margin-bottom: 20rpx;
		background-color: #fff;
		padding: 30rpx;

		.h1 {
			font-weight: 600;
			color: #333333;
			line-height: 44rpx;
			font-size: 32rpx;
			margin-bottom: 40rpx;
		}

		/deep/.u-read-more__content {
			color: #333333;
			font-size: 28rpx;
			line-height: 40rpx;
		}
	}

	.part3 {
		/deep/ img {
			width: 100%;
			height: 280rpx;
			background: #f2f3f5;
			border-radius: 8rpx;
			text-indent: 0;
			display: block;
			margin-bottom: 20rpx;
		}

		/deep/ p {
			text-indent: 0;
		}
	}
}

.bottom-fill{
	height: 148rpx;
}
.bottomBtn {
	position: fixed;
	z-index: 2;
	width: 100%;
	background-color: #fff;
	padding: 30rpx 0;
	box-shadow: 0rpx -2rpx 12rpx 0rpx rgba(157, 157, 157, 0.19);
	left: 0;
	bottom: 0;

	.submit {
		height: 88rpx;
		background: #0fc8ac;
		border-radius: 44rpx;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
	}

	/deep/ .u-button {
		width: calc(100% - 56rpx);
		height: 88rpx;
		background: #0fc8ac;
		border-radius: 44rpx;
		color: #fff;
		font-size: 32rpx;
		font-weight: 600;
	}
}
</style>
