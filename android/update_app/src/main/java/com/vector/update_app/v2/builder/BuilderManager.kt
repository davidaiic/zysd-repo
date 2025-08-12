package com.vector.update_app.v2.builder

import android.content.Context
import com.vector.update_app.R
import com.vector.update_app.core.DownloadManager
import com.vector.update_app.utils.ALog
import com.vector.update_app.v2.AllenVersionChecker
import java.io.File


object BuilderManager {
    private var downloadBuilder: DownloadBuilder? = null
    lateinit var context: Context
    fun getDownloadBuilder(): DownloadBuilder? {
        return downloadBuilder
    }

    fun init(context: Context, downloadBuilder: DownloadBuilder): BuilderManager {
        this.context = context
        this.downloadBuilder = downloadBuilder
        return this
    }

    fun destroy() {
        downloadBuilder = null
    }


    fun checkAndDeleteAPK() {
        doWhenNotNull {
            try {
                val downloadPath: String = downloadAPKPath + context.getString(R.string.versionchecklib_download_apkname, context.packageName)
                if (!DownloadManager.checkAPKIsExists(context, downloadPath)) {
                    ALog.e("删除本地apk")
                    File(downloadPath).delete()
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

    }

    fun checkForceUpdate() {
        doWhenNotNull {
            forceUpdateListener?.onShouldForceUpdate()
        }
    }

    fun <T> doWhenNotNull(nullBlock: (() -> T)? = null, block: DownloadBuilder.() -> T): T? {
        val builder = downloadBuilder
        if (builder != null) {
            return builder.block()

        } else {
            nullBlock?.invoke()
            AllenVersionChecker.getInstance().cancelAllMission()
        }
        return null
    }

}