package com.manle.phone.android.yaodian.activity

import android.os.Build
import android.os.Bundle
import android.webkit.WebSettings
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.ext.loadImage
import com.app.base.ext.dateSimpleFormat
import com.app.base.ext.logE
import com.app.base.utils.extraAct
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.view.nine.ImageAdapter
import com.drake.brv.utils.*
import com.drake.channel.receiveEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.CommentBean
import com.manle.phone.android.yaodian.bean.NewsDetailBean
import com.manle.phone.android.yaodian.databinding.ActivityNewsDetailBinding
import com.manle.phone.android.yaodian.databinding.AdapterCommentDetailBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.pop.CommentPop
import com.manle.phone.android.yaodian.util.CommUtils
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx
import com.manle.phone.android.yaodian.vm.DetailViewModel
import java.util.Date


class NewsDetailActivity : BaseActivity<DetailViewModel, ActivityNewsDetailBinding>(layoutId = R.layout.activity_news_detail) {
    companion object {
        fun startAct(activity: FragmentActivity, articleId: String) {
            activity.startActivity<NewsDetailActivity>(AppConfig.KEY1 to articleId)
        }
    }

    //资讯id
    private val articleId by extraAct(AppConfig.KEY1, "")
    var commentPop: CommentPop? = null

    override fun initView(savedInstanceState: Bundle?) {

        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "资讯详情")
        mBind.click = ProxyClick()
        mBind.imgRv.linear()
            .divider {
                setDivider(width = 20)
            }.setup { addType<String> { R.layout.adapter_comment_img } }
        mBind.commentRv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 15, end = 15, dp = true)
            }.setup {
                addType<CommentBean> { R.layout.adapter_comment_detail }
                onBind {
                    val bean = getModel<CommentBean>()
                    val ngv = getBinding<AdapterCommentDetailBinding>().ngv
                    val imageAdapter = ImageAdapter(bean.pictures, onBindView = { imageView, item, position ->
                        imageView.loadImage(item)
                    })
                    imageAdapter.onItemViewClick = { imageView, item, position ->
                        CommUtils.showImage(context, ngv, imageView, position, bean.pictures)
                    }
                    getBinding<AdapterCommentDetailBinding>().ngv.adapter = imageAdapter

                }
                R.id.likeTv.onClick {
                    jumpByLogin {
                        val model = getModel<CommentBean>()
                        scopeNetLife {
                            Post<String>(Api.article_comment_like) {
                                param("commentId", model.commentId)
                            }.await()
                            model.isLike = if (model.isLike == 0) 1 else 0
                            model.likeNum = if (model.isLike == 0) model.likeNum - 1 else model.likeNum + 1
                            "${model.likeNum}".logE("-----当前点赞数-----")
                            this@setup.notifyItemChanged(modelPosition)
                        }
                    }

                }
            }
        mBind.prl.onRefresh {
            getData(index)
        }.refresh()

    }

    override fun createObserver() {
        super.createObserver()
        receiveEvent<Boolean>(AppConfig.NEW_COMMENT_SUCCESS) {
            commentPop = null
            mBind.prl.refresh()
        }
    }

    inner class ProxyClick {

        fun comment() {
            jumpByLogin {
                if (commentPop == null) {
                    commentPop = CommentPop(context, 2, articleId)
                }
                XPopup.Builder(context)
                    .autoOpenSoftInput(true)
                    .autoFocusEditText(true)
                    .asCustom(commentPop)
                    .show()
            }

        }


        fun share() {
            mBind.nsv.shareToWx(this@NewsDetailActivity, type = 2, id = articleId)
        }
    }


    private fun getData(page: Int) {
        scopeNetLife {
            val model = Post<NewsDetailBean>(Api.article_detail) {
                param("articleId", articleId)
                param("page", page)
            }.await()
            if (mBind.prl.index == 1) {
                mBind.data = model.info
                mBind.imgRv.models = model.info.pictures
                mBind.haveComment = model.commentList.isNotEmpty()
                mBind.webView.settings.apply {
                    setSupportZoom(true)
                    useWideViewPort = true
                    loadWithOverviewMode = true
                }
                mBind.webView.loadDataWithBaseURL(null, formatHtmlData(model.info.content), "text/html", "utf-8", null) //加载html数据
            }
            mBind.prl.addData(model.commentList, mBind.commentRv.bindingAdapter) {
                model.commentList.size == 20
            }
        }
    }

    private fun formatHtmlData(bodyHTML: String): String {
        val head = ("<head>"
                + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"> "
                + "<style>img{max-width: 100%; width:100%; height:auto;}</style>"
                + "</head>")
        return "<html>$head<body>$bodyHTML</body></html>"
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }


}