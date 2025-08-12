package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.app_use.ext.loadImage
import com.app.base.app_use.ext.loadRoundedCornersImage
import com.app.base.ext.dp2fpx
import com.app.base.view.nine.ImageAdapter
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.linear
import com.drake.brv.utils.setup
import com.drake.channel.receiveEvent
import com.drake.channel.receiveEventLive
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.CommentDetailActivity
import com.manle.phone.android.yaodian.bean.CommentBean
import com.manle.phone.android.yaodian.bean.CommentListBean
import com.manle.phone.android.yaodian.databinding.AdapterCommentBinding
import com.manle.phone.android.yaodian.databinding.FragmentCommentBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CommUtils
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx


class CommentFragment : BaseFragment<BaseViewModel, FragmentCommentBinding>(R.layout.fragment_comment) {
    companion object {
        fun newInstance() = CommentFragment()
    }

    var sortId: String = ""
    var labelId: String = ""
    var keyword: String = ""
    override fun initView(savedInstanceState: Bundle?) {
        mBind.rv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 15, end = 15, dp = true)
            }.setup {
                addType<CommentBean> { R.layout.adapter_comment }
                onBind {
                    val ngv = getBinding<AdapterCommentBinding>().ngv
                    val bean = getModel<CommentBean>()
                    val imageAdapter = ImageAdapter(bean.pictures, onBindView = { imageView, item, _ ->
                        imageView.loadRoundedCornersImage(url = item, round = dp2fpx(2f))
                    })
                    imageAdapter.onItemViewClick = { imageView, _, position ->
                        CommUtils.showImage(context, ngv, imageView, position, bean.pictures)
                    }
                    ngv.adapter = imageAdapter

                }
                onClick(R.id.item, R.id.likeTv, R.id.commentTv, R.id.shareIv) {
                    val model = getModel<CommentBean>()
                    when (it) {
                        R.id.item -> {
                            CommentDetailActivity.startAct(requireActivity(), model.commentId)
                        }
                        R.id.likeTv -> setCommentLike(model.commentId) {
                            jumpByLogin(loginSuccessCall = false) {
                                model.isLike = if (model.isLike == 0) 1 else 0
                                model.likeNum = if (model.isLike == 0) model.likeNum - 1 else model.likeNum + 1
                                this@setup.notifyItemChanged(modelPosition)
                            }

                        }
                        R.id.commentTv -> {
                            CommentDetailActivity.startAct(requireActivity(), model.commentId)

                        }
                        R.id.shareIv -> {
                            getBinding<AdapterCommentBinding>().item.shareToWx(requireActivity(), type = 1, id = model.commentId)
                        }

                    }
                }
            }
        mBind.prl.onRefresh {
            getData(index)
        }

    }

    override fun lazyLoadData() {
        mBind.prl.autoRefresh()
    }

    override fun createObserver() {
        super.createObserver()
        receiveEvent<Boolean>(AppConfig.PUBLISH_SUCCESS) {
            mBind.prl.refresh()
        }
    }


    private fun setCommentLike(commentId: String, callBack: () -> Unit = {}) = scopeNetLife {
        Post<String>(Api.comment_like) {
            param("commentId", commentId)
        }.await()
        callBack.invoke()
    }


    private fun getData(page: Int) {
        scopeNetLife {
            val comment = Post<CommentListBean>(Api.COMMENT_LIST) {
                param("type", 0)
                param("page", page)
                param("keyword", keyword)
            }.await()
            mBind.prl.addData(comment.commentList, mBind.rv.bindingAdapter) {
                comment.commentList.size == 20
            }
        }
    }


    fun setSort(sortId: String, labelId: String,key:String) {
        this.sortId = sortId
        this.labelId = labelId
        this.keyword=key
        mBind.prl.refresh()
    }


}