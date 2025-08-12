package com.app.base.ext

import android.content.Context
import android.content.res.Resources
import android.util.TypedValue
import android.view.FocusFinder
import android.view.View
import com.app.base.lifecycle.appContext
import kotlin.math.roundToInt


val Context.screenWidth
    get() = resources.displayMetrics.widthPixels


val Context.screenHeight
    get() = resources.displayMetrics.heightPixels


fun Context.dp2px(dp: Int): Int {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f).toInt()

}


fun Context.dp2fpx(dp: Int): Float {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f)
}


fun Context.dp2px(dp: Float): Int {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f).toInt()
}


fun Context.dp2fpx(dp: Float): Float {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f)
}


fun Context.px2dp(px: Int): Int {
    val scale = resources.displayMetrics.density
    return (px / scale + 0.5f).toInt()
}



fun View.dp2px(dp: Int): Int {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f).toInt()
}

fun View.dp2px(dp: Float): Int {
    val scale = resources.displayMetrics.density
    return (dp * scale + 0.5f).toInt()
}


fun View.px2dp(px: Int): Int {
    val scale = resources.displayMetrics.density
    return (px / scale + 0.5f).toInt()
}


fun Context.sp2px(sp: Int): Int {
    val fontScale = resources.displayMetrics.scaledDensity
    return (sp * fontScale + 0.5f).toInt()
}


fun Context.px2sp(px: Float): Int {
    val fontScale = resources.displayMetrics.scaledDensity
    return (px / fontScale + 0.5f).toInt()
}


fun dp2px(dp: Float): Int {
    val scale = appContext.resources.displayMetrics.density
    return (dp * scale + 0.5f).toInt()
}


fun dp2fpx(dp: Float): Float {
    val scale = appContext.resources.displayMetrics.density
    return dp * scale + 0.5f
}


val Number.dp
    get() = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        this.toFloat(),
        Resources.getSystem().displayMetrics
    )


val Number.sp
    get() = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_SP,
        this.toFloat(),
        Resources.getSystem().displayMetrics
    )


val Number.px
    get() = TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_PX,
        this.toFloat(),
        Resources.getSystem().displayMetrics
    ).toInt()


fun Int.toDp(): Int = (this / Resources.getSystem().displayMetrics.density).toInt()


fun Int.toPx(): Int = appContext.dp2px(this)
fun Float.toPx(): Int = appContext.dp2px(this)
fun Int.toFPx(): Float = appContext.dp2fpx(this)
fun Float.toFPx(): Float = appContext.dp2fpx(this)