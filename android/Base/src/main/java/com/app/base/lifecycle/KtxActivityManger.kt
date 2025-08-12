package com.app.base.lifecycle

import android.app.Activity
import androidx.fragment.app.FragmentActivity
import java.util.*


object KtxActivityManger {
    private val mActivityList = LinkedList<Activity>()

    val currentActivity: FragmentActivity?
        get() =
            if (mActivityList.isEmpty()) null
            else mActivityList.last as FragmentActivity


    fun pushActivity(activity: Activity) {

        if (mActivityList.contains(activity)) {
            if (mActivityList.last != activity) {
                mActivityList.remove(activity)
                mActivityList.add(activity)
            }
        } else {
            mActivityList.add(activity)
        }
    }


    fun popActivity(activity: Activity) {
        mActivityList.remove(activity)
    }


    fun finishCurrentActivity() {
        currentActivity?.finish()
    }


    fun finishActivity(activity: Activity) {
        mActivityList.remove(activity)
        activity.finish()
    }


    fun finishActivity(clazz: Class<*>) {
        for (activity in mActivityList)
            if (activity.javaClass == clazz){
                mActivityList.remove(activity)
                activity.finish()
            }

    }


    fun finishAllActivity() {
        for (activity in mActivityList)
            activity.finish()
    }


    fun finishOtherActivity(cls: Class<*>) {
        val it: MutableIterator<Activity> = mActivityList.iterator()
        while (it.hasNext()) {
            val activityReference = it.next()
            if (activityReference.javaClass != cls) {
                it.remove()
                activityReference.finish()
            }
        }
    }

}