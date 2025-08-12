package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SearchUserBean(
    @SerialName("avatar")
    val avatar: String = "",
    @SerialName("content")
    val content: String = ""
)