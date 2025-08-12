package com.manle.phone.android.yaodian.pop

import androidx.databinding.DataBindingUtil
import androidx.fragment.app.FragmentActivity
import com.app.base.ext.colorSpan
import com.app.base.ext.getColor
import com.app.base.ext.sizeSpan
import com.lxj.xpopup.core.CenterPopupView
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.PopScanCodeCenterBinding


class ScanCodeCenterPopupView(val activity: FragmentActivity, val name: String, val switchPhoto: () -> Unit, val toDetail: () -> Unit, val cancel: () -> Unit) : CenterPopupView(activity) {
    lateinit var binding: PopScanCodeCenterBinding
    override fun getImplLayoutId(): Int {
        return R.layout.pop_scan_code_center
    }


    override fun onCreate() {
        super.onCreate()
        binding = DataBindingUtil.bind(popupImplView)!!
        binding.click = ProxyClick()

        binding.tvContent.text = name


    }

    inner class ProxyClick {

        fun takePhone() {
            switchPhoto.invoke()
            dismiss()
        }


        fun yes() {
            toDetail.invoke()
            dismiss()

        }

        fun close() {
            cancel.invoke()
            dismiss()
        }
    }
}