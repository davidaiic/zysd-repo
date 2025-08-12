package com.app.base.view.dialog.extensions

import android.animation.Animator

fun Animator.addAnimatorListenerEx(listener: AnimatorListenerEx.() -> Unit): Animator {
    val animatorListenerEx = AnimatorListenerEx()
    this.addListener(animatorListenerEx)
    animatorListenerEx.listener()
    return this
}

class AnimatorListenerEx : Animator.AnimatorListener {

    private var animatorStart: ((animator: Animator?) -> Unit)? = null
    private var animatorEnd: ((animator: Animator?) -> Unit)? = null
    private var animatorRepeat: ((animator: Animator?) -> Unit)? = null
    private var animatorCancel: ((animator: Animator?) -> Unit)? = null

    fun onAnimatorStart(listener: (animator: Animator?) -> Unit): AnimatorListenerEx {
        animatorStart = listener
        return this
    }

    fun onAnimatorEnd(listener: (animator: Animator?) -> Unit): AnimatorListenerEx {
        animatorEnd = listener
        return this
    }

    fun onAnimatorRepeat(listener: (animator: Animator?) -> Unit): AnimatorListenerEx {
        animatorRepeat = listener
        return this
    }

    fun onAnimatorCancel(listener: (animator: Animator?) -> Unit): AnimatorListenerEx {
        animatorCancel = listener
        return this
    }

    override fun onAnimationStart(animation: Animator) {
        animatorStart?.invoke(animation)
    }

    override fun onAnimationEnd(animation: Animator) {
        animatorEnd?.invoke(animation)
    }

    override fun onAnimationCancel(animation: Animator) {
        animatorCancel?.invoke(animation)
    }

    override fun onAnimationRepeat(animation: Animator) {
        animatorRepeat?.invoke(animation)
    }




}