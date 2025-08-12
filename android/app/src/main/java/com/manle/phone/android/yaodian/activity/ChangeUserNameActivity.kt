package com.manle.phone.android.yaodian.activity

import android.annotation.SuppressLint
import android.os.Bundle
import android.view.View
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.logE
import com.app.base.ext.showToast
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.sendEvent
import com.drake.net.NetConfig
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.drake.net.utils.withIO
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.ActivityChangeUserNameBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CacheUtil
import com.manle.phone.android.yaodian.vm.ChangeUserNameViewModel
import kotlinx.coroutines.launch
import okhttp3.internal.wait


class ChangeUserNameActivity : BaseActivity<ChangeUserNameViewModel, ActivityChangeUserNameBinding>(R.layout.activity_change_user_name) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<ChangeUserNameActivity>()
        }
    }

    val userBean = CacheUtil.getUser()
    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "编辑名字")
        mViewModel.userNameLiveData.value = userBean?.username
        mBind.vm = mViewModel
        mBind.click = ProxyClick()

    }

    inner class ProxyClick {

        fun save() {
            mViewModel.userNameLiveData.value?.let {
                if (it.length in 2..24) {
                    scopeDialog {
                        Post<String>(Api.change_user_info) {
                            param("nickname", it)
                        }.await()
                        userBean?.let {user->
                            user.username = it
                            CacheUtil.setUser(user)
                        }

                        sendEvent(true, tag = AppConfig.CHANGE_USER_NAME)
                        finish()
                    }

                } else {
                    showToast("请设置2-24个字符")
                }
            }

        }


        fun cancel() {
            finish()
        }
    }


    @SuppressLint("SetTextI18n")
    override fun createObserver() {
        super.createObserver()
        mViewModel.userNameLiveData.observe(this) { newName ->
            mBind.limitTv.text = "${newName.length}/24"
        }

    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}