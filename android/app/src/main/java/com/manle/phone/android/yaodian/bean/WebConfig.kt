package com.manle.phone.android.yaodian.bean

import androidx.fragment.app.FragmentActivity
import com.app.base.app_use.bean.WebResponse
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.activity.WebActivity
import com.manle.phone.android.yaodian.net.Api


object WebConfig {
    const val h5 = "https://h5.shiyao.yaojk.com.cn/"

    const val yhxyUrl = "${h5}#/pages/mine/yhxy?1.1.33"

    const val yszyUrl = "${h5}#/pages/mine/yszy?1.1.33"

    const val yhxy = "yhxy"


    const val lxwm = "lxwm"


    const val yjfk = "yjfk"


    const val rghc = "rghc"


    const val jgcx = "jgcx"

    const val zpcx = "zpcx"


    const val lscx = "lscx"


    const val ewm = "ewm"


    const val basicInfo = "basicInfo"


    const val deviceInfo = "deviceInfo"


    const val threeInfo = "threeInfo"


    const val useInfo = "useInfo"


    const val wysj = "wysj"


    const val wybj = "wybj"


    const val yszy = "yszy"


    const val jyjc = "jyjc"


    const val hzzm = "hzzm"


    const val csjz = "csjz"


    const val zwjb = "zwjb"


    const val userMange = "userMange"


    const val yccx = "yccx"


    const val sms = "sms"


    const val smRisk = "smRisk"


    const val about = "about"


    const val gwyfw = "gwyfw"


    const val gwwfw = "gwwfw"


    const val gnyfw = "gnyfw"

    var urlList: MutableList<WebListUrlBean.UrlBean> = mutableListOf()

    fun jumpWeb(key: String,userHtmlTitle:Boolean = true) {
        urlList.forEach {
            if (key == it.keyword) {
                WebActivity.start(WebResponse(url = h5 + it.linkUrl, it.title, isUserHtmlTitle = userHtmlTitle))
            }
        }

    }

    fun jumpSmsWeb(goodsId: Long) {
        urlList.forEach {
            if (it.keyword == sms) {
                WebActivity.start(WebResponse(url = h5 + it.linkUrl + "&goodsId=${goodsId}", it.title, isUserHtmlTitle = false))
            }
        }

    }


    fun getWebUrl(key: String): String {
        urlList.forEach {
            if (key == it.keyword) {
                return h5 + it.linkUrl
            }
        }
        return ""
    }

     fun jumpHtmlWeb(activity: FragmentActivity,key: String) {

        activity.scopeNetLife {
            val contentBean = Post<ContentBean>(Api.CONTET) {
                param("keyword", key)
            }.await()
            WebActivity.start(WebResponse(htmlContent = contentBean.content, title = contentBean.title, isUserHtmlTitle = false))
        }
    }

}