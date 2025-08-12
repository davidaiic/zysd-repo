package com.manle.phone.android.yaodian.bean


@kotlinx.serialization.Serializable
data class ApiDetailBean<T>(
    val info: T? = null
)