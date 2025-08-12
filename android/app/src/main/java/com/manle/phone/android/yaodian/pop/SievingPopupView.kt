package com.manle.phone.android.yaodian.pop

import android.content.Context
import androidx.databinding.DataBindingUtil
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.utils.*
import com.lxj.xpopup.impl.PartShadowPopupView
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.SievingBean
import com.manle.phone.android.yaodian.databinding.DialogSievingBinding


class SievingPopupView(context: Context, val bean: SievingBean, val onSubmitClick: (sortId: String, labelId: String) -> Unit = { s: String, s1: String -> }) : PartShadowPopupView(context) {
    lateinit var binding: DialogSievingBinding
    override fun getImplLayoutId(): Int {
        return R.layout.dialog_sieving
    }

    var sortId = ""
    var labelId = ""
    override fun onCreate() {
        super.onCreate()
        binding = DataBindingUtil.bind(popupImplView)!!
        binding.sortRv.grid(spanCount = 4)
            .divider {
                setDivider(8, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<SievingBean.Sort> { R.layout.adapter_sort }
                R.id.item.onClick {
                    (mutable as MutableList<SievingBean.Sort>).forEach {
                        it.isSelected = false
                    }
                    val model = getModel<SievingBean.Sort>()
                    model.isSelected = true
                    model.notifyChange()
                }

            }.models = bean.sortList
        binding.labelRv.grid(spanCount = 4)
            .divider {
                setDivider(8, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<SievingBean.Label> { R.layout.adapter_label }
                R.id.item.onClick {
                    val model = getModel<SievingBean.Label>()
                    model.isSelected = !model.isSelected
                    model.notifyChange()
                }
            }.models = bean.labelList
        binding.click = ProxyClick()

    }

    inner class ProxyClick {

        fun reset() {
            (binding.sortRv.bindingAdapter.mutable as MutableList<SievingBean.Sort>).forEach {
                it.isSelected = false
            }
            binding.sortRv.bindingAdapter.notifyDataSetChanged()
            (binding.labelRv.bindingAdapter.mutable as MutableList<SievingBean.Label>).forEach {
                it.isSelected = false
            }
            binding.labelRv.bindingAdapter.notifyDataSetChanged()
            sortId = ""
            labelId = ""
        }


        fun submit() {
            (binding.sortRv.bindingAdapter.mutable as MutableList<SievingBean.Sort>).forEach {
                if (it.isSelected) {
                    sortId = it.sortId
                }
            }
            labelId = ""
            (binding.labelRv.bindingAdapter.mutable as MutableList<SievingBean.Label>).forEach {
                if (it.isSelected) {
                    labelId = labelId + "," + it.labelId
                }
            }
            if (labelId.isNotEmpty()) {
                labelId = labelId.substring(1, labelId.length)
            }

            onSubmitClick(sortId, labelId)

        }
    }
}