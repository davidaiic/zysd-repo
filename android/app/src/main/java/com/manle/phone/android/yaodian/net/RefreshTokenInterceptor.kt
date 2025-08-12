package com.manle.phone.android.yaodian.net

import com.drake.net.Net
import com.drake.net.NetConfig
import com.drake.net.exception.ConvertException
import com.drake.net.exception.ResponseException
import com.drake.net.request.kType
import okhttp3.Interceptor
import okhttp3.Response
import okio.BufferedSource
import org.json.JSONObject
import java.nio.charset.Charset


class RefreshTokenInterceptor(private val tokenErrorCode: Int, private val tokenError: () -> Unit = {}) : Interceptor {
    override fun intercept(chain: Interceptor.Chain): Response {
        val request = chain.request()
        val response = chain.proceed(request)

        return synchronized(RefreshTokenInterceptor::class.java) {

            try {
                val responseBody = response.body
                responseBody?.run {
                    val source: BufferedSource = responseBody.source()
                    source.request(Long.MAX_VALUE)
                    val buffer = source.buffer
                    val string = buffer.clone().readString(Charset.forName("UTF-8"))
                    val json = JSONObject(string)
                    if (json.getInt("code")==401) {
                        tokenError.invoke()
                    }
                }
            } catch (e: Exception) {
                response
            }
//            if (response.code == tokenErrorCode ) {
//                tokenError.invoke()
//            }
            response
        }
//        val request = chain.request()
//        val response = chain.proceed(request)
//        return synchronized(RefreshTokenInterceptor::class.java) {
//            if (response.isSuccessful  && JSONObject(response.body?.string().toString()).getInt("code") == tokenErrorCode) {
//                tokenError.invoke()
//                chain.proceed(request)
//            } else {
//                response
//            }
//        }


    }
}