<!-- 未登录页面 -->
<template>
	<view class="mainWrap">
		<!-- <view class="contents">
			<u-navbar v-if="!isH5" title="未登录" :fixed="false"
				:titleStyle="{ color: '#FFF', fontSize: '18px' }">
				<template v-slot:left></template>
			</u-navbar>
		</view> -->
		<view class="contents">
		    <u-navbar v-if="!isH5" title="未登录" class="searchBars"  
			:titleStyle="{ color: '#FFF', fontSize: '36rpx' }" :fixed="false" leftIcon=" ">
		        <!-- <view class="u-nav-slot" slot="left">未登录</view> -->
		    </u-navbar>
		</view>
		<view class="content" :style="{ height: scrollViewheight - 70 + 'px' }">
			<u-empty text="登录后才能查看，请前往登录" :icon="$utils.getImgUrl('noLogin.png')" width="160px" height="140px"
				:margin-top="120"></u-empty>
		</view>
		<view class="bottomBtn">
			<!-- #ifdef H5 -->
			<u-button type="text" @click="getUser">
				登录
			</u-button>
			<!-- #endif -->
			<!-- #ifndef H5 -->
			<u-button openType="getPhoneNumber" @getphonenumber="getUser" type="text" v-if="!isLogin">
				登录
			</u-button>
			<!-- #endif -->
		</view>
	</view>
</template>

<script>
import Cache from '@/utils/cache';

import { bridgrCall } from '@/utils/bridge';
import {
	getOpenidReq,
	getUserPhoneReq,
	userRegisterReq,
	userInfoReq,
} from '@/api/user.js'
import {mapGetters} from 'vuex'
export default {
	computed: mapGetters(['isLogin']),
	data() {
		return {
			next_path:'',
			inviteId:''
		};
	},
	onLoad(option) {
		if(option.redirec){
			this.next_path = option.redirect
		}
	},
	methods: {
		// 获取用户信息, 登录
		getUser(detail) {
			let that = this
			this.getUserFunc(detail);
		},
		getUserFunc(e) {
			let that = this
			//#ifdef H5
			bridgrCall
				.goLogin()
				.then((res) => {
					const resdata = res?.data || {};
					if (resdata.uid) {
						that.LoginSuccess(resdata)
					}
				})
				.catch((e) => {
					console.log(e);
				});
			return;
			//#endif
			if (e.detail.errMsg == "getPhoneNumber:ok") {
				let code = uni.getStorageSync("code");
				if (!code) {
					uni.login({
						provider: "weixin",
						success(resCode) {
							code = resCode.code;
							uni.setStorageSync("code", code);
							that.getUserInner(e, code);
						},
					});
				} else {
					this.getUserInner(e, code);
				}
			} else {
				uni.showToast({
					icon: "none",
					title: "登录失败,拒绝授权！",
					duration: 1500,
				});
			}
		},
		
		getUserInner(e, code) {
			let that = this
			let params = {
				code: code,
			};
			getOpenidReq(params).then((resp) => {
				if (resp && resp.data && resp.data.token) {
					that.LoginSuccess(resp.data)
				} else {
					let p = {
						code: e.detail.code,
					};
					getUserPhoneReq(p).then((phone) => {
						if (phone.data && phone.data.mobile) {
							let reg = {
								nickname: "微信用户",
								avatar: "https://shiyao.yaojk.com.cn/uploads/avatar/20230110/1673363728.png",
								openid: resp.data.openid,
								mobile: phone.data.mobile,
							};
							if (this.inviteId) reg["inviteId"] = this.inviteId;
							userRegisterReq(reg).then((register) => {
								if (register.data && register.data.token) {
									that.LoginSuccess(register.data)
								}
							});
						} else {
							uni.showToast({
								icon: "none",
								title: "获取手机号失败,请再次获取",
							});
						}
					});
				}
			});
		},
		LoginSuccess(signdata){
			let that = this
			this.$store.dispatch('LOGIN', signdata).then(res=>{
				return userInfoReq()
			}).then(res=>{
				this.$store.dispatch('USERINFO',res.data.info)
				
				uni.showToast({
					icon: "none",
					title: this.inviteId ? "加入成功" : "登录成功",
					duration: 1500,
					success() {
						uni.$u.sleep(2000).then(() => {
							that.leftClick();
						});
					},
				});
			})
			
		},
		leftClick(){
			
			let backurl = Cache.get('login_back_url');
			let tab_paths = ['/pages/index/index','/pages/circle/circle','/pages/mine/mine']
			if(backurl){
				if(tab_paths.indexOf(backurl) > -1){
					uni.switchTab({
						url:backurl,
						success: function(e) {
							let page = getCurrentPages().pop(); 
							if (page == undefined || page == null) return; 
							page.onLoad(); 
						}
					})
				}else{
					uni.redirectTo({
						url:backurl
					})
				}
			}else{
				this.$utils.Tips({
					title:'',
					endtime:1
				},{
					tab: 3
				})
			}
			
		}
	}
};
</script>

<style lang="scss" scoped>
.content {
	padding: 40rpx 30rpx 30rpx;
}

.bottomBtn {
	position: fixed;
	z-index: 2;
	width: calc(100% - 28px);
	left: 14px;
	bottom: 20px;

	.submit {
		height: 44px;
		background: #0fc8ac;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}

	/deep/ .u-button {
		height: 44px;
		background: #0fc8ac;
		border-radius: 22px;
		color: #fff;
		font-size: 16px;
		font-weight: 600;
	}
}
</style>
