package com.app.base.view.nine


import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import com.app.base.R
import kotlin.math.ceil

open class NineGridView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : ViewGroup(context, attrs, defStyleAttr) {


    var spanCount = 3

    var maxCount = 9


    var itemGap = 0


    var singleStrategy: Int = Strategy.USUAL


    var twoStrategy: Int = Strategy.USUAL


    var threeStrategy: Int = Strategy.USUAL


    var fourStrategy: Int = Strategy.USUAL


    var extraStrategy: Int = Strategy.SHOW


    var adapter: Adapter? = null
        set(value) {
            field = value
            addViews()
        }


    object Strategy {
        const val USUAL = 0
        const val FILL = 1
        const val CUSTOM = 2
        const val BILI = 3


        const val SHOW = 0
        const val HIDE = 1
    }

    init {
        if (attrs != null) {
            val typedArray = context.obtainStyledAttributes(attrs, R.styleable.NineGridView)
            spanCount = typedArray.getInt(R.styleable.NineGridView_ngv_spanCount, spanCount)
            maxCount = typedArray.getInt(R.styleable.NineGridView_ngv_maxCount, maxCount)
            itemGap = typedArray.getDimension(R.styleable.NineGridView_ngv_itemGap, 2f).toInt()

            singleStrategy = typedArray.getInt(
                R.styleable.NineGridView_ngv_single_strategy,
                Strategy.USUAL
            )
            twoStrategy = typedArray.getInt(
                R.styleable.NineGridView_ngv_two_strategy,
                Strategy.USUAL
            )
            threeStrategy = typedArray.getInt(
                R.styleable.NineGridView_ngv_three_strategy,
                Strategy.USUAL
            )
            fourStrategy = typedArray.getInt(
                R.styleable.NineGridView_ngv_four_strategy,
                Strategy.USUAL
            )
            extraStrategy = typedArray.getInt(
                R.styleable.NineGridView_ngv_extra_strategy,
                Strategy.SHOW
            )

            typedArray.recycle()
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        if (adapter == null || adapter?.getItemCount() == 0) {
            super.onMeasure(widthMeasureSpec, heightMeasureSpec)
            return
        }

        when (adapter!!.getItemCount()) {
            1 -> {
                measureSingleItem(widthMeasureSpec, heightMeasureSpec)
            }
            2 -> {
                measureTwoItem(widthMeasureSpec)
            }
            3 -> {
                measureThreeItem(widthMeasureSpec)
            }
            4 -> {
                measureFourItem(widthMeasureSpec)
            }
            else -> {
                measureItem(widthMeasureSpec, spanCount, getLineCount())
            }
        }

    }


    private fun getItemSize(
        widthMeasureSpec: Int,
        itemCount: Int = this.spanCount
    ) = (MeasureSpec.getSize(widthMeasureSpec) - (itemGap * (itemCount - 1))) / itemCount


    private fun measureItem(
        widthMeasureSpec: Int,
        itemCount: Int,
        lineCount: Int
    ) {
        val itemSize = getItemSize(widthMeasureSpec, itemCount)
        val width = MeasureSpec.getSize(widthMeasureSpec)
        val height = itemSize * lineCount + ((lineCount - 1) * itemGap)
        val childMeasureSpec = MeasureSpec.makeMeasureSpec(itemSize, MeasureSpec.EXACTLY)
        measureChildren(childMeasureSpec, childMeasureSpec)
        setMeasuredDimension(width, height)
    }


    private fun measureSingleItem(
        widthMeasureSpec: Int,
        heightMeasureSpec: Int
    ) {
        val width = MeasureSpec.getSize(widthMeasureSpec)
        val height = when (singleStrategy) {
            Strategy.FILL -> {
                measureChildren(widthMeasureSpec, widthMeasureSpec)
                width
            }
            Strategy.CUSTOM -> {
                measureChildren(widthMeasureSpec, heightMeasureSpec)
                getChildAt(0).measuredHeight
            }
            else -> {
                val itemsSize = getItemSize(widthMeasureSpec, spanCount)
                val itemMeasureSpec = MeasureSpec.makeMeasureSpec(itemsSize, MeasureSpec.EXACTLY)
                measureChildren(itemMeasureSpec, itemMeasureSpec)
                itemsSize
            }
        }
        setMeasuredDimension(width, height)
    }


    private fun measureTwoItem(widthMeasureSpec: Int) {
        when (twoStrategy) {
            Strategy.FILL -> {
                measureItem(widthMeasureSpec, 2, 1)
            }
            else -> {
                measureItem(widthMeasureSpec, spanCount, 1)
            }
        }
    }


    private fun measureThreeItem(widthMeasureSpec: Int) {
        when (threeStrategy) {
            Strategy.FILL -> {
                measureItem(widthMeasureSpec, spanCount, 1)
            }
            Strategy.BILI -> {
                measureItem(widthMeasureSpec, spanCount, 2)
            }
            else -> {//usual
                measureItem(widthMeasureSpec, spanCount, 1)
            }
        }
    }


    private fun measureFourItem(widthMeasureSpec: Int) {
        when (fourStrategy) {
            Strategy.FILL -> {
                measureItem(widthMeasureSpec, 2, 2)
            }
            Strategy.BILI -> {
                measureItem(widthMeasureSpec, spanCount, 2)
            }
            else -> {//usual
                measureItem(widthMeasureSpec, spanCount, getLineCount())
            }
        }
    }

    override fun onLayout(changed: Boolean, l: Int, t: Int, r: Int, b: Int) {
        layoutChildren()
    }

    override fun onFinishInflate() {
        super.onFinishInflate()
        if (isInEditMode) {
            adapter = InEditModeAdapter(maxCount)
        }
    }


    private fun performBind() {
        if (adapter == null) return
        post {
            for (index in 0 until childCount) {
                val viewType = adapter!!.getItemViewType(index)
                val child = getChildAt(index)
                if (child.layoutParams is ItemViewLayoutParams) {
                    val lp = child.layoutParams as ItemViewLayoutParams
                    when (lp.type) {
                        ItemViewLayoutParams.TYPE_ITEM_VIEW -> {
                            adapter!!.onBindItemView(child, viewType, index)
                        }
                        ItemViewLayoutParams.TYPE_EXTRA_VIEW -> {
                            adapter!!.onBindExtraView(child, viewType, index)
                        }
                        ItemViewLayoutParams.TYPE_SINGLE_VIEW -> {
                            adapter!!.onBindSingleView(child, viewType, index)
                        }
                    }
                }
            }
        }
    }


    private fun layoutChildren() {
        if (adapter == null) return

        when (childCount) {
            1 -> {
                layoutSingleItem()
            }
            2 -> {
                layoutTwoItem()
            }
            3 -> {
                layoutThreeItem()
            }
            4 -> {
                layoutFourItem()
            }
            else -> {
                layoutItem(spanCount)
            }
        }
        if (maxCount < childCount) {
            layoutExtraView()
        }

        performBind()
    }


    private fun layoutItem(skipLinePosition: Int) {
        var left = 0
        var top = 0
        var right = 0
        var bottom = 0

        val itemCount = getDisplayCount()
        for (i in 0 until itemCount) {
            val itemView = getChildAt(i)
            right = left + itemView.measuredWidth
            bottom = top + itemView.measuredHeight

            itemView.layout(left, top, right, bottom)

            if ((i + 1) % skipLinePosition == 0) {
                left = 0
                top = bottom + itemGap
            } else {
                left = right + itemGap
            }
        }
    }


    private fun layoutSingleItem() {
        val singleView = getChildAt(0)
        singleView.layout(0, 0, singleView.measuredWidth, singleView.measuredHeight)
    }


    private fun layoutTwoItem() {
        layoutItem(spanCount)
    }


    private fun layoutThreeItem() {
        when (threeStrategy) {
            Strategy.BILI -> {
                layoutItem(2)
            }
            else -> {
                layoutItem(spanCount)
            }
        }
    }


    private fun layoutFourItem() {
        when (fourStrategy) {
            Strategy.BILI, Strategy.FILL -> {
                layoutItem(2)
            }
            else -> {
                layoutItem(spanCount)
            }
        }
    }


    private fun layoutExtraView() {
        if (adapter == null) return
        if (extraStrategy == Strategy.SHOW && adapter!!.getItemCount() > maxCount) {
            val extraView = getChildAt(childCount - 1)
            val lastView = getChildAt(childCount - 2)

            val left = lastView.left
            val top = lastView.top
            val right = lastView.right
            val bottom = lastView.bottom

            extraView.layout(left, top, right, bottom)
        }
    }


    private fun addViews() {
        removeAllViewsInLayout()

        if (adapter == null || adapter!!.getItemCount() == 0) {
            requestLayout()
            return
        }

        val adapter = adapter ?: return
        val displayCount = getDisplayCount()
        var itemViewType = adapter.getItemViewType(0)


        val singleView = adapter.onCreateSingleView(this, itemViewType)
        if (singleStrategy == Strategy.CUSTOM && singleView != null && adapter.getItemCount() == 1) {
            val singleViewLayoutParams = createSingleViewLayoutParams(singleView)
            addViewInLayout(singleView, 0, singleViewLayoutParams, true)
            requestLayout()
            return
        }


        for (position in 0 until displayCount) {
            itemViewType = adapter.getItemViewType(position)
            val itemView = adapter.onCreateItemView(this, itemViewType)
            val itemViewLayoutParams = createItemViewLayoutParams(
                ItemViewLayoutParams.TYPE_ITEM_VIEW
            )
            addViewInLayout(itemView, position, itemViewLayoutParams, true)
        }


        if (adapter.getItemCount() > maxCount) {
            itemViewType = adapter.getItemViewType(displayCount)
            val extraView = adapter.onCreateExtraView(this, itemViewType)
            if (extraStrategy == Strategy.SHOW && extraView != null) {
                val layoutParams = createItemViewLayoutParams(ItemViewLayoutParams.TYPE_EXTRA_VIEW)
                addViewInLayout(extraView, displayCount, layoutParams, true)
            }
        }

        requestLayout()
    }


    private fun createSingleViewLayoutParams(singleView: View): LayoutParams {
        val layoutParams = ItemViewLayoutParams(
            LayoutParams.MATCH_PARENT,
            LayoutParams.MATCH_PARENT
        )
        layoutParams.type = ItemViewLayoutParams.TYPE_SINGLE_VIEW
        if (singleStrategy == Strategy.CUSTOM) {
            layoutParams.width = singleView.layoutParams.width
            layoutParams.height = singleView.layoutParams.height
        }
        return layoutParams
    }


    private fun createItemViewLayoutParams(type: Int): LayoutParams {
        val itemViewLayoutParams = ItemViewLayoutParams(
            LayoutParams.MATCH_PARENT,
            LayoutParams.MATCH_PARENT
        )
        itemViewLayoutParams.type = type
        return itemViewLayoutParams
    }

    //
    internal class ItemViewLayoutParams(
        width: Int,
        height: Int
    ) : ViewGroup.MarginLayoutParams(width, height) {

        companion object {
            const val TYPE_SINGLE_VIEW = 1
            const val TYPE_ITEM_VIEW = 2
            const val TYPE_EXTRA_VIEW = 3
        }

        var type: Int = TYPE_ITEM_VIEW
    }


    private fun getDisplayCount(): Int {
        if (adapter == null) return 0
        return if (adapter!!.getItemCount() > maxCount) maxCount else adapter!!.getItemCount()
    }


    private fun getLineCount(): Int {
        return ceil(getDisplayCount().toDouble() / spanCount).toInt()
    }


    abstract class Adapter {


        abstract fun getItemCount(): Int


        open fun getItemViewType(position: Int) = 0


        abstract fun onCreateItemView(
            parent: ViewGroup,
            viewType: Int
        ): View

        abstract fun onBindItemView(
            itemView: View,
            viewType: Int,
            position: Int
        )


        open fun onCreateSingleView(
            parent: ViewGroup,
            viewType: Int
        ): View? = null

        open fun onBindSingleView(
            singleView: View,
            viewType: Int,
            position: Int
        ) {

        }


        open fun onCreateExtraView(
            parent: ViewGroup,
            viewType: Int
        ): View? = null

        open fun onBindExtraView(
            extraView: View,
            viewType: Int,
            position: Int
        ) {

        }
    }
}