package com.manle.phone.android.yaodian.bean

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class ToWebTokenBean(
    @SerialName("data")
    val data: TokenBean = TokenBean()
)