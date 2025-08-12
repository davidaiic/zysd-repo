package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class HotSearchBean(
    @SerialName("searchTip")
    val searchTip: String = "",
    @SerialName("wordList")
    val wordList: List<Word> = listOf(),

) {
    @Serializable
    data class Word(
        @SerialName("word")
        val word: String = "",
        val selected: Boolean = false
    )
}