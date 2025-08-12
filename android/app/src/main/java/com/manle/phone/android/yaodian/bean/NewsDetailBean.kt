package com.manle.phone.android.yaodian.bean

import com.app.base.ext.formatNum
import kotlinx.serialization.Serializable

import kotlinx.serialization.SerialName



@Serializable
data class NewsDetailBean(
    @SerialName("commentList")
    val commentList: MutableList<CommentBean> = mutableListOf(),
    @SerialName("info")
    val info: Info = Info()
) {


    @Serializable
    data class Info(
        @SerialName("articleId")
        val articleId: Int = 0,
        @SerialName("avatar")
        val avatar: String = "",
        @SerialName("commentNum")
        val commentNum: Int = 0,
        @SerialName("content")
        val content: String = "",
        @SerialName("created")
        val created: String = "",
        @SerialName("isLike")
        val isLike: Int = 0,
        @SerialName("label")
        val label: MutableList<String> = mutableListOf(),
        @SerialName("pictures")
        val pictures: MutableList<String> = mutableListOf(),
        @SerialName("likeNum")
        val likeNum: Int = 0,
        @SerialName("title")
        val title: String = "",
        @SerialName("username")
        val username: String = ""
    ) {
        fun getCommentDetailNumText() = "评论(${commentNum.formatNum()})"
        fun getCommentNumText() = commentNum.formatNum()
    }
}