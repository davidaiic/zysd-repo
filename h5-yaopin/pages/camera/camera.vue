<template>
  <view>
    <view class="cameraBg" v-if="loading">
      <camera v-if="type === 'pz'" device-position="back" flash="off"
        style="width: 100%; height: 100vh;position: relative;" mode="normal" @error="error">
        <cover-view class="camera-content">
          <cover-view class="content-head" :style="{ height: headerHeight }">
            <cover-image class="left" src="@/static/left-icon.png" @click="leftClick"></cover-image>
            <cover-view class="title">{{ '拍照' }}</cover-view>
          </cover-view>
          <cover-view class="album" @click="takePhoto">
            <cover-image class="albumImg" src="@/static/camera/beat.png"></cover-image>
            <cover-view> 拍照 </cover-view>
          </cover-view>
        </cover-view>
      </camera>
      <camera v-else device-position="back" :flash="flash" style="width: 100%; height: 100vh;position: relative;"
        mode="scanCode" @error="error" @scancode="scanCode">
        <cover-view class="camera-content">
          <cover-view class="content-head" :style="{ height: headerHeight }">
            <cover-image class="left" src="@/static/left-icon.png" @click="leftClick"></cover-image>
            <cover-view class="title">{{ '扫一扫' }}</cover-view>
          </cover-view>
          <cover-view class="bg-one">
            <cover-view class="one-head"></cover-view>
            <cover-view class="one-content">
              <!-- <cover-view class="content-lr"></cover-view> -->
              <cover-view class="content-center">
                <cover-view class="sys_border" :style="{ width: imgWidth, height: imgWidth }">
                  <cover-view :animation="scanAnimation" class="line_bg" :style="{ width: imgWidth, height: imgWidth }">
                    <cover-image class="line" src="@/static/camera/icon_sys.png"></cover-image>
                  </cover-view>

                  <!-- <cover-image src="@/static/camera/icon_sys_border.png"> </cover-image> -->
                  <cover-view class="light" @click="flashChange">
                    <cover-image v-if="isOff" class="light_img" src="@/static/camera/icon_light_close.png"></cover-image>
                    <cover-image v-else class="light_img" src="@/static/camera/icon_light_open.png"></cover-image>
                    <cover-view class="light_text">{{ isOff ? '轻触点亮' : '轻触关闭' }}</cover-view>
                  </cover-view>
                  <!-- 左上角 -->
                  <cover-view class="scan-border scan-left-top scan-verLine"></cover-view>
                  <cover-view class="scan-border scan-left-top scan-horLine"></cover-view>
                  <!-- 左下角 -->
                  <cover-view class="scan-border scan-left-bottom scan-verLine"></cover-view>
                  <cover-view class="scan-border scan-left-bottom scan-horLine"></cover-view>
                  <!-- 右上角 -->
                  <cover-view class="scan-border scan-right-top scan-verLine"></cover-view>
                  <cover-view class="scan-border scan-right-top scan-horLine"></cover-view>
                  <!-- 右下角 -->
                  <cover-view class="scan-border scan-right-bottom scan-verLine"></cover-view>
                  <cover-view class="scan-border scan-right-bottom scan-horLine"></cover-view>
                </cover-view>
              </cover-view>
              <!-- <cover-view class="content-lr"></cover-view> -->
            </cover-view>
          </cover-view>
          <cover-view class="bg-two">
            <cover-image src="@/static/camera/icon_example.png"
              :style="{ width: imgWidth, height: '120rpx', margin: '40rpx 116rpx' }"> </cover-image>
            <cover-view class="text_center">示例图</cover-view>
            <cover-view class="text_center" style="font-size: 24rpx; margin-top: 40rpx">扫描13位数字条形码，无条形码时，请拍照</cover-view>
          </cover-view>
        </cover-view>
        <cover-view v-if="show" class="modal-view">
          <cover-view class="title-content">
            <cover-view class="title">{{ modaltitle }}</cover-view>
            <u-icon name="close" color="#E0E0E0" size="20" @click="close"></u-icon>
          </cover-view>
          <cover-view class="slot-content">
            <cover-view class="word">{{ content }}</cover-view>
            <cover-view class="word goods">{{ goodsName }}</cover-view>
          </cover-view>
          <cover-view class="foot">
            <cover-view class="foot-bt  foot-left" @click="close">
              <cover-view>{{ cancleText }}</cover-view></cover-view>
            <cover-view class="foot-bt  foot-right" @click="confirm">
              <cover-view>{{ confirmText }}</cover-view></cover-view>
          </cover-view>
        </cover-view>
      </camera>
      <cover-view class="scanBtn">
        <cover-image class="beatImg" src="@/static/camera/icon-album@2x.png" @click="scan"></cover-image>
        <cover-view :class="{ unpick_text: type === 'pz' }" @click="changeType('sys')">扫一扫</cover-view>
        <cover-view :class="{ unpick_text: type !== 'pz' }" @click="changeType('pz')">拍照</cover-view>
      </cover-view>
    </view>
  </view>
</template>

