package com.manle.phone.android.yaodian.activity

import android.annotation.SuppressLint
import android.os.Build
import android.os.Bundle
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.View
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.initVp
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.extraAct
import com.app.base.utils.startActivity
import com.lxj.xpopup.util.KeyboardUtils
import com.manle.phone.android.yaodian.App
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.HotSearchBean
import com.manle.phone.android.yaodian.databinding.ActivitySearchBinding
import com.manle.phone.android.yaodian.fragment.SearchAssociationFragment
import com.manle.phone.android.yaodian.fragment.SearchDefaultFragment
import com.manle.phone.android.yaodian.fragment.SearchListFragment
import com.manle.phone.android.yaodian.vm.SearchViewModel


class SearchActivity : BaseActivity<SearchViewModel, ActivitySearchBinding>(layoutId = R.layout.activity_search) {
    val listFragment = mutableListOf<Fragment>()


    companion object {
        fun startAct(search: String = "",isSearch:Boolean=true) {
            KtxActivityManger.currentActivity?.startActivity<SearchActivity>(
                AppConfig.KEY1 to search,AppConfig.KEY2 to isSearch)
        }
    }

    val search by extraAct<String>(AppConfig.KEY1)
    var isSearch by extraAct<Boolean>(AppConfig.KEY2,true)



    @SuppressLint("ClickableViewAccessibility")
    override fun initView(savedInstanceState: Bundle?) {
      mViewModel.isFirst=!isSearch

        mBind.click = ProxyClick()
        mBind.vm = mViewModel
        listFragment.add(SearchDefaultFragment.newInstance(this,0))
        listFragment.add(SearchAssociationFragment.newInstance())
        listFragment.add(SearchListFragment.newInstance())
        mBind.vp.initVp(supportFragmentManager, lifecycle, listFragment, false, listFragment.size)
        if (!search.isNullOrEmpty()) {
            mBind.etSearch.setText(search)
        }

        mBind.etSearch.setOnKeyListener { _, keyCode, event ->
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.action == KeyEvent.ACTION_DOWN) {
                mViewModel.searchText.value?.let {
                    if (it.isNullOrEmpty()) return@let
                    mBind.etSearch.isCursorVisible = false
                    if (it.isNotEmpty()) {

                        mViewModel.currentItemLiveData.value = 2
                    }
                }
            }
            false
        }
        mBind.etSearch.setOnTouchListener { _, event ->
            if (MotionEvent.ACTION_DOWN == event.action) {
                mBind.etSearch.apply {
                    isCursorVisible = true
                    if (mBind.vp.currentItem == 0 && mViewModel.searchText.value.isNullOrEmpty()) {

                    } else {
                        mViewModel.currentItemLiveData.value = 1
                    }
                }

            }
            false
        }

        mBind.etSearch.onFocusChangeListener = View.OnFocusChangeListener { v, hasFocus ->

            mViewModel.focus = hasFocus
            if (hasFocus) {
                KeyboardUtils.showSoftInput(v)
                mViewModel.searchText.value?.apply {
                    mBind.etSearch.setSelection(length)
                }

                if (mBind.vp.currentItem == 0 && mViewModel.searchText.value.isNullOrEmpty()) {
                    return@OnFocusChangeListener
                }
                mViewModel.currentItemLiveData.value = 1
            }
        }
        if (!search.isNullOrEmpty()) {
            mViewModel.searchText.value = search

            if (isSearch){
                mViewModel.currentItemLiveData.value = 2
            }

        }

    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun createObserver() {
        super.createObserver()

        mViewModel.currentItemLiveData.observe(this) {
            when (it) {
                2 -> {
                    KeyboardUtils.hideSoftInput(window)
                    mBind.etSearch.apply {
                        isCursorVisible = false
                    }
                    mViewModel.refreshList.value = true
                }
            }
            mBind.vp.setCurrentItem(it, false)

        }

    }


    inner class ProxyClick {
        fun back() {
            if (mBind.vp.currentItem != 0) {
                mViewModel.searchText.value = ""
                mBind.etSearch.clearFocus()
                KeyboardUtils.hideSoftInput(window)
                mBind.vp.setCurrentItem(0, false)
            } else {
                KeyboardUtils.hideSoftInput(window)
                finish()
            }
        }


        fun toScan() {
            ScanActivity.startAct()
        }

        fun toTakePhoto() {
            ScanActivity.startAct(type = 1)
        }


        fun search() {


            mViewModel.searchText.value?.let {
                if (it.isNullOrEmpty()) return
                mBind.etSearch.isCursorVisible = false
                if (it.isNotEmpty()) {

                    mViewModel.currentItemLiveData.value = 2
                }
            }

        }


        fun clearSearchText() {
            mViewModel.searchText.value = ""
            mViewModel.currentItemLiveData.value = 0
        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.toolBar)
    }


}