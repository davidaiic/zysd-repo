import api from '@/utils/apis.js'

const state = {
	currentUser: null
}

const getters = {
	currentUser: state => state.currentUser
}

const actions = {
	// 渠道列表接口
	getQueryChannelList({
		commit,
		state
	}, params) {
		return api.queryChannelList(params)
	},
	// 药厂列表接口
	getQueryCompanyList({
		commit,
		state
	}, params) {
		return api.queryCompanyList(params)
	},
	// 价格查询接口
	getQueryPriceSearch({
		commit,
		state
	}, params) {
		return api.queryPriceSearch(params)
	},
	// 药厂防伪码查询文案接口
	getQueryCodeQuery({
		commit,
		state
	}, params) {
		return api.querycodeQuery(params)
	},
	// 规格列表接口
	getSpecList({
		commit,
		state
	}, params) {
		return api.querySpecList(params)
	},
	// 比价接口
	comparePrice({
		commit,
		state
	}, params) {
		return api.comparePrice(params)
	},
	// 新药品查询接口
	getRelateGoodsName({
		commit,
		state
	}, params) {
		return api.getRelateGoodsName(params)
	},
	
	
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
