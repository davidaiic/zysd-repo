package com.app.base.activity

import android.os.Bundle
import android.view.View
import androidx.annotation.LayoutRes
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import com.app.base.R
import com.app.base.ext.*
import com.app.base.net.manager.NetState
import com.app.base.net.manager.NetworkStateManager
import com.app.base.viewmodel.BaseViewModel
import com.gyf.immersionbar.ImmersionBar


abstract class BaseVmDbActivity<VM : BaseViewModel, DB : ViewDataBinding>(@LayoutRes val layoutId: Int) :
    AppCompatActivity(), ImmersionOwner {


    lateinit var mViewModel: VM

    abstract fun initView(savedInstanceState: Bundle?)


    open fun initData() {}

    val context by lazy { this }

    val viewLifecycleOwner: FragmentActivity by lazy { this }

    lateinit var mBind: DB

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.statusBarColor = color(R.color.color_white)
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR

        mBind = DataBindingUtil.setContentView(this, layoutId)
        mBind.lifecycleOwner = this
        ImmersionBar.with(this).navigationBarColor(R.color.color_white).autoDarkModeEnable(true)
            .statusBarDarkFont(true, 0.2f).init()
        if (immersionBarEnabled()) {
            initImmersionBar()
        }
        init(savedInstanceState)
    }

    private fun init(savedInstanceState: Bundle?) {
        mViewModel = createViewModel()
        registerDialogChange()
        initView(savedInstanceState)
        initData()
        createObserver()
        NetworkStateManager.instance.mNetworkStateCallback.observe(this, Observer {
            onNetworkStateChanged(it)
        })
    }


    open fun registerDialogChange() {
    }


    open fun onNetworkStateChanged(netState: NetState) {
        if (!netState.isHaveNet) {
            //断开网络
            showMyToast(R.string.no_net.getString())
        }
    }

    private fun createViewModel(): VM {
        return ViewModelProvider(this)[getVmClazz(this)]
    }



    abstract fun createObserver()


    open fun initDataBind() {}


    override fun immersionBarEnabled() = true

    override fun initImmersionBar() {}


    fun setImmToolbar(view: View) {
        ImmersionBar.setTitleBar(this, view)

    }

    fun setWhiteToolbar(view: View) {
        ImmersionBar.with(this).statusBarDarkFont(false).init()
        ImmersionBar.setTitleBar(this, view)


    }

    fun setDarkToolbar(view: View) {
        ImmersionBar.with(this).statusBarDarkFont(true, 0.2f).init()
        ImmersionBar.setTitleBar(this, view)
    }


}