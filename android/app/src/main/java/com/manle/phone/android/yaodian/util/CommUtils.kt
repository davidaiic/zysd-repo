package com.manle.phone.android.yaodian.util

import android.content.ContentResolver
import android.content.Context
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.FileUtils
import android.text.SpannableString
import android.text.Spanned
import android.text.style.TextAppearanceSpan
import android.webkit.MimeTypeMap
import android.widget.ImageView
import androidx.annotation.RequiresApi
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentActivity
import com.app.base.AppConfig
import com.app.base.app_use.ext.showLoadingExt
import com.app.base.ext.screenWidth
import com.app.base.ext.showToast
import com.app.base.view.dialog.extensions.bindingListenerFun
import com.app.base.view.dialog.extensions.dataConvertListenerFun
import com.app.base.view.dialog.extensions.newAppDialog
import com.app.base.view.dialog.other.DialogGravity
import com.app.base.view.nine.NineGridView
import com.drake.channel.sendEvent
import com.luck.picture.lib.utils.PictureFileUtils.getPath
import com.lxj.xpopup.XPopup
import com.lxj.xpopup.util.SmartGlideImageLoader
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.DialogShareToWxBinding
import com.manle.phone.android.yaodian.net.NetUseConfig
import com.manle.phone.android.yaodian.util.CommUtils.jumpByLogin
import org.json.JSONObject
import top.zibin.luban.Luban
import top.zibin.luban.OnCompressListener
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.util.*
import java.util.regex.Pattern
import kotlin.math.roundToInt


object CommUtils {

    fun FragmentActivity.jumpByLogin(loginSuccessCall: Boolean = true, action: (FragmentActivity) -> Unit) {
        val isLogin = CacheUtil.isLogin()
        if (isLogin) {
            action(this)
        } else {
            showLoadingExt()
            PhoneLoginUtil.login(this) {
                if (loginSuccessCall) {
                    action(this)
                }
            }
        }
    }


    fun Fragment.jumpByLogin(loginSuccessCall: Boolean = true, action: (Fragment) -> Unit) {
        if (NetUseConfig.isLogin) {
            action(this)
        } else {
            requireActivity().showLoadingExt()
            PhoneLoginUtil.login(requireActivity()) {
                if (loginSuccessCall) {
                    action(this)
                }
            }

        }
    }


    fun setMatcherText(mContext: Context?, text: String?, style: Int, vararg key: String): SpannableString? {
        val ss = SpannableString(text)
        for (i in key.indices) {
            val pat = Pattern.quote("" + key[i])
            val pattern = Pattern.compile(pat)
            val matcher = pattern.matcher(ss)
            while (matcher.find()) {
                val start = matcher.start()
                val end = matcher.end()
                ss.setSpan(TextAppearanceSpan(mContext, style), start, end, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE) //new ForegroundColorSpan(color)
            }
        }
        return ss
    }


    fun showImage(context: Context, nineGridView: NineGridView, imageView: ImageView, position: Int, images: List<String>) {
        XPopup.Builder(context).asImageViewer(
            imageView, position, images, false, true, -1, -1, -1, false,
            Color.rgb(32, 36, 46), { popupView, position ->
                popupView.updateSrcView(nineGridView.getChildAt(position) as ImageView)
            }, SmartGlideImageLoader(), null
        )
            .show()
    }


    fun FragmentActivity.shareToWx(shareCall: () -> Unit = {}) {
        newAppDialog {
            layoutId = R.layout.dialog_share_to_wx
            gravity = DialogGravity.CENTER_BOTTOM
            width = screenWidth
            outCancel = true
            touchCancel = true
            animStyle = R.style.BottomTransAlphaADAnimation
            bindingListenerFun<DialogShareToWxBinding>(this@shareToWx) { binding, dialog ->
                binding.lifecycleOwner = dialog.viewLifecycleOwner
            }
            dataConvertListenerFun<DialogShareToWxBinding> { binding, dialog ->
                binding.shareTv.setOnClickListener {
                    dialog.dismiss()
                    shareCall.invoke()
                }
                binding.cancleTv.setOnClickListener {
                    dialog.dismiss()
                }
            }
        }.showOnWindow(supportFragmentManager)
    }


    @RequiresApi(Build.VERSION_CODES.Q)
    fun uriToFileApiQ(uri: Uri?, context: Context): File? {
        var file: File? = null
        if (uri == null) return null

        if (uri.scheme.equals(ContentResolver.SCHEME_FILE)) {
            file = uri.path?.let { File(it) }
        } else if (uri.scheme.equals(ContentResolver.SCHEME_CONTENT)) {
            val contentResolver = context.contentResolver
            val displayName = "${System.currentTimeMillis() + ((Math.random() + 1) * 1000).roundToInt()}.${MimeTypeMap.getSingleton().getExtensionFromMimeType(contentResolver.getType(uri))}"
            try {
                val inputStream: InputStream? = contentResolver.openInputStream(uri)
                val cache = File(context.cacheDir.absolutePath, displayName)
                val fos = FileOutputStream(cache)
                inputStream?.let { FileUtils.copy(it, fos) }
                file = cache
                fos.close()
                inputStream?.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
        }


        return file
    }

    fun String.showErrorMessage(success: () -> Unit = {}, error: (message: String) -> Unit = {}) {
        val jsonObject = JSONObject(this)
        if (jsonObject.getInt("code") == 200) {
            success()
        } else {
            error(jsonObject.getString("message"))
        }
    }
}