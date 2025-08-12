package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.ext.loadImage
import com.app.base.app_use.ext.loadRoundedCornersImage
import com.app.base.ext.dp2fpx
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
import com.manle.phone.android.yaodian.bean.CommentDetailBean
import com.manle.phone.android.yaodian.databinding.ActivityCommentDetailBinding
import com.manle.phone.android.yaodian.databinding.AdapterCommentBinding
import com.manle.phone.android.yaodian.databinding.AdapterCommentDetailBinding
import com.manle.phone.android.yaodian.pop.CommentPop
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx
import com.manle.phone.android.yaodian.vm.DetailViewModel


class CommentDetailActivity : BaseActivity<DetailViewModel, ActivityCommentDetailBinding>(layoutId = R.layout.activity_comment_detail) {
    companion object {
        fun startAct(activity: FragmentActivity, commentId: String) {
            activity.startActivity<CommentDetailActivity>(AppConfig.KEY1 to commentId)
        }
    }

    val commentId by extraAct(AppConfig.KEY1, "")
    var commentPop: CommentPop? = null
    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "帖子详情")
        mBind.click = ProxyClick()
//        mBind.imgRv.linear()
//            .divider {
//                setDivider(width = 20)
//            }.setup { addType<String> { R.layout.adapter_comment_img } }
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
                    imageAdapter.onItemViewClick = { imageView, _, position ->
                        CommUtils.showImage(context, ngv, imageView, position, bean.pictures)
                    }
                    getBinding<AdapterCommentDetailBinding>().ngv.adapter = imageAdapter

                }
                R.id.likeTv.onClick {
                    jumpByLogin(loginSuccessCall = false) {
                        val model = getModel<CommentBean>()
                        scopeNetLife {
                            Post<String>(Api.comment_like) {
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
        receiveEvent<Boolean>(AppConfig.PUBLISH_SUCCESS) {
            mBind.prl.refresh()
            commentPop = null
        }
    }

    inner class ProxyClick {

        fun comment() {
            jumpByLogin {
                if (commentPop == null) {
                    commentPop = CommentPop(context, 1, commentId)
                }
                XPopup.Builder(context)
                    .autoOpenSoftInput(true)
                    .autoFocusEditText(true)
                    .asCustom(commentPop)
                    .show()
            }

        }

        fun share() {
            mBind.nsv.shareToWx(this@CommentDetailActivity, type = 1, id = commentId)
        }
    }

    private fun getData(page: Int) {
        scopeNetLife {
            val model = Post<CommentDetailBean>(Api.comment_detail) {
                param("commentId", commentId)
                param("page", page)
            }.await()
            if (mBind.prl.index == 1) {
                mBind.data = model.info

                val imageAdapter = ImageAdapter(model.info.pictures, onBindView = { imageView, item, _ ->
                    imageView.loadRoundedCornersImage(url = item, round = dp2fpx(2f))
                })
                imageAdapter.onItemViewClick = { imageView, _, position ->
                    CommUtils.showImage(context, mBind.ngv, imageView, position, model.info.pictures)
                }
                mBind.ngv.adapter = imageAdapter
//                mBind.imgRv.models = model.info.pictures
                mBind.haveComment = model.commentList.isNotEmpty()
            }

            mBind.prl.addData(model.commentList, mBind.commentRv.bindingAdapter) {
                model.commentList.size == 20
            }
        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }

}