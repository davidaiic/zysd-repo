package com.app.base.activity


import android.os.Bundle
import androidx.annotation.LayoutRes
import androidx.databinding.ViewDataBinding
import com.app.base.app_use.ext.dismissLoadingExt
import com.app.base.app_use.ext.showLoadingExt

import com.app.base.viewmodel.BaseViewModel

import   com.app.base.ext.hideSoftKeyboard



abstract class BaseActivity<VM : BaseViewModel, DB : ViewDataBinding>(@LayoutRes layoutId: Int) :
    BaseVmDbActivity<VM, DB>(layoutId) {


    var loadingType = BASE_LOADING

    companion object {
        const val BASE_LOADING = 0

    }


    override fun createObserver() {

    }

    fun setLoadType(loadingType: Int) {
        this.loadingType = loadingType
    }


    override fun onResume() {
        super.onResume()
        hideSoftKeyboard(viewLifecycleOwner)
    }

    fun hideSoftKeyboard() {
        hideSoftKeyboard(this)
    }

    override fun registerDialogChange() {
        mViewModel.loadingChange.getShowLoading().observe(viewLifecycleOwner) {
            if (it) showLoading()
            else dismissLoading()
        }
    }

    open fun dismissLoading() {
        dismissLoadingExt()
    }

    open fun showLoading(hasShadowBg: Boolean = false) {
        showLoadingExt(hasShadowBg = hasShadowBg)
    }


}