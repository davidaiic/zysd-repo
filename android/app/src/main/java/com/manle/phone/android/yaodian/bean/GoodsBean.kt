package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class GoodsBean(

    @SerialName("goodsId")
    val goodsId: Long = 0L,
    @SerialName("goodsImage")
    val goodsImage: String = "",
    @SerialName("goodsName")
    val goodsName: String = "",
    @SerialName("searchNum")
    val searchNum: Int = 0,
    @SerialName("companyId")
    val companyId: Long = 0L,
    @SerialName("companyName")
    val companyName: String = "",
    @SerialName("risk")
    val risk: Int = 0,
    @SerialName("clinicalStage")
    val clinicalStage: String = "",
    @SerialName("marketTag")
    val marketTag: String = "",
    @SerialName("medicalTag")
    val medicalTag: String = "",
    @SerialName("drugProperties")
    val drugProperties: String = "",
    @SerialName("drugPropertiesColor")
    val drugPropertiesColor: String = "",
    @SerialName("keyword")
    val keyword: String = "",



) {
    fun getSearchNumText() = "${searchNum}人查询过"
}