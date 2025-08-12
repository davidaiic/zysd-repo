package com.manle.phone.android.yaodian.activity

import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Log
import androidx.activity.result.ActivityResultLauncher
import androidx.annotation.RequiresApi
import androidx.camera.core.*
import androidx.core.content.ContextCompat
import coil.load
import com.app.base.AppConfig
import com.app.base.activity.BaseActivity
import com.app.base.app_use.bean.WebResponse
import com.app.base.ext.*
import com.app.base.lifecycle.KtxActivityManger
import com.app.base.utils.*
import com.app.base.utils.PopUtils.asScanConfirm
import com.app.base.viewmodel.BaseViewModel
import com.base.myzxing.CameraScan
import com.base.myzxing.DecodeConfig
import com.base.myzxing.DecodeFormatManager
import com.base.myzxing.DefaultCameraScan
import com.base.myzxing.analyze.MultiFormatAnalyzer
import com.base.myzxing.config.ResolutionCameraConfig
import com.base.myzxing.util.CodeUtils
import com.base.myzxing.util.PermissionUtils
import com.drake.net.Post
import com.drake.net.utils.scopeDialog

import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.ActivityScanBinding
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList
import com.google.zxing.Result
import com.lxj.xpopup.XPopup
import com.manle.phone.android.yaodian.bean.*
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.pop.ScanCodeCenterPopupView
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.flow.callbackFlow
import top.zibin.luban.Luban
import top.zibin.luban.OnCompressListener
import java.io.File
import java.net.URI



class ScanActivity : BaseActivity<BaseViewModel, ActivityScanBinding>
    (layoutId = R.layout.activity_scan), CameraScan.OnScanResultCallback {
    companion object {
        private const val FILENAME_FORMAT = "yyyy-MM-dd-HH-mm-ss-SSS"




        fun startAct( type: Int = 0, jumpType: Int = 0, webUserScan: Boolean = false,myActivityLauncher: ActivityResultLauncher<Intent>?=null) {
            KtxActivityManger.currentActivity?.apply {
                jumpByLogin {
                    if(null==myActivityLauncher){
                        startActivity<ScanActivity>(
                            AppConfig.KEY1 to type,
                            AppConfig.KEY2 to jumpType,
                            AppConfig.KEY3 to webUserScan
                        )
                    }else{
                        startActivityForResult<ScanActivity>(
                            myActivityLauncher,
                            AppConfig.KEY1 to type,
                            AppConfig.KEY2 to jumpType,
                            AppConfig.KEY3 to webUserScan,
                        )
                    }

                }
            }
        }

    }

    private val CAMERA_PERMISSION_REQUEST_CODE = 0X86



    lateinit var mCameraScan: DefaultCameraScan
    var config: ResolutionCameraConfig? = null
    var type by extraAct(AppConfig.KEY1, 0)
    var jumpType by extraAct(AppConfig.KEY2, 0)
    var webUserScan by extraAct(AppConfig.KEY3, false)
    override fun initView(savedInstanceState: Bundle?) {
        mBind.isOnlyShowScan = !webUserScan
        initCameraScan()
        startCamera()
        mBind.click = ProxyClick()
        if (type == 1) {
            ProxyClick().switchPhoto()
        }
    }

    override fun onStop() {
        super.onStop()
        mCameraScan.setAnalyzeImage(false)
    }

    override fun onResume() {
        super.onResume()
        if (type == 0) {
            mCameraScan.setAnalyzeImage(true)
        }
    }

    inner class ProxyClick {

        fun closeAct() {
            finish()
        }


        fun toggleTorchState() {
            val isTorch = mCameraScan.isTorchEnabled
            mCameraScan.enableTorch(!isTorch)
            mBind.ivFlashlight.isSelected = !isTorch
            mBind.ivFlashlight.text = if (isTorch) "轻触点亮" else "轻触关闭"
        }


        fun selectImg() {

            PictureSelector.create(this@ScanActivity)
                .openGallery(SelectMimeType.ofImage())
                .setImageEngine(CoilEngine())
                .setMaxSelectNum(1)
                .forResult(object : OnResultCallbackListener<LocalMedia> {
                    override fun onResult(result: ArrayList<LocalMedia>?) {
                        if (result != null) {
                            val path = result[0].realPath
                            when (type) {
                                1 -> {
                                    Luban.with(context)
                                        .load(result[0].realPath)
                                        .ignoreBy(100)
                                        .setTargetDir(context.cacheDir.absolutePath)
                                        .filter { path -> path.isNotEmpty() }
                                        .setCompressListener(object : OnCompressListener {
                                            override fun onStart() {

                                                showLoading()
                                                mBind.photoImgFl.visible()
                                            }

                                            override fun onSuccess(index: Int, compressFile: File?) {

                                                dismissLoading()
                                                compressFile?.let { file ->
                                                    mBind.photoImgIv.load(file.absolutePath)
                                                    imgRoc(file)
                                                }

                                            }

                                            override fun onError(index: Int, e: Throwable?) {

                                                showToast("识别失败")
                                                mBind.photoImgFl.gone()
                                                dismissLoading()
                                            }
                                        }).launch()
                                }
                                else -> {
                                    val string = CodeUtils.parseCode(BitmapFactory.decodeFile(path), if (webUserScan) DecodeFormatManager.TWO_DIMENSIONAL_HINTS else DecodeFormatManager.ONE_DIMENSIONAL_HINTS)
                                    if (string.isNullOrEmpty()) {
                                        asScanConfirm(title = if (webUserScan) "未识别到有效二维码" else "未识别到有效条形码", confirmListener = {
                                            mCameraScan.setAnalyzeImage(true)
                                        }).show()
                                        return
                                    }
                                    scanSearch(string)


                                }
                            }

                        }
                    }

                    override fun onCancel() {
                    }
                })
        }


        fun toScan() {
            mBind.fragmentTitleTv.text = "扫一扫"
            type = 0
            mBind.scanLl.visible()
            mBind.takePhotoIv.gone()
            mBind.toScanTv.setTextColor(R.color.white.getColor())
            mBind.toTakePhotoTv.setTextColor(R.color.color_70_ffffff.getColor())
            mCameraScan.setAnalyzeImage(true)

        }


        fun switchPhoto() {
            mBind.fragmentTitleTv.text = "拍照"
            type = 1
            mCameraScan.setAnalyzeImage(false)
            mBind.scanLl.gone()
            mBind.takePhotoIv.visible()
            mBind.toScanTv.setTextColor(R.color.color_70_ffffff.getColor())
            mBind.toTakePhotoTv.setTextColor(R.color.white.getColor())
        }


        fun takePhoto() {
            val name = SimpleDateFormat(FILENAME_FORMAT, Locale.CHINA)
                .format(System.currentTimeMillis())

            val contentValues = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, name)
                put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg")
                if (Build.VERSION.SDK_INT > Build.VERSION_CODES.P) {
                    put(MediaStore.Images.Media.RELATIVE_PATH, "Pictures/CameraX-Image")
                }
            }


            val outputOptions = ImageCapture.OutputFileOptions
                .Builder(
                    contentResolver,
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                    contentValues
                )
                .build()


            mCameraScan.imageCapture.takePicture(
                outputOptions,
                ContextCompat.getMainExecutor(this@ScanActivity),
                object : ImageCapture.OnImageSavedCallback {
                    override fun onError(exc: ImageCaptureException) {
                    }

                    @RequiresApi(Build.VERSION_CODES.Q)
                    override fun onImageSaved(output: ImageCapture.OutputFileResults) {

                        output.savedUri?.let {
                            Luban.with(context)
                                .load(it)
                                .setTargetDir(context.cacheDir.absolutePath)
                                .filter { path -> path.isNotEmpty() }
                                .setCompressListener(object : OnCompressListener {
                                    override fun onStart() {
                                        showLoading()
                                        mBind.photoImgFl.visible()
                                    }

                                    override fun onSuccess(index: Int, compressFile: File?) {
                                        dismissLoading()
                                        compressFile?.let { file ->
                                            mBind.photoImgIv.load(file.absolutePath)
                                            imgRoc(file)
                                        }

                                    }

                                    override fun onError(index: Int, e: Throwable?) {
                                        showToast("识别失败")
                                        mBind.photoImgFl.gone()
                                        dismissLoading()
                                    }
                                }).launch()
                        }
                    }
                }
            )
        }


        fun cancel() {
            mBind.photoImgFl.gone()
        }

    }



    private fun initCameraScan() {
        mCameraScan = DefaultCameraScan(this, mBind.previewView)
        mCameraScan.setOnScanResultCallback(this)

        val decodeConfig = DecodeConfig()
        decodeConfig.setHints(if (webUserScan) DecodeFormatManager.TWO_DIMENSIONAL_HINTS else DecodeFormatManager.ONE_DIMENSIONAL_HINTS) ////设置解码
            .setSupportVerticalCode(false)
            .setSupportLuminanceInvert(false)
            .setAreaRectRatio(0.8f)
            .isFullAreaScan = false

        config = ResolutionCameraConfig(this)
        mCameraScan
            .setPlayBeep(true)
            .setVibrate(true)
            .setCameraConfig(config)
            .setNeedAutoZoom(false)
            .setNeedTouchZoom(true)
            .setOnScanResultCallback(this)
            .setAnalyzer(MultiFormatAnalyzer(decodeConfig))
            .setAnalyzeImage(true)

    }


    private fun startCamera() {

        if (PermissionUtils.checkPermission(this, Manifest.permission.CAMERA)) {
            mCameraScan.startCamera()
        } else {
            PermissionUtils.requestPermission(this, Manifest.permission.CAMERA, CAMERA_PERMISSION_REQUEST_CODE)
        }

    }


    private fun releaseCamera() {
        mCameraScan.release()
    }


    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String?>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            requestCameraPermissionResult(permissions, grantResults)
        }
    }


    private fun requestCameraPermissionResult(permissions: Array<String?>, grantResults: IntArray) {
        if (PermissionUtils.requestPermissionsResult(Manifest.permission.CAMERA, permissions, grantResults)) {
            startCamera()
        } else {
            finish()
        }
    }

    override fun onDestroy() {
        releaseCamera()
        super.onDestroy()
    }


    override fun onScanResultCallback(result: Result?): Boolean {
        mCameraScan.setAnalyzeImage(false)
        result!!.text.logE("扫码")
        scanSearch(result.text)
        return true
    }


    private fun scanSearch(code: String) {
        if (webUserScan) {
            setResult(Activity.RESULT_OK, Intent().putExtras(AppConfig.KEY1 to code))
            finish()
            return
        }
        mCameraScan.setAnalyzeImage(false)
        scopeDialog {
            val data = Post<ScanDataBean>(Api.scan_code) {
                param("code", code)
            }.await()
            if (data.result == 0) {
                //无结果
                XPopup.Builder(context)
                    .dismissOnTouchOutside(false)
                    .dismissOnBackPressed(false)
                    .asConfirm(
                        "该条形码未查询到结果",
                        "请对准商品正面拍照",
                        "拍照",
                        "取消",
                        { mCameraScan.setAnalyzeImage(true) },
                        { ProxyClick().switchPhoto() },
                        false,
                        R.layout.pop_scan_center_confirm,
                    ).show()
            } else {
                //扫描有结果
                XPopup.Builder(context)
                    .dismissOnTouchOutside(false)
                    .dismissOnBackPressed(false)
                    .asCustom(
                        ScanCodeCenterPopupView(
                            activity = context,
                            name = data.goodsName,
                            switchPhoto = {
                                ProxyClick().switchPhoto()
                            }, toDetail = {
                                if (data.risk == 0 && jumpType == 0) {
                                    SearchDetailActivity.startAct(context, data.goodsId)
                                } else {
                                    WebActivity.start(WebResponse(url = WebConfig.h5 + data.linkUrl, title = data.serverName))
                                }

                            }, cancel = {
                                mCameraScan.setAnalyzeImage(true)
                            })
                    ).show()

            }

        }
    }


    private fun imgRoc(file: File) {
        scopeDialog {
            val bean = Post<ImgRocBean>(Api.img_recognition) {
                param("file", file)
            }.await()
            PicRecognitionActivity.startAct(this@ScanActivity, bean)
            mBind.photoImgFl.gone()
        }
    }

    override fun initImmersionBar() {
        setWhiteToolbar(mBind.toolbar)
    }


}