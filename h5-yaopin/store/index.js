import Vue from 'vue'
import Vuex from 'vuex'
import login from "@/store/login.js";
import home from "@/store/home.js";
import rghc from "@/store/rghc.js";
import jgcx from "@/store/jgcx.js";
import user from "@/store/user.js";

Vue.use(Vuex) // vue的插件机制

// Vuex.Store 构造器选项
const store = new Vuex.Store({
    // 为了不和页面或组件的data中的造成混淆，state中的变量前面建议加上$符号
    state: {
        // 用户信息
        $userInfo: {
            id: 1
        }
    },
    modules: {
        login,
		home,
		rghc,
		jgcx,
		user
    }
})

export default store
