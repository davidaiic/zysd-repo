package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class CallBackJsBean(
    @SerialName("data")
    val data: MutableList<String> = mutableListOf(),
)