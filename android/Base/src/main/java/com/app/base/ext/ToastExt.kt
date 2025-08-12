package com.app.base.ext


import android.content.Context
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.TextView
import android.widget.Toast
import com.app.base.R
import com.app.base.lifecycle.appContext



fun showToast(message: String, duration: Int = Toast.LENGTH_SHORT) =
    Toast.makeText(appContext, message, duration)
        .apply {
            setText(message)
        }.show()


fun showToast(message: Int, duration: Int = Toast.LENGTH_SHORT) =
    Toast.makeText(appContext, message, duration)
        .apply {
            setText(message)
        }.show()


var mToast: Toast? = null


fun showMyToast( msg: String, setWidth: Boolean = false, gravity: Int = Gravity.CENTER) {
    if (mToast != null) {
        mToast!!.cancel()
        mToast = null
    }
    mToast = Toast(appContext)
    val view: View = R.layout.toast_center.inflate(appContext)
    val tvMsg = view.findViewById<TextView>(R.id.tv_msg)
    if (setWidth) {
        tvMsg.maxWidth = appContext.screenWidth - appContext.dp2px(130)
    }
    tvMsg.text = msg

    mToast?.apply {
        setView(view)
        setGravity(gravity, 0, 0)
        show()
    }
}
