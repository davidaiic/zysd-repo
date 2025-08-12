package com.manle.phone.android.yaodian.activity

import android.app.Activity
import android.content.res.ColorStateList
import android.graphics.Typeface
import android.os.Build
import android.os.Bundle
import android.widget.LinearLayout
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import androidx.viewpager2.adapter.FragmentStateAdapter
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.*
import com.app.base.utils.startActivity
import com.app.base.view.dialog.extensions.bindingListenerFun
import com.app.base.view.dialog.extensions.dataConvertListenerFun
import com.app.base.view.dialog.extensions.newAppDialog
import com.app.base.view.dialog.other.DialogGravity

import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.bean.WebConfig.jumpHtmlWeb
import com.manle.phone.android.yaodian.bean.WebListUrlBean
import com.manle.phone.android.yaodian.databinding.ActivityMainBinding
import com.manle.phone.android.yaodian.databinding.DialogProtocolBinding
import com.manle.phone.android.yaodian.fragment.CommentAndNewsFragment
import com.manle.phone.android.yaodian.fragment.HomeFragment
import com.manle.phone.android.yaodian.fragment.MineFragment
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig.xieyi
import com.manle.phone.android.yaodian.util.CacheUtil



class MainActivity : BaseActivity<BaseViewModel, ActivityMainBinding>(R.layout.activity_main) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<MainActivity>()
        }
    }


    private var lastPosition = 0
    private var position = 0

    @RequiresApi(Build.VERSION_CODES.N)
    override fun initView(savedInstanceState: Bundle?) {
        mBind.click = ProxyClick()
        scopeNetLife {
            WebConfig.urlList = Post<WebListUrlBean>(Api.web_url).await().urlList
        }
        if (!CacheUtil.haveAgree()) {
            newAppDialog {
                layoutId = R.layout.dialog_protocol
                gravity = DialogGravity.CENTER_CENTER
                width = dp2px(300)
                height = dp2px(500)
                outCancel = false
                touchCancel = false
                animStyle = R.style.BottomTransAlphaADAnimation
                bindingListenerFun<DialogProtocolBinding>(context) { binding, dialog ->
                    binding.lifecycleOwner = dialog.viewLifecycleOwner
                }
                dataConvertListenerFun<DialogProtocolBinding> { binding, dialog ->
                    binding.webTv.text = xieyi
                    binding.tv.appendColorSpan(
                        "如您同意", color(R.color.color_333333)
                    ).appendClickSpan(
                        str = "《用户协议》", color = color(R.color.color_0FC8AC)
                    ) {
                        jumpHtmlWeb(this@MainActivity, "protocol")
                    }.appendClickSpan(
                        str = "《隐私政策》", color = color(R.color.color_0FC8AC)
                    ) {
                        jumpHtmlWeb(this@MainActivity, "privacy")
                    }.appendClickSpan(
                        str = "《个人信息收集清单》", color = color(R.color.color_0FC8AC)
                    ) {
                        jumpHtmlWeb(this@MainActivity, "basicUserInfo")
                    }.appendColorSpan(
                        "以及", color(R.color.color_333333)
                    ).appendClickSpan(
                        str = "《第三方信息共享清单》", color = color(R.color.color_0FC8AC)
                    ) {
                        jumpHtmlWeb(this@MainActivity, "thirdShareInventory")
                    }.appendColorSpan(
                        "请点击\"同意并继续\"按钮开启我们的服务", color(R.color.color_333333)
                    )
                    binding.yesTv.setOnClickListener {
                        CacheUtil.setAgree(true)
                        dialog.dismiss()
                    }
                    binding.noTv.setOnClickListener {
                        finish()
                    }
                }
            }.showOnWindow(supportFragmentManager)

        }
        setVp()

    }


    private fun setVp() {
        mBind.vp.initVp(isUserInputEnabled = false, offscreenPageLimitCount = 4) {
            adapter = object : FragmentStateAdapter(this@MainActivity) {
                override fun getItemCount(): Int {
                    return 4
                }


                override fun createFragment(position: Int): Fragment {
                    return when (position) {
                        0 -> HomeFragment.newInstance()
                        1 -> CommentAndNewsFragment.newInstance()
                        else -> MineFragment.newInstance()
                    }
                }

            }
        }

        setTextSelectedUI(mBind.tvHome, R.color.color_20_black, R.color.color_0FC8AC)
        setTextSelectedUI(mBind.tvQz, R.color.color_20_black, R.color.color_0FC8AC)
        setTextSelectedUI(mBind.tvMe, R.color.color_20_black, R.color.color_0FC8AC)
        setBottomSelectPos(0)
    }


    private fun setTextSelectedUI(
        tv: TextView,
        normalTextColor: Int,
        selectTextColor: Int
    ): TextView {
        val states = arrayOfNulls<IntArray>(2)
        states[0] = intArrayOf(android.R.attr.state_selected)
        states[1] = intArrayOf(-android.R.attr.state_selected)
        val colors = intArrayOf(
            ContextCompat.getColor(context, selectTextColor),
            ContextCompat.getColor(context, normalTextColor)
        )
        tv.setTextColor(ColorStateList(states, colors))
        return tv
    }


    private fun setBottomSelectPos(pos: Int) {
        lastPosition = position
        position = pos
        mBind.tvHome.isSelected = pos == 0
        mBind.tvQz.isSelected = pos == 1
        mBind.tvMe.isSelected = pos == 2

        when (position) {
            0 -> {
                mBind.tvHome.setTypeface(null, Typeface.BOLD)
                when (lastPosition) {
                    1 -> {
                        mBind.tvQz.setTypeface(null, Typeface.NORMAL)
                    }
                    2 -> {
                        mBind.tvMe.setTypeface(null, Typeface.NORMAL)
                    }

                }
            }
            1 -> {
                mBind.tvQz.setTypeface(null, Typeface.BOLD)
                when (lastPosition) {
                    0 -> {
                        mBind.tvHome.setTypeface(null, Typeface.NORMAL)
                    }
                    2 -> {
                        mBind.tvMe.setTypeface(null, Typeface.NORMAL)
                    }

                }
            }
            2 -> {
                mBind.tvMe.setTypeface(null, Typeface.BOLD)
                when (lastPosition) {

                    0 -> {
                        mBind.tvHome.setTypeface(null, Typeface.NORMAL)
                    }
                    1 -> {
                        mBind.tvQz.setTypeface(null, Typeface.NORMAL)
                    }

                }
            }

        }

        mBind.vp.setCurrentItem(pos, false)


    }

    override fun createObserver() {
        super.createObserver()
        receiveEvent<Int>(AppConfig.SWITCH_MAIN_TAB) {
            setBottomSelectPos(it)
        }
    }

    inner class ProxyClick {
        fun toHome() = setBottomSelectPos(0)
        fun toQz() = setBottomSelectPos(1)
        fun toMe() = setBottomSelectPos(2)

    }


}