package com.vector.update_app.v2.callback

import com.vector.update_app.v2.builder.BuilderManager


interface LifecycleListener {
    fun isDisposed() =
            BuilderManager.getDownloadBuilder() == null

}