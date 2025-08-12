package com.app.base.net.manager

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.ConnectivityManager



class NetworkStateReceive : BroadcastReceiver() {
    var isInit = true
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ConnectivityManager.CONNECTIVITY_ACTION) {
            if(!isInit){
                if (!NetworkUtil.isNetworkAvailable(context)) {
                    NetworkStateManager.instance.mNetworkStateCallback.value?.let {
                        if(it.isHaveNet){
                            NetworkStateManager.instance.mNetworkStateCallback.postValue(NetState(isHaveNet = false))
                        }
                        return
                    }
                    NetworkStateManager.instance.mNetworkStateCallback.postValue(NetState(isHaveNet = false))
                }else{
                    NetworkStateManager.instance.mNetworkStateCallback.value?.let {
                        if(!it.isHaveNet){
                            NetworkStateManager.instance.mNetworkStateCallback.postValue(NetState(isHaveNet = true))
                        }
                        return
                    }
                    NetworkStateManager.instance.mNetworkStateCallback.postValue(NetState(isHaveNet = true))
                }
            }
            isInit = false
        }

    }
}