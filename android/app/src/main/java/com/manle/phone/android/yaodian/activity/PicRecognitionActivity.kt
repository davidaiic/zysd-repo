package com.manle.phone.android.yaodian.activity

import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.scopeNetLife
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.utils.extraAct
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.drake.brv.annotaion.DividerOrientation
import com.drake.brv.utils.*
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.databinding.ActivityPicRecognitionBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.vm.PicRecognitionViewModel
import kotlinx.serialization.DeserializationStrategy
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.w3c.dom.Text


class PicRecognitionActivity : BaseActivity<PicRecognitionViewModel, ActivityPicRecognitionBinding>(R.layout.activity_pic_recognition) {
    companion object {
        fun startAct(activity: FragmentActivity, imgRocBean: ImgRocBean) {
            activity.startActivity<PicRecognitionActivity>(AppConfig.KEY1 to Json.encodeToString(imgRocBean))
        }
    }

    var search: String = ""
    private val json by extraAct(AppConfig.KEY1, "")
    lateinit var imgRocBean: ImgRocBean
    override fun initView(savedInstanceState: Bundle?) {
        imgRocBean = Json.decodeFromString(ImgRocBean.serializer(), json)
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "图片识别结果", rightText = "重拍", onRightClick = {
            finish()
        })
        mBind.data = imgRocBean
        mBind.click = ProxyClick()


        imgRocBean.let {
            it.keywords[0].apply {
                selected = true
                search = name
            }
            mBind.searchTagRv.grid(spanCount = 2)
                .divider {
                    setDivider(width = 15, dp = true)
                    orientation = DividerOrientation.GRID
                }.setup {
                    addType<ImgRocBean.KeywordBean> { R.layout.adapter_pic_recognition }
                    R.id.item.onClick {
                        (mutable as MutableList<ImgRocBean.KeywordBean>).forEachIndexed { index, keywordBean ->
                            keywordBean.selected = modelPosition == index
                        }
                        notifyDataSetChanged()
                        val model = getModel<ImgRocBean.KeywordBean>()
                        search = model.name
                        mBind.prl.index = 1
                        getHot()
                    }
                }.models = it.keywords
        }


        mBind.searchRv.grid(spanCount = 2)
            .divider {
                setDivider(width = 15, dp = true)
                orientation = DividerOrientation.GRID
            }.setup {
                addType<GoodsBean> { R.layout.adapter_goods }
                R.id.item.onClick {
                    val model = getModel<GoodsBean>()
                    SearchDetailActivity.startAct(this@PicRecognitionActivity, model.goodsId)
                }
            }
        mBind.prl.onLoadMore {
            getHot()
        }
        getHot()
    }


    fun getHot() {
        scopeDialog {
            val data = Post<GoodsListBean>(Api.home_search) {
                param("keyword", search)
                param("page", mBind.prl.index)
            }.await()
            mBind.prl.addData(data.goodsList, mBind.searchRv.bindingAdapter) {
                data.goodsList.size == 20
            }
        }

    }

    inner class ProxyClick {

        fun getTextRv() {
            scopeDialog {
                val data = Post<PicTextBean>(Api.extract_text) {
                    param("imageId", imgRocBean.imageId)
                }.await()
                CopyTextActivity.startAct(context, data)
            }

        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}