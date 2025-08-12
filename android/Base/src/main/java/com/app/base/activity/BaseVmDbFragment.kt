package com.app.base.activity


import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.Fragment
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.gyf.immersionbar.ImmersionBar
import com.app.base.ext.logD

import com.app.base.net.manager.NetState
import com.app.base.net.manager.NetworkStateManager
import com.app.base.viewmodel.BaseViewModel
import com.app.base.ext.getVmClazz


abstract class  BaseVmDbFragment<VM : BaseViewModel, DB : ViewDataBinding>(@LayoutRes val layoutId: Int)  : Fragment(), ImmersionOwner {


    private var isFirst: Boolean = true

    lateinit var mViewModel: VM

    lateinit var mActivity: AppCompatActivity


    lateinit var mBind: DB

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        mBind = DataBindingUtil.inflate(inflater, layoutId, container, false)
        mBind.lifecycleOwner = this
        return mBind.root
    }


    override fun onAttach(context: Context) {
        super.onAttach(context)
        mActivity = context as AppCompatActivity
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (immersionBarEnabled()) {
            initImmersionBar()
        }
        isFirst = true
        mViewModel = createViewModel()
        initView(savedInstanceState)
        createObserver()
        onVisible()
        registerDialogChange()
        initData()
    }


    open fun onNetworkStateChanged(netState: NetState) {}


    private fun createViewModel(): VM {
        return ViewModelProvider(this).get(getVmClazz(this))
    }

    abstract fun initView(savedInstanceState: Bundle?)

    abstract fun lazyLoadData()

    abstract fun createObserver()

    override fun onResume() {
        super.onResume()
        onVisible()
    }


    override fun immersionBarEnabled() = false
    override fun initImmersionBar() {}

    private fun onVisible() {
        if (lifecycle.currentState == Lifecycle.State.STARTED && isFirst) {
            view?.postDelayed({
                lazyLoadData()
                NetworkStateManager.instance.mNetworkStateCallback.observe(
                    this,
                    Observer {
                        if (!isFirst) {
                            onNetworkStateChanged(it)
                        }
                    })
                isFirst = false
            }, 120)
        }
    }

    open fun initData() {}

    fun setImmToolbar(view: View) {
        ImmersionBar.setTitleBar(this, view)
    }

    fun setWhiteToolbar(view: View) {
        activity?.let {
            ImmersionBar.with(it).statusBarDarkFont(false).init()
            ImmersionBar.setTitleBar(this, view)
        }

    }

    fun setDarkToolbar(view: View) {
        activity?.let {
            ImmersionBar.with(it).statusBarDarkFont(true, 0.2f).init()
            ImmersionBar.setTitleBar(this, view)
        }
    }

    open fun registerDialogChange() {
    }


}