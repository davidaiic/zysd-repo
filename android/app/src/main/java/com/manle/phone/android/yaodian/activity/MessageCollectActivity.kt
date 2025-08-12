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
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.databinding.ActivityMessageCollectBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CacheUtil


class MessageCollectActivity : BaseActivity<BaseViewModel, ActivityMessageCollectBinding>(layoutId = R.layout.activity_message_collect) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<MessageCollectActivity>()
        }
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "个人信息收集清单")
        mBind.click = ProxyClick()

    }

    inner class ProxyClick {

        fun time() {
            XPopup.Builder(context)
                .asBottomList("", arrayOf("一天", "一周", "一个月")) { position, text ->
                    showToast(text)
                }.show()
        }


        fun userMessage() {
            WebConfig.jumpWeb(WebConfig.basicInfo)
        }


        fun userUseMessage() {
            WebConfig.jumpWeb(WebConfig.useInfo)
        }


        fun deviceMessage() {
            WebConfig.jumpWeb(WebConfig.deviceInfo)
        }


    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}