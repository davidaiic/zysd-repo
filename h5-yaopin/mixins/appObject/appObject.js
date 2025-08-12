import { urlConfig } from "@/utils/config";
import { curPlatform } from "@/utils/utils";
export default {
  data() {
    return {
      scrollViewheight: 700,
      tagtopHeight: 44,
      showModelPop: false,
    };
  },

  computed: {
    isH5() {
      return curPlatform() === "H5";
    },
  },
  //#ifndef H5
  //   onPullDownRefresh() {
  //     uni.$u.sleep(1000).then(() => {
  //       uni.stopPullDownRefresh();
  //     });
  //   },
  //#endif
  methods: {
    /**
     * 获取scroll-view高度
     * @param plus
     * @param useSearch 是否存在搜索框
     */
    // getHeight(plus = false, useSearch = true) {
    // 	const query = uni.createSelectorQuery().in(this);
    // 	const that = this;
    // 	let plusHeight = 0
    // 	if (useSearch) plusHeight = plus ? 64 : 20
    // 	query
    // 		.select('.contents')
    // 		.boundingClientRect(data => {
    // 			const systemInfo = uni.getSystemInfoSync();
    // 			that.scrollViewheight = systemInfo.windowHeight - data.height - plusHeight;

    // 		})
    // 		.exec();

    // },

    getHeight() {
      const systemInfo = uni.getSystemInfoSync();
      this.scrollViewheight =
        systemInfo.windowHeight -
        systemInfo.statusBarHeight -
        (this.isH5 ? 0 : 44);
      // console.log(this.isH5,'dsbridge')
    },

    /* 列表滚动 */
    scroll: function (e) {
      this.resetSwipeAction();
      this.old.scrollTopHeight = e.detail.scrollTop;
    },
    // 回到顶部
    backToTop() {
      this.scrollTopHeight = this.old.scrollTopHeight;
      this.$nextTick(() => {
        this.scrollTopHeight = 0;
      });
    },
    // 返回操作
    leftClick() {
      let pages = getCurrentPages();
      let prevPage = pages[pages.length - 2];
      if (prevPage) {
        if (prevPage.route.indexOf("mine/mine") > -1) {
          uni.switchTab({
            url: "/pages/mine/mine",
          });
        } else if (prevPage.route.indexOf("circle/circle") > -1) {
          uni.switchTab({
            url: "/pages/circle/circle",
          });
        } else {
          uni.navigateBack({
            delta: 1,
          });
        }
      } else {
        uni.switchTab({
          url: "/pages/index/index",
        });
      }
    },
  },
};
