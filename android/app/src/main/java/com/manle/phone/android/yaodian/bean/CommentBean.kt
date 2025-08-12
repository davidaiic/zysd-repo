package com.manle.phone.android.yaodian.bean


import com.app.base.ext.formatNum
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CommentBean(
    @SerialName("avatar")
    val avatar: String = "",
    @SerialName("commentId")
    val commentId: String = "",
    @SerialName("commentNum")
    val commentNum: Int = 0,
    @SerialName("content")
    val content: String = "",
    @SerialName("created")
    val created: String = "",
    @SerialName("isLike")
    var isLike: Int = 0,
    @SerialName("likeNum")
    var likeNum: Int = 0,
    @SerialName("username")
    val username: String = "",

    @SerialName("pictures")
    var pictures: MutableList<String> = mutableListOf(),

) {

    fun getLikeNumText() = if(likeNum==0)"点赞" else likeNum.formatNum()
    fun getCommentNumText() = if(commentNum==0)"评论" else commentNum.formatNum()

}