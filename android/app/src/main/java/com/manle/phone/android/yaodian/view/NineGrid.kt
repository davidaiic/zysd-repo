package com.manle.phone.android.yaodian.view


import android.content.Context

import android.util.AttributeSet
import coil.load
import com.app.base.view.NineGridLayout
import com.makeramen.roundedimageview.RoundedImageView





class NineGrid(context: Context, attributeSet: AttributeSet) : NineGridLayout(context, attributeSet) {

    override fun displayImage(imageView: RoundedImageView?, url: String?) {
        imageView?.load(url)
    }

    override fun onClickImage(position: Int, url: String?, urlList: List<String?>?) {

    }
}