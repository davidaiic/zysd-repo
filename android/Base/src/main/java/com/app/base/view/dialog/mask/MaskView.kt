package com.app.base.view.dialog.mask

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.View
import com.app.base.R


class MaskView : View {

    private var paint: Paint = Paint(Paint.ANTI_ALIAS_FLAG)


    private var trueWidth = 0
    private var trueHeight = 0


    private var highlightAreaType = HighlightAreaType.TRANSPARENT_CUBE


    var highlightArea = HighlightArea()
        set(value) {
            field = value
            invalidate()
        }


    var highlightBitmap: Bitmap? = null
        set(value) {
            field = value
            highlightAreaType = HighlightAreaType.BITMAP
            invalidate()
        }

    var maskAlpha = 0.5f
        set(value) {
            field = value
            invalidate()
        }

    private var bgColor = Color.TRANSPARENT

    private val viewFullRect = Rect()

    private val xfermode = PorterDuffXfermode(PorterDuff.Mode.DST_OUT)

    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs) {

        val a = context.obtainStyledAttributes(attrs, R.styleable.MaskView)
        highlightAreaType = when (a.getInt(R.styleable.MaskView_mask_highlightAreaType, HighlightAreaType.TRANSPARENT_CUBE.value)) {
            0 -> HighlightAreaType.TRANSPARENT_CUBE
            1 -> HighlightAreaType.BITMAP
            else -> HighlightAreaType.TRANSPARENT_CUBE
        }
        highlightArea.areaRect.set(
                a.getDimension(R.styleable.MaskView_mask_highlightAreaLeft, 0f),
                a.getDimension(R.styleable.MaskView_mask_highlightAreaTop, 0f),
                a.getDimension(R.styleable.MaskView_mask_highlightAreaRight, 0f),
                a.getDimension(R.styleable.MaskView_mask_highlightAreaBottom, 0f)
        )
        val radius = a.getDimension(R.styleable.MaskView_mask_highlightAreaRadius, 0f)
        highlightArea.radiusX = radius
        highlightArea.radiusY = radius
        a.getResourceId(R.styleable.MaskView_mask_highlightBitmap, 0).apply {
            if (this != 0) {
                highlightBitmap = BitmapFactory.decodeResource(resources, this)
            }
        }
        maskAlpha = a.getFloat(R.styleable.MaskView_mask_Alpha, 0.5f)
        a.recycle()
    }

    override fun onDraw(canvas: Canvas) {

        setBackgroundColor(bgColor)

        val saved = canvas.saveLayer(
                viewFullRect.left.toFloat(),
                viewFullRect.top.toFloat(),
                viewFullRect.right.toFloat(),
                viewFullRect.bottom.toFloat(), paint)

        paint.color = Color.argb((255 * maskAlpha).toInt(), 0, 0, 0)

        canvas.drawRect(viewFullRect, paint)

        paint.color = Color.WHITE

        paint.xfermode = xfermode

        canvas.drawRoundRect(highlightArea.areaRect, highlightArea.radiusX, highlightArea.radiusY, paint)

        paint.xfermode = null

        canvas.restoreToCount(saved)

        if (highlightAreaType == HighlightAreaType.BITMAP) {
            highlightBitmap?.let {
                canvas.drawBitmap(
                        it,
                        viewFullRect, highlightArea.areaRect, paint)
            }
        }

    }

    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        super.onLayout(changed, left, top, right, bottom)
        trueWidth = right - left
        trueHeight = bottom - top

        viewFullRect.set(0, 0, trueWidth, trueHeight)
    }

}