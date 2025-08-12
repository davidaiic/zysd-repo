package com.app.base.utils

import android.app.Activity
import android.app.Application
import android.content.ComponentCallbacks
import android.content.Context
import android.content.res.Configuration


private var myDensity = 0.0f
private var myScaledDensity = 0.0f


object ScreenFixConfig {

    fun init(application: Application, maxDp: Int = 375, fitDri: Dir = Dir.HORIZONTAL) {
        if (maxDp == 0) {
            return
        }

        val displayMetrics = application.resources.displayMetrics
        if (myDensity == 0F) {
            myDensity = displayMetrics.density
            myScaledDensity = displayMetrics.scaledDensity
            application.registerComponentCallbacks(object : ComponentCallbacks {
                override fun onConfigurationChanged(p0: Configuration) {
                    if (p0.fontScale > 0) {
                        myScaledDensity = application.resources.displayMetrics.scaledDensity
                    }
                }

                override fun onLowMemory() {}
            })
        }
        val targetDensity = if (fitDri == Dir.HORIZONTAL) {
            (displayMetrics.widthPixels.toFloat()) / maxDp
        } else {
            (displayMetrics.heightPixels.toFloat()) / maxDp
        }

        val targetScaledDensity = targetDensity * (myScaledDensity / myDensity)
        val targetDensityDpi = (160 * targetDensity).toInt()
        displayMetrics.density = targetDensity
        displayMetrics.scaledDensity = targetScaledDensity
        displayMetrics.densityDpi = targetDensityDpi //???
        val activityDisplayMetrics = application.resources.displayMetrics
        activityDisplayMetrics.densityDpi = targetDensityDpi
        activityDisplayMetrics.density = targetDensity
        activityDisplayMetrics.scaledDensity = targetScaledDensity
    }


    enum class Dir {
        HORIZONTAL, VERTICAL
    }
}