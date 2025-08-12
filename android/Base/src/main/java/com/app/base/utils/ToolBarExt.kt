package com.app.base.utils

import android.os.Build
import android.os.Environment
import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.widget.Toolbar
import androidx.fragment.app.FragmentActivity
import com.app.base.R
import com.app.base.ext.*
import com.app.base.lifecycle.appContext

import com.app.base.view.CommToolBar

import kotlinx.coroutines.channels.awaitClose
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.callbackFlow


fun Toolbar.initToolBar(
    activity: FragmentActivity,
    backStr:String="",
    titleStrId: Int = 0,
    titleStr: String = "",
    rightImg: Int = 0,
    rightText: String = "",
    rightTextColor: Int = 0,
    onRightClick: (toolbar: Toolbar) -> Unit = {},
    interceptBack: Boolean = false,
    onBack: () -> Unit = {}
): Toolbar {
    if(backStr.isNotEmpty()){
        findViewById<TextView>(R.id.backTv).text = backStr
    }
    if (titleStrId != 0) {
        findViewById<TextView>(R.id.fragmentTitleTv).text = titleStrId.getString().toHtml()
    }
    if (titleStr.isNotEmpty()) {
        findViewById<TextView>(R.id.fragmentTitleTv).text = titleStr
    }
    if (rightImg != 0) {
        findViewById<TextView>(R.id.toolbarTv).gone()
        findViewById<ImageView>(R.id.toolbarIv).visible()
        findViewById<ImageView>(R.id.toolbarIv).setImageResource(rightImg)
        findViewById<ImageView>(R.id.toolbarIv).setOnClickListener { onRightClick.invoke(this) }
    }
    if (rightText.isNotEmpty()) {
        findViewById<TextView>(R.id.toolbarIv).gone()
        findViewById<TextView>(R.id.toolbarTv).visible()
        findViewById<TextView>(R.id.toolbarTv).text = rightText
        if (0 != rightTextColor) {
            findViewById<TextView>(R.id.toolbarTv).setTextColor(rightTextColor.getColor())
        }
        findViewById<TextView>(R.id.toolbarTv).setOnClickListener { onRightClick.invoke(this) }
    }
    findViewById<TextView>(R.id.backTv).setOnClickListener { if (interceptBack) onBack.invoke() else activity.finish() }
    return this
}









