import App from './App'
import * as utils from '@/utils/utils.js'

// #ifndef VUE3
import Vue from 'vue'
import uView from '@/uni_modules/uview-ui'
import store from './store'
import appObjectMixin from '@/mixins/appObject/appObject.js';
import { bridgrCall } from './utils/bridge'
Vue.use(uView)
Vue.config.productionTip = false
Vue.prototype.$utils = utils
Vue.prototype.$store = store
App.mpType = 'app'
Vue.mixin(appObjectMixin)
// #ifdef MP
// 引入uView对小程序分享的mixin封装
const mpShare = require('@/uni_modules/uview-ui/libs/mixin/mpShare.js')
Vue.mixin(mpShare)
// #endif


const app = new Vue({
	store,
    ...App
})
app.$mount()
// #endif

// #ifdef VUE3
import { createSSRApp } from 'vue'
export function createApp() {
  const app = createSSRApp(App)
  return {
    app
  }
}
// #endif

// #ifdef H5 
bridgrCall.getUserInfo().then((res)=>{
  const resdata = res?.data || {}
  if(resdata.uid) {
    uni.setStorageSync('uid', resdata.uid)
    uni.setStorageSync('token', resdata.token)
  } else {
    // uni.navigateTo({
    //   url: '/pages/login/noLogin'
    // })
  }
 
}).catch((err)=>{
  alert('error', JSON.stringify(err))
})
//#endif