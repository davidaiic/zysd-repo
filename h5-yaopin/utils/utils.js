import store from "@/store";
import { bridgrCall } from "@/utils/bridge";

// url &?
export function formatGetUri(obj) {
  let temp = [];
  Object.keys(obj).forEach((key) => {
    let value = obj[key];
    if (typeof value !== "undefined" || value !== null) {
      temp.push([key, value].join("="));
    }
  });
  return "?" + temp.join("&");
}

export function getImgUrl(val) {
  return `/static/${val}`;
}

export function transImg(img) {
  return img
    .map((item) => {
      return item.url;
    })
    .join(",");
}

export function getUserFunc(e, cb, inviteId) {
  //#ifdef H5
  bridgrCall
    .goLogin()
    .then((res) => {
      const resdata = res?.data || {};
      if (resdata.uid) {
        uni.setStorageSync("uid", resdata.uid);
        uni.setStorageSync("token", resdata.token);
      }
      cb();
    })
    .catch((e) => {
      console.log(e);
    });
  return;
  //#endif
  if (e.detail.errMsg == "getPhoneNumber:ok") {
    let code = uni.getStorageSync("code");
    if (!code) {
      uni.login({
        provider: "weixin",
        success(resCode) {
          code = resCode.code;
          uni.setStorageSync("code", code);
          getUserInner(e, cb, code, inviteId);
        },
      });
    } else {
      getUserInner(e, cb, code, inviteId);
    }
  } else {
    uni.showToast({
      icon: "none",
      title: "登录失败,拒绝授权！",
      duration: 1500,
    });
  }
}

function getUserInner(e, cb, code, inviteId) {
  let params = {
    code: code,
  };
  store.dispatch("login/getOpenid", params).then((resp) => {
    if (resp && resp.data && resp.data.token) {
      uni.setStorageSync("uid", resp.data.uid);
      uni.setStorageSync("token", resp.data.token);
      uni.showToast({
        icon: "none",
        title: "登录成功",
        duration: 1500,
        success() {
          uni.$u.sleep(2000).then(() => {
            cb && cb();
          });
        },
      });
    } else {
      let p = {
        code: e.detail.code,
      };
      store.dispatch("login/getUserPhone", p).then((phone) => {
        if (phone.data && phone.data.mobile) {
          let reg = {
            nickname: "微信用户",
            avatar:
              "https://shiyao.yaojk.com.cn/uploads/avatar/20230110/1673363728.png",
            openid: resp.data.openid,
            mobile: phone.data.mobile,
          };
          if (inviteId) reg["inviteId"] = inviteId;
          store.dispatch("user/getRegister", reg).then((register) => {
            if (register.data && register.data.token) {
              uni.setStorageSync("uid", register.data.uid);
              uni.setStorageSync("token", register.data.token);
              uni.showToast({
                icon: "none",
                title: inviteId ? "加入成功" : "登录成功",
                duration: 1500,
                success() {
                  uni.$u.sleep(2000).then(() => {
                    cb && cb();
                  });
                },
              });
            }
          });
        } else {
          uni.showToast({
            icon: "none",
            title: "获取手机号失败,请再次获取",
          });
        }
      });
    }
  });
}
// 节流函数
export function throttle(fn, delay) {
  let timer = null;

  return function () {
    if (timer) {
      return;
    }
    timer = setTimeout(() => {
      fn.apply(this, arguments);
      timer = null;
    }, delay);
  };
}

export function debounce(callback, delay = 1000) {
  let timer = null;
  return function () {
    let self = this;
    let args = arguments;
    timer && clearTimeout(timer);
    timer = setTimeout(function () {
      callback.apply(self, args);
    }, delay);
  };
}

export function dsBridgeAsyn(event, cb) {
  if (dsBridge) {
    dsBridge.call("asynCallNative", event, cb);
  }
}
export function dsBridgeSyn(data, cb) {
  if (dsBridge) {
    return cb(dsBridge.call("synCallNative", data));
  }
}
export function curPlatform() {
  let platform = "MP-WEIXIN";
  //#ifdef H5
  platform = "H5";
  //#endif

  //#ifdef MP-WEIXIN
  platform = "MP-WEIXIN";
  //#endif
  return platform;
}
