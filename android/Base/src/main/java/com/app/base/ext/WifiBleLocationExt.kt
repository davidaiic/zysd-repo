package com.app.base.ext

import android.annotation.SuppressLint
import android.content.Context
import android.location.LocationManager
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.TelephonyManager
import androidx.appcompat.app.AppCompatActivity
import com.app.base.lifecycle.appContext
import java.lang.reflect.Method




val mWifiManager by lazy { appContext.applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager }


fun getWifiName(): String = mWifiManager.connectionInfo.ssid



fun isLocServiceEnable(): Boolean {
    val locationManager = appContext.getSystemService(Context.LOCATION_SERVICE) as LocationManager
    val gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    val network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    return gps || network
}


fun getMobileDataEnabled(): Boolean {
    try {
        val tm = appContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager? ?: return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return tm.isDataEnabled
        }
        @SuppressLint("PrivateApi") val getMobileDataEnabledMethod: Method? = tm.javaClass.getDeclaredMethod("getDataEnabled")
        if (null != getMobileDataEnabledMethod) {
            return getMobileDataEnabledMethod.invoke(tm) as Boolean
        }
    } catch (e: Exception) {
        e.toString().logE("getMobileDataEnabled")
    }
    return false
}


fun getNetworkOperatorName(): String? {
    val tm = appContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager? ?: return ""
    return tm.networkOperatorName
}


 fun isOpenGPS(): Boolean {
    val locationManager = appContext.getSystemService(AppCompatActivity.LOCATION_SERVICE) as LocationManager
    val gps = locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)
    val network = locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
    return gps || network
}