<script>
import PopModal from '../../components/pop-modal/pop-modal.vue';
import urlConfig from '@/utils/config.js';
// 移动动画
let animation = wx.createAnimation({});
// 提示音（如果有可以导入，这个我用手机震动来提示扫码完成）
let innerAudioContext = wx.createInnerAudioContext();
export default {
  data() {
    return {
      loading: false,
      type: "sys",
      bgColor: "#080808",
      show: false,
      modaltitle: "该条形码未查询到结果",
      confirmText: "取消",
      cancleText: '拍照',
      content: '您查真伪的是',
      linkUrl: "",
      goodsName: "拍照",
      isOff: true,
      uploadHeader: {
        uid: uni.getStorageSync('uid'),
        token: uni.getStorageSync('token'),
      },
      scanAnimation: null,
      isRec: false,//识别中了
      // flash: 'off'
    };
  },
  computed: {
    imgWidth() {
      return parseInt(uni.getSystemInfoSync().windowWidth - 116) + "px";
    },
    headerHeight() {
      const systemInfo = uni.getSystemInfoSync();
      return systemInfo.statusBarHeight + 44 + "px";
    },
    // //是拍照
    // isPz() {
    //   return this.type === "pz";
    // },
    // mode() {
    //   return this.isPz ? 'normal' : 'scanCode'
    // },
    flash() {
      return this.isOff ? 'off' : 'on'
    }
  },
  created() {
    // 初始化扫码动画
    this.initAnimation();
  },
  onLoad(query) {
    this.type = query.type || "sys";
  },
  mounted() {
    this.loading = true
  },
  methods: {
    initAnimation() {
      var that = this;
      // 控制向上还是向下移动
      let m = true;
      setInterval(
        function () {
          if (m) {
            animation.translateY(240).step({ duration: 3000 });
            m = !m;
          } else {
            animation.translateY(10).step({ duration: 3000 });
            m = !m;
          }
          that.scanAnimation = animation.export();
        }.bind(this),
        3000
      );
    },
    flashChange() {
      console.log(this.isOff, this.flash)
      this.isOff = !this.isOff
    },
    // 相册
    scan() {
      // 选择图片
      uni.chooseImage({
        count: 1,
        sizeType: ["original", "compressed"],
        sourceType: ["album"],
        success: (res) => {
          this.compress(res.tempFilePaths[0]);
        }
      });
    },
    // 启动图片压缩
    compress(tempFilePaths) {
      const vm = this;
      uni.showLoading({
        title: "智能识别中..."
      });
      uni.compressImage({
        src: tempFilePaths,
        quality: 80,
        success: (imageRes) => {
          vm.uploadFilePromise(imageRes.tempFilePath).then((res) => {
            uni.hideLoading();
            console.log(res.data)
            if (!res.data) {
              return uni.showToast({
                title: "未识别到任何结果",
                icon: 'none'
              })
            }
            uni.navigateTo({
              url: `/pages/sbjg/pzjg/pzjg?result=${encodeURIComponent(JSON.stringify(res.data))}`
            })
          })
        }
      });
    },
    scanCode(e) {
      const that = this;
      const result = e.target.result || e.detail.result;
      const params = {
        code: result
      };
      if (this.isRec) {
        return
      }
      this.isRec = true

      uni.showLoading({
        title: "智能识别中..."
      });
      uni.vibrateShort({
        success: function () {
          that.$store.dispatch("home/scanCode", params).then(res => {
            if (res.data.result === 1) {
              that.modaltitle = '请确认是否为该商品'
              that.confirmText = '是'
              that.cancleText = '否，拍照查验'
              that.content = '您查真伪的是'
              that.goodsName = res.data.goodsName
              that.linkUrl = res.data.risk == 1 ? `/pages/result/smRisk?goodsId=${res.data.goodsId}` : `/pages/result/smNoRisk?goodsId=${res.data.goodsId}`
              that.show = true
            } else {
              that.modaltitle = '该条形码未查询到结果'
              that.confirmText = '取消'
              that.cancleText = '拍照'
              that.content = `请对准商品正面拍照`
              that.goodsName = ''
              that.show = true
            }
          }).finally(() => {
            uni.hideLoading()
            that.isRec = false
          })
        }
      });

    },
    uploadFilePromise(url) {
      let that = this;
      return new Promise((resolve, reject) => {
        uni.uploadFile({
          url: `${urlConfig}/query/imageRecognition`, // 仅为示例，非真实的接口地址
          filePath: url,
          header: that.uploadHeader,
          name: 'file',
          success: res => {
            if (res.data) {
              resolve(JSON.parse(res.data));
            } else {
              resolve();
            }
          },
          fail: error => {
            reject();
          }
        });
      });
    },
    // 拍照
    takePhoto() {
      const ctx = uni.createCameraContext();
      ctx.takePhoto({
        quality: "high",
        success: (res) => {
          this.compress(res.tempImagePath);
        }
      });
    },
    changeType(type) {
      if (this.type == type) {
        return
      }
      uni.redirectTo({
        url: `/pages/camera/camera?type=${type}`
      })
    },
    error(e) {
      uni.showToast({
        title: `错了`,
        duration: 2000
      });
    },
    confirm() {
      this.show = false;
      if (this.linkUrl) {
        uni.navigateTo({
          url: this.linkUrl
        })
      }
    },
    close() {
      uni.redirectTo({
        url: `/pages/camera/camera?type=pz`
      })
      this.show = false;
    }
  },

  components: { PopModal }
}
</script>

