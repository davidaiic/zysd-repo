import store from '@/store'
import {
	LOGIN_STATUS,
	UID,
	USER_INFO
} from '@/config/cache';

import Cache from '@/utils/cache';

const state = {
	// token: Cache.get(LOGIN_STATUS) || '',
	// uid: Cache.get(UID) || null,
	token:'d32a058e9cffe0c73a41535006aaa4d4',
	uid:'146',
	userInfo: Cache.get(USER_INFO)?JSON.parse(Cache.get(USER_INFO)):null,
	currentUser: null,
	isH5:false,
	scrollViewheight:700,
	isShowAdd:Cache.get('isShowAdd') || '',
	
};


const mutations = {
	UPDATE_DEVICE(state, opt) {
		state.isH5 = opt.isH5;
		state.scrollViewheight = opt.scrollViewheight;
	},
	LOGIN(state, opt) {
		state.token = opt.token;
		state.uid = opt.uid;
		Cache.set(LOGIN_STATUS, opt.token);
		Cache.set(UID, opt.uid);
	},
	UPDATE_USERINFO(state, userInfo){
		state.userInfo = userInfo;
		Cache.set(USER_INFO, userInfo);
	},
	UPDATE_LOGIN(state, token) {
		state.token = token;
	},
	LOGOUT(state) {
		state.token = undefined;
		state.uid = undefined
		
		state.userInfo = null
		Cache.clear(LOGIN_STATUS);
		Cache.clear(UID);
		Cache.clear(USER_INFO);
	},
	
	//更新useInfo数据
	changUserInfo(state, payload) {
		state.userInfo[payload.amount1] = payload.amount2;
		Cache.set(USER_INFO, state.userInfo);
	},
	
	UPDATE_ISSHOWADD(state, opt) {
		Cache.set('isShowAdd', '1');
		state.isShowAdd = '1';
	},

};


const actions = {
	UpdateDevice({state,commit}, force){
		
	},
	LOGIN({state,commit}, force){
		return new Promise(reslove => {
			commit("LOGIN", force);
			reslove(force);
		}).catch(() => {
		
		});
	},
	USERINFO({state,commit}, force) {
  		return new Promise(reslove => {
			commit("UPDATE_USERINFO", force);
			reslove(force);
  		}).catch(() => {
  		
  		});
  	},
	LOGOUT({state,commit}) {
		return new Promise(reslove => {
			commit("LOGOUT");
			reslove(force);
		}).catch(() => {
		
		});
	}
};


export default {
	state,
	mutations,
	actions
};
