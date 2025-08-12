package com.manle.phone.android.yaodian.bean


import kotlinx.serialization.Serializable


@Serializable
data class UserBean(
    var accessToken: String = "",
    var mobile: String = "",
    var userId: String = "",
    var userIcon: String = "",
    var nickname: String = "",
    var username: String = "",
    var avatar: String = ""
) {
    fun getUserNameText() = if (username.isNullOrEmpty()) "欢迎登录" else username
}