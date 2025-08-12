package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.extraAct
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.linear
import com.drake.brv.utils.setup
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.ArticleListBean
import com.manle.phone.android.yaodian.bean.NewsBean
import com.manle.phone.android.yaodian.databinding.ActivityNewsMoreBinding
import com.manle.phone.android.yaodian.databinding.AdapterNewsBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx


class NewsMoreActivity : BaseActivity<BaseViewModel, ActivityNewsMoreBinding>(R.layout.activity_news_more) {
    companion object {
        fun start(key: String) = KtxActivityManger.currentActivity!!.startActivity<NewsMoreActivity>(
            AppConfig.KEY1 to key
        )
    }

    val key by extraAct(AppConfig.KEY1, "")
    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "更多资讯")
        //新闻
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
                            NewsDetailActivity.startAct(this@NewsMoreActivity, model.articleId)
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
                            NewsDetailActivity.startAct(this@NewsMoreActivity, model.articleId)
                        }
                        R.id.shareWxTv -> {
                            getBinding<AdapterNewsBinding>().item.shareToWx(this@NewsMoreActivity, type = 2, id = model.articleId)
                        }

                    }
                }
            }
        mBind.prl.onRefresh {
            getData(index)
        }.autoRefresh()
    }


    private fun setCommentLike(articleId: String, callBack: () -> Unit = {}) = scopeNetLife {
        Post<String>(Api.article_like) {
            param("articleId", articleId)
        }.await()
        callBack.invoke()
    }


    private fun getData(page: Int) {
        scopeNetLife {
            val listBean = Post<ArticleListBean>(Api.article_list) {
                param("page", page)
                param("sortId", "")
                param("labelId", "")
                param("keyword", key)
            }.await()
            mBind.prl.addData(listBean.articleList, mBind.rv.bindingAdapter) {
                listBean.articleList.size == 20
            }
        }

    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }

}