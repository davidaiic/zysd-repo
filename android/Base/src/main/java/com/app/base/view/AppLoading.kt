package com.app.base.view

import android.content.Context
import android.view.animation.Animation
import android.view.animation.AnimationUtils
import android.view.animation.LinearInterpolator
import android.widget.ImageView
import com.app.base.R
import com.lxj.xpopup.core.CenterPopupView



class AppLoading(context: Context) : CenterPopupView(context) {

    private var ivLoading: ImageView? = null
    private val mAnimation: Animation = AnimationUtils.loadAnimation(context, R.anim.image_rotate)
    private val linearInterpolator = LinearInterpolator()
    override fun getImplLayoutId(): Int {
        return R.layout.layout_progress_dialog
    }

    override fun onCreate() {
        super.onCreate()
        ivLoading = findViewById(R.id.ivLoading)
        popupImplView.elevation = 10f
        mAnimation.interpolator = linearInterpolator
        ivLoading?.startAnimation(mAnimation)
    }



    override fun onDismiss() {
        super.onDismiss()
        mAnimation.cancel()
    }



}