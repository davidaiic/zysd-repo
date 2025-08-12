package com.app.base.utils

import android.app.Activity
import androidx.fragment.app.Fragment
import com.app.base.R
import com.lxj.xpopup.XPopup
import com.lxj.xpopup.impl.ConfirmPopupView



object PopUtils {

    fun Fragment.asConfirm(
        title: String = "",
        content: String = "",
        cancelBtnText: String = "",
        confirmBtnText: String = "",
        isHideCancel: Boolean = false,
        bindLayoutId: Int = R.layout.app_xpopup_center_impl_confirm,
        build: XPopup.Builder = XPopup.Builder(requireActivity()),
        cancelListener: () -> Unit = {},
        confirmListener: () -> Unit = {},
    ): ConfirmPopupView {
        return build.asConfirm(
            title,
            content,
            cancelBtnText,
            confirmBtnText,
            { confirmListener.invoke() },
            { cancelListener.invoke() },
            isHideCancel,
            bindLayoutId
        )


    }


    fun Activity.asConfirm(
        title: String = "",
        content: String = "",
        cancelBtnText: String = "取消",
        confirmBtnText: String = "确定",
        isHideCancel: Boolean = false,
        bindLayoutId: Int = R.layout.app_xpopup_center_impl_confirm,
        build: XPopup.Builder = XPopup.Builder(this),
        cancelListener: () -> Unit = {},
        confirmListener: () -> Unit = {},
    ): ConfirmPopupView {
        return build.asConfirm(
            title,
            content,
            cancelBtnText,
            confirmBtnText,
            { confirmListener.invoke() },
            { cancelListener.invoke() },
            isHideCancel,
            bindLayoutId
        )
    }

    fun Activity.asScanConfirm(
        title: String = "未识别到有效条形码",
        content: String = "",
        cancelBtnText: String = "取消",
        confirmBtnText: String = "重新识别",
        isHideCancel: Boolean = true,
        bindLayoutId: Int = R.layout.app_scan_error_confirm,
        build: XPopup.Builder = XPopup.Builder(this),
        cancelListener: () -> Unit = {},
        confirmListener: () -> Unit = {},
    ): ConfirmPopupView {
        return build.asConfirm(
            title,
            content,
            cancelBtnText,
            confirmBtnText,
            { confirmListener.invoke() },
            { cancelListener.invoke() },
            isHideCancel,
            bindLayoutId
        )
    }

}