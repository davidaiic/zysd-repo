package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class GoodsDetailBean(

    @SerialName("articleList")
    val articleList: List<NewsBean> = listOf(),
    @SerialName("goodsInfo")
    val goodsInfo: GoodsBean = GoodsBean(),
    @SerialName("serverList")
    val serverList: List<ServerBean> = listOf()
) {



    @Serializable
    data class ServerBean(
        @SerialName("desc")
        val desc: String = "",
        @SerialName("icon")
        val icon: String = "",
        @SerialName("serverId")
        val serverId: Int = 0,
        @SerialName("serverName")
        val serverName: String = "",
        @SerialName("linkUrl")
        val linkUrl: String = ""

    )
}