package com.manle.phone.android.yaodian.activity

import android.content.Intent
import android.os.Bundle
import androidx.fragment.app.FragmentActivity
import coil.load
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.ext.gone
import com.app.base.ext.logE
import com.app.base.ext.showToast
import com.app.base.ext.visible
import com.app.base.utils.CoilEngine
import com.app.base.utils.initToolBar
import com.app.base.utils.startActivity
import com.app.base.viewmodel.BaseViewModel
import com.drake.brv.utils.bindingAdapter
import com.drake.channel.receiveEvent
import com.drake.channel.sendEvent
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.drake.net.utils.scopeNetLife
import com.drake.net.utils.toRequestBody
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.databinding.ActivityUserCenterBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.AppCompressFileEngine
import com.manle.phone.android.yaodian.util.CacheUtil
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.internal.wait
import top.zibin.luban.Luban
import top.zibin.luban.OnCompressListener
import java.io.File


class UserCenterActivity : BaseActivity<BaseViewModel, ActivityUserCenterBinding>(R.layout.activity_user_center) {
    companion object {
        fun startAct(activity: FragmentActivity) {
            activity.startActivity<UserCenterActivity>()
        }
    }

    private val selImageList = mutableListOf<LocalMedia>()
    private var userBean = CacheUtil.getUser()
    override fun initView(savedInstanceState: Bundle?) {
        mBind.topBar.toolbar.initToolBar(activity = this, titleStr = "个人中心")
        if (null == userBean) {
            getUser()
        } else {
            mBind.user = userBean
        }

        mBind.click = ProxyClick()
    }


    private fun getUser() {
        scopeDialog {
            Post<ApiDetailBean<UserBean>>(Api.user_detail).await().info?.let {
                userBean = it
                mBind.user = it
                CacheUtil.setUser(it)
            }
        }
    }


    inner class ProxyClick {

        fun changeHead() {
            PictureSelector.create(context)
                .openGallery(SelectMimeType.ofImage())
                .setImageEngine(CoilEngine())
                .setSelectionMode(SelectModeConfig.SINGLE)
                .isDirectReturnSingle(true)
                .setSelectedData(selImageList)
                .setMaxSelectNum(1)
                .setMinSelectNum(1)
                .setImageSpanCount(4)
                .isDisplayCamera(true)
                .isPreviewImage(true)
                .setCameraImageFormat(PictureMimeType.JPEG)
                .isCameraRotateImage(false)
                .forResult(object : OnResultCallbackListener<LocalMedia> {
                    override fun onResult(result: ArrayList<LocalMedia>?) {

                        result?.get(0)?.let { it ->
                            selImageList.apply {
                                clear()
                                add(it)
                            }
                            scopeNetLife {
                                val file = File(if (it.isCompressed) it.compressPath else it.realPath)
                                val data = Post<UploadSuccessBean>(Api.change_user_head) {
                                    param("file", file)
                                }.await()
                                userBean?.let { user ->
                                    user.avatar = data.avatar
                                    mBind.user = user
                                    CacheUtil.setUser(user)
                                }
                                sendEvent(true, tag = AppConfig.CHANGE_USER_HEAD)
                                dismissLoading()
                            }.catch {
                                dismissLoading()
                                showToast("更换失败")
                            }
                        }
                    }

                    override fun onCancel() {
                    }

                })
        }



        fun changeNickName() {
            ChangeUserNameActivity.startAct(this@UserCenterActivity)

        }
    }


    override fun createObserver() {
        super.createObserver()
        receiveEvent<Boolean>(AppConfig.CHANGE_USER_NAME) {
            CacheUtil.getUser()?.let { user ->
                userBean = user
                mBind.user = user
            }

        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.topBar.toolbar)
    }
}