package com.app.base.ext

import android.text.TextUtils

import java.util.regex.Pattern


fun String?.isPhone(): Boolean {
    return this?.let {
        Pattern.matches(it, "0?(13|14|15|16|17|18|19)[0-9]{9}")
    } ?: let {
        false
    }
}

fun String.isMobileNO(): Boolean {

    val telRegex = "^((13[0-9])|(14[5,7,9])|(15[^4])|(18[0-9])|(17[0,1,3,5,6,7,8]))\\d{8}\$"
    return if (TextUtils.isEmpty(this)) false else this.matches(Regex(telRegex))
}


fun String?.isTel(): Boolean {
    return this?.let {
        val matcher1 = Pattern.matches("^0(10|2[0-5|789]|[3-9]\\d{2})\\d{7,8}\$", it)
        val matcher2 = Pattern.matches("^0(10|2[0-5|789]|[3-9]\\d{2})-\\d{7,8}$", it)
        val matcher3 = Pattern.matches("^400\\d{7,8}$", it)
        val matcher4 = Pattern.matches("^400-\\d{7,8}$", it)
        val matcher5 = Pattern.matches("^800\\d{7,8}$", it)
        val matcher6 = Pattern.matches("^800-\\d{7,8}$", it)
        return matcher1 || matcher2 || matcher3 || matcher4 || matcher5 || matcher6
    } ?: let {
        false
    }
}



fun String?.isEmail(): Boolean {
   return this?.let {
       Pattern.matches("^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$", this)
    } ?: let {
         false
    }

}

