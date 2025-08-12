package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.ext.dp2px
import com.app.base.ext.initVp
import com.app.base.utils.AppVpUtils.bindVp
import com.app.base.view.dialog.extensions.bindingListenerFun
import com.app.base.view.dialog.extensions.dataConvertListenerFun
import com.app.base.view.dialog.extensions.newAppDialog
import com.app.base.view.dialog.other.DialogGravity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.CommentNewsSearchActivity
import com.manle.phone.android.yaodian.activity.PublishPostActivity
import com.manle.phone.android.yaodian.activity.SearchActivity
import com.manle.phone.android.yaodian.bean.CommentListBean
import com.manle.phone.android.yaodian.bean.SievingBean
import com.manle.phone.android.yaodian.databinding.DialogSievingBinding
import com.manle.phone.android.yaodian.databinding.FragmentCommentAndNewsBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.pop.SievingPopupView
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin



class CommentAndNewsFragment : BaseFragment<BaseViewModel, FragmentCommentAndNewsBinding>(R.layout.fragment_comment_and_news) {
    companion object {
        fun newInstance() = CommentAndNewsFragment()
    }

    private val commentFragment = CommentFragment.newInstance()
    private val newsAllFragment = NewsAllFragment.newInstance()
    private val listFragment = mutableListOf(commentFragment, newsAllFragment)
    private val topTab = mutableListOf("评论", "资讯")
    var sievingPopupView: SievingPopupView? = null


    override fun initView(savedInstanceState: Bundle?) {
        mBind.click = ProxyClick()
        mBind.vp.initVp(childFragmentManager, lifecycle, listFragment, true, topTab.size)
        mBind.magicIndicator.bindVp(mBind.vp, topTab) {

        }

    }

    override fun lazyLoadData() {
        getSieving()
    }

    override fun createObserver() {
        super.createObserver()
        receiveEvent<Int>(AppConfig.SWITCH_MAIN_TAB) {
            mBind.vp.currentItem=0
        }

    }

    private fun getSieving() {
        scopeNetLife {
            val sievingBean = Post<SievingBean>(Api.filter_criteria).await()
            sievingPopupView = SievingPopupView(requireContext(), sievingBean) { sortId, labelId ->
                sievingPopupView?.apply { dismiss() }
//                commentFragment.setSort(sortId, labelId,"")
                newsAllFragment.setSort(sortId, labelId,"")
            }
        }
    }

    inner class ProxyClick {

        fun toSearch(){
          CommentNewsSearchActivity.startAct()

        }

        fun sieving() {
            sievingPopupView?.let {
                XPopup.Builder(context)
                    .atView(mBind.toolbar)
                    .asCustom(it)
                    .show()
            }

        }


        fun publishPost() {
            PublishPostActivity.startAct(requireActivity())
        }
    }

    override fun immersionBarEnabled(): Boolean {
        return true
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.toolbar)
    }
}