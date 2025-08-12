package com.vector.update_app.utils;

import android.util.Log;

import com.vector.update_app.core.AllenChecker;



public class ALog {
    public static void e(String msg) {
        if (AllenChecker.isDebug()) {
            if (msg != null && !msg.isEmpty())
                Log.e("Allen Checker", msg);
        }
    }
}
