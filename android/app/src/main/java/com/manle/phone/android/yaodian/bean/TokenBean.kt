package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class TokenBean(
    @SerialName("token")
    val token: String = "",
    @SerialName("uid")
    val uid: Long = 0L
)