package com.manle.phone.android.yaodian.bean


import com.app.base.ext.formatNum
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class HomeBean(
    @SerialName("bannerList")
    val bannerList: List<BannerBean> = listOf(),
    @SerialName("goodsList")
    val goodsList: List<GoodsBean> = listOf(),
    @SerialName("searchList")
    val searchList: List<SearchUserBean> = listOf(),
    @SerialName("searchText")
    val searchText: String = "",

    @SerialName("selfQueryNum")
    val selfQueryNum: Int = 0,

    @SerialName("scanNum")
    val scanNum: Int = 0,
    @SerialName("manualVerifyNum")
    val manualVerifyNum: Int = 0,



    @SerialName("priceQueryNum")
    val priceQueryNum: Int = 0,
    @SerialName("checkNum")
    val checkNum: Int = 0,
    @SerialName("compareNum")
    val compareNum: Int = 0,


) {
    fun getSelfQueryNumNumText() = selfQueryNum.formatNum()
    fun getScanNumText() = scanNum.formatNum()

    fun getManualVerifyNumText() = manualVerifyNum.formatNum()


    fun getPriceQueryNumText() = priceQueryNum.formatNum()
    fun getCheckNumText() = checkNum.formatNum()
    fun getCompareNumText() = compareNum.formatNum()
}