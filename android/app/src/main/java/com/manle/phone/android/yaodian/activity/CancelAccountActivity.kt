package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.showToast
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.PopUtils.asConfirm
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.ActivityCancelAccountBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CacheUtil


class CancelAccountActivity : BaseActivity<BaseViewModel, ActivityCancelAccountBinding>(R.layout.activity_cancel_account) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<CancelAccountActivity>()
        }
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "注销账号")
        mBind.click = ProxyClick()

    }

    inner class ProxyClick {

        fun think() {
            finish()
        }

        fun cancelAccount() {
            asConfirm(title = "确定要注销账号吗？", confirmListener = {
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

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}