package com.app.base.app_use.ext

import android.content.res.ColorStateList
import android.text.Spannable
import android.text.SpannableStringBuilder
import android.text.TextUtils
import android.text.style.ClickableSpan
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.ColorInt
import androidx.appcompat.widget.AppCompatTextView
import androidx.databinding.BindingAdapter
import com.app.base.R
import com.app.base.ext.DIRECTION
import com.app.base.ext.drawable
import com.app.base.ext.getDrawable
import com.google.android.material.button.MaterialButton

import com.zhpan.bannerview.BannerViewPager



@BindingAdapter("headImageUrl", "placeholder", requireAll = false)
fun headImageView(imageView: ImageView, headImageUrl: String?, placeholder: Int?) {
    imageView.loadImage(
        imageUrl  = headImageUrl,
        placeHolder = placeholder ?: R.drawable.ic_head_logo,
        error = placeholder ?: R.drawable.ic_head_logo
    )
}

@BindingAdapter("imageUrl", "placeHolder", requireAll = false)
fun loadImage(imageView: ImageView, imageUrl: String?, placeHolder: Int?) {
    if (null == placeHolder) {
        imageView.loadImage(imageUrl)
    } else {
        imageView.loadImage(imageUrl, placeHolder = placeHolder, error = placeHolder)
    }
}

@BindingAdapter("blurImageUrl", "placeHolder", requireAll = false)
fun loadImageBlur(imageView: ImageView, imageUrl: String?, placeHolder: Int?) {
    if (null == placeHolder) {
        imageView.blurTransformation(imageUrl)
    } else {
        imageView.blurTransformation(imageUrl, placeHolder = placeHolder, error = placeHolder)
    }
}


@BindingAdapter("imageXyUrl", requireAll = false)
fun loadImageXY(iv: ImageView, imageXyUrl: String?) {
    iv.loadImageXY(imageXyUrl, minusCount = 43)
}



@BindingAdapter("drawableId", requireAll = false)
fun loadImageDrawableId(imageView: ImageView, drawableId: Int) {
    imageView.setImageResource(if (0 == drawableId) R.drawable.ic_error_img else drawableId)

}

@BindingAdapter("bannerUrl", requireAll = false)
fun loadHomeBannerImage(imageView: ImageView, bannerUrl: String = "") {
    imageView.loadImage(bannerUrl, placeHolder = R.drawable.ic_error_img, error = R.drawable.ic_error_img)
}



@BindingAdapter(
    "drawableStartX",
    "drawableEndX",
    "drawableLeftX",
    "drawableRightX",
    "drawableTopX",
    "drawableBottomX",
    requireAll = false
)
fun setTextViewDrawable(
    textView: TextView,
    drawableStartX: Int? = null,
    drawableEndX: Int? = null,
    drawableLeftX: Int? = null,
    drawableRightX: Int? = null,
    drawableTopX: Int? = null,
    drawableBottomX: Int? = null,
) {
    drawableStartX?.let {
        textView.drawable(it, DIRECTION.L)
    }
    drawableEndX?.let {
        textView.drawable(it, DIRECTION.R)
    }

    drawableLeftX?.let {
        textView.drawable(it, DIRECTION.L)
    }

    drawableRightX?.let {
        textView.drawable(it, DIRECTION.R)
    }

    drawableTopX?.let {
        textView.drawable(it, DIRECTION.T)
    }
    drawableBottomX?.let {
        textView.drawable(it, DIRECTION.B)
    }


}



@BindingAdapter("visible")
fun setVisibleOrGone(v: View, isVisible: Boolean) {
    v.visibility = if (isVisible) {
        View.VISIBLE
    } else {
        View.GONE
    }
}


