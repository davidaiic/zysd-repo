package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import androidx.lifecycle.scopeNetLife
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.logE
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.SettingActivity
import com.manle.phone.android.yaodian.activity.UserCenterActivity
import com.manle.phone.android.yaodian.activity.WebActivity
import com.manle.phone.android.yaodian.bean.ApiDetailBean
import com.manle.phone.android.yaodian.bean.CommentListBean
import com.manle.phone.android.yaodian.bean.UserBean
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.databinding.FragmentMineBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CacheUtil
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.PhoneLoginUtil


class MineFragment : BaseFragment<BaseViewModel, FragmentMineBinding>(R.layout.fragment_mine) {
    companion object {
        fun newInstance() = MineFragment()
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBind.click = ProxyClick()
        mBind.isLogin = NetUseConfig.isLogin

    }

    override fun onResume() {
        super.onResume()
        getData()
    }

    private fun getData() {
        scopeNetLife {
            try {
                Post<ApiDetailBean<UserBean>>(Api.user_detail).await().info?.let {
                    mBind.user = it
                    CacheUtil.setUser(it)
                }
            } catch (e: Exception) {
                mBind.user = UserBean()

            }

        }
    }

    override fun createObserver() {
        super.createObserver()
        receiveEvent<Boolean>(AppConfig.CHANGE_USER_HEAD) {
            CacheUtil.getUser()?.let { user ->
                mBind.user = user
            }

        }
        receiveEvent<Boolean>(AppConfig.CHANGE_USER_NAME) {
            CacheUtil.getUser()?.let { user ->
                mBind.user = user
            }
        }
        receiveEvent<Boolean>(AppConfig.LOGIN_TYPE) {
            getData()
            mBind.isLogin = NetUseConfig.isLogin
        }
    }

    inner class ProxyClick {

        fun login() {
            jumpByLogin {
                UserCenterActivity.startAct(requireActivity())
            }

        }


        fun waitPay() {

        }


        fun waitSend() {

        }


        fun sendReady() {

        }


        fun sendToAddress() {

        }


        fun searchHistory() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.lscx,userHtmlTitle = false)
            }

        }


        fun feedBack() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.yjfk,userHtmlTitle = false)
            }

        }


        fun callUs() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.lxwm,userHtmlTitle = false)
            }

        }


        fun shareCode() {
            WebConfig.jumpWeb(WebConfig.ewm,userHtmlTitle = false)
        }


        fun setting() {
            SettingActivity.startAct(requireActivity())

        }
    }

    override fun immersionBarEnabled(): Boolean {
        return true
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.toolbar)
    }

    override fun lazyLoadData() {

    }
}