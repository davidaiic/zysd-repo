package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.logE
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.extraAct
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.*
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.GoodsDetailBean
import com.manle.phone.android.yaodian.bean.ItemBean
import com.manle.phone.android.yaodian.bean.NewsBean
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.databinding.ActivitySearchDetailBinding
import com.manle.phone.android.yaodian.databinding.AdapterNewsBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx
import com.manle.phone.android.yaodian.vm.SearchDetailViewModel


class SearchDetailActivity : BaseActivity<SearchDetailViewModel, ActivitySearchDetailBinding>(R.layout.activity_search_detail) {
    companion object {
        fun startAct(activity: FragmentActivity, goodsId: Long) {
            activity.jumpByLogin {
                it.startActivity<SearchDetailActivity>(AppConfig.KEY1 to goodsId)
            }

        }
    }

    val goodsId by extraAct(AppConfig.KEY1, 0L)
    var goodsDetailBean: GoodsDetailBean? = null
    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "查询详情")
        mBind.click = ProxyClick()
        mBind.itemRv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 25, end = 25, dp = true)
            }.setup {
                addType<GoodsDetailBean.ServerBean> { R.layout.item_server }
                R.id.item.onClick {
                    val model = getModel<GoodsDetailBean.ServerBean>()
                    WebActivity.start(WebResponse(url = WebConfig.h5 + model.linkUrl, title = model.serverName))
                }
            }

        mBind.newsRv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 15, end = 15, dp = true)
                endVisible = true
            }.setup {
                addType<NewsBean> { R.layout.adapter_news }
                onClick(R.id.likeTv, R.id.shareWxTv,R.id.item) {
                    val model = getModel<NewsBean>()
                    when (it) {

                        R.id.likeTv ->
                            jumpByLogin(loginSuccessCall = false) {
                                scopeNetLife {
                                    Post<String>(Api.article_like) {
                                        param("articleId", model.articleId)
                                    }.await()
                                    model.isLike = if (model.isLike == 0) 1 else 0
                                    model.likeNum = if (model.isLike == 0) model.likeNum-- else model.likeNum++
                                    notifyItemChanged(modelPosition)
                                }
                            }

                        R.id.shareWxTv -> {
                            getBinding<AdapterNewsBinding>().item.shareToWx(this@SearchDetailActivity, type = 2, id = model.articleId)
                        }
                        R.id.item -> {
                            NewsDetailActivity.startAct(this@SearchDetailActivity, model.articleId)
                        }
                    }
                }
            }

        getData()
    }

    inner class ProxyClick {

        fun toManual() {
            goodsDetailBean?.let {
                WebConfig.jumpSmsWeb(it.goodsInfo.goodsId)
            }

        }


        fun more() {

            goodsDetailBean?.goodsInfo?.let {
                NewsMoreActivity.start(it.keyword)
            }

        }
    }

    private fun getData() {
        scopeDialog {
            goodsDetailBean = Post<GoodsDetailBean>(Api.goods_server) {
                param("goodsId", goodsId)
            }.await()
            goodsDetailBean?.let { bean ->
                mBind.model = bean.goodsInfo
                mBind.itemRv.models = bean.serverList
                mBind.newsRv.models = bean.articleList
                mBind.showNews = bean.articleList.isNotEmpty()
            }
        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}