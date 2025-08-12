package com.app.base.utils

import android.app.Activity
import android.graphics.Rect
import android.view.View
import android.view.ViewTreeObserver.OnGlobalLayoutListener


class SoftKeyBoardListener(activity: Activity) {
    private val rootView: View = activity.window.decorView
    var rootViewVisibleHeight = 0
    private var onSoftKeyBoardChangeListener: OnSoftKeyBoardChangeListener? = null
    private fun setOnSoftKeyBoardChangeListener(onSoftKeyBoardChangeListener: OnSoftKeyBoardChangeListener) {
        this.onSoftKeyBoardChangeListener = onSoftKeyBoardChangeListener
    }

    interface OnSoftKeyBoardChangeListener {
        fun keyBoardShow(height: Int)
        fun keyBoardHide(height: Int)
    }

    fun setListener(onSoftKeyBoardChangeListener: OnSoftKeyBoardChangeListener) {
        setOnSoftKeyBoardChangeListener(onSoftKeyBoardChangeListener)
    }

    init {

        rootView.viewTreeObserver.addOnGlobalLayoutListener(OnGlobalLayoutListener {
            val r = Rect()
            rootView.getWindowVisibleDisplayFrame(r)
            val visibleHeight: Int = r.height()
            if (rootViewVisibleHeight == 0) {
                rootViewVisibleHeight = visibleHeight
                return@OnGlobalLayoutListener
            }


            if (rootViewVisibleHeight == visibleHeight) {
                return@OnGlobalLayoutListener
            }


            if (rootViewVisibleHeight - visibleHeight > 200) {
                if (onSoftKeyBoardChangeListener != null) {
                    onSoftKeyBoardChangeListener!!.keyBoardShow(rootViewVisibleHeight - visibleHeight)
                }
                rootViewVisibleHeight = visibleHeight
                return@OnGlobalLayoutListener
            }


            if (visibleHeight - rootViewVisibleHeight > 200) {
                if (onSoftKeyBoardChangeListener != null) {
                    onSoftKeyBoardChangeListener!!.keyBoardHide(visibleHeight - rootViewVisibleHeight)
                }
                rootViewVisibleHeight = visibleHeight
                return@OnGlobalLayoutListener
            }
        })
    }
}