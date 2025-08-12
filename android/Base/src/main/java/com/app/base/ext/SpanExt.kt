package com.app.base.ext

import android.graphics.Color
import android.graphics.Typeface
import android.text.Spannable
import android.text.SpannableString
import android.text.TextPaint
import android.text.style.*
import android.view.View


fun CharSequence.toSizeSpan(range: IntRange, scale: Float = 1.5f): CharSequence {
    return SpannableString(this).apply {
        setSpan(
            RelativeSizeSpan(scale),
            range.first,
            range.last,
            Spannable.SPAN_INCLUSIVE_EXCLUSIVE
        )
    }
}


fun CharSequence.toColorSpan(range: IntRange, color: Int = Color.RED): CharSequence {
    return SpannableString(this).apply {
        setSpan(
            ForegroundColorSpan(color),
            range.first,
            range.last,
            Spannable.SPAN_INCLUSIVE_EXCLUSIVE
        )
    }
}


fun CharSequence.toBackgroundColorSpan(range: IntRange, color: Int = Color.RED): CharSequence {
    return SpannableString(this).apply {
        setSpan(
            BackgroundColorSpan(color),
            range.first,
            range.last,
            Spannable.SPAN_INCLUSIVE_EXCLUSIVE
        )
    }
}


fun CharSequence.toDeleteLineSpan(range: IntRange): CharSequence {
    return SpannableString(this).apply {
        setSpan(StrikethroughSpan(), range.first, range.last, Spannable.SPAN_INCLUSIVE_EXCLUSIVE)
    }
}


fun CharSequence.toClickSpan(
    range: IntRange,
    color: Int = Color.RED,
    isUnderlineText: Boolean = false,
    clickAction: () -> Unit
): CharSequence {
    return SpannableString(this).apply {
        val clickableSpan = object : ClickableSpan() {
            override fun onClick(widget: View) {
                clickAction()
            }

            override fun updateDrawState(ds: TextPaint) {
                ds.color = color
                ds.isUnderlineText = isUnderlineText
            }
        }
        setSpan(clickableSpan, range.first, range.last, Spannable.SPAN_INCLUSIVE_EXCLUSIVE)
    }
}


fun CharSequence.toStyleSpan(style: Int = Typeface.BOLD, range: IntRange): CharSequence {
    return SpannableString(this).apply {
        setSpan(StyleSpan(style), range.first, range.last, Spannable.SPAN_INCLUSIVE_EXCLUSIVE)
    }
}