package com.app.base.ext




import android.text.TextUtils
import android.util.Log
import com.app.base.BuildConfig

const val TAG = "BaseMVVM"

var appLog = BuildConfig.DEBUG


private enum class LEVEL {
    V, D, I, W, E, LE
}

fun String.logV(tag: String = TAG) = log(LEVEL.V, tag, this)

fun String.logD(tag: String = TAG) = log(LEVEL.D, tag, this)

fun String.logI(tag: String = TAG) = log(LEVEL.I, tag, this)

fun String.logW(tag: String = TAG) = log(LEVEL.W, tag, this)

fun String.logE(tag: String = TAG) = log(LEVEL.E, tag, this)

fun String.logLE(tag: String = TAG) = log(LEVEL.LE, tag, this)

private fun log(level: LEVEL, tag: String, message: String) {
    if (!appLog) return
    when (level) {
        LEVEL.V -> Log.v(tag, message)
        LEVEL.D -> Log.d(tag, message)
        LEVEL.I -> Log.i(tag, message)
        LEVEL.W -> Log.w(tag, message)
        LEVEL.E -> Log.e(tag, message)
        LEVEL.LE -> message.debugLongInfo(tag)
    }
}

fun String.debugLongInfo(tag: String) {
    var msg = this
    if (!appLog || TextUtils.isEmpty(msg)) {
        return
    }
    msg = msg.trim { it <= ' ' }
    var index = 0
    val maxLength = 3500
    var sub: String
    while (index < msg.length) {
        sub = if (msg.length <= index + maxLength) {
            msg.substring(index)
        } else {
            msg.substring(index, index + maxLength)
        }
        index += maxLength
        Log.d(tag, sub.trim { it <= ' ' })
    }
}
