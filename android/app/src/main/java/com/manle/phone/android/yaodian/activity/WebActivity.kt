package com.manle.phone.android.yaodian.activity

import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.webkit.*
import android.widget.LinearLayout
import androidx.activity.OnBackPressedCallback
import androidx.activity.result.ActivityResultLauncher
import androidx.annotation.RequiresApi
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.*
import com.app.base.lifecycle.KtxActivityManger.currentActivity
import com.app.base.utils.*
import com.app.base.viewmodel.BaseViewModel
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.google.gson.Gson
import com.just.agentweb.AgentWeb
import com.just.agentweb.DefaultWebClient
import com.just.agentweb.MiddlewareWebChromeBase
import com.just.agentweb.MiddlewareWebClientBase
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.CallBackJsBean
import com.manle.phone.android.yaodian.bean.CallBackJsCodeBean
import com.manle.phone.android.yaodian.bean.ToWebTokenBean
import com.manle.phone.android.yaodian.bean.UploadSuccessBean
import com.manle.phone.android.yaodian.databinding.ActivityWebBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.AppCompressFileEngine
import com.manle.phone.android.yaodian.util.CacheUtil
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.CommUtils.shareToWx
import com.manle.phone.android.yaodian.util.WxShareUtil
import kotlinx.coroutines.Deferred
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.json.JSONObject
import wendu.dsbridge.CompletionHandler
import wendu.dsbridge.DWebView
import java.io.File



class WebActivity : BaseActivity<BaseViewModel, ActivityWebBinding>(R.layout.activity_web) {
    companion object {
        fun start(webResponse: WebResponse) = currentActivity!!.startActivity<WebActivity>(
            AppConfig.KEY1 to webResponse
        )
    }


    var webResponse: WebResponse? by extraAct(AppConfig.KEY1)
    var mAgentWeb: AgentWeb? = null

    private var preWeb: AgentWeb.PreAgentWeb? = null

    lateinit var dWebView: DWebView
    lateinit var launch: ActivityResultLauncher<Intent>
    var handler: CompletionHandler<Any>? = null

    @RequiresApi(Build.VERSION_CODES.N)
    override fun initView(savedInstanceState: Bundle?) {

        if (webResponse == null) {
            finish()
        }
        launch = this.registerForActivityResult {
            it?.getStringExtra(AppConfig.KEY1)?.let { url ->
                handler?.complete(Gson().toJson(CallBackJsCodeBean(url)))
            }
        }
        webResponse?.let {
            mBind.topBar.toolbar.apply {
                //设置menu 关键代码
                initToolBar(activity = this@WebActivity, backStr = "返回", titleStr = if (it.isUserHtmlTitle) "" else it.title, interceptBack = true) {
                    hideSoftKeyboard(viewLifecycleOwner)
                    if (dWebView.canGoBack()) {
                        dWebView.goBack()
                    } else {
                        finish()
                    }
                }
            }
            dWebView = DWebView(context)
            preWeb = AgentWeb.with(this)
                .setAgentWebParent(mBind.webcontent, LinearLayout.LayoutParams(-1, -1))
                .useDefaultIndicator(R.color.color_0FC8AC.getColor(), 2.toDp())// 进度条
                .useMiddlewareWebClient(getMiddlewareWebClient())
                .useMiddlewareWebChrome(getMiddlewareWebChrome())
                .setWebView(dWebView)
                .setSecurityType(AgentWeb.SecurityType.STRICT_CHECK)
                .setOpenOtherPageWays(DefaultWebClient.OpenOtherPageWays.ASK)
                .interceptUnkownUrl()
                .createAgentWeb()
                .ready()
            //注入对象
            loadData()
        }

    }


    private fun loadData() {



        if (webResponse!!.url.isEmpty()) {
            dWebView.loadData(webResponse!!.htmlContent, "text/html", "UTF-8")
        } else {
            mAgentWeb = preWeb?.go(webResponse!!.url)!!
            dWebView.addJavascriptObject(JsApi(this), null)
            onBackPressedDispatcher.addCallback(this,
                object : OnBackPressedCallback(true) {
                    override fun handleOnBackPressed() {
                        if (dWebView.canGoBack()) {
                            dWebView.goBack()
                        } else {
                            finish()
                        }
                    }
                })
        }


    }



    @RequiresApi(Build.VERSION_CODES.N)
    private fun getMiddlewareWebClient(): MiddlewareWebClientBase {
        return object : MiddlewareWebClientBase() {
            override fun shouldInterceptRequest(
                view: WebView?,
                request: WebResourceRequest?
            ): WebResourceResponse? {
                return super.shouldInterceptRequest(view, request)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)

            }

            override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?) {

                XPopup.Builder(context)
                    .asConfirm(R.string.prompt.getString(), "SSL证书错误，是否继续", {
                        handler?.proceed()
                    }, {
                        handler?.cancel()
                    }).show()

            }
        }
    }

    private fun getMiddlewareWebChrome(): MiddlewareWebChromeBase {
        return object : MiddlewareWebChromeBase() {
            override fun onReceivedTitle(view: WebView?, title: String?) {
                super.onReceivedTitle(view, title)

                webResponse?.let {
                    if (!title.isNullOrEmpty() && it.isUserHtmlTitle && title != "识药查真伪") {
                        mBind.topBar.fragmentTitleTv.text = title
                    }
                }
            }
        }
    }


    class JsApi(val activity: WebActivity) {

        @JavascriptInterface
        fun asynCallNative(event: Any, handler: CompletionHandler<Any>) {


            val jsonObject = JSONObject(event.toString())
            val action = jsonObject.getString("action")
            val value = jsonObject.getString("value")
            when (action) {
                "photo" -> {
                    val selImageList = mutableListOf<LocalMedia>()
                    val max = JSONObject(value).getInt("max")
                    selectImg(selImageList, max) {

                        activity.scopeDialog {
                            var imgs = mutableListOf<String>()
                            if (selImageList.size > 0) {
                                val jobList = mutableListOf<Deferred<UploadSuccessBean>>()
                                selImageList.forEach {
                                    val file = File(if (it.isCompressed) it.compressPath else it.realPath)
                                    val job: Deferred<UploadSuccessBean> = Post<UploadSuccessBean>(Api.uploadImg) {
                                        param("file", file)
                                        param("type", "photo")
                                    }
                                    jobList.add(job)
                                }

                                jobList.forEach {
                                    imgs.add(it.await().url)
                                }
                                handler.complete(Gson().toJson(CallBackJsBean(imgs)))
                            }

//                            val data = Post<UploadSuccessBean>(Api.uploadImg) {
//                                param("file", File(selImageList[0].realPath))
//                                param("type", "photo")
//                            }.await()

                        }
                    }
                }
                "scan" -> {
                    activity.handler = handler

                    ScanActivity.startAct(webUserScan = true, myActivityLauncher = activity.launch)
                }

                "saveImage" -> {
                    val imgUrl = JSONObject(value).getString("image")
                    DownloadSaveImg.downloadImg(activity, imgUrl)


                }
                "share" -> {
                    activity.shareToWx {
                        val path = JSONObject(value).getString("path")
                        val title = JSONObject(value).getString("title")
                        val img = JSONObject(value).getString("imageURL")


                        Glide.with(activity)
                            .asBitmap()
                            .load(img)
                            .into(object : CustomTarget<Bitmap>(SIZE_ORIGINAL, SIZE_ORIGINAL) {
                                override fun onResourceReady(resource: Bitmap, transition: Transition<in Bitmap>?) {
                                    WxShareUtil.wxAppletShare(title = title, path = path, resource)
                                }

                                override fun onLoadCleared(placeholder: Drawable?) {

                                }


                            });


                    }

                }
                "browserImage" -> {


                }
                "goLogin" -> {

                    activity.jumpByLogin {
                        if (NetUseConfig.isLogin) {
                            CacheUtil.getTokenBean().let {
                                handler.complete(Gson().toJson(it))
                            }
                        }
                    }

                }

                "backPage" -> {
                    if (activity.dWebView.canGoBack()) {
                        activity.dWebView.goBack()
                    } else {
                        activity.finish()
                    }
                }
                else -> {

                }
            }

        }

        @JavascriptInterface
        fun synCallNative(event: Any): Any {

            val jsonObject = JSONObject(event.toString())
            val action = jsonObject.getString("action")
            val value = jsonObject.getString("value")

            when (action) {
                "getUserInfo" -> {
                    if (NetUseConfig.isLogin) {
                        Json.encodeToString(ToWebTokenBean(CacheUtil.getTokenBean())).logE()
                        return Json.encodeToString(ToWebTokenBean(CacheUtil.getTokenBean()))
                    }
                }
                "back" -> {
                    MainActivity.startAct(activity)
                }
                "browserImage" -> {

                    return ""
                }
                "goodsDetail" -> {

                }

                else -> {
                    return ""
                }
            }
            return ""
        }


        private fun selectImg(selImageList: MutableList<LocalMedia>, maxImgCount: Int, callback: () -> Unit) {
            PictureSelector.create(activity)
                .openGallery(SelectMimeType.ofImage())
                .setImageEngine(CoilEngine())
                .setSelectedData(selImageList)
                .setMaxSelectNum(maxImgCount)
                .setMinSelectNum(1)
                .setImageSpanCount(4)
                .setSelectionMode(SelectModeConfig.MULTIPLE)
                .isDisplayCamera(true)
                .isPreviewImage(true)
                .setCameraImageFormat(PictureMimeType.JPEG)
                .isCameraRotateImage(false)
                .setCompressEngine(AppCompressFileEngine())
                .forResult(object : OnResultCallbackListener<LocalMedia> {
                    override fun onResult(result: java.util.ArrayList<LocalMedia>?) {

                        selImageList.clear()
                        result?.let { it1 -> selImageList.addAll(it1) }
                        callback.invoke()
                    }

                    override fun onCancel() {

                    }


                })
        }


    }


    override fun onPause() {
        mAgentWeb?.webLifeCycle?.onPause()
        super.onPause()
    }


    override fun onResume() {
        mAgentWeb?.webLifeCycle?.onResume()
        super.onResume()
    }

    override fun onDestroy() {
        mAgentWeb?.webLifeCycle?.onDestroy()
        setSupportActionBar(null)
        super.onDestroy()
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }

}