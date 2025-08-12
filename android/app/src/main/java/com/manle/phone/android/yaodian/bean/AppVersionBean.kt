package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.Serializable

import kotlinx.serialization.SerialName




@Serializable
data class AppVersionBean(
    @SerialName("info")
    val info: Info = Info(),
    @SerialName("isUpdate")
    val isUpdate: Int = 0
) {
    @Serializable
    data class Info(
        @SerialName("content")
        val content: String = "",
        @SerialName("downloadUrl")
        val downloadUrl: String = "",
        @SerialName("file")
        val file: String = "",
        @SerialName("isMust")
        val isMust: Int = 0

    )
}