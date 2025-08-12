package com.app.base.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.widget.ImageView
import androidx.fragment.app.Fragment
import coil.imageLoader
import coil.request.ImageRequest
import coil.transform.CircleCropTransformation
import com.app.base.app_use.ext.loadCircleWHImage
import com.luck.picture.lib.engine.CropFileEngine

import com.yalantis.ucrop.UCrop
import com.yalantis.ucrop.UCropImageEngine
import java.util.ArrayList


class AppCropFileEngine : CropFileEngine {
    override fun onStartCrop(fragment: Fragment, srcUri: Uri, destinationUri: Uri, dataSource: ArrayList<String>, requestCode: Int) {
        val uCrop = UCrop.of(srcUri, destinationUri, dataSource);
        val options = UCrop.Options().apply {

            withAspectRatio(1f, 1f)

            setHideBottomControls(true)

        }


        uCrop.withOptions(options)
        uCrop.setImageEngine(object : UCropImageEngine {
            override fun loadImage(context: Context?, url: String?, imageView: ImageView?) {
                imageView?.loadCircleWHImage(url, width = 180, height = 180)
            }

            override fun loadImage(context: Context?, url: Uri?, maxWidth: Int, maxHeight: Int, call: UCropImageEngine.OnCallbackListener<Bitmap>?) {
                context?.let {
                    val request = ImageRequest.Builder(it)
                        .data(url)
                        .transformations(CircleCropTransformation())
                        .size(maxWidth, maxHeight)
                        .target(onSuccess = { drawable ->
                            val bitmap = (drawable as BitmapDrawable).bitmap
                            call?.onCall(bitmap)
                        }, onError = {
                            call?.onCall(null)
                        })
                        .build()
                    it.imageLoader.enqueue(request)
                }

            }
        })
        uCrop.start(fragment.requireActivity(), fragment, requestCode)
    }
}