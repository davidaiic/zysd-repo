package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import androidx.fragment.app.activityViewModels
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.ext.initVp
import com.app.base.utils.AppVpUtils.bindVp
import com.app.base.viewmodel.BaseViewModel
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.PublishPostActivity
import com.manle.phone.android.yaodian.activity.SearchActivity
import com.manle.phone.android.yaodian.bean.SievingBean
import com.manle.phone.android.yaodian.databinding.FragmentCommentAndNewsBinding
import com.manle.phone.android.yaodian.databinding.FragmentCommentAndNewsSearchBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.pop.SievingPopupView
import com.manle.phone.android.yaodian.vm.SearchViewModel


class CommentAndNewsSearchFragment : BaseFragment<BaseViewModel, FragmentCommentAndNewsSearchBinding>(R.layout.fragment_comment_and_news_search) {
    companion object {
        fun newInstance() = CommentAndNewsSearchFragment()
    }

    private val commentFragment = CommentFragment.newInstance()
    private val newsAllFragment = NewsAllFragment.newInstance()
    private val listFragment = mutableListOf(commentFragment, newsAllFragment)
    private val topTab = mutableListOf("评论", "资讯")

    private val activityVm by activityViewModels<SearchViewModel>()

    var sortId: String = ""
    var labelId: String = ""
    var keyword: String = ""

    override fun initView(savedInstanceState: Bundle?) {
        mBind.vp.initVp(childFragmentManager, lifecycle, listFragment, true, topTab.size)
        mBind.magicIndicator.bindVp(mBind.vp, topTab) {

        }

    }


    fun setSort(sort: String, label: String) {
        this.sortId = sort
        this.labelId = label
        commentFragment.setSort(sortId, labelId, keyword)
        newsAllFragment.setSort(sortId, labelId, keyword)
    }

    override fun createObserver() {
        super.createObserver()
        activityVm.refreshList.observe(this) {
            commentFragment.setSort(sortId, labelId, keyword)
            newsAllFragment.setSort(sortId, labelId, keyword)
            activityVm.addSearchHistory()
        }
        activityVm.searchText.observe(this) {
            keyword = it
        }
    }

    override fun lazyLoadData() {

    }


}
