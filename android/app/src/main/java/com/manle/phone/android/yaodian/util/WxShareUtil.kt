package com.manle.phone.android.yaodian.util


import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Rect
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.PixelCopy
import android.view.View
import android.view.ViewGroup
import android.view.Window
import androidx.fragment.app.FragmentActivity
import com.drake.net.Post
import com.drake.net.utils.scopeDialog
import com.manle.phone.android.yaodian.App
import com.manle.phone.android.yaodian.App.Companion.wxApi
import com.manle.phone.android.yaodian.bean.ShareBean
import com.manle.phone.android.yaodian.databinding.AdapterCommentBinding
import com.manle.phone.android.yaodian.net.Api
import com.manle.phone.android.yaodian.util.CommUtils.shareToWx
import com.manle.phone.android.yaodian.util.WxShareUtil.getBitmap
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage
import com.tencent.mm.opensdk.modelmsg.WXMiniProgramObject
import java.io.ByteArrayOutputStream


object WxShareUtil {


    private fun buildTransaction(type: String?): String {
        return if (type == null) System.currentTimeMillis()
            .toString() else type + System.currentTimeMillis()
    }

    fun wxAppletShare(
        title: String,
        path: String,
        bitmap: Bitmap
    ) {

        val miniProgramObj = WXMiniProgramObject()
        miniProgramObj.webpageUrl = "http://www.qq.com";
        miniProgramObj.miniprogramType =
            WXMiniProgramObject.MINIPTOGRAM_TYPE_RELEASE
        miniProgramObj.userName="gh_15bcd961d4b4"
        miniProgramObj.path = path
        val msg = WXMediaMessage(miniProgramObj)

        msg.title = title
        msg.description = ""
        msg.thumbData = compressBitmap(bitmap,128)

        val req: SendMessageToWX.Req = SendMessageToWX.Req()
        req.transaction = buildTransaction("miniProgram")
        req.message = msg
        req.scene = SendMessageToWX.Req.WXSceneSession
        wxApi?.sendReq(req)
    }



    fun compressBitmap(bitmap: Bitmap, sizeLimit: Long): ByteArray {
        val baos = ByteArrayOutputStream()
        var quality = 100
        bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos)

        while (baos.toByteArray().size / 1024 > sizeLimit) {
            baos.reset()
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos)
            quality -= 10
        }
        return baos.toByteArray()
    }


    fun convertViewToBitmap(view: View): Bitmap {
        view.measure(
            View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED),
            View.MeasureSpec.makeMeasureSpec(0, View.MeasureSpec.UNSPECIFIED)
        )
        view.layout(0, 0, view.measuredWidth, view.measuredHeight)
        val bitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        view.draw(canvas)
        return bitmap
    }

    fun FragmentActivity.getBitmap(group: ViewGroup, bitmapCallback: (Bitmap) -> Unit) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { // Above Android O, use PixelCopy
            val bitmap = Bitmap.createBitmap(group.width, group.height, Bitmap.Config.ARGB_8888)
            val location = IntArray(2)
            group.getLocationInWindow(location)
            PixelCopy.request(
                window,
                Rect(location[0], location[1], location[0] + group.width, location[1] + group.height),
                bitmap,
                {
                    if (it == PixelCopy.SUCCESS) {
                        bitmapCallback.invoke(bitmap)
                    } else {

                    }
                },
                Handler(Looper.getMainLooper())
            )
        } else {
            var h = 0
            for (i in 0 until group.childCount) {
                h += group.getChildAt(i).height
            }

            val bitmapResult = Bitmap.createBitmap(group.width, h, Bitmap.Config.RGB_565)
            val canvas = Canvas(bitmapResult!!)
            group.draw(canvas)
            canvas.setBitmap(null)
            bitmapCallback.invoke(bitmapResult)
        }
    }
    fun ViewGroup.shareToWx(context:FragmentActivity,type:Int=1,id:String){
        context.shareToWx {
            context.scopeDialog {
                val shareBean = Post<ShareBean>(Api.app_share) {
                    param("type", type)
                    param("thirdId", id)
                }.await()
               context.getBitmap(this@shareToWx) {
                    wxAppletShare(title = shareBean.title, path = shareBean.path, it)
                }
            }
        }
    }

}
