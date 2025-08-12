package com.manle.phone.android.yaodian.pop

import android.content.Context
import android.net.Uri
import android.view.inputmethod.EditorInfo
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.FragmentActivity
import androidx.recyclerview.widget.RecyclerView
import com.app.base.AppConfig
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.showToast
import com.app.base.utils.CoilEngine
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.grid
import com.drake.brv.utils.setup
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.CompressFileEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnKeyValueResultCallbackListener
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.lxj.xpopup.core.BottomPopupView
import com.lxj.xpopup.util.KeyboardUtils
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.activity.WebActivity
import com.manle.phone.android.yaodian.bean.ContentBean
import com.manle.phone.android.yaodian.bean.FooterBean
import com.manle.phone.android.yaodian.bean.UploadSuccessBean
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.AppCompressFileEngine
import kotlinx.coroutines.Deferred
import java.io.File


class CommentPop(val activity: FragmentActivity, val type: Int, val id: String = "") : BottomPopupView(activity) {
    private val selImageList = mutableListOf<LocalMedia>()
    private val maxImgCount = 8
    override fun getImplLayoutId(): Int {
        return R.layout.pop_commnet
    }

    var contentBean: ContentBean = ContentBean()
    lateinit var imgRv: RecyclerView
    lateinit var commentEt: EditText
    override fun onCreate() {
        super.onCreate()
        imgRv = findViewById<RecyclerView>(R.id.imgRv)
        commentEt = findViewById<EditText>(R.id.et)
        activity.scopeNetLife {
            contentBean = Post<ContentBean>(Api.CONTET) {
                param("keyword", "criterion")
            }.await()
        }
        findViewById<TextView>(R.id.gyTv).setOnClickListener {
            WebActivity.start(WebResponse(htmlContent = contentBean.content, title = contentBean.title, isUserHtmlTitle = false))
        }
        commentEt.setOnEditorActionListener { _, actionId, _ ->
            return@setOnEditorActionListener when (actionId) {
                EditorInfo.IME_ACTION_SEND -> {
                    sendComment()
                    true
                }
                else -> false
            }
        }
        initWidget()
    }


    private fun sendComment() {

        val content = commentEt.text.toString()
        if (content.isNullOrEmpty()) {
            showToast("请输入内容")
            return
        }

        activity.scopeDialog {
            var imgs = ""
            if (selImageList.size > 0) {
                val jobList = mutableListOf<Deferred<UploadSuccessBean>>()
                selImageList.forEach {
                    val file = File(if (it.isCompressed) it.compressPath else it.realPath)
                    val job: Deferred<UploadSuccessBean> = Post<UploadSuccessBean>(Api.uploadImg) {
                        param("file", file)
                        param("type", "photo")
                    }
                    jobList.add(job)
                }

                jobList.forEach {
                    imgs = imgs + it.await().url + ","
                }
            }
            if (type == 1) {
                Post<UploadSuccessBean>(Api.add_comment) {
                    param("commentId", id)
                    param("content", if (content.isNullOrEmpty()) "" else content)
                    param("pictures", if (imgs.isEmpty()) imgs else imgs.substring(0, imgs.length - 1))

                }.await()
                sendEvent(true, AppConfig.PUBLISH_SUCCESS)
            } else {
                Post<UploadSuccessBean>(Api.add_article_comment) {
                    param("articleId", id)
                    param("content", if (content.isNullOrEmpty()) "" else content)
                    param("pictures", if (imgs.isEmpty()) imgs else imgs.substring(0, imgs.length - 1))
                }.await()
                sendEvent(true, AppConfig.NEW_COMMENT_SUCCESS)
            }


            dismiss()
        }
    }

    private fun initWidget() {
        imgRv.grid(spanCount = 4)
            .divider {
                setDivider(width = 10, dp = true)
            }.setup {
                addType<LocalMedia> { R.layout.adapter_img }
                addType<FooterBean>(R.layout.adapter_add_img)
                R.id.picIv.onClick {
                    PictureSelector.create(context)
                        .openPreview()
                        .setImageEngine(CoilEngine())
                        .startActivityPreview(modelPosition, false, selImageList as ArrayList<LocalMedia>?);
                }
                R.id.deleteImgIv.onClick {
                    mutable.removeAt(modelPosition)
                    if (mutable.size < maxImgCount && footerCount == 0) {
                        adapter.addFooter(FooterBean())
                    }
                    notifyDataSetChanged()
                }
                R.id.addPicIv.onClick {
                    KeyboardUtils.hideSoftInput(commentEt)
                    PictureSelector.create(context)
                        .openGallery(SelectMimeType.ofImage())
                        .setImageEngine(CoilEngine())
                        .setSelectedData(selImageList)
                        .setMaxSelectNum(maxImgCount)
                        .setMinSelectNum(1)
                        .setImageSpanCount(4)
                        .setSelectionMode(SelectModeConfig.MULTIPLE)
                        .isDisplayCamera(true)
                        .isPreviewImage(true)
                        .setCameraImageFormat(PictureMimeType.JPEG)
                        .isCameraRotateImage(false)
                        .setCompressEngine(AppCompressFileEngine())
                        .forResult(object : OnResultCallbackListener<LocalMedia> {
                            override fun onResult(result: java.util.ArrayList<LocalMedia>?) {
                                KeyboardUtils.showSoftInput(commentEt)
                                result?.let { it1 ->
                                    selImageList.clear()
                                    selImageList.addAll(it1)
                                    imgRv.bindingAdapter.let { adapter ->
                                        if (selImageList.size == maxImgCount) {
                                            adapter.removeFooter(FooterBean())
                                        } else {
                                            if (adapter.footerCount == 0) {
                                                adapter.addFooter(FooterBean())
                                            }
                                        }
                                        imgRv.bindingAdapter.notifyDataSetChanged()
                                    }
                                }

                            }

                            override fun onCancel() {
                                KeyboardUtils.showSoftInput(commentEt)
                            }


                        })
                }
            }.models = selImageList
        imgRv.bindingAdapter.addFooter(FooterBean())


    }
}