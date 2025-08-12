export default {
	token: state => state.app.token,
	isLogin: state => !!state.app.token,
	userInfo: state => state.app.userInfo || null,
	uid: state => state.app.uid,
	isShowAdd: state => state.app.isShowAdd,
	currentUser: (state) => state.app.currentUser,
	
	isH5:(state) => state.app.isH5,
	scrollViewheight:(state) => state.app.scrollViewheight,
	// 圈子
	circleTab: (state) => state.concatCircle.circle_tab,
	
	
};
