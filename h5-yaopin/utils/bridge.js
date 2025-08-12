import { dsBridgeAsyn, dsBridgeSyn } from "./utils"
import html2canvas from 'html2canvas'
export const bridgrCall = {
    scan() {
        const event = {
            action: "scan",
            value: {} 
        }
        return promiseCall(dsBridgeAsyn,event)
    },
     goCourseVideo() {
        const event = {
            action: "scan",
        }
        return promiseCall(dsBridgeAsyn,event)
    },
     goLogin() {
        const event = {
            action: "goLogin",
            value: {}
        }
        return promiseCall(dsBridgeAsyn,event)
    },
    getUserInfo() {
        const event = {
            action: "getUserInfo",
            value: {}
        }
        return promiseCall(dsBridgeSyn,event)
    },
    //上传图片的桥
    getPhoto(value = {}) {
        const event = {
            action: "photo",
            value: {"max": "1",...value}
        }
        return promiseCall(dsBridgeAsyn,event)
    },
     //保存图片的桥
     saveImage(value = {}) {
        const event = {
            action: "saveImage",
            value: {"image": value.image}
        }
        return promiseCall(dsBridgeAsyn,event)
    },
     //返回的桥
     back(value = {}) {
        const event = {
            action: "back",
            value: {}
        }
        return promiseCall(dsBridgeAsyn,event)
    },
    goodsDetail(value={}) {
        const event = {
            action: "goodsDetail",
            value: {...value}
        }
        return promiseCall(dsBridgeSyn,event)
    },
    //分享桥
    goShare(value = {}) {
        if(value.img) {
         return call(value.img)
        } else {
         return getCurrImage(call)
        }
        function call(img) {
            const event = {
                action: "share",
                value: {
                    "type": "1" ,
                    "path": value.path,
                     "imageURL": img,
                     "desc": "",
                     "title": value.title,
                }
            }
            console.log(event,'分享')
            return promiseCall(dsBridgeAsyn,event)
        }
    }
}

function getCurrImage(cb) {
    let img = ''
    uni.showLoading({
        title: ''
      })
      let dom = document.querySelector('.uni-body')
      const imgDom = dom.querySelectorAll('img')
      if(imgDom) {
        Array.from(imgDom).map(_=>{
            _.crossOrigin='anonymous'
            _.crossorigin='anonymous'
        })
      }
      return html2canvas(dom, {
        width: dom.clientWidth, //dom 原始宽度
        height: dom.clientHeight,
        scrollY: 0,
        scrollX: 0,
        useCORS: true
      }).then((canvas) => {
        uni.hideLoading()
        //成功后调用返回canvas.toDataURL返回图片的imageData
        img = canvas.toDataURL('image/png', 1)
       return cb(img)
      })
}

function promiseCall(bridge,event) {
   return new Promise((resolve, reject) => {
        try {
            bridge(event,(v) => {
                const res = (typeof v === 'string') ? JSON.parse(v || '{}') : v
                resolve(res)
            })
        } catch (error) {
            reject(error)
        }
       
    })
}