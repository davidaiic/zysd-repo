package com.manle.phone.android.yaodian.util



import android.graphics.Color
import android.widget.ImageView
import android.widget.TextView
import androidx.databinding.BindingAdapter
import androidx.recyclerview.widget.RecyclerView
import com.app.base.app_use.ext.loadImage
import com.app.base.ext.*
import com.app.base.lifecycle.appContext
import com.drake.brv.utils.divider
import com.drake.brv.utils.linear
import com.drake.brv.utils.setup
import com.luck.picture.lib.entity.LocalMedia
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.GoodsBean
import com.manle.phone.android.yaodian.bean.TagBean



@BindingAdapter("isLike", requireAll = false)
fun likeTv(tv: TextView, isLike: Boolean) {
    tv.drawable(if (isLike) R.drawable.ic_comment_likeed else R.drawable.ic_comment_unlike, DIRECTION.L)
}


@BindingAdapter("tagType", requireAll = false)
fun tagBg(tv: TextView, tagType: Int) {
    tv.background = when (tagType) {
        2 -> appContext.createDrawable(color = R.color.color_10_459BF0.getColor(), radius = 4f)
        else -> appContext.createDrawable(color = R.color.color_10_FF9330.getColor(), radius = 4f)
    }
    val textColor = when (tagType) {
        2 -> R.color.color_459BF0
        else -> R.color.color_FF9330
    }
    tv.setTextColor(textColor.getColor())
}


@BindingAdapter("labelSelected", requireAll = false)
fun labelBg(tv: TextView, labelSelected: Boolean) {
    tv.background = if (labelSelected) {
        tv.context.createDrawable(color = R.color.color_0FC8AC.getColor(), radius = 4f)
    } else {
        tv.context.createDrawable(color = R.color.color_F2F3F5.getColor(), radius = 4f)
    }
    val textColor = if (labelSelected) {
        R.color.white
    } else {
        R.color.color_333333
    }
    tv.setTextColor(textColor.getColor())
}


@BindingAdapter("havaSelected", requireAll = false)
fun searchBg(tv: TextView, selected: Boolean) {
    tv.background = if (selected) {
        tv.context.createDrawable(color = R.color.color_0FC8AC.getColor(), radius = dp2fpx(30f))
    } else {
        tv.context.createDrawable(color = R.color.color_F6F7F8.getColor(), radius = dp2fpx(30f))
    }
    val textColor = if (selected) {
        R.color.white
    } else {
        R.color.color_666666
    }
    tv.setTextColor(textColor.getColor())
    val drawable = if (selected) {
        R.drawable.ic_search_white
    } else {
        R.drawable.ic_search_black
    }
    tv.drawable(drawable, DIRECTION.L)
}


@BindingAdapter("goodsBean", requireAll = false)
fun searchTagRv(rv: RecyclerView, goodsBean: GoodsBean?) {
    if (goodsBean == null) {
        return
    }
    val tags = mutableListOf<TagBean>()
    if (goodsBean.clinicalStage.isNotEmpty()) {
        tags.add(TagBean(type = 1, goodsBean.clinicalStage))
    }
    if (goodsBean.marketTag.isNotEmpty()) {
        tags.add(TagBean(type = 2, goodsBean.marketTag))
    }
    if (goodsBean.medicalTag.isNotEmpty()) {
        tags.add(TagBean(type = 3, goodsBean.medicalTag))
    }
    rv.linear(orientation = RecyclerView.HORIZONTAL)
        .divider { setDivider(width = 7, dp = true) }
        .setup {
            addType<TagBean> { R.layout.adapter_tag }
        }.models = tags
}


@BindingAdapter("lables", requireAll = false)
fun zxTagRv(rv: RecyclerView, lables: MutableList<String>?) {
    if (lables.isNullOrEmpty()) return
    val tags = mutableListOf<TagBean>()
    lables.forEach {
        tags.add(TagBean(type = 3, text = it))
    }
    rv.linear(orientation = RecyclerView.HORIZONTAL)
        .divider { setDivider(width = 7, dp = true) }
        .setup {
            addType<TagBean> { R.layout.adapter_tag }
        }.models = tags
}


@BindingAdapter("detailLabels", requireAll = false)
fun zxDetailTagRv(rv: RecyclerView, detailLabels: MutableList<String>?) {
    if (detailLabels.isNullOrEmpty()) return
    rv.linear(orientation = RecyclerView.HORIZONTAL)
        .divider { setDivider(width = 7, dp = true) }
        .setup {
            addType<String> { R.layout.adapter_tag_detail }
        }.models = detailLabels
}



@BindingAdapter("copyTextSelected", requireAll = false)
fun copyTextSelect(tv: TextView, copyTextSelected: Boolean) {
    tv.background = if (copyTextSelected) {
        tv.context.createDrawable(color = R.color.color_0FC8AC.getColor(), radius = 2f)
    } else {
        tv.context.createDrawable(color = R.color.color_F2F3F5.getColor(), radius = 2f)
    }
    val textColor = if (copyTextSelected) {
        R.color.white
    } else {
        R.color.color_333333
    }
    tv.setTextColor(textColor.getColor())

}



@BindingAdapter("tagColor", requireAll = false)
fun tagModeBg(tv: TextView, tagColor: String?) {
    if (tagColor.isNullOrEmpty()) return
    tv.background = appContext.createDrawable(color = Color.parseColor(tagColor), topLeftRadius = 4f, bottomRightRadius = 4f)
}


@BindingAdapter("media", requireAll = false)
fun setSelectImg(iv: ImageView, media: LocalMedia) {
    var path = if (media.isCut && !media.isCompressed) {
        media.cutPath
    } else if (media.isCompressed || media.isCut && media.isCompressed) {
        media.compressPath
    } else {
        media.path
    }

    iv.loadImage(path)
}



