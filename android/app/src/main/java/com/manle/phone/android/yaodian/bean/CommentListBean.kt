package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CommentListBean(
    @SerialName("commentList")
    val commentList: List<CommentBean> = listOf()
)