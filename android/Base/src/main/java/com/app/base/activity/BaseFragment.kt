package com.app.base.activity

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.ViewDataBinding
import com.app.base.app_use.ext.dismissLoadingExt
import com.app.base.app_use.ext.showLoadingExt
import com.app.base.ext.getAppViewModel
import com.app.base.viewmodel.BaseViewModel
import   com.app.base.ext.hideSoftKeyboard



abstract class BaseFragment<VM : BaseViewModel, DB : ViewDataBinding>(@LayoutRes layoutId: Int) :
    BaseVmDbFragment<VM, DB>(layoutId) {

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        return super.onCreateView(inflater, container, savedInstanceState)
    }

    override fun createObserver() {

    }

    override fun onResume() {
        super.onResume()
        hideSoftKeyboard(activity)
    }

    fun hideSoftKeyboard() {
        hideSoftKeyboard(activity)
    }

    open fun showLoading() {
        context?.showLoadingExt()
    }

    open fun dismissLoading() {
        dismissLoadingExt()
    }

    override fun registerDialogChange() {
        mViewModel.loadingChange.getShowLoading().observe(viewLifecycleOwner) {
            if (it)
                showLoading()
            else
                dismissLoading()
        }

    }
}