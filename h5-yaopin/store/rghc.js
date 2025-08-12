import api from '@/utils/apis.js'

const state = {
	currentUser: null
}

const getters = {
	currentUser: state => state.currentUser
}

const actions = {
	// 人工核查信息接口
	getQueryManual({
		commit,
		state
	}, params) {
		return api.queryManual(params)
	},
	// 照片查询接口
	getQueryPhoto({
		commit,
		state
	}, params) {
		return api.queryPhoto(params)
	}
}

const mutations = {

}

export default {
	namespaced: true,
	state,
	getters,
	actions,
	mutations
}
