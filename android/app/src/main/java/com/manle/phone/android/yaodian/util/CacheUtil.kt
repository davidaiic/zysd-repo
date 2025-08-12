package com.manle.phone.android.yaodian.util

import com.app.base.AppConfig.APP_NAME
import com.app.base.AppConfig.HAVE_AGREE
import com.app.base.AppConfig.IS_LOGIN
import com.app.base.AppConfig.SEARCH_HISTORY
import com.app.base.AppConfig.SEARCH_NEWS_HISTORY
import com.app.base.AppConfig.TOKEN
import com.app.base.AppConfig.USER_ID
import com.app.base.AppConfig.USER_INFO
import com.drake.net.NetConfig
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.manle.phone.android.yaodian.bean.TokenBean
import com.manle.phone.android.yaodian.bean.UserBean
import com.manle.phone.android.yaodian.net.NetUseConfig

import com.tencent.mmkv.MMKV
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json


object CacheUtil {




    fun setTokenBean(tokenBean: TokenBean) {
        MMKV.mmkvWithID(APP_NAME).encode(TOKEN, Gson().toJson(tokenBean))
    }

    fun getTokenBean(): TokenBean {
        val type = object : TypeToken<TokenBean>() {}.type
        return MMKV.mmkvWithID(APP_NAME).decodeString(TOKEN, "").let {
            if (it!!.isEmpty()) TokenBean()
            else Gson().fromJson(it, type)
        }
    }


    fun isLogin(): Boolean = MMKV.mmkvWithID(APP_NAME).decodeBool(IS_LOGIN, false)


    fun setIsLogin(isLogin: Boolean) = MMKV.mmkvWithID(APP_NAME).encode(IS_LOGIN, isLogin)



    fun loginOut() {
        setIsLogin(false)
        NetUseConfig.changUser()
    }


    fun loginIn(tokenBean: TokenBean) {
        NetUseConfig.changUser(tokenBean.token, tokenBean.uid, true)
        setIsLogin(true)
        setTokenBean(tokenBean)

    }



    fun setSearchHistoryList(agreementList: MutableList<String>) {
        MMKV.mmkvWithID(APP_NAME).encode(SEARCH_HISTORY, Gson().toJson(agreementList))
    }

    fun getSearchHistoryList(): MutableList<String> {
        val type = object : TypeToken<MutableList<String>>() {}.type
        return MMKV.mmkvWithID(APP_NAME).decodeString(SEARCH_HISTORY, "").let {
            if (it!!.isEmpty()) mutableListOf()
            else Gson().fromJson(it, type)
        }
    }

    fun setSearchNewsHistoryList(agreementList: MutableList<String>) {
        MMKV.mmkvWithID(APP_NAME).encode(SEARCH_NEWS_HISTORY, Gson().toJson(agreementList))
    }

    fun getSearchNewsHistoryList(): MutableList<String> {
        val type = object : TypeToken<MutableList<String>>() {}.type
        return MMKV.mmkvWithID(APP_NAME).decodeString(SEARCH_NEWS_HISTORY, "").let {
            if (it!!.isEmpty()) mutableListOf()
            else Gson().fromJson(it, type)
        }
    }


    fun setUser(userBean: UserBean) {
        MMKV.mmkvWithID(APP_NAME).encode(USER_INFO, Json.encodeToString(userBean))
    }

    fun getUser(): UserBean? {
        return MMKV.mmkvWithID(APP_NAME).decodeString(USER_INFO, "").let {
            if (it!!.isEmpty()) null
            else Json.decodeFromString(UserBean.serializer(),it)
        }
    }


    fun haveAgree(): Boolean = MMKV.mmkvWithID(APP_NAME).decodeBool(HAVE_AGREE, false)


    fun setAgree(isAgree: Boolean) = MMKV.mmkvWithID(APP_NAME).encode(HAVE_AGREE, isAgree)


}
