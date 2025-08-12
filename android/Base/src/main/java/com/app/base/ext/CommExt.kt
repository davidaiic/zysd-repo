package com.app.base.ext

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Resources
import android.net.Uri
import android.os.Build
import android.text.Html
import android.text.Spanned
import android.util.TypedValue
import android.view.View
import android.view.inputmethod.InputMethodManager
import androidx.core.content.ContextCompat
import androidx.core.os.ConfigurationCompat
import com.app.base.lifecycle.appContext


fun setOnclickNoRepeat(vararg views: View?, interval: Long = 500, onClick: (View) -> Unit) {
    views.forEach {
        it?.clickNoRepeat(interval = interval) { view ->
            onClick.invoke(view)
        }
    }
}


var lastClickTime = 0L
fun View.clickNoRepeat(interval: Long = 500, action: (view: View) -> Unit) {
    setOnClickListener {
        val currentTime = System.currentTimeMillis()
        if (lastClickTime != 0L && (currentTime - lastClickTime < interval)) {
            return@setOnClickListener
        }
        lastClickTime = currentTime
        action(it)
    }
}



fun hideSoftKeyboard(activity: Activity?) {
    activity?.let { act ->
        val view = act.currentFocus
        view?.let {
            val inputMethodManager =
                act.getSystemService(Activity.INPUT_METHOD_SERVICE) as InputMethodManager
            inputMethodManager.hideSoftInputFromWindow(
                view.windowToken,
                InputMethodManager.HIDE_NOT_ALWAYS
            )
        }
    }
}

fun String.toHtml(flag: Int = Html.FROM_HTML_MODE_LEGACY): Spanned {
    return if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.N) {
        Html.fromHtml(this, flag)
    } else {
        Html.fromHtml(this)
    }
}

fun Context.color(id: Int) = ContextCompat.getColor(this, id)

fun Int.getColor() = ContextCompat.getColor(appContext, this)

fun View.color(id: Int) = context.color(id)

fun Context.string(id: Int) = getString(id)

fun Context.stringArray(id: Int): Array<String> = resources.getStringArray(id)


fun Context.drawable(id: Int) = ContextCompat.getDrawable(this, id)

fun Int.getDrawable() = appContext.getDrawable( this)

fun Context.dimenPx(id: Int) = resources.getDimensionPixelSize(id)


fun Int.getString() = appContext.getString(this)


fun View.drawable(id: Int) = context.drawable(id)
fun Int.drawable() = ContextCompat.getDrawable(appContext, this)


fun Int.getStringFormat(vararg strings: Any) = appContext.getString(this, *strings)


fun Context.getStringFormat(stringId: Int, vararg strings: Any) = getString(stringId, *strings)


fun Activity.callPhone(tel: String) {
    val intent = Intent()
    intent.action = Intent.ACTION_CALL
    val data = Uri.parse("tel:$tel")
    intent.data = data
    startActivity(intent)
}

fun Int.formatNum(): String {
    if (this in 0..10000) {
        return this.toString()
    } else if (this > 10000) {
        val w = this / 10000
        val q = (this - w * 10000) / 1000
        return w.toString() + "." + q + "w"
    }
    return "0"
}



