package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.scopeNetLife
import com.app.base.AppConfig
import com.app.base.activity.BaseFragment
import com.app.base.ext.createDrawable
import com.app.base.ext.dp2fpx
import com.app.base.ext.dp2px
import com.app.base.ext.getColor
import com.app.base.lifecycle.appContext
import com.app.base.utils.extraFrag
import com.app.base.utils.newInstanceFragment
import com.app.base.view.FlexboxMaxLinesLayoutManager
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.utils.divider
import com.drake.brv.utils.grid
import com.drake.brv.utils.models
import com.drake.brv.utils.setup
import com.drake.net.Post
import com.drake.net.utils.scopeNetLife
import com.google.android.flexbox.FlexboxLayoutManager
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.HotSearchBean
import com.manle.phone.android.yaodian.databinding.AdapterSearchHotBinding
import com.manle.phone.android.yaodian.databinding.FragmentSearchDefaultBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.vm.SearchViewModel



class SearchDefaultFragment : BaseFragment<BaseViewModel, FragmentSearchDefaultBinding>(layoutId = R.layout.fragment_search_default) {
    private val activityVm by activityViewModels<SearchViewModel>()

    companion object {
        fun newInstance(activity: FragmentActivity, type: Int) = activity.newInstanceFragment<SearchDefaultFragment>(AppConfig.KEY1 to type)
    }

    val type by extraFrag(AppConfig.KEY1, 0)

    override fun initView(savedInstanceState: Bundle?) {
        activityVm.type = type
        mBind.vm = activityVm
        mBind.click = ProxyClick()

        mBind.historyFlexBoxRv.layoutManager = FlexboxMaxLinesLayoutManager(requireContext(), 2)
        mBind.historyFlexBoxRv.setup {
            addType<String>(R.layout.adapter_search_history)
            R.id.item.onClick {
                activityVm.searchText.value = getModel<String>()
                //切换到搜索页面
                activityVm.currentItemLiveData.value = if (type == 0) 2 else 1


            }
        }

        mBind.hotFlexBoxRv.grid(spanCount = 2)
            .divider {
                setDivider(width = 20, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<HotSearchBean.Word>(R.layout.adapter_search_hot)
                onBind {
                    val binding = getBinding<AdapterSearchHotBinding>()
                    binding.sortTv.background = when (modelPosition) {
                        1 -> createDrawable(R.color.color_FF9330.getColor(), radius = dp2fpx(30f))
                        2 -> createDrawable(R.color.color_FDD986.getColor(), radius = dp2fpx(30f))
                        3 -> createDrawable(R.color.color_999999.getColor(), radius = dp2fpx(30f))
                        else -> createDrawable(R.color.color_FC511E.getColor(), radius = dp2fpx(30f))
                    }
                    binding.sortTv.text = "${modelPosition + 1}"
                }
                R.id.item.onClick {
                    activityVm.searchText.value = getModel<HotSearchBean.Word>().word
                    //切换到搜索页面
                    activityVm.currentItemLiveData.value = if (type == 0) 2 else 1
                }
            }
        activityVm.getSearchHistory()
        activityVm.getHotWordList()

    }

    override fun lazyLoadData() {

    }

    override fun createObserver() {
        super.createObserver()
        activityVm.historyList.observe(viewLifecycleOwner) {
            mBind.historyFlexBoxRv.models = it
        }
        activityVm.hotList.observe(this){
            mBind.hotFlexBoxRv.models=it
        }

    }

    inner class ProxyClick {

        fun deleteHistory() {
            activityVm.clearSearchHistory()
        }
    }
}