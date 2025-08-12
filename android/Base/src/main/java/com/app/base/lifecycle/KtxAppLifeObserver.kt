package com.app.base.lifecycle

import androidx.lifecycle.*



object KtxAppLifeObserver : LifecycleEventObserver {

    var isForeground = MutableLiveData<Boolean>()


    override fun onStateChanged(source: LifecycleOwner, event: Lifecycle.Event) {
        when (event) {
            Lifecycle.Event.ON_START -> {
                isForeground.value = true
            }
            Lifecycle.Event.ON_STOP -> {
                isForeground.value = false
            }
            Lifecycle.Event.ON_DESTROY -> {

            }
            else -> {

            }
        }
    }

}