package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.app_use.ext.loadImage
import com.app.base.view.nine.ImageAdapter
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.linear
import com.drake.brv.utils.setup
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.CommentDetailActivity
import com.manle.phone.android.yaodian.activity.NewsDetailActivity
import com.manle.phone.android.yaodian.bean.ArticleListBean
import com.manle.phone.android.yaodian.bean.NewsBean
import com.manle.phone.android.yaodian.databinding.AdapterCommentBinding
import com.manle.phone.android.yaodian.databinding.AdapterNewsBinding
import com.manle.phone.android.yaodian.databinding.FragmentCommentBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx


class NewsAllFragment : BaseFragment<BaseViewModel, FragmentCommentBinding>(R.layout.fragment_comment) {
    companion object {
        fun newInstance() = NewsAllFragment()
    }

    var sortId: String = ""
    var labelId: String = ""
    var keyword: String = ""
    override fun initView(savedInstanceState: Bundle?) {

        mBind.rv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 15, end = 15, dp = true)
                endVisible = true
            }.setup {
                addType<NewsBean> { R.layout.adapter_news }
                onClick(R.id.item, R.id.likeTv, R.id.commentTv, R.id.shareWxTv) {
                    val model = getModel<NewsBean>()
                    when (it) {
                        R.id.item -> {
                            NewsDetailActivity.startAct(requireActivity(), model.articleId)
                        }
                        R.id.likeTv ->
                            jumpByLogin(loginSuccessCall = false) {
                                setCommentLike(model.articleId) {
                                    jumpByLogin {
                                        model.isLike = if (model.isLike == 0) 1 else 0
                                        model.likeNum = if (model.isLike == 0) model.likeNum - 1 else model.likeNum + 1
                                        this@setup.notifyItemChanged(modelPosition)
                                    }
                                }
                            }
                        R.id.commentTv -> {
                            NewsDetailActivity.startAct(requireActivity(), model.articleId)
                        }
                        R.id.shareWxTv -> {
                            getBinding<AdapterNewsBinding>().item.shareToWx(requireActivity(), type = 2, id = model.articleId)
                        }

                    }
                }
            }
        mBind.prl.onRefresh {
            getData(index, sortId, labelId)
        }

    }

    override fun lazyLoadData() {
        mBind.prl.autoRefresh()
    }



    private fun setCommentLike(articleId: String, callBack: () -> Unit = {}) = scopeNetLife {
        Post<String>(Api.article_like) {
            param("articleId", articleId)
        }.await()
        callBack.invoke()
    }


    private fun getData(page: Int, sortId: String, labelId: String) {
        scopeNetLife {
            val listBean = Post<ArticleListBean>(Api.article_list) {
                param("page", page)
                param("sortId", sortId)
                param("labelId", labelId)
                param("keyword", keyword)
            }.await()
            mBind.prl.addData(listBean.articleList, mBind.rv.bindingAdapter) {
                listBean.articleList.size == 20
            }
        }

    }


    fun setSort(sortId: String, labelId: String, key: String) {
        this.sortId = sortId
        this.labelId = labelId
        this.keyword = key
        mBind.prl.refresh()
    }


}