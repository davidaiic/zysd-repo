package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ContentBean(
    @SerialName("content")
    val content: String = "",
    @SerialName("title")
    val title: String = ""
)