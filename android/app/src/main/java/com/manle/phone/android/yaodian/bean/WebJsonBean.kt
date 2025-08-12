package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class WebJsonBean(
    @SerialName("action")
    val action: String = "",
    @SerialName("value")
    val value: Value = Value()
) {
    @Serializable
    data class Value(
        @SerialName("max")
        val max: Int = 0
    )
}