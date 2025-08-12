package com.manle.phone.android.yaodian.bean

import androidx.databinding.BaseObservable
import androidx.databinding.Bindable
import kotlinx.serialization.Serializable

import kotlinx.serialization.SerialName



@Serializable
data class SievingBean(
    @SerialName("labelList")
    val labelList: List<Label> = listOf(),
    @SerialName("sortList")
    val sortList: List<Sort> = listOf()
) {
    @Serializable
    data class Label(
        @SerialName("labelId")
        val labelId: String = "",
        @SerialName("name")
        val name: String = ""
    ) : BaseObservable() {
        @Bindable
        var isSelected: Boolean = false
    }

    @Serializable
    data class Sort(
        @SerialName("name")
        val name: String = "",
        @SerialName("sortId")
        val sortId: String = ""
    ): BaseObservable() {
        @Bindable
        var isSelected: Boolean = false
    }
}