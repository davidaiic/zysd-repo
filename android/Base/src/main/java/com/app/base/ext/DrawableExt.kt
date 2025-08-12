package com.app.base.ext

import android.content.Context
import android.content.res.ColorStateList
import android.graphics.Color
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.graphics.drawable.RippleDrawable
import android.os.Build
import android.view.View
import androidx.fragment.app.Fragment
import com.app.base.R
import com.app.base.lifecycle.appContext



fun Context.createDrawable(
    color: Int = Color.TRANSPARENT,
    radius: Float = 0f,
    strokeColor: Int = Color.TRANSPARENT,
    strokeWidth: Int = 0,
    enableRipple: Boolean = true,
    rippleColor: Int = Color.parseColor("#88999999"),
    gradientStartColor: Int = 0,
    gradientEndColor: Int = 0,
    gradientOrientation: GradientDrawable.Orientation = GradientDrawable.Orientation.LEFT_RIGHT
): Drawable {
    val content = GradientDrawable().apply {
        cornerRadius = radius
        setStroke(strokeWidth, strokeColor)
        gradientType = GradientDrawable.LINEAR_GRADIENT
        if (gradientStartColor != 0 || gradientEndColor != 0) {
            orientation = gradientOrientation
            colors = intArrayOf(gradientStartColor, gradientEndColor)
        } else {
            setColor(color)
        }
    }
    if (Build.VERSION.SDK_INT >= 21 && enableRipple) {
        return RippleDrawable(ColorStateList.valueOf(rippleColor), content, null)
    }
    return content
}
fun Fragment.createDrawable(
    color: Int = Color.TRANSPARENT,
    radius: Float = 0f,
    strokeColor: Int = Color.TRANSPARENT,
    strokeWidth: Int = 0,
    enableRipple: Boolean = true,
    rippleColor: Int = Color.parseColor("#88999999"),
    gradientStartColor: Int = 0,
    gradientEndColor: Int = 0,
    gradientOrientation: GradientDrawable.Orientation = GradientDrawable.Orientation.LEFT_RIGHT
): Drawable {
    return context!!.createDrawable(
        color,
        radius,
        strokeColor,
        strokeWidth,
        enableRipple,
        rippleColor,
        gradientStartColor = gradientStartColor,
        gradientEndColor = gradientEndColor,
        gradientOrientation = gradientOrientation
    )
}

fun View.createDrawable(
    color: Int = Color.TRANSPARENT,
    radius: Float = 0f,
    strokeColor: Int = Color.TRANSPARENT,
    strokeWidth: Int = 0,
    enableRipple: Boolean = true,
    rippleColor: Int = Color.parseColor("#88999999"),
    gradientStartColor: Int = 0,
    gradientEndColor: Int = 0,
    gradientOrientation: GradientDrawable.Orientation = GradientDrawable.Orientation.LEFT_RIGHT
): Drawable {
    return context!!.createDrawable(
        color,
        radius,
        strokeColor,
        strokeWidth,
        enableRipple,
        rippleColor,
        gradientStartColor = gradientStartColor,
        gradientEndColor = gradientEndColor,
        gradientOrientation = gradientOrientation
    )
}
fun Context.createDrawable(
    color: Int = Color.TRANSPARENT,
    topLeftRadius: Float = 0f,
    topRightRadius: Float = 0f,
    bottomLeftRadius: Float = 0f,
    bottomRightRadius: Float = 0f,
    strokeColor: Int = Color.TRANSPARENT,
    strokeWidth: Int = 0,
    enableRipple: Boolean = true,
    rippleColor: Int = Color.parseColor("#88999999"),
    gradientStartColor: Int = 0,
    gradientEndColor: Int = 0,
    gradientOrientation: GradientDrawable.Orientation = GradientDrawable.Orientation.LEFT_RIGHT
): Drawable {
    val content = GradientDrawable().apply {
        cornerRadii = floatArrayOf(topLeftRadius, topLeftRadius, topRightRadius,topRightRadius,bottomRightRadius, bottomRightRadius,bottomLeftRadius,bottomLeftRadius)
        setStroke(strokeWidth, strokeColor)
        gradientType = GradientDrawable.LINEAR_GRADIENT
        if (gradientStartColor != 0 || gradientEndColor != 0) {
            orientation = gradientOrientation
            colors = intArrayOf(gradientStartColor, gradientEndColor)
        } else {
            setColor(color)
        }
    }
    if (Build.VERSION.SDK_INT >= 21 && enableRipple) {
        return RippleDrawable(ColorStateList.valueOf(rippleColor), content, null)
    }
    return content
}

fun View.createDrawable(
    color: Int = Color.TRANSPARENT,
    topLeftRadius: Float = 0f,
    topRightRadius: Float = 0f,
    bottomLeftRadius: Float = 0f,
    bottomRightRadius: Float = 0f,
    strokeColor: Int = Color.TRANSPARENT,
    strokeWidth: Int = 0,
    enableRipple: Boolean = true,
    rippleColor: Int = Color.parseColor("#88999999"),
    gradientStartColor: Int = 0,
    gradientEndColor: Int = 0,
    gradientOrientation: GradientDrawable.Orientation = GradientDrawable.Orientation.LEFT_RIGHT
): Drawable {
    return context!!.createDrawable(
        color,
        topLeftRadius,
        topRightRadius,
        bottomLeftRadius,
        bottomRightRadius,
        strokeColor,
        strokeWidth,
        enableRipple,
        rippleColor,
        gradientStartColor = gradientStartColor,
        gradientEndColor = gradientEndColor,
        gradientOrientation = gradientOrientation
    )
}

