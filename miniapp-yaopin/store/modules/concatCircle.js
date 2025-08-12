const state = {
	circle_tab:1, //1,圈子，2，资讯
	filter_info:{}
};

const mutations = {
	UPDATE_CIRCLETAB(state, data) {
		state.circle_tab =  parseInt(data);
	},
	UPDATE_filterinfo(state, data) {
		state.filter_info =  data;
	}
};


const actions = {
	ChangeCircleTab({state,commit}, force) {
  		return new Promise(reslove => {
			commit("UPDATE_CIRCLETAB", force);
			reslove(force);
  		}).catch(() => {
  		
  		});
  	},
	ChangeFilterInfo({state,commit}, force){
		commit("UPDATE_filterinfo", force);
	}
	
};


export default {
	state,
	mutations,
	actions
};
