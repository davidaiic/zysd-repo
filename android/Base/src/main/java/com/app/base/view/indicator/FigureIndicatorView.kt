package com.app.base.view.indicator

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.AttributeSet
import androidx.annotation.ColorInt
import androidx.core.content.ContextCompat
import com.app.base.R
import com.app.base.ext.dp2px
import com.app.base.ext.sp2px
import com.zhpan.bannerview.utils.BannerUtils
import com.zhpan.indicator.base.BaseIndicatorView


class FigureIndicatorView : BaseIndicatorView {
    private var corner = BannerUtils.dp2px(20f).toFloat()

    private var backgroundColor = Color.parseColor("#00327D")

    private var textColor = Color.WHITE

    private var textSize = context.sp2px(12).toFloat()

    var mPaint: Paint = Paint()
    var newWidth: Int = context.dp2px(35)
    var newHeight: Int = context.dp2px(15)
    private var isNewHw: Boolean = false

    constructor(context: Context) : super(context, null, 0)
    constructor(context: Context, attrs: AttributeSet) : super(context, attrs, 0) {
        setViewAttributes(context, attrs)
    }

    private fun setViewAttributes(context: Context, attrs: AttributeSet?) {

        val array = context.obtainStyledAttributes(attrs, R.styleable.FigureIndicatorView)
        textColor = array.getColor(
            R.styleable.FigureIndicatorView_fiv_text_color,
            ContextCompat.getColor(context, R.color.color_white)
        )
        backgroundColor = array.getColor(
            R.styleable.FigureIndicatorView_fiv_bg_color,
            ContextCompat.getColor(context, R.color.color_black)
        )
        corner = array.getDimension(
            R.styleable.FigureIndicatorView_fiv_corner,
            context.dp2px(20).toFloat()
        )
        textSize = array.getDimension(
            R.styleable.FigureIndicatorView_fiv_text_size,
            context.sp2px(12).toFloat()
        )
        array.recycle()
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec)
        if (isNewHw) {
            setMeasuredDimension(newWidth, newHeight)
        }
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)

        if (getPageSize() > 1) {
            mPaint.color = backgroundColor

            canvas.drawRoundRect(
                RectF(0f, 0f, width.toFloat(), height.toFloat()),
                corner,
                corner,
                mPaint
            )
            mPaint.color = textColor
            mPaint.textSize = textSize
            val text = "${getCurrentPosition() + 1}/${getPageSize()}"
            //文字长度
            val textWidth = mPaint.measureText(text).toInt()
            val fontMetricsInt = mPaint.fontMetricsInt
            val baseline = ((measuredHeight - fontMetricsInt.bottom + fontMetricsInt.top) / 2
                    - fontMetricsInt.top)
            canvas.drawText(text, (width - textWidth) / 2f, baseline.toFloat(), mPaint)
        }
    }

    fun setCorner(corner: Float) {
        this.corner = corner
    }

    override fun setBackgroundColor(@ColorInt backgroundColor: Int) {
        this.backgroundColor = backgroundColor
        invalidate()
    }

    fun setTextSize(textSize: Float) {
        this.textSize = textSize
        invalidate()
    }

    fun setTextColor(textColor: Int) {
        this.textColor = textColor
        invalidate()
    }

    fun setNewHw(isNewHw: Boolean) {
        this.isNewHw = isNewHw
        invalidate()
    }

    fun setW(w: Int) {
        this.newWidth = context.dp2px(w)
        invalidate()
    }

    fun setH(h: Int) {
        this.newHeight = context.dp2px(h)
        invalidate()
    }
}