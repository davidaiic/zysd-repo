package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import android.widget.TextView
import androidx.fragment.app.activityViewModels
import androidx.recyclerview.widget.RecyclerView
import com.app.base.activity.BaseFragment
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.utils.*
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.SearchDetailActivity
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.databinding.AdapterGoodsBinding
import com.manle.phone.android.yaodian.databinding.FragmentSearchListBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import com.manle.phone.android.yaodian.vm.SearchViewModel


class SearchListFragment : BaseFragment<BaseViewModel, FragmentSearchListBinding>(layoutId = R.layout.fragment_search_list) {
    private val activityVm by activityViewModels<SearchViewModel>()

    companion object {
        fun newInstance() = SearchListFragment()

    }

    lateinit var searchEmptyRv: RecyclerView

    override fun initView(savedInstanceState: Bundle?) {

        setAdapter(mBind.searchRv)

        mBind.prl.onRefresh {

            scopeNetLife {
                activityVm.searchText.value?.let {
                    if (index == 1) {
                        activityVm.addSearchHistory()
                    }
                    val data = Post<GoodsListBean>(Api.home_search) {
                        param("keyword", it)
                        param("page", index)
                    }.await()
                    //搜索到的菜谱
                    mBind.prl.addData(data = data.goodsList, mBind.searchRv.bindingAdapter) {
                        data.goodsList.size == 20
                    }
                }
            }

        }
        mBind.prl.stateLayout?.onEmpty {
            searchEmptyRv = findViewById(R.id.searchEmptyRv)
            findViewById<TextView>(R.id.nowPullImgTv).setOnClickListener {
                WebConfig.jumpWeb(WebConfig.zpcx)
            }
            setAdapter(searchEmptyRv)
            scopeDialog {
                searchEmptyRv.models = Post<HomeBean>(Api.HOMEINDEX).await().goodsList
            }

        }
    }


    private fun setAdapter(rv: RecyclerView) {
        rv.grid(spanCount = 2)
            .divider {
                setDivider(width = 11, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<GoodsBean>(R.layout.adapter_goods)
                onCreate {
                    getBinding<AdapterGoodsBinding>()
                        .tagRv
                        .linear(orientation = RecyclerView.HORIZONTAL)
                        .divider { setDivider(width = 7, dp = true) }
                        .setup {
                            addType<TagBean> { R.layout.adapter_tag }
                        }
                }
                onBind {
                    val tags = mutableListOf<TagBean>()
                    val model = getModel<GoodsBean>()
                    if (model.clinicalStage.isNotEmpty()) {
                        tags.add(TagBean(type = 1, model.clinicalStage))
                    }
                    if (model.marketTag.isNotEmpty()) {
                        tags.add(TagBean(type = 2, model.marketTag))
                    }
                    if (model.medicalTag.isNotEmpty()) {
                        tags.add(TagBean(type = 3, model.medicalTag))
                    }
                    getBinding<AdapterGoodsBinding>().tagRv.models = tags

                }
                R.id.item.onClick {
                    requireActivity().jumpByLogin{
                        val model = getModel<GoodsBean>()
                        if (model.risk == 0) {
                            SearchDetailActivity.startAct(requireActivity(), model.goodsId)
                        } else {
                            WebConfig.jumpWeb(WebConfig.smRisk)
                        }
                    }

                }
            }
    }

    override fun lazyLoadData() {

    }

    override fun createObserver() {
        super.createObserver()

        activityVm.refreshList.observe(this) {
            mBind.prl.autoRefresh()
        }
    }
}


