package com.manle.phone.android.yaodian.vm


import android.text.Html
import android.util.Log
import android.view.View
import android.widget.TextView
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.scopeNetLife
import com.app.base.ext.*
import com.app.base.lifecycle.appContext
import com.app.base.view.dialog.extensions.bindingListenerFun
import com.app.base.view.dialog.extensions.dataConvertListenerFun
import com.app.base.view.dialog.extensions.newAppDialog
import com.app.base.view.dialog.other.DialogGravity
import com.app.base.viewmodel.BaseViewModel
import com.drake.net.NetConfig
import com.drake.net.Post
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.databinding.DialogProtocolBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CacheUtil
import com.vector.update_app.callback.APKDownloadListener
import com.vector.update_app.utils.AppUtils
import com.vector.update_app.v2.AllenVersionChecker
import com.vector.update_app.v2.BaseDialog
import com.vector.update_app.v2.builder.UIData
import com.vector.update_app.v2.callback.CustomVersionDialogListener
import java.io.File



class HomeViewModel : BaseViewModel() {
    val homeBean = MutableLiveData<HomeBean>()
    val refreshStop = MutableLiveData<Boolean>()

    val commeentList = MutableLiveData<CommentListBean>()

    val likeSuccess = MutableLiveData<Any>()


    fun getHomeData() = scopeNetLife {
        showLoading()
        homeBean.value = Post<HomeBean>(Api.HOMEINDEX).await()
    }.finally {
        refreshStop.value = true
        hideLoading()
    }

    fun getCommentList() = scopeNetLife {
        commeentList.value = Post<CommentListBean>(Api.COMMENT_LIST) {
            param("type", 1)
            param("page", 1)
        }.await()
    }


    fun setCommentLike(commentId: String, callBack: () -> Unit = {}) = scopeNetLife {
        Post<String>(Api.comment_like) {
            param("commentId", commentId)
        }.await()
        callBack.invoke()
    }


    fun updateApp() = scopeNetLife {
        val data = Post<AppVersionBean>(Api.check_version) {
            param("os", "android")
            param("version", AppUtils.getVersionName(appContext))
        }.await()
        if (data.isUpdate != 0) {
            updateNewApp(data)
        }

    }


    private fun updateNewApp(appVersionBean: AppVersionBean) {
        val uiData = UIData.create()
        uiData.downloadUrl = appVersionBean.info.downloadUrl
        uiData.content = appVersionBean.info.content
        AllenVersionChecker
            .getInstance().downloadOnly(uiData).apply {
                isShowNotification = false
                isShowDownloadingDialog = true
                isShowDownloadFailDialog = true
                apkDownloadListener = object : APKDownloadListener {
                    override fun onDownloading(progress: Int) {
                        if (progress == 1) {
                            Log.e("下载---", "$progress")
                        }

                    }

                    override fun onDownloadSuccess(file: File) {
                        Log.e("下载---", "${file.absolutePath}")
                    }

                    override fun onDownloadFail() {
                        Log.e("下载---", "失败")
                    }
                }
                customVersionDialogListener = CustomVersionDialogListener { context, versionBundle ->
                    val baseDialog = BaseDialog(context, R.style.BaseDialog, R.layout.pop_update_app)
                    val textView: TextView = baseDialog.findViewById(R.id.tv_msg)
                    val cancelTv: TextView = baseDialog.findViewById(R.id.versionchecklib_version_dialog_cancel)
                    val centerView: View = baseDialog.findViewById(R.id.centerView)

                    if (appVersionBean.info.isMust == 3) {
                        cancelTv.visibility = View.GONE
                        centerView.visibility = View.GONE
                    } else {
                        cancelTv.visibility = View.VISIBLE
                        centerView.visibility = View.VISIBLE
                    }
                    textView.text = versionBundle.content.toHtml()
                    return@CustomVersionDialogListener baseDialog
                }
            }.executeMission(appContext)


    }

}