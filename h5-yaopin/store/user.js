import api from '@/utils/apis.js'

const state = {
	currentUser: null
}

const getters = {
	currentUser: state => state.currentUser
}

const actions = {
	getUserFeedback({
		commit,
		state
	}, principal) {
		return api.userFeedback(principal)
	},
	getRegister({
		commit,
		state
	}, principal) {
		return api.getRegister(principal)
	},
	getUserCenter({
		commit,
		state
	}, principal) {
		return api.userCenter(principal)
	},
	getUserCreateShare({
		commit,
		state
	}, principal) {
		return api.userCreateShare(principal)
	},
	getUserInviteInfo({
		commit,
		state
	}, principal) {
		return api.userInviteInfo(principal)
	},
	getUserQueryInfo({
		commit,
		state
	}, principal) {
		return api.userQueryInfo(principal)
	},
	getUserQueryLog({
		commit,
		state
	}, principal) {
		return api.userQueryLog(principal)
	},
	getUserShareInfo({
		commit,
		state
	}, principal) {
		return api.userShareInfo(principal)
	},
	getUserList({
		commit,
		state
	}, principal) {
		return api.userList(principal)
	},
	getUserCreateWxQRCode({
		commit,
		state
	}, principal) {
		return api.userCreateWxQRCode(principal)
	}
}

const mutations = {
	clearCurrentUser(state) {
		state.currentUser = ''
	}
}

export default {
	namespaced: true,
	state,
	getters,
	actions,
	mutations
}
