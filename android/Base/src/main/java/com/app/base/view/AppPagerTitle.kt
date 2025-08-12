package com.app.base.view

import android.content.Context
import android.graphics.Typeface
import android.util.TypedValue
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.app.base.R
import com.app.base.ext.dp2px
import com.app.base.ext.getColor
import com.app.base.ext.invisible
import com.app.base.ext.visible


import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IMeasurablePagerTitleView


class AppPagerTitle(context: Context) : LinearLayout(context), IMeasurablePagerTitleView {


    init {
        initView(context)
    }

    private lateinit var view: View
    private lateinit var title: TextView
    private lateinit var bottomV: View

    private fun initView(context: Context) {
        gravity = Gravity.CENTER
        view = LayoutInflater.from(context).inflate(R.layout.view_app_pager_title, this)
        title = view.findViewById(R.id.titleTv)
        bottomV = view.findViewById(R.id.bottomV)

        setPadding(0, 0, dp2px(20f), 0)
    }

    override fun onSelected(index: Int, totalCount: Int) {
        title.setTextColor(R.color.color_333333.getColor())
        title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
        title.typeface = Typeface.defaultFromStyle(Typeface.BOLD)
        bottomV.visible()

    }

    override fun onDeselected(index: Int, totalCount: Int) {
        title.setTextColor(R.color.color_666666.getColor())
        title.setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
        title.typeface = Typeface.defaultFromStyle(Typeface.NORMAL)
        bottomV.invisible()

    }

    override fun onLeave(index: Int, totalCount: Int, leavePercent: Float, leftToRight: Boolean) {
    }

    override fun onEnter(index: Int, totalCount: Int, enterPercent: Float, leftToRight: Boolean) {
    }

    override fun getContentLeft(): Int {

        return left + width / 2 - view.width / 2
    }

    override fun getContentTop(): Int {
        return height / 2 - view.height / 2
    }

    override fun getContentRight(): Int {
        return left + width / 2 + view.width / 2

    }


    override fun getContentBottom(): Int {
        return height / 2 + view.height / 2
    }

    fun setTitle(titleText: String) {
        title.text = titleText
    }


}
