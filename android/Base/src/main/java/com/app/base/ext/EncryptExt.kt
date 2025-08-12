package com.app.base.ext

import android.os.Build
import android.provider.Settings
import android.util.Base64
import com.app.base.lifecycle.appContext
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec


fun md5(sourceStr: String): String {
    var md5 = ""
    try {
        val md = MessageDigest.getInstance("MD5")
        md.update(sourceStr.toByteArray())
        val b = md.digest()
        var i: Int
        val buf = StringBuilder("")
        for (aB in b) {
            i = aB.toInt()
            if (i < 0) i += 256
            if (i < 16) buf.append("0")
            buf.append(Integer.toHexString(i))
        }
        md5 = buf.toString()
    } catch (e: NoSuchAlgorithmException) {
        e.printStackTrace()
    }
    return md5
}








