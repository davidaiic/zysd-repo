package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ScanDataBean(
    @SerialName("goodsId")
    val goodsId: Long = 0L,
    @SerialName("goodsName")
    val goodsName: String = "",
    @SerialName("result")
    val result: Int = 0,
    @SerialName("risk")
    val risk: Int = 0,
    @SerialName("serverName")
    val serverName: String = "",
    @SerialName("linkUrl")
    val linkUrl: String = "",

)