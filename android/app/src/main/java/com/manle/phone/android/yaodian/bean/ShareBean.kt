package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ShareBean(
    @SerialName("path")
    val path: String = "",
    @SerialName("title")
    val title: String = ""
)