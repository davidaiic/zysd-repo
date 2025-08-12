package com.manle.phone.android.yaodian.vm

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.scopeNetLife
import com.app.base.AppConfig
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.models
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.activity.SearchActivity
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CacheUtil
import kotlin.time.measureTimedValue


class SearchViewModel : BaseViewModel() {



    val searchText = MutableLiveData<String>("")


    val historyList = MutableLiveData(mutableListOf<String>())


    val currentItemLiveData = MutableLiveData<Int>()


    val refreshList = MutableLiveData<Boolean>()


    var focus = false


    var type: Int = 0


    val hotList = MutableLiveData(listOf<HotSearchBean.Word>())

    var isFirst= false


    fun clearSearchHistory() {
        if (type == 0) CacheUtil.setSearchHistoryList(mutableListOf()) else CacheUtil.setSearchHistoryList(mutableListOf())
        getSearchHistory()
    }


    fun getSearchHistory() {
        historyList.value = if (type == 0) CacheUtil.getSearchHistoryList() else CacheUtil.getSearchNewsHistoryList()
    }



    fun addSearchHistory() {
        searchText.value?.let {
            if (it.isNullOrEmpty()) return@let
            historyList.value?.let { list ->
                if (!list.contains(it)) {
                    //集合没有
                    if (list.size > 8) {
                        // 大于8 就删除最后一个，也就是最早的一个
                        list.removeAt(list.size - 1)
                    }
                    //每次都添加到第一个
                    list.add(0, it)
                }
                historyList.postValue(list)
                if (type == 0) CacheUtil.setSearchHistoryList(list) else CacheUtil.setSearchNewsHistoryList(list)

            }
        }
    }

    fun getHotWordList(){
        scopeNetLife {
            hotList.value = Post<HotSearchBean>(Api.hot_word) {
                param("type", type)
            }.await().wordList
        }
    }


}