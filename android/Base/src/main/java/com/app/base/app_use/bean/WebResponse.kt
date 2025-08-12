package com.app.base.app_use.bean

import android.os.Parcelable
import kotlinx.parcelize.Parcelize



@Parcelize
data class WebResponse(
    var url: String = "",
    var title: String = "",
    val htmlContent: String = "",
    val isUserHtmlTitle: Boolean = true,
    val type: Int = 0,
) : Parcelable