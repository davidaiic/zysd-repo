package com.app.base.activity

import android.app.Activity
import android.app.Dialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.ViewModelProvider
import com.app.base.R
import com.app.base.ext.getColor
import com.app.base.ext.getVmClazz
import com.app.base.viewmodel.BaseViewModel
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialogFragment


abstract class BaseBottomSheetDialogFragment<VM : BaseViewModel, DB : ViewDataBinding>(@LayoutRes val layoutId: Int) :
    BottomSheetDialogFragment() {

    lateinit var mBind: DB
    lateinit var mViewModel: VM
    lateinit var activity: Activity
    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        activity = requireActivity()
        if (!::mBind.isInitialized) {
            mBind = DataBindingUtil.inflate(inflater, layoutId, container, false)
        }
        mBind.lifecycleOwner = this
        return mBind.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        mViewModel = createViewModel()
        initView(savedInstanceState)
        createObserver()
    }

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        if (context == null) {
            return super.onCreateDialog(savedInstanceState);
        }
        return  ProxyBottomSheetDialog(requireContext(), theme)
    }

    abstract fun initView(savedInstanceState: Bundle?)


    abstract fun createObserver()


    private fun createViewModel(): VM {
        return ViewModelProvider(this)[getVmClazz(this)]
    }


    fun setLayout(peekHeight: Int, draggable: Boolean = true) {
        val parentView = mBind.root.parent as View
        parentView.setBackgroundColor(R.color.transparent.getColor())
        val behavior = BottomSheetBehavior.from(parentView)
        if (draggable) {
            behavior.peekHeight = peekHeight
            val lp = parentView.layoutParams
            lp.height = ViewGroup.LayoutParams.MATCH_PARENT
            parentView.layoutParams = lp
        } else {
            parentView.layoutParams.height = peekHeight
            behavior.state = BottomSheetBehavior.STATE_EXPANDED
            behavior.setDraggable(false)
        }


    }

    override fun show(manager: FragmentManager, tag: String?) {
        try {
            //在每个add事务前增加一个remove事务，防止连续的add
            manager.beginTransaction().remove(this).commit()
            super.show(manager, tag)
        } catch (e: Exception) {
            //同一实例使用不同的tag会异常,这里捕获一下
            e.printStackTrace()
        }
    }

    open fun isShowing(): Boolean {
        return null != dialog && dialog!!.isShowing
    }

}