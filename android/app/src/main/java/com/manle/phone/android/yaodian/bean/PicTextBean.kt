package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class PicTextBean(
    @SerialName("words")
    val words: MutableList<Word> = mutableListOf()
) {
    @Serializable
    data class Word(
        @SerialName("text")
        val text: String = "",
        var selected: Boolean=false
    )
}