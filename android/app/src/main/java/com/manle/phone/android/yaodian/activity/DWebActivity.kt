package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import android.webkit.JavascriptInterface
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.logE
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.extraAct
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.google.gson.Gson
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.CallBackJsBean
import com.manle.phone.android.yaodian.bean.WebJsonBean
import com.manle.phone.android.yaodian.databinding.ActivityDWebBinding
import wendu.dsbridge.CompletionHandler


class DWebActivity : BaseActivity<BaseViewModel, ActivityDWebBinding>(R.layout.activity_d_web) {
    companion object {
        fun start(webResponse: WebResponse) = KtxActivityManger.currentActivity!!.startActivity<DWebActivity>(
            AppConfig.KEY1 to webResponse
        )
    }

    var webResponse: WebResponse? by extraAct(AppConfig.KEY1)
    override fun initView(savedInstanceState: Bundle?) {
        mBind.webView.loadUrl(webResponse!!.url)
        mBind.webView.settings.javaScriptEnabled = true
        mBind.webView.addJavascriptObject(JsApi(context), null)
    }

    class JsApi(val activity: FragmentActivity) {

        @JavascriptInterface
        fun asynCallNative(event: Any, handler: CompletionHandler<Any>) {
            val webJsonBean = Gson().fromJson(event.toString(), WebJsonBean::class.java)

            when (webJsonBean.action) {
                "photo" -> {
                    //选择图片
                 handler.complete(Gson().toJson(CallBackJsBean(mutableListOf("https://shiyao.yaojk.com.cn/uploads/photo/20230420/a36de92715856ea6d663d7bf7c3b6985.jpg"))))
                }
                else -> {

                }
            }

        }
    }
}