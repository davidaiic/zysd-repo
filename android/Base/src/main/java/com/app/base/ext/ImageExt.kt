package com.app.base.app_use.ext


import android.os.Build
import android.widget.ImageView
import androidx.annotation.DrawableRes
import androidx.core.graphics.drawable.toBitmap
import coil.ImageLoader
import coil.decode.GifDecoder
import coil.decode.ImageDecoderDecoder
import coil.load
import coil.transform.CircleCropTransformation
import coil.transform.RoundedCornersTransformation
import com.app.base.R
import com.app.base.app_use.transform.BlurTransformation
import com.app.base.ext.dp2fpx
import com.app.base.ext.dp2px
import com.app.base.ext.screenWidth
import com.app.base.lifecycle.appContext
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.CenterCrop
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.RequestOptions
import com.lxj.xpopup.util.SmartGlideImageLoader
import kotlin.math.roundToInt


fun ImageView.loadImage(
    imageUrl: String?,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    this.load(imageUrl) {
        placeholder(placeHolder)
        error(error)
    }
}


fun ImageView.loadImageXY(url: String?, minusCount: Int = 0, defaultImage: Int = R.drawable.ic_error_img) {
    this.load(url) {
        placeholder(defaultImage)
        error(defaultImage)
        target {
            val bitmap = it.toBitmap()
            val imageWidth = bitmap.width
            //图片高度
            val imageHeight = bitmap.height
            val para = this@loadImageXY.layoutParams
            val density = appContext.resources.displayMetrics.density
            para.width = (appContext.screenWidth - (density * minusCount).roundToInt()) / 2
            if (para != null) {
                para.height = para.width * imageHeight / imageWidth
                this@loadImageXY.layoutParams = para
            }
            this@loadImageXY.setImageBitmap(bitmap)

        }
    }

}


fun ImageView.loadGIF(@DrawableRes drawableId: Int) = load(drawableId)


fun ImageView.loadCircleImage(
    url: String?,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    this.load(url) {
        placeholder(placeHolder)
        error(error)
        transformations(CircleCropTransformation())
    }
}


fun ImageView.loadRoundedCornersImage(
    url: String?,
    topLeft: Float = 0f,
    topRight: Float = 0f,
    bottomLeft: Float = 0f,
    bottomRight: Float = 0f,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    this.load(url) {
        placeholder(placeHolder)
        error(error)
        transformations(RoundedCornersTransformation(dp2fpx(topLeft), dp2fpx(topRight), dp2fpx(bottomLeft), dp2fpx(bottomRight)))
    }

}


fun ImageView.loadRoundedCornersImage(
    url: String = "",
    round: Float = 0f,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    if (url.contains(".gif")) {
       val transform=RoundedCorners(dp2px(round))
        val options=RequestOptions().placeholder(R.drawable.ic_error_img).transform(CenterCrop(),transform)
        Glide.with(context).asGif().load(url).apply(options).into(this)
    } else{
        this.load(url) {
            placeholder(placeHolder)
            error(error)
            transformations(RoundedCornersTransformation(dp2fpx(round), dp2fpx(round), dp2fpx(round), dp2fpx(round)))
        }
    }


}


fun ImageView.loadWHImage(url: String? = "", width: Int = 0, height: Int = 0) {
    this.load(url) {
        size(width, height)
    }
}


fun ImageView.loadCircleWHImage(
    url: String?,
    width: Int = 0,
    height: Int = 0,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    this.load(url) {
        size(width, height)
        placeholder(placeHolder)
        error(error)
        transformations(CircleCropTransformation())
    }
}


fun ImageView.blurTransformation(
    url: String?,
    @DrawableRes placeHolder: Int = R.drawable.ic_error_img,
    @DrawableRes error: Int = R.drawable.ic_error_img
) {
    this.load(url) {
        placeholder(placeHolder)
        error(error)
        transformations(BlurTransformation(context = this@blurTransformation.context, radius = 5, sampling = 5f))
    }
}


