package com.app.base.viewmodel


import androidx.lifecycle.ViewModel
import com.app.base.livdata.MutableResult
import com.app.base.livdata.Result


open class BaseViewModel : ViewModel() {
    val loadingChange: UiLoadingChange by lazy { UiLoadingChange() }


    inner class UiLoadingChange {

        private val isShowDialog = MutableResult<Boolean>()

        fun getShowLoading(): Result<Boolean> {
            return isShowDialog
        }

        fun setShowLoading(showLoading: Boolean) {
            isShowDialog.value = showLoading
        }


    }


    fun showLoading() {
        loadingChange.setShowLoading(true)
    }

    fun hideLoading() {
        loadingChange.setShowLoading(false)
    }




}