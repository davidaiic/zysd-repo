package com.app.base.lifecycle

import android.app.Activity
import android.app.Application
import android.os.Bundle
import com.app.base.ext.logD



class KtxLifeCycleCallBack : Application.ActivityLifecycleCallbacks {

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        KtxActivityManger.pushActivity(activity)
    }

    override fun onActivityStarted(activity: Activity) {

    }

    override fun onActivityResumed(activity: Activity) {

    }

    override fun onActivityPaused(activity: Activity) {
    }


    override fun onActivityDestroyed(activity: Activity) {
        KtxActivityManger.popActivity(activity)
    }


    override fun onActivityStopped(activity: Activity) {

    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {

    }


}