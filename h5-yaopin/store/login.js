import api from '@/utils/apis.js'

const state = {
	currentUser: null
}

const getters = {
	currentUser: state => state.currentUser
}

const actions = {
	getOpenid({
		commit,
		state
	}, principal) {
		return new Promise((resolve, reject) => {
			api.getOpenid(principal).then(user => {
				resolve(user)
			}).catch(msg => {
				reject()
			})
		})
	},
	getUserPhone({
		commit,
		state
	}, principal) {
		return new Promise((resolve, reject) => {
			api.getUserPhone(principal).then(user => {
				resolve(user)
			}).catch(msg => {
				reject()
			})
		})
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
