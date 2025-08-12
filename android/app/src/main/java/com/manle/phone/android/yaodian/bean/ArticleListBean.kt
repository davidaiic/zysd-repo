package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class ArticleListBean(
    @SerialName("articleList")
    val articleList: List<NewsBean> = listOf()
) {

}