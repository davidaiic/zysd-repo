package com.app.base.app_use.ext

import android.annotation.SuppressLint
import android.content.Context
import com.app.base.view.AppLoading
import com.lxj.xpopup.XPopup
import com.lxj.xpopup.core.BasePopupView





private var loadingDialog: BasePopupView? = null
@SuppressLint("StaticFieldLeak")
private val appLoading: AppLoading? = null

fun Context.showLoadingExt(popupView: BasePopupView = appLoading ?: AppLoading(this), hasShadowBg:Boolean=false) {
    loadingDialog = XPopup.Builder(this)
        .hasShadowBg(hasShadowBg)
        .dismissOnTouchOutside(false)
        .asCustom(popupView)
        .show()
}



fun dismissLoadingExt() {
    loadingDialog?.dismiss()
    loadingDialog = null
}

