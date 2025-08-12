package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import android.view.View
import androidx.recyclerview.widget.GridLayoutManager
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.app_use.bean.WebResponse
import com.app.base.app_use.ext.loadImage
import com.app.base.ext.dp2px
import com.app.base.ext.getColor
import com.app.base.ext.logE
import com.app.base.view.marquee.SimpleMF
import com.app.base.view.nine.ImageAdapter
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.layoutmanager.HoverGridLayoutManager
import com.drake.brv.utils.*
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.*
import com.manle.phone.android.yaodian.adapter.HomeBannerAdapter
import com.manle.phone.android.yaodian.bean.CommentBean
import com.manle.phone.android.yaodian.bean.GoodsBean
import com.manle.phone.android.yaodian.bean.WebConfig
import com.manle.phone.android.yaodian.bean.WebListUrlBean
import com.manle.phone.android.yaodian.databinding.AdapterCommentBinding
import com.manle.phone.android.yaodian.databinding.FragmentHomeBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.util.WxShareUtil.shareToWx
import com.manle.phone.android.yaodian.vm.HomeViewModel
import com.scwang.smart.refresh.layout.util.SmartUtil
import com.zhpan.indicator.enums.IndicatorStyle



class HomeFragment : BaseFragment<HomeViewModel, FragmentHomeBinding>(R.layout.fragment_home) {
    companion object {
        fun newInstance() = HomeFragment()
    }

    override fun initView(savedInstanceState: Bundle?) {
        mBind.click = ProxyClick()
        mBind.show = false
        mViewModel.updateApp()
        mBind.smv.setOnItemClickListener { mView, mData, mPosition ->
            ProxyClick().toSearch(mData as String)
        }
        //banner
        mBind.vpBanner
            .disallowParentInterceptDownEvent(true)
            .registerLifecycleObserver(lifecycle)
            .setIndicatorStyle(IndicatorStyle.CIRCLE)
            .setIndicatorSliderRadius(9)
            .setIndicatorSliderColor(R.color.color_999999.getColor(), R.color.color_0FC8AC.getColor())
            .setIndicatorMargin(0, 0, SmartUtil.dp2px(10f), SmartUtil.dp2px(5f))
            .setAdapter(HomeBannerAdapter())
            .setOnPageClickListener { _: View?, position: Int ->
                val bean = mViewModel.homeBean.value!!.bannerList[position]
                if (bean.type == 1) {
                    if (bean.linkUrl.startsWith("https://shiyao.yaojk.com.cn/shiyao/")) {
                        if (bean.linkUrl.contains("goods?")) {
                            val links = bean.linkUrl.split("=")
                            SearchDetailActivity.startAct(requireActivity(), links[1].toLong())

                        } else if (bean.linkUrl.contains("articleInfo?")) {
                            val links = bean.linkUrl.split("=")
                            NewsDetailActivity.startAct(requireActivity(), links[1])
                        }
                    } else {
                        WebActivity.start(WebResponse(url = bean.linkUrl, title = bean.name, isUserHtmlTitle = false))
                    }
                }


            }.create()

        mBind.ypRv.grid(spanCount = 2)
            .divider {
                setDivider(width = 15, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<GoodsBean> { R.layout.adapter_goods }
                R.id.item.onClick {
                    val model = getModel<GoodsBean>()
                    if (model.risk == 0) {
                        SearchDetailActivity.startAct(requireActivity(), model.goodsId)
                    } else {
                        WebConfig.jumpWeb(WebConfig.smRisk)
                    }
                }
            }
        //热门评论
        mBind.plRv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setMargin(start = 15, end = 15, dp = true)
            }.setup {
                addType<CommentBean> { R.layout.adapter_comment }
                onBind {
                    val bean = getModel<CommentBean>()
                    val ngv = getBinding<AdapterCommentBinding>().ngv
                    val imageAdapter = ImageAdapter(bean.pictures, onBindView = { imageView, item, position ->
                        imageView.loadImage(item)
                    })
                    imageAdapter.onItemViewClick = { imageView, item, position ->
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
                        R.id.likeTv ->
                            jumpByLogin(loginSuccessCall = false) {
                                mViewModel.setCommentLike(model.commentId) {
                                    model.isLike = if (model.isLike == 0) 1 else 0
                                    model.likeNum = if (model.isLike == 0) model.likeNum - 1 else model.likeNum + 1
                                    "${model.likeNum}".logE("-----当前点赞数-----")
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
            mViewModel.getHomeData()
            mViewModel.getCommentList()
        }
    }

    override fun lazyLoadData() {
        mBind.prl.refresh()

    }

    override fun createObserver() {
        super.createObserver()
        mViewModel.homeBean.observe(this) {
            mBind.show = true
            mBind.model = it
            val simpleMF = SimpleMF<String>(context)
            simpleMF.data = it.searchText.split(",")
            mBind.smv.setMarqueeFactory(simpleMF)
            mBind.smv.startFlipping()
            mBind.ypRv.models = it.goodsList
            mBind.vpBanner.refreshData(it.bannerList)
            mBind.smoothSl.setData(it.searchList)

        }
        mViewModel.refreshStop.observe(this) {
            if (it) {
                mBind.prl.finishRefresh()
            }
        }
        mViewModel.commeentList.observe(this) {
            mBind.plRv.models = it.commentList
        }

    }

    inner class ProxyClick {

        fun toSearch(data: String) {
            SearchActivity.startAct(data, isSearch = false)

        }

        fun toSearchEmpty() {
            SearchActivity.startAct()
        }


        fun toScan() {
            ScanActivity.startAct()
        }


        fun toTakePhoto() {
            ScanActivity.startAct(type = 1)

        }


        fun toScanReal() {
            ScanActivity.startAct(jumpType = 1)
        }


        fun toRghc() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.rghc)
            }

        }

        fun toJgcx() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.jgcx)
            }

        }


        fun toWysj() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.wysj)
            }
        }

        fun toWybj() {
            jumpByLogin {
                WebConfig.jumpWeb(WebConfig.wybj)
            }

        }


        fun toMore() {
            sendEvent(1, AppConfig.SWITCH_MAIN_TAB)
//            MoreCommentActivity.startAct()

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