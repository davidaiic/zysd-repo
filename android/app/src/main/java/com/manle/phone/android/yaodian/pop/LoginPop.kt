package com.manle.phone.android.yaodian.pop

import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.marginBottom
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.lifecycleScope
import com.app.base.AppConfig
import com.app.base.app_use.bean.WebResponse
import com.app.base.app_use.ext.dismissLoadingExt
import com.app.base.app_use.ext.showLoadingExt
import com.app.base.ext.*
import com.app.base.lifecycle.appContext
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNet
import com.drake.net.utils.scopeNetLife
import com.drake.tooltip.toast
import com.lxj.xpopup.core.FullScreenDialog
import com.lxj.xpopup.impl.FullScreenPopupView
import com.lxj.xpopup.util.KeyboardUtils
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.WebActivity
import com.manle.phone.android.yaodian.bean.TokenBean
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.databinding.ActivityCodeLoginBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CacheUtil
import com.manle.phone.android.yaodian.util.CommUtils.showErrorMessage

import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class LoginPop(val activity: FragmentActivity, val callBack: () -> Unit = {}) : FullScreenPopupView(activity) {
    lateinit var binding: ActivityCodeLoginBinding
    var phone = ""
    var code = ""
    var time = 60
    var select = false
    val yhxi = WebConfig.getWebUrl(WebConfig.yhxy)
    val yszy = WebConfig.getWebUrl(WebConfig.yszy)
    override fun getImplLayoutId(): Int {
        return R.layout.activity_code_login
    }

    override fun onCreate() {
        super.onCreate()
        binding = DataBindingUtil.bind(popupImplView)!!
        binding.click = ProxyClick()
        binding.phoneEt.addAfterTextChanged {
            phone = it.text.toString()
            changeLogin()
        }
        binding.codeEt.addAfterTextChanged {
            code = it.text.toString()
            changeLogin()
        }
        binding.closeIv.setOnClickListener {
            dismiss()
        }
        setAgreement()

    }

    private fun changeLogin() {
        if (phone.isNotEmpty() && phone.length == 11 && code.isNotEmpty() && code.length == 6) {
            binding.loginTv.background = createDrawable(color = R.color.color_0FC8AC.getColor(), radius = dp2fpx(30f))
        } else {
            binding.loginTv.background = createDrawable(color = R.color.color_CACACA.getColor(), radius = dp2fpx(30f))
        }
    }


    private fun setAgreement() {
        binding.tvUserAgreement.appendColorSpan(
            "我已阅读并同意", color(R.color.color_333333)
        ).appendClickSpan(
            str = "《用户协议》", color = color(R.color.color_0FC8AC)
        ) {
            KeyboardUtils.hideSoftInput(binding.phoneEt)
            WebActivity.start(WebResponse(url = if (yhxi.isNullOrEmpty()) WebConfig.yhxyUrl else yhxi, title = "用户协议", isUserHtmlTitle = false))
        }.appendClickSpan(
            str = "《隐私政策》", color = color(R.color.color_0FC8AC)
        ) {

            WebActivity.start(WebResponse(url = if (yszy.isNullOrEmpty()) WebConfig.yszyUrl else yszy, title = "隐私政策", isUserHtmlTitle = false))
        }
    }

    inner class ProxyClick {

        fun selectAgreement() {
            if (select) {
                select = false
                binding.agreementIv.setImageResource(R.drawable.ic_login_uncheck)
            } else {
                select = true
                binding.agreementIv.setImageResource(R.drawable.ic_login_checked)
            }
        }


        fun getCode() {

            if (time != 60) {
                return
            }

            activity.scopeDialog {
                try {
                    Post<String>(Api.user_sendSms) {
                        param("phone", phone)
                    }.await().runCatching {
                        binding.codeEt.requestFocus()
                        this.showErrorMessage(success = {
                            binding.codeEt.requestFocus()
                            binding.getCodeTv.setTextColor(R.color.color_999999.getColor())
                            lifecycleScope.launch {
                                for (i in 60 downTo 0) {
                                    delay(1000)
                                    if (i != 0) {
                                        binding.getCodeTv.text = "${i}s后重新获取"
                                        time = i
                                    } else {
                                        binding.getCodeTv.setTextColor(R.color.color_0FC8AC.getColor())
                                        binding.getCodeTv.text = "获取验证码"
                                        time = 60
                                    }

                                }
                            }
                        }, error = {
                            showToast(it)

                        })
                    }

                } catch (e: Exception) {
                    e.message?.let { s ->
                        showToast(s)
                    }
                }

            }

        }


        fun login() {
            if (!select) {
                showToast("请同意隐私协议")
                return
            }
            KeyboardUtils.hideSoftInput(binding.codeEt)
            if (phone.isNotEmpty() && phone.length == 11 && code.isNotEmpty() && code.length == 6) {
                activity.scopeDialog {
                    val tokenBean = Post<TokenBean>(Api.user_smsLogin) {
                        param("phone", phone)
                        param("code", code)
                    }.await()
                    CacheUtil.loginIn(tokenBean)
                    sendEvent(true, AppConfig.LOGIN_TYPE)
                    dismiss()
                    callBack.invoke()
                }
            } else {
                toast("请输入手机号和验证码")
            }
        }
    }

}