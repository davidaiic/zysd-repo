package com.manle.phone.android.yaodian


import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build.VERSION.SDK_INT
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.view.animation.LinearInterpolator
import android.widget.ImageView
import coil.Coil
import coil.ImageLoader
import coil.decode.GifDecoder
import coil.decode.ImageDecoderDecoder
import com.app.base.BR
import com.app.base.BaseApp
import com.app.base.R
import com.app.base.ext.logE
import com.app.base.lifecycle.appContext
import com.chuckerteam.chucker.api.ChuckerCollector
import com.chuckerteam.chucker.api.ChuckerInterceptor
import com.drake.brv.utils.BRV
import com.drake.net.BuildConfig
import com.drake.net.NetConfig
import com.drake.net.cookie.PersistentCookieJar
import com.drake.net.interceptor.LogRecordInterceptor
import com.drake.net.interceptor.RequestInterceptor
import com.drake.net.okhttp.*
import com.drake.net.request.BaseRequest
import com.drake.statelayout.StateConfig
import com.drake.tooltip.dialog.BubbleDialog
import com.localebro.okhttpprofiler.OkHttpProfilerInterceptor
import com.manle.phone.android.yaodian.net.*
import com.manle.phone.android.yaodian.util.CacheUtil
import com.manle.phone.android.yaodian.util.CacheUtil.loginOut
import com.noober.background.BackgroundLibrary
import com.scwang.smart.refresh.footer.ClassicsFooter
import com.scwang.smart.refresh.header.ClassicsHeader
import com.scwang.smart.refresh.layout.SmartRefreshLayout
import com.tencent.mm.opensdk.constants.ConstantsAPI
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory
import com.tencent.mmkv.MMKV
import okhttp3.Cache
import java.util.concurrent.TimeUnit



class App : BaseApp() {

    companion object {
        var wxApi: IWXAPI?=null
    }


    override fun onCreate() {
        super.onCreate()

        wxApi=WXAPIFactory.createWXAPI(this, NetUseConfig.APP_ID, true)
        wxApi?.registerApp(NetUseConfig.APP_ID)
        MMKV.initialize(this)
        BackgroundLibrary.inject(this)

        val tokenBean = CacheUtil.getTokenBean()
        NetUseConfig.changUser(token = tokenBean.token, uId = tokenBean.uid, CacheUtil.isLogin())
        NetConfig.initialize(Api.HOST, this) {
            connectTimeout(30, TimeUnit.SECONDS)
            readTimeout(30, TimeUnit.SECONDS)
            writeTimeout(30, TimeUnit.SECONDS)
            cache(Cache(cacheDir, 1024 * 1024 * 128))
            setDebug(BuildConfig.DEBUG)

            addInterceptor(LogRecordInterceptor(BuildConfig.DEBUG))
            addInterceptor(OkHttpProfilerInterceptor())

            addInterceptor(RefreshTokenInterceptor(401) {
                loginOut()
            })

            setRequestInterceptor(object : RequestInterceptor {
                override fun interceptor(request: BaseRequest) {
                    request.setHeader("uid", NetUseConfig.userId)
                    request.setHeader("token", NetUseConfig.token)
                }
            })

            cookieJar(PersistentCookieJar(this@App))

            if (BuildConfig.DEBUG) {
                addInterceptor(
                    ChuckerInterceptor.Builder(this@App)
                        .collector(ChuckerCollector(this@App))
                        .maxContentLength(250000L)
                        .redactHeaders(emptySet())
                        .alwaysReadResponseBody(false)
                        .build()
                )
            }

            setConverter(SerializationConverter())

            setDialogFactory {
                BubbleDialog(it, "加载中...")
            }
        }
        initializeThirdPart()

    }


    private fun initializeThirdPart() {

        StateConfig.apply {
            emptyLayout = R.layout.view_empty
            errorLayout = R.layout.view_error
            loadingLayout = R.layout.view_loading
            onLoading {
                val mAnimation: Animation = AnimationUtils.loadAnimation(context, R.anim.image_rotate)
                mAnimation.interpolator = LinearInterpolator()
                findViewById<ImageView>(R.id.ivLoading).startAnimation(mAnimation)
            }

        }

        BRV.modelId = BR.model



        SmartRefreshLayout.setDefaultRefreshHeaderCreator { context, _ ->
            ClassicsHeader(context)
        }
        SmartRefreshLayout.setDefaultRefreshFooterCreator { context, _ ->
            ClassicsFooter(context)
        }
    }





}


