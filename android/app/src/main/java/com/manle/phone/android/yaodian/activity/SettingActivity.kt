package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import android.view.View
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.showToast
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.PopUtils.asConfirm
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.databinding.ActivitySettingBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CacheUtil



class SettingActivity : BaseActivity<BaseViewModel, ActivitySettingBinding>(R.layout.activity_setting) {

    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<SettingActivity>()
        }
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "设置中心")
        mBind.click = ProxyClick()

        mBind.islogin=NetUseConfig.isLogin

    }

    inner class ProxyClick {

        fun click1() {
            WebConfig.jumpWeb(WebConfig.yhxy,userHtmlTitle = false)
        }


        fun click2() {
            WebConfig.jumpWeb(WebConfig.yszy,userHtmlTitle = false)
        }


        fun click3() {
            WebConfig.jumpWeb(WebConfig.about,userHtmlTitle = false)
        }


        fun click4() {
            WebConfig.jumpWeb(WebConfig.threeInfo)
        }


        fun click5() {
            MessageCollectActivity.startAct(this@SettingActivity)

        }


        fun click6() {
            CancelAccountActivity.startAct(this@SettingActivity)

        }


        fun loginOut() {
            if (NetUseConfig.isLogin) {
                asConfirm(title = "确定要退出登录吗？", confirmListener = {
                    scopeDialog {
                        Post<String>(Api.user_logout).await()
                        CacheUtil.loginOut()
                        showToast("退出登录成功")
                        sendEvent(true, AppConfig.LOGIN_TYPE)
                        KtxActivityManger.finishOtherActivity(MainActivity::class.java)
                    }
                }).show()

            }


        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}