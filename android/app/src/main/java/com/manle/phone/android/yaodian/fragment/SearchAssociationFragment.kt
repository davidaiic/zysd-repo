package com.manle.phone.android.yaodian.fragment

import android.os.Bundle
import android.text.TextUtils
import androidx.fragment.app.activityViewModels
import androidx.lifecycle.scopeNetLife
import com.app.base.activity.BaseFragment
import com.app.base.ext.getColor
import com.app.base.ext.gone
import com.app.base.ext.logE
import com.app.base.ext.visible
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.linear
import com.drake.brv.utils.setup
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.AssociateWordBean
import com.manle.phone.android.yaodian.bean.AssociationBean
import com.manle.phone.android.yaodian.databinding.AdapterAssociationBinding
import com.manle.phone.android.yaodian.databinding.FragmentSearchAssociationBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils.setMatcherText
import com.manle.phone.android.yaodian.vm.SearchViewModel



class SearchAssociationFragment : BaseFragment<BaseViewModel, FragmentSearchAssociationBinding>(layoutId = R.layout.fragment_search_association) {
    private val activityVm by activityViewModels<SearchViewModel>()

    companion object {
        fun newInstance() = SearchAssociationFragment()
    }

    override fun initView(savedInstanceState: Bundle?) {


        mBind.searchKeyRv.linear()
            .divider {
                setDivider(width = 1, dp = true)
                setColor(R.color.color_F2F3F5.getColor())
                setMargin(start = 15, end = 15, dp = true)
            }.setup {
                addType<AssociationBean>(R.layout.adapter_association)
                onBind {
                    val data = getModel<AssociationBean>()
                    if (!TextUtils.isEmpty(data.word) && !TextUtils.isEmpty(activityVm.searchText.value)) {
                        val keyList: MutableList<String> = mutableListOf()
                        for (j in 0 until activityVm.searchText.value!!.length) {
                            keyList.add(activityVm.searchText.value!!.substring(j, j + 1))
                        }
                        getBinding<AdapterAssociationBinding>().tvSearchResult.text = setMatcherText(context, data.word, R.style.SearchStyle, *keyList.toTypedArray())
                    } else {
                        getBinding<AdapterAssociationBinding>().tvSearchResult.text = data.word
                    }
                }
                R.id.item.onClick {
                    activityVm.searchText.value = getModel<AssociationBean>().word
                    activityVm.currentItemLiveData.value = 2
                }
            }

        mBind.prl.onRefresh {
            activityVm.searchText.value?.let { text ->
                scopeNetLife {
                    val wordList = Post<AssociateWordBean>(Api.home_associate_word) {
                        param("keyword", text)
                        param("page", index)
                    }.await().wordList
                    mBind.prl.addData(wordList, mBind.searchKeyRv.bindingAdapter) {
                        wordList.size == 20
                    }
                }
            }
        }
    }

    override fun lazyLoadData() {
    }

    override fun createObserver() {
        super.createObserver()

        activityVm.searchText.observe(this) {
            if(activityVm.isFirst){
                activityVm.isFirst=false
                return@observe
            }
            if (activityVm.currentItemLiveData.value == 2) {
                return@observe
            }
            if (it.isNullOrEmpty()) {
                activityVm.currentItemLiveData.value = 0
                return@observe
            }
            if (activityVm.currentItemLiveData.value != 1) {
                activityVm.currentItemLiveData.value = 1
            }
            mBind.prl.refresh()
        }


    }
}