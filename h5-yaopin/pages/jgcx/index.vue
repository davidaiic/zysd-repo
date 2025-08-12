<!-- 价格查询 -->
<template>
	<view class="mainWrap">
		<view class="contents">
			<u-navbar v-if="!isH5" title="价格查询" :fixed="false" @leftClick="leftClick"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }">
			</u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 100 + 'px' }">
			<!-- 表单 -->
			<view class="form">
				<u--form ref="form1">
					<u-form-item prop="goodsName" borderBottom>
						<u--input v-model="goodsInfo.goodsName" disabledColor="#ffffff" placeholder="输入药品名称" border="none"
							@input="getGoodsList"></u--input>
						<view slot="right">
							<u-loading-icon v-if="loading"></u-loading-icon>
							<u-icon v-else name="arrow-down" @click="showPop4()"></u-icon>
						</view>
					</u-form-item>
					<u-form-item prop="companyId" borderBottom @click="showPop2">
						<u--input v-model="goodsInfo.companyName" disabled disabledColor="#ffffff" placeholder="选择厂家"
							border="none"></u--input>
						<u-icon slot="right" name="arrow-down"></u-icon>
					</u-form-item>

					<u-form-item prop="specs" borderBottom @click="showPop3()">
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
				<u-read-more ref="uReadMore3" :shadowStyle="shadowStyle" :toggle="true" closeText="查看更多" color="#0FC8AC"
					showHeight="170">
					<u-parse :content="content3" @ready="load"></u-parse>
				</u-read-more>
			</view>

			<view class="bottomBtn">
				<u-button class="submit" @click="submitForm">立即查询</u-button>
			</view>
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
export default {
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
			content3: ``
		};
	},
	onLoad() {
		this.getAllChannal();
		// this.getAllCompanyList();
		this.load();
		this.getContentStatute();
		this.getContentCost();
		this.getContentLogistics();
		this.getHeight();
	},
	methods: {
		getAllChannal() {
			this.$store.dispatch('jgcx/getQueryChannelList').then(res => {
				this.channelList = res.data.channelList.map(items => {
					items.name = items.channelName;
					return items;
				});
			});
		},
		getAllCompanyList() {
			const params = {
				type: 2,
				goodsName: this.goodsInfo.goodsName
			}
			this.$store.dispatch('jgcx/getQueryCompanyList', params).then(res => {
				this.$set(this.companyList, 0, res.data.companyList)
			});
		},
		selSelect(e) {
			this.goodsInfo.channelId = e.channelId;
			this.goodsInfo.channelName = e.channelName;
			// this.$refs.form1.validateField('goodsInfo.channelId');
		},
		selSelect2(e) {
			let p = e.value[0]
			this.goodsInfo.companyId = p.companyId;
			this.goodsInfo.companyName = p.companyName;
			// this.$refs.form1.validateField('goodsInfo.companyId');
			this.showSel2 = false;
			this.getSpecList()
			// this.getGoodsList()
			// this.goodsInfo.goodsName = ''
			this.goodsInfo.specs = ''
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
		showPop4() {
			let that = this
			// if (!that.goodsInfo.companyId) {
			// 	uni.showToast({
			// 		icon: 'none',
			// 		title: '请先选择厂家'
			// 	});
			// } else {
			// 	this.showSel4 = true
			// }
			this.showSel4 = true
		},
		//规格列表
		getSpecList() {
			let that = this
			if (that.goodsInfo.goodsName && that.goodsInfo.companyId) {
				let params = {
					goodsName: that.goodsInfo.goodsName,
					companyId: that.goodsInfo.companyId
				}
				that.$store.dispatch('jgcx/getSpecList', params).then(res => {
					this.$set(this.specList, 0, res.data.specList)
					// console.log(this.specList, 'this.specListthis.specList')
				})
			}
		},
		getGoodsList() {
			let that = this
			let params = {
				keyword: that.goodsInfo.goodsName
			}
			this.loading = true
			this.goodsInfo.companyId = '';
			this.goodsInfo.companyName = '';
			this.goodsInfo.specs = ''
			that.$store.dispatch('jgcx/getRelateGoodsName', params).then(res => {
				this.$set(this.goodsList, 0, res.data.goodsNameList)
				this.loading = false
			}).finally(() => {
				this.getAllCompanyList()
				this.loading = false
			}
			)
			// if (that.goodsInfo.companyId) {
			// 	let params = {
			// 		// companyId: that.goodsInfo.companyId
			// 	}
			// 	that.$store.dispatch('jgcx/getRelateGoodsName', params).then(res => {
			// 		this.goodsList[0] = res.data.goodsNameList
			// 	})
			// }
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
		load() {
			this.$nextTick(() => {
				this.$refs.uReadMore1.init();
				this.$refs.uReadMore2.init();
				this.$refs.uReadMore3.init();
			})
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
			let token = uni.getStorageSync('token')
			if (token) {
				uni.$u.sleep(1000).then(() => {
					uni.hideLoading();
					delete params.companyName
					delete params.channelName
					console.log(`/pages/jgcx/result${formatGetUri(params)}`)
					uni.navigateTo({
						url: `/pages/jgcx/result${formatGetUri(params)}`
					});
				})
			} else {
				uni.$u.sleep(1000).then(() => {
					uni.hideLoading();
					uni.navigateTo({
						url: '/pages/login/noLogin'
					})
				})
			}

		},
		getContentStatute() {
			let that = this;
			let params = {
				keyword: 'statute'
			};
			that.$store.dispatch('home/getPluginContent', params).then(res => {
				this.part1Tit = res.data.title;
				this.content1 = res.data.content;
			});
		},
		getContentCost() {
			let that = this;
			let params = {
				keyword: 'cost'
			};
			that.$store.dispatch('home/getPluginContent', params).then(res => {
				this.part2Tit = res.data.title;
				this.content2 = res.data.content;
			});
		},
		getContentLogistics() {
			let that = this;
			let params = {
				keyword: 'logistics'
			};
			that.$store.dispatch('home/getPluginContent', params).then(res => {
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

.content {
	//background-color: #F8F8F8;
	height: calc(100vh - 340rpx);
	overflow-y: auto;

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
