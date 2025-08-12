package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class BannerBean(
    @SerialName("bannerId")
    val bannerId: Int = 0,
    @SerialName("imageUrl")
    val imageUrl: String = "",
    @SerialName("linkUrl")
    var linkUrl: String = "",
    @SerialName("name")
    val name: String = "",
    @SerialName("notes")
    val notes: String = "",
    @SerialName("text1")
    val text1: String = "",
    @SerialName("text2")
    val text2: String = "",
    @SerialName("type")
    val type: Int = 0
)