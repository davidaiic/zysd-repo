package com.manle.phone.android.yaodian.activity

import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.addAfterTextChanged
import com.app.base.ext.showToast
import com.app.base.utils.CoilEngine
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.brv.utils.divider
import com.drake.brv.utils.grid
import com.drake.brv.utils.setup
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.drake.tooltip.toast
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.CompressFileEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.ContentBean
import com.manle.phone.android.yaodian.bean.FooterBean
import com.manle.phone.android.yaodian.bean.UploadSuccessBean
import com.manle.phone.android.yaodian.databinding.ActivityPublishPostBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.AppCompressFileEngine
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import kotlinx.coroutines.Deferred
import top.zibin.luban.Luban
import top.zibin.luban.OnNewCompressListener
import java.io.File



class PublishPostActivity : BaseActivity<BaseViewModel, ActivityPublishPostBinding>(layoutId = R.layout.activity_publish_post) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.jumpByLogin {
                it.startActivity<PublishPostActivity>()
            }

        }
    }

    private val selImageList = mutableListOf<LocalMedia>()
    private val maxImgCount = 8 //允许选择图片最大数

    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "发布帖子")
        mBind.click = ProxyClick()
        mBind.et.addAfterTextChanged {
            if (it.text.length == 1000) {
                toast("最多输入1000字符！")
            }
        }

        initWidget()
    }

    inner class ProxyClick {

        fun toCriterion() {
            scopeNetLife {
                val data = Post<ContentBean>(Api.CONTET) {
                    param("keyword", "criterion")
                }.await()
                WebActivity.start(WebResponse(htmlContent = data.content, title = data.title))
            }
        }


        fun uploadImg() {
            val content = mBind.et.text.toString()
            if (content.isNullOrEmpty()) {
                showToast("请输入内容或上传图片")
                return
            }

            scopeDialog {
                var imgs = ""
                if (selImageList.isNotEmpty()) {
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
                Post<UploadSuccessBean>(Api.add_comment) {
                    param("content", if (content.isNullOrEmpty()) "" else content)
                    param("pictures", if (imgs.isEmpty()) imgs else imgs.substring(0, imgs.length - 1))
                }.await()
                sendEvent(true, AppConfig.PUBLISH_SUCCESS)
                finish()

            }
        }
    }


    private fun initWidget() {
        mBind.imgRv.grid(spanCount = 4)
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
                            override fun onResult(result: ArrayList<LocalMedia>?) {
                                result?.let { it1 ->
                                    selImageList.clear()
                                    selImageList.addAll(it1)
                                    mBind.imgRv.bindingAdapter.let { adapter ->
                                        if (selImageList.size == maxImgCount) {
                                            adapter.removeFooter(FooterBean())
                                        } else {
                                            if (adapter.footerCount == 0) {
                                                adapter.addFooter(FooterBean())
                                            }
                                        }
                                        mBind.imgRv.bindingAdapter.notifyDataSetChanged()
                                    }
                                }

                            }

                            override fun onCancel() {

                            }

                        })
                }
            }.models = selImageList
        mBind.imgRv.bindingAdapter.addFooter(FooterBean())


    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}