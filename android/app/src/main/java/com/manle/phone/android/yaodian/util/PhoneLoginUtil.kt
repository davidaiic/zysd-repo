package com.manle.phone.android.yaodian.util

import android.content.Context
import android.widget.ImageView
import android.widget.RelativeLayout
import android.widget.TextView
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import com.app.base.AppConfig
import com.app.base.app_use.ext.dismissLoadingExt
import com.app.base.app_use.ext.showLoadingExt
import com.app.base.ext.getColor
import com.app.base.ext.logE
import com.app.base.ext.showToast
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.PopUtils.asConfirm
import com.cmic.gen.sdk.auth.GenAuthnHelper
import com.cmic.gen.sdk.auth.GenTokenListener
import com.cmic.gen.sdk.view.GenAuthThemeConfig
import com.cmic.gen.sdk.view.GenLoginAuthActivity
import com.cmic.gen.sdk.view.GenLoginClickListener
import com.cmic.gen.sdk.view.GenLoginPageInListener
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.google.gson.Gson
import com.hjq.permissions.OnPermissionCallback
import com.hjq.permissions.Permission
import com.hjq.permissions.XXPermissions
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.BuildConfig
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.MainActivity
import com.manle.phone.android.yaodian.bean.TokenBean
import com.manle.phone.android.yaodian.bean.UserBean
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.pop.LoginPop
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.json.JSONObject


object PhoneLoginUtil {
    private var isChecked = false
    val yhxi = WebConfig.getWebUrl(WebConfig.yhxy)
    val yszy = WebConfig.getWebUrl(WebConfig.yszy)


    fun login(activity: FragmentActivity, callBack: () -> Unit = {}) {
        var mAuthHelper: GenAuthnHelper? = null
        val mListener = GenTokenListener { p0, jsonObject ->
            if (p0 != 10000) {
                showToast("一键登录失败")
                showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)
            } else {
                if (jsonObject.has("token")) {
                    val accessToken = jsonObject.optString("token")
                    activity.scopeDialog {
                        val tokenBean = Post<TokenBean>(Api.user_login) {
                            param("accessToken", accessToken)
                        }.await()
                        CacheUtil.loginIn(tokenBean)
                        sendEvent(true, AppConfig.LOGIN_TYPE)
                        mAuthHelper?.quitAuthActivity()
                        activity.lifecycleScope.launch {
                            delay(100)
                            callBack.invoke()
                        }
                    }.catch {
                        showToast("一键登录失败")
                        showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)
                    }

                } else if (jsonObject.optString("resultCode") != "200020") {
                    showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)
                }

            }
        }



        GenAuthnHelper.setDebugMode(false)
        mAuthHelper = GenAuthnHelper.getInstance(activity)
        mAuthHelper.setPageInListener(GenLoginPageInListener { resultCode, p1 ->
            if (resultCode.equals("200087")) {
                dismissLoadingExt()
            }
        })

        val relativeLayout = RelativeLayout(activity)
        relativeLayout.layoutParams = RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT)
        val view = activity.layoutInflater.inflate(R.layout.my_login_view, relativeLayout, false)
        var themeConfigBuilder: GenAuthThemeConfig.Builder = GenAuthThemeConfig.Builder()
            .setStatusBar(R.color.white.getColor(), false)
            .setAuthContentView(view)
            .setClauseLayoutResID(R.layout.clause_title, "closeIv")
            .setNavTextSize(14)
            .setNavTextColor(R.color.black.getColor())
            .setNavColor(R.color.white.getColor())
            .setNumberSize(20, false)
            .setNumberColor(R.color.color_333333.getColor())
            .setNumberOffsetX(120)
            .setNumFieldOffsetY(299)
            .setLogBtnTextColor(R.color.white.getColor())
            .setLogBtnImgPath("ic_login_bg")
            .setLogBtnMargin(48, 48)
            .setLogBtnText("本机号码一键登录", R.color.white.getColor(), 16, true)
            .setLogBtnOffsetY(387) //登录按钮Y偏移量
            .setLogBtn(280, 44)
            .setLogBtnClickListener(object : GenLoginClickListener {
                override fun onLoginClickStart(p0: Context?, p1: JSONObject?) {
                    activity.showLoadingExt(hasShadowBg = false)
                }

                override fun onLoginClickComplete(p0: Context?, p1: JSONObject?) {
                    dismissLoadingExt()
                }

            })
            .setGenCheckedChangeListener {
                isChecked = it
            }
            .setGenAuthLoginListener { context, authLoginCallBack ->
                activity.asConfirm(title = "授权提示", content = "是否同意授权？", cancelBtnText = "取消", confirmBtnText = "确定",
                    build = XPopup.Builder(context)
                        .dismissOnTouchOutside(false)
                        .dismissOnBackPressed(false),
                    confirmListener = {
                        authLoginCallBack.onAuthLoginCallBack(true);
                    }).show()
            }
            .setCheckTipText("请阅读并勾选用户条款")
            .setCheckBoxImgPath("ic_login_checked", "ic_login_uncheck", 18, 18)
            .setPrivacyState(false)
            .setPrivacyAlignment(
                "登录即同意" + GenAuthThemeConfig.PLACEHOLDER + "用户协议、隐私政策",
                "用户协议", if (yhxi.isNullOrEmpty()) WebConfig.yhxyUrl else yhxi,
                "隐私政策", if (yszy.isNullOrEmpty()) WebConfig.yszyUrl else yszy,
                "", "",
                "", ""
            )
            .setPrivacyText(14, R.color.color_333333.getColor(), R.color.color_0FC8AC.getColor(), false, false)
            .setPrivacyMargin(20, 15)
            .setPrivacyOffsetY_B(200)
            .setCheckBoxLocation(0)
            .setAppLanguageType(0)
            .setWebDomStorage(true)
            .setPrivacyBookSymbol(true)
            .setAuthPageActIn("right_in", "right_out")
            .setAuthPageActOut("right_in", "right_out")
            .setAuthPageWindowMode(0, 0)
            .setThemeId(-1)
            .setBackButton(false)
        view.findViewById<ImageView>(R.id.closeIv).setOnClickListener {
            mAuthHelper.quitAuthActivity()
        }
        view.findViewById<TextView>(R.id.otherLoginTv).setOnClickListener {
            showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)
        }
        mAuthHelper?.authThemeConfig = themeConfigBuilder.build()
        XXPermissions.with(activity)
            .permission(Permission.READ_PHONE_STATE)
            .request(object : OnPermissionCallback {
                override fun onGranted(permissions: MutableList<String>, allGranted: Boolean) {
                    if (allGranted) {
                        mAuthHelper?.loginAuth(Api.APP_ID, Api.APP_KEY, mListener, 10000);
                    } else {
                        showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)
                    }
                }

                override fun onDenied(permissions: MutableList<String>, doNotAskAgain: Boolean) {
                    showLoginPop(mAuthHelper = mAuthHelper!!, activity = activity, callBack = callBack)

                }
            })
    }

    fun showLoginPop(mAuthHelper: GenAuthnHelper, activity: FragmentActivity, callBack: () -> Unit) {

        dismissLoadingExt()
        XPopup.Builder(activity)
            .autoDismiss(false)
            .isLightStatusBar(true)
            .autoOpenSoftInput(true)
            .dismissOnBackPressed(false)
            .asCustom(LoginPop(activity, callBack))
            .show()
        mAuthHelper?.quitAuthActivity()
    }

}