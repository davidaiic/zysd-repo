package com.manle.phone.android.yaodian.bean


import com.app.base.ext.formatNum
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class CommentDetailBean(
    @SerialName("commentList")
    val commentList: MutableList<CommentBean> = mutableListOf(),
    @SerialName("info")
    val info: Info = Info()
) {


    @Serializable
    data class Info(
        @SerialName("avatar")
        val avatar: String = "",
        @SerialName("commentId")
        val commentId: Int = 0,
        @SerialName("commentNum")
        val commentNum: Int = 0,
        @SerialName("content")
        val content: String = "",
        @SerialName("created")
        val created: String = "",
        @SerialName("isLike")
        val isLike: Int = 0,
        @SerialName("likeNum")
        val likeNum: Int = 0,
        @SerialName("pictures")
        val pictures: MutableList<String> = mutableListOf(),
        @SerialName("username")
        val username: String = ""

    ){
        fun getCommentDetailNumText() = "评论(${commentNum.formatNum()})"
        fun getCommentNumText() = commentNum.formatNum()
    }
}
