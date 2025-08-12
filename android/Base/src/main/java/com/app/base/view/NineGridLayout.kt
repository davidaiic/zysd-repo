package com.app.base.view

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.util.AttributeSet
import android.view.Gravity
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import com.app.base.R
import com.app.base.ext.dp2px
import com.makeramen.roundedimageview.RoundedImageView

import kotlin.math.ceil



abstract class NineGridLayout(context: Context, attrs: AttributeSet) : ViewGroup(context, attrs) {
    private val DEFUALT_SPACING = 3f
    private val DEFUALT_RADIUS = 0F
    private val MAX_COUNT = 9


    private var mSpacing = DEFUALT_SPACING
    private var mColumns = 0
    private var mRows = 0
    private var mTotalWidth = 0


    private var mIsShowAll = false
    private var mIsFirst = true
    private val mUrlList: MutableList<String> = mutableListOf()
    private var ivRadius = DEFUALT_RADIUS

    init {
        initView(context, attrs)
    }

    private fun initView(context: Context, attrs: AttributeSet) {
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.NineGridLayout)
        mSpacing = typedArray.getDimension(R.styleable.NineGridLayout_sapcing, DEFUALT_SPACING)
        ivRadius = typedArray.getDimension(R.styleable.NineGridLayout_ivRadius, DEFUALT_SPACING)
        typedArray.recycle()

    }


    override fun onLayout(changed: Boolean, left: Int, top: Int, right: Int, bottom: Int) {
        mTotalWidth = right - left
        if (mIsFirst) {
            notifyDataSetChanged()
            mIsFirst = false
        }
    }


    open fun setSpacing(spacing: Float) {
        mSpacing = spacing
    }


    open fun setIsShowAll(isShowAll: Boolean) {
        mIsShowAll = isShowAll
    }

    open fun setUrlList(urlList: MutableList<String>) {

        mUrlList.clear()
        mUrlList.addAll(urlList)
        notifyDataSetChanged()
    }

    open fun notifyDataSetChanged() {

        refresh()

    }

    fun refresh() {
        removeAllViews()
        val size = getListSize(mUrlList)
        if (size == 0) {
            layoutZero()
            return
        }

        generateChildrenLayout(size)
        layoutParams(size)
        when (size) {
            1 -> {
                val url = mUrlList[0]
                val imageView = createImageView(0, url)
                layoutImageView(imageView, 0, url, false, size)
            }
            2 -> {
                for (i in 0 until size) {
                    val url = mUrlList[i]
                    var imageView = createImageView(i, url)
                    layoutImageView(imageView, i, url, false, size)
                }
            }
            else -> {
                for (i in 0 until size) {
                    val url = mUrlList[i]
                    var imageView: RoundedImageView
                    if (!mIsShowAll) {
                        if (i < MAX_COUNT - 1) {
                            imageView = createImageView(i, url)
                            layoutImageView(imageView, i, url, false, size)
                        } else {
                            if (size <= MAX_COUNT) {
                                imageView = createImageView(i, url)
                                layoutImageView(imageView, i, url, false, size)
                            } else {
                                imageView = createImageView(i, url)
                                layoutImageView(imageView, i, url, true, size)
                                break
                            }
                        }
                    } else {
                        imageView = createImageView(i, url)
                        layoutImageView(imageView, i, url, false, size)
                    }
                }
            }
        }


    }

    private fun layoutZero() {
        val params = layoutParams
        params.height = 0
        layoutParams = params
    }

    private fun layoutParams(size: Int) {

        when (size) {
            1 -> {
                val params = layoutParams
                params.height = dp2px(160)
                layoutParams = params
            }
            2 -> {
                val params = layoutParams
                params.height = dp2px(110)
                layoutParams = params
            }
            else -> {
                val singleHeight = ((mTotalWidth - mSpacing * (3 - 1)) / 3).toInt()
                val params = layoutParams
                params.height = (singleHeight * mRows + mSpacing * (mRows - 1)).toInt()
                layoutParams = params
            }
        }


    }

    private fun createImageView(i: Int, url: String): RoundedImageView {
        val imageView = RoundedImageView(context)
        imageView.cornerRadius = ivRadius
        imageView.scaleType = ImageView.ScaleType.CENTER_CROP
        imageView.setOnClickListener { onClickImage(i, url, mUrlList) }
        return imageView
    }


    @SuppressLint("SetTextI18n")
    private fun layoutImageView(imageView: RoundedImageView, i: Int, url: String, showNumFlag: Boolean, size: Int) {
        when (size) {
            1 -> {
                val singleWidth = mTotalWidth
                val position = findPosition(i)
                val left = singleWidth * position[1]
                val top = singleWidth * position[0]
                val right = left + singleWidth
                val bottom = top + dp2px(160)
                imageView.layout(left, top, right, bottom)
                addView(imageView)
                displayImage(imageView, url)
            }
            2 -> {
                val singleWidth = ((mTotalWidth - mSpacing * (2 - 1)) / 2).toInt()
                val position = findPosition(i)
                val left = ((singleWidth + mSpacing) * position[1]).toInt()
                val top = singleWidth * position[0]
                val right = left + singleWidth
                val bottom = top + dp2px(110)
                imageView.layout(left, top, right, bottom)
                addView(imageView)
                displayImage(imageView, url)
            }
            else -> {
                val singleWidth = ((mTotalWidth - mSpacing * (3 - 1)) / 3).toInt()
                val position = findPosition(i)
                val left = ((singleWidth + mSpacing) * position[1]).toInt()
                val top = ((singleWidth + mSpacing) * position[0]).toInt()
                val right = left + singleWidth
                val bottom = top + singleWidth
                imageView.layout(left, top, right, bottom)
                addView(imageView)
                if (showNumFlag) {
                    val overCount = getListSize(mUrlList) - MAX_COUNT
                    if (overCount > 0) {
                        val textSize = 30f
                        val textView = TextView(context)
                        textView.text = "+$overCount"
                        textView.setTextColor(Color.WHITE)
                        textView.setPadding(0, singleWidth / 2 - getFontHeight(textSize), 0, 0)
                        textView.textSize = textSize
                        textView.gravity = Gravity.CENTER
                        textView.setBackgroundColor(Color.BLACK)
                        textView.background.alpha = 120
                        textView.layout(left, top, right, bottom)
                        addView(textView)
                    }
                }
                displayImage(imageView, url)
            }

        }


    }

    private fun findPosition(childNum: Int): IntArray {
        val position = IntArray(2)
        for (i in 0 until mRows) {
            for (j in 0 until mColumns) {
                if (i * mColumns + j == childNum) {
                    position[0] = i
                    position[1] = j
                    break
                }
            }
        }
        return position
    }

    private fun generateChildrenLayout(length: Int) {
        if (length <= 3) {
            mRows = 1
            mColumns = length
        } else if (length <= 6) {
            mRows = 2
            mColumns = 3
            if (length == 4) {
                mColumns = 2
            }
        } else {
            mColumns = 3
            if (mIsShowAll) {
                mRows = length / 3
                val b = length % 3
                if (b > 0) {
                    mRows++
                }
            } else {
                mRows = 3
            }
        }
    }

    private fun getListSize(list: List<String>?): Int {
        return if (list == null || list.isEmpty()) {
            0
        } else list.size
    }

    private fun getFontHeight(fontSize: Float): Int {
        val paint = Paint()
        paint.textSize = fontSize
        val fm: Paint.FontMetrics = paint.fontMetrics
        return ceil(fm.descent - fm.ascent).toInt()
    }


    protected abstract fun displayImage(imageView: RoundedImageView?, url: String?)

    protected abstract fun onClickImage(position: Int, url: String?, urlList: List<String?>?)
}