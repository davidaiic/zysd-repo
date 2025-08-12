@file:Suppress("UNCHECKED_CAST", "MemberVisibilityCanBePrivate")

package com.manle.phone.android.yaodian.net


import com.drake.net.NetConfig
import com.drake.net.convert.NetConverter
import com.drake.net.exception.ConvertException
import com.drake.net.exception.RequestParamsException
import com.drake.net.exception.ResponseException
import com.drake.net.exception.ServerResponseException
import com.drake.net.request.kType
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer
import okhttp3.Response
import org.json.JSONException
import org.json.JSONObject
import java.lang.reflect.Type
import kotlin.reflect.KType

class SerializationConverter(
    val success: String = "200",
    val code: String = "code",
    val message: String = "message",
) : NetConverter {

    companion object {
        val jsonDecoder = Json {
            ignoreUnknownKeys = true
            coerceInputValues = true
        }
    }

    override fun <R> onConvert(succeed: Type, response: Response): R? {
        try {
            return NetConverter.onConvert<R>(succeed, response)
        } catch (e: ConvertException) {
            val code = response.code
            when {
                code in 200..299 -> {
                    val bodyString = response.body?.string() ?: return null
                    val kType = response.request.kType
                        ?: throw ConvertException(response, "Request does not contain KType")
                    return try {
                        val json = JSONObject(bodyString)
                        val srvCode = json.getString(this.code)
                        if (srvCode == success) { // 对比后端自定义错误码
                            json.getString("data").parseBody<R>(kType)
                        } else {

                            val errorMessage = json.optString(message, NetConfig.app.getString(com.drake.net.R.string.no_error_message))
                            throw ResponseException(response, errorMessage, tag = srvCode)
                        }
                    } catch (e: JSONException) {
                        bodyString.parseBody<R>(kType)
                    }
                }
                code in 400..499 -> throw RequestParamsException(response, code.toString())
                code >= 500 -> throw ServerResponseException(response, code.toString())
                else -> throw ConvertException(response)
            }
        }
    }

    fun <R> String.parseBody(succeed: KType): R? {
        return jsonDecoder.decodeFromString(Json.serializersModule.serializer(succeed), this) as R
    }
}