package com.manle.phone.android.yaodian.bean

import com.app.base.ext.formatNum
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable
data class NewsBean(
    @SerialName("articleId")
    val articleId: String = "",
    @SerialName("commentNum")
    val commentNum: Int = 0,
    @SerialName("cover")
    val cover: String = "",
    @SerialName("created")
    val created: String = "",
    @SerialName("isLike")
    var isLike: Int = 0,
    @SerialName("label")
    val label: List<String> = listOf(),
    @SerialName("likeNum")
    var likeNum: Int = 0,
    @SerialName("readNum")
    val readNum: Int = 0,
    @SerialName("title")
    val title: String = ""
){
    fun getReadNumText()="${readNum}阅读"

    fun getLikeNumText() = if(likeNum==0)"点赞" else likeNum.formatNum()
    fun getCommentNumText() = if(commentNum==0)"评论" else commentNum.formatNum()


}