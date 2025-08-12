package com.app.base.net.manager;

import static android.Manifest.permission.ACCESS_WIFI_STATE;
import static android.content.Context.WIFI_SERVICE;
import static com.app.base.ext.WifiBleLocationExtKt.getMobileDataEnabled;
import static com.app.base.ext.WifiBleLocationExtKt.getNetworkOperatorName;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.text.TextUtils;

import androidx.annotation.RequiresPermission;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.util.Enumeration;



public class NetworkUtil {
    public static String url = "http://www.baidu.com";



    private static int TIMEOUT = 3000;



    public static boolean isNetworkAvailable(Context context) {
        ConnectivityManager manager = (ConnectivityManager) context.getApplicationContext().getSystemService(
                Context.CONNECTIVITY_SERVICE);
        if (null == manager) {
            return false;
        }
        NetworkInfo info = manager.getActiveNetworkInfo();
        return null != info && info.isAvailable();
    }











}
