package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class CallBackJsCodeBean(
    @SerialName("data")
    val data: String = ""
)