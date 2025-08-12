package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class AssociationBean(
    @SerialName("word")
    val word: String = "",//关键词

)