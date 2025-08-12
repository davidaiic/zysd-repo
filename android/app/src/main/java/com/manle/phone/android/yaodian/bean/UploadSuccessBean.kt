package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.Serializable

import kotlinx.serialization.SerialName



@Serializable
data class UploadSuccessBean(
    @SerialName("url")
    val url: String = "",
    @SerialName("avatar")
    val avatar: String = ""

)