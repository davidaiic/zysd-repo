package com.manle.phone.android.yaodian.activity

import android.annotation.SuppressLint
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.showToast
import com.app.base.utils.extraAct
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.utils.*
import com.google.android.flexbox.FlexboxLayoutManager
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.PicTextBean
import com.manle.phone.android.yaodian.databinding.ActivityCopyTextBinding
import com.manle.phone.android.yaodian.view.SlidingCheckLayout
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json



class CopyTextActivity : BaseActivity<BaseViewModel, ActivityCopyTextBinding>(R.layout.activity_copy_text), SlidingCheckLayout.OnSlidingPositionListener {
    companion object {
        fun startAct(activity: FragmentActivity, picTextBean: PicTextBean) {
            activity.startActivity<CopyTextActivity>(AppConfig.KEY1 to Json.encodeToString(picTextBean))
        }
    }

    val json by extraAct(AppConfig.KEY1, "")
    lateinit var picTextBean: PicTextBean

    @SuppressLint("ClickableViewAccessibility")
    override fun initView(savedInstanceState: Bundle?) {
        picTextBean = Json.decodeFromString(PicTextBean.serializer(), json)
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "提取文字")
        mBind.click = ProxyClick()

        mBind.scl.setOnSlidingPositionListener(this)
        mBind.rv.layoutManager = FlexboxLayoutManager(context)
        mBind.rv.divider {
            setDivider(width = 5, dp = true)
            orientation = DividerOrientation.VERTICAL
        }.divider {
            setDivider(width = 15, dp = true)
            orientation = DividerOrientation.HORIZONTAL
        }.setup {
            addType<PicTextBean.Word> { R.layout.item_copy_text }
            R.id.copyTv.onClick {
                val model = getModel<PicTextBean.Word>()
                model.selected = !model.selected
                notifyItemChanged(modelPosition)
            }
        }.models = picTextBean.words



    }


    var copyText = ""

    inner class ProxyClick {

        fun selectAll() {
            (mBind.rv.mutable as MutableList<PicTextBean.Word>).forEach {
                it.selected = true
            }
            mBind.rv.bindingAdapter.notifyDataSetChanged()

        }

        fun copy() {
            copyText = ""
            (mBind.rv.mutable as MutableList<PicTextBean.Word>).forEach {
                if (it.selected) {
                    copyText += it.text
                }
            }
            if(copyText.isNullOrEmpty()){
                showToast("无内容可复制")
                return
            }
            val cm: ClipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val mClipData = ClipData.newPlainText("Label", copyText)
            cm.setPrimaryClip(mClipData)
            showToast("内容已复制")
        }


        fun search() {
            copyText = ""
            (mBind.rv.mutable as MutableList<PicTextBean.Word>).forEach {
                if (it.selected) {
                    copyText += it.text
                }
            }
            if(copyText.isNullOrEmpty()){
                showToast("无内容")
                return
            }
            SearchActivity.startAct(copyText)


        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }

    override fun onSlidingPosition(position: Int) {
        val model = mBind.rv.bindingAdapter.mutable[position] as PicTextBean.Word
        model.selected = !model.selected
        mBind.rv.bindingAdapter.notifyItemChanged(position)

    }

    override fun onSlidingRangePosition(startPosition: Int, endPosition: Int) {
        for (i in startPosition..endPosition) {
            val model = mBind.rv.bindingAdapter.mutable[i] as PicTextBean.Word
            model.selected = !model.selected
        }
        mBind.rv.bindingAdapter.notifyItemRangeChanged(startPosition, endPosition - startPosition + 1)
    }
}