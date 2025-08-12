package com.app.base.ext

import android.annotation.SuppressLint
import android.graphics.Color
import android.graphics.Rect
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.text.*
import android.text.method.HideReturnsTransformationMethod
import android.text.method.LinkMovementMethod
import android.text.method.PasswordTransformationMethod
import android.view.KeyEvent
import android.view.MotionEvent
import android.view.View
import android.view.View.OnTouchListener
import android.widget.EditText
import android.widget.TextView
import androidx.databinding.BindingAdapter


fun TextView.sizeDrawable(
    width: Int, height: Int, leftDrawable: Int = 0, topDrawable: Int = 0,
    rightDrawable: Int = 0, bottomDrawable: Int = 0
): TextView {
    val rect = Rect(0, 0, width, height)
    setCompoundDrawables(
        findDrawable(leftDrawable, 0, this)?.apply { bounds = rect },
        findDrawable(topDrawable, 1, this)?.apply { bounds = rect },
        findDrawable(rightDrawable, 2, this)?.apply { bounds = rect },
        findDrawable(bottomDrawable, 3, this)?.apply { bounds = rect }
    )
    return this
}


private fun findDrawable(drawableRes: Int, index: Int, textView: TextView): Drawable? {
    if (drawableRes != 0) return textView.drawableRes(drawableRes)
    if (textView.compoundDrawables.isNotEmpty()) return textView.compoundDrawables[index]
    return null
}

fun View.drawableRes(id: Int) = context.drawable(id)

// direction位置
enum class DIRECTION {
    L, R, T, B
}


fun TextView.drawable(drawable: Int, direction: DIRECTION = DIRECTION.L) {
    // LEFT TOP RIGHT BOTTOM
    setCompoundDrawablesRelativeWithIntrinsicBounds(
        if (direction == DIRECTION.L) drawable else 0,
        if (direction == DIRECTION.T) drawable else 0,
        if (direction == DIRECTION.R) drawable else 0,
        if (direction == DIRECTION.B) drawable else 0
    )
}


fun TextView.sizeSpan(str: String = "", range: IntRange, scale: Float = 1.5f): TextView {
    //text（Set） text（Get）
    text = (str.ifEmpty { text }).toSizeSpan(range, scale)
    return this
}


fun TextView.appendSizeSpan(str: String = "", scale: Float = 1.5f): TextView {
    append(str.toSizeSpan(0..str.length, scale))
    return this
}


fun TextView.colorSpan(str: String = "", range: IntRange, color: Int = Color.RED): TextView {
    text = (if (str.isEmpty()) text else str).toColorSpan(range, color)
    return this
}


fun TextView.appendColorSpan(str: String = "", color: Int = Color.RED): TextView {
    append(str.toColorSpan(0..str.length, color))
    return this
}


fun TextView.backgroundColorSpan(
    str: String = "",
    range: IntRange,
    color: Int = Color.RED
): TextView {
    text = (if (str.isEmpty()) text else str).toBackgroundColorSpan(range, color)
    return this
}


fun TextView.appendBackgroundColorSpan(str: String = "", color: Int = Color.RED): TextView {
    append(str.toBackgroundColorSpan(0..str.length, color))
    return this
}


fun TextView.deleteLineSpan(str: String = "", range: IntRange): TextView {
    text = (if (str.isEmpty()) text else str).toDeleteLineSpan(range)
    return this
}


fun TextView.appendDeleteLineSpan(str: String = ""): TextView {
    append(str.toDeleteLineSpan(0..str.length))
    return this
}

fun TextView.clickSpan(
    str: String = "",
    range: IntRange,
    color: Int = Color.RED,
    isUnderlineText: Boolean = false,
    clickAction: () -> Unit
): TextView {
    movementMethod = LinkMovementMethod.getInstance()
    highlightColor = Color.TRANSPARENT  // remove click bg color
    text =
        (if (str.isEmpty()) text else str).toClickSpan(range, color, isUnderlineText, clickAction)
    return this
}

fun TextView.appendClickSpan(
    str: String = "",
    color: Int = Color.RED,
    isUnderlineText: Boolean = false,
    clickAction: () -> Unit
): TextView {
    movementMethod = LinkMovementMethod.getInstance()
    highlightColor = Color.TRANSPARENT  // remove click bg color
    append(str.toClickSpan(0..str.length, color, isUnderlineText, clickAction))
    return this
}


fun TextView.styleSpan(str: String = "", range: IntRange, style: Int = Typeface.BOLD): TextView {
    text = (if (str.isEmpty()) text else str).toStyleSpan(style = style, range = range)
    return this
}


fun TextView.appendStyleSpan(str: String = "", style: Int = Typeface.BOLD): TextView {
    append(str.toStyleSpan(style = style, range = 0..str.length))
    return this
}


fun TextView.appendNormalStyleSpan(str: String = "", style: Int = Typeface.NORMAL): TextView {
    append(str.toStyleSpan(style = style, range = 0..str.length))
    return this
}




fun EditText.addAfterTextChanged(
    afterTextChanged: (editText: EditText) -> Unit
): EditText {
    addTextChangedListener(object : TextWatcher {
        override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

        }

        override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {

        }

        override fun afterTextChanged(s: Editable?) {
            afterTextChanged.invoke(this@addAfterTextChanged)
        }

    })

    return this
}

@SuppressLint("ClickableViewAccessibility")
fun EditText.setOnRightIconClick(rightIconClick: (editText: EditText) -> Unit) {
    setOnTouchListener(OnTouchListener { _, event ->

        val drawable: Drawable = compoundDrawables[2] ?: return@OnTouchListener false

        if (event.action != MotionEvent.ACTION_UP) return@OnTouchListener false
        if (event.x > (width
                    - paddingRight
                    - drawable.intrinsicWidth)
        ) {
            rightIconClick.invoke(this)
        }
        false
    })
}

@SuppressLint("ClickableViewAccessibility")
fun EditText.setAction() {
    setOnTouchListener { _, event ->
        if (event.action == MotionEvent.ACTION_UP) {
            requestFocus()
        }
        false
    }
}

@SuppressLint("ClickableViewAccessibility")
fun EditText.setEnterAction(onEnterAction: (editText: EditText) -> Unit) {

    setOnKeyListener { _, keyCode, event ->
        if (keyCode == KeyEvent.KEYCODE_ENTER && event.action == KeyEvent.ACTION_DOWN) {
            onEnterAction.invoke(this)
        }
        false
    }
}