package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class AssociateWordBean(
    @SerialName("wordList")
    val wordList: MutableList<AssociationBean> = mutableListOf(),
)