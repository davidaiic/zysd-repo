package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ImgRocBean(
    @SerialName("imageId")
    val imageId: Long = 0L,
    @SerialName("imageUrl")
    val imageUrl: String = "",
    @SerialName("keywords")
    val keywords: MutableList<KeywordBean> = mutableListOf()
) {
    @Serializable
    data class KeywordBean(
        @SerialName("name")
        val name: String = "",
        var selected: Boolean = false
    )
}