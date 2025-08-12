package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class WebListUrlBean(
    @SerialName("urlList")
    val urlList: MutableList<UrlBean> = mutableListOf()
) {
    @Serializable
    data class UrlBean(
        @SerialName("keyword")
        val keyword: String = "",
        @SerialName("linkUrl")
        val linkUrl: String = "",
        @SerialName("title")
        val title: String = ""
    )
}