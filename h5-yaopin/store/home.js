import api from "@/utils/apis.js";

const state = {
  currentUser: null,
};

const getters = {
  currentUser: (state) => state.currentUser,
};

const actions = {
  getHomeIndex({ commit, state }, params) {
    return api.homeIndex(params);
  },

  getHomeCommentList({ commit, state }, params) {
    return api.homeCommentList(params);
  },

  getHomeCommentLike({ commit, state }, params) {
    return api.homeCommentLike(params);
  },

  getHomeHotWord({ commit, state }, params) {
    return api.homeHotWord(params);
  },

  getHomeSearch({ commit, state }, params) {
    return api.homeSearch(params);
  },

  getQueryCompanySearch({ commit, state }, params) {
    return api.queryCompanySearch(params);
  },

  getPluginKefu({ commit, state }, params) {
    return api.pluginKefu(params);
  },

  getPluginContent({ commit, state }, params) {
    return api.pluginContent(params);
  },

  getHomeComment({ commit, state }, params) {
    return api.homeAddComment(params);
  },

  getHomeCommentInfo({ commit, state }, params) {
    return api.homeCommentInfo(params);
  },

  getPluginContact({ commit, state }, params) {
    return api.pluginContact(params);
  },
  getGoodsList({ commit, state }, params) {
    return api.getGoodsList(params);
  },
  getAssociateWord({ commit, state }, params) {
    return api.homeAssociateWord(params);
  },
  getHotGoods({ commit, state }, params) {
    return api.getHotGoods(params);
  },
  getArticleList({ commit, state }, params) {
    return api.getArticleList(params);
  },
  getFilterCriteria({ commit, state }, params) {
    return api.getFilterCriteria(params);
  },
  addArticleComment({ commit, state }, params) {
    return api.addArticleComment(params);
  },
  articleLike({ commit, state }, params) {
    return api.articleLike(params);
  },
  articleInfo({ commit, state }, params) {
    return api.articleInfo(params);
  },
  articleCommentLike({ commit, state }, params) {
    return api.articleCommentLike(params);
  },

  imageRecognition({ commit, state }, params) {
    return api.imageRecognition(params);
  },
  goodsServer({ commit, state }, params) {
    return api.goodsServer(params);
  },
  extractText({ commit, state }, params) {
    return api.extractText(params);
  },

  scanCode({ commit, state }, params) {
    return api.scanCode(params);
  },
  goodsRisk({ commit, state }, params) {
    return api.goodsRisk(params);
  },
  instructions({ commit, state }, params) {
    return api.instructions(params);
  },
  goodsSubject({ commit, state }, params) {
    return api.goodsSubject(params);
  },
  errorRecovery({ commit, state }, params) {
    return api.errorRecovery(params);
  },
  getAbout({ commit, state }, params) {
    return api.getAbout(params);
  },
  appShare({ commit, state }, params) {
    return api.appShare(params);
  },
  getGoodsInfo({ commit, state }, params) {
    return api.getGoodsInfo(params);
  },
};

const mutations = {};

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations,
};