<style lang="scss">
page {
  background-color: black;
}
</style>

<style lang="scss" scoped>
.modal-view {
  position: absolute;
  width: 80%;
  min-height: 300rpx;
  top: 40%;
  left: 7%;
  padding: 30rpx;
  background-color: white;
  color: #333;
  display: flex;
  border-radius: 16rpx;
  flex-direction: column;

  .title-content {
    display: flex;
    flex-direction: row;
    padding: 30rpx;
    align-items: center;
    justify-content: center;

    .title {
      flex: 1;
      text-align: center;
      font-size: 32rpx;
      line-height: 44rpx;
      margin-left: 40rpx;
    }
  }

  .slot-content {
    font-size: 28rpx;
    color: #333;
    padding: 0 30rpx;
    display: flex;
    flex-direction: row;
    align-items: center;
    justify-content: center;

    .word {
      // display: inline;
    }

    .goods {
      font-size: 32rpx;
      color: #0FC8AC
    }
  }

  .foot {
    display: flex;
    flex-direction: row;
    margin: 20rpx 20rpx 0 20rpx;

    .foot-bt {
      flex: 1;
      border-radius: 50%;
      display: flex;
      align-items: center;
      height: 80rpx;
      justify-content: center;
    }

    .foot-left {
      background-color: #E0E0E0;
      margin-right: 20rpx;
    }

    .foot-right {
      background-color: #0FC8AC;
      color: #ffffff
    }
  }
}



.cameraBg {
  width: 100%;
  height: 100vh;
  position: fixed;
  color: #ffffff;
  background-color: #080808;

  .left {
    width: 48rpx;
    height: 48rpx
  }

  .camera-content {
    display: flex;
    flex-direction: column;
    width: 100%;
    height: 100vh;

    .content-head {
      display: flex;
      flex-direction: row;
      align-items: flex-end;
      padding: 30rpx 30rpx;

      .title {
        flex: 1;
        text-align: center;
        margin-right: 78rpx;
      }
    }

    .bg-one {
      display: flex;
      flex-direction: column;

      .one-head {
        //background-color: #080808;
        width: 100%;
        height: 100rpx;
      }

      .one-content {
        flex: 1;
        display: flex;
        flex-direction: row;
        justify-content: center;

        .content-lr {
          //background-color: #080808;
          width: 116rpx;
        }
      }
    }

    .bg-two {
      flex: 1;
      //background-color: #080808;
    }
  }


  .scan-img {
    width: 100%;
    height: 100%;
    z-index: 1;
  }

  .text_center {
    text-align: center;
    margin-top: 20rpx;
  }


  .sys_border {
    position: relative;
    border: 2rpx solid #0FC8AC;

    .scan-border {
      background-color: #0FC8AC;
      position: absolute;
    }

    .scan-verLine {
      width: 5px;
      height: 20px;
    }

    .scan-horLine {
      width: 20px;
      height: 5px;
    }

    // 左上角
    .scan-left-top {
      left: 0;
      top: 0;
    }

    // 左下角
    .scan-left-bottom {
      left: 0;
      bottom: 0;
    }

    // 右上角
    .scan-right-top {
      right: 0;
      top: 0;
    }

    // 右下角
    .scan-right-bottom {
      right: 0;
      bottom: 0;
    }

    .light {
      width: 100%;
      position: absolute;
      bottom: 0;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;

      &_img {
        width: 36rpx;
        height: 36rpx;
      }

      &_text {
        margin: 10rpx 0;
        font-size: 24rpx;
      }
    }

    .line_bg {
      position: absolute;
      top: 5px;
      left: 5px;
      background-color: transparent;
      // animation: mymove 2s infinite;
      // animation-timing-function: linear;

      .line {
        width: 100%;
        height: 6rpx;
      }
    }

    // @keyframes mymove {
    //   0% {
    //     transform: translateY(0);
    //   }

    //   100% {
    //     transform: translateY(80%);
    //   }
    // }
  }

  .album {
    width: 100%;
    position: fixed;
    bottom: 200rpx;
    z-index: 99999;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    font-size: 24rpx;
    font-weight: 400;
    color: #ffffff;

    .albumImg {
      width: 120rpx;
      height: 120rpx;
      margin-bottom: 30rpx;
    }
  }

  .scanBtn {
    width: 100%;
    z-index: 99999;
    position: fixed;
    bottom: 100rpx;
    display: flex;
    flex-direction: row;
    color: white;
    font-size: 28rpx;
    justify-content: space-around;
    align-items: center;

    .unpick_text {
      opacity: 0.7;
    }

    .beatImg {
      width: 36rpx;
      height: 36rpx;
    }
  }
}
</style>
