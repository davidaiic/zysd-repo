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
import com.app.base.ext.gone
import com.app.base.ext.initVp
import com.app.base.ext.visible
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.extraAct
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.lxj.xpopup.XPopup
import com.lxj.xpopup.util.KeyboardUtils
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.SievingBean
import com.manle.phone.android.yaodian.databinding.ActivityCommentNewsSearchBinding
import com.manle.phone.android.yaodian.fragment.*
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.pop.SievingPopupView
import com.manle.phone.android.yaodian.vm.SearchViewModel


class CommentNewsSearchActivity : BaseActivity<SearchViewModel, ActivityCommentNewsSearchBinding>
    (R.layout.activity_comment_news_search) {
    private val listFragment = mutableListOf<Fragment>()
    var sievingPopupView: SievingPopupView? = null
    private val commentAndNewsSearchFragment = CommentAndNewsSearchFragment()

    companion object {
        fun startAct() {
            KtxActivityManger.currentActivity?.startActivity<CommentNewsSearchActivity>()
        }
    }


    @SuppressLint("ClickableViewAccessibility")
    override fun initView(savedInstanceState: Bundle?) {
        mBind.click = ProxyClick()
        mBind.vm = mViewModel
        listFragment.add(SearchDefaultFragment.newInstance(this, 1))
        listFragment.add(commentAndNewsSearchFragment)
        mBind.vp.initVp(supportFragmentManager, lifecycle, listFragment, false, listFragment.size)

        mBind.etSearch.setOnKeyListener { _, keyCode, event ->
            if (keyCode == KeyEvent.KEYCODE_ENTER && event.action == KeyEvent.ACTION_DOWN) {
                mViewModel.searchText.value?.let {
                    if (it.isNullOrEmpty()) return@let
                    mBind.etSearch.isCursorVisible = false
                    if (it.isNotEmpty()) {
                        mViewModel.currentItemLiveData.value = 1
                    }
                }
            }
            false
        }
        getSieving()
    }


    private fun getSieving() {
        scopeNetLife {
            val sievingBean = Post<SievingBean>(Api.filter_criteria).await()
            sievingPopupView = SievingPopupView(this@CommentNewsSearchActivity, sievingBean) { sortId, labelId ->
                sievingPopupView?.apply { dismiss() }
                commentAndNewsSearchFragment.setSort(sortId, labelId)
            }
        }
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun createObserver() {
        super.createObserver()
        mViewModel.currentItemLiveData.observe(this) {
            when (it) {
                1 -> {
                    KeyboardUtils.hideSoftInput(window)
                    mBind.etSearch.apply {
                        isCursorVisible = false
                    }
                    mViewModel.refreshList.value = true
                    mBind.selectTv.visible()
                }
                else -> {
                    mBind.selectTv.gone()
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

        fun sieving() {
            sievingPopupView?.let {
                XPopup.Builder(context)
                    .atView(mBind.toolBar)
                    .asCustom(it)
                    .show()
            }

        }


        fun search() {
            mViewModel.searchText.value?.let {
                if (it.isNullOrEmpty()) return
                mBind.etSearch.isCursorVisible = false
                if (it.isNotEmpty()) {
                    mViewModel.currentItemLiveData.value = 1
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