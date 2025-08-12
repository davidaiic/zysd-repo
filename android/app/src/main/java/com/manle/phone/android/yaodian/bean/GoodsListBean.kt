package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class GoodsListBean(
    @SerialName("goodsList")
    val goodsList: List<GoodsBean> = listOf()
)