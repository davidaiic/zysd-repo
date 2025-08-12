
package com.base.myzxing.util;

import android.util.Log;

import java.util.Locale;


public class LogUtils {

    public static final String TAG = "ZXingLite";

    public static final String VERTICAL = "|";


    private static boolean isShowLog = true;


    private static int priority = 1;


    public static final int PRINTLN = 1;


    public static final int VERBOSE = 2;


    public static final int DEBUG = 3;


    public static final int INFO = 4;


    public static final int WARN = 5;


    public static final int ERROR = 6;


    public static final int ASSERT = 7;

    public static final String TAG_FORMAT = "%s.%s(%s:%d)";

    private LogUtils() {
        throw new AssertionError();
    }

    public static void setShowLog(boolean isShowLog) {

        LogUtils.isShowLog = isShowLog;
    }

    public static boolean isShowLog() {

        return isShowLog;
    }

    public static int getPriority() {

        return priority;
    }

    public static void setPriority(int priority) {

        LogUtils.priority = priority;
    }


    private static String generateTag(StackTraceElement caller) {
        String tag = TAG_FORMAT;
        String callerClazzName = caller.getClassName();
        callerClazzName = callerClazzName.substring(callerClazzName.lastIndexOf(".") + 1);
        tag = String.format(Locale.getDefault(), tag, callerClazzName, caller.getMethodName(), caller.getFileName(), caller.getLineNumber());
        return new StringBuilder().append(TAG).append(VERTICAL).append(tag).toString();
    }

    public static StackTraceElement getStackTraceElement(int n) {
        return Thread.currentThread().getStackTrace()[n];
    }


    private static String getCallerStackLogTag() {
        return generateTag(getStackTraceElement(5));
    }


    private static String getStackTraceString(Throwable t) {
        return Log.getStackTraceString(t);
    }


    public static void v(String msg) {
        if (isShowLog && priority <= VERBOSE)
            Log.v(getCallerStackLogTag(), String.valueOf(msg));

    }

    public static void v(Throwable t) {
        if (isShowLog && priority <= VERBOSE)
            Log.v(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void v(String msg, Throwable t) {
        if (isShowLog && priority <= VERBOSE)
            Log.v(getCallerStackLogTag(), String.valueOf(msg), t);
    }


    public static void d(String msg) {
        if (isShowLog && priority <= DEBUG)
            Log.d(getCallerStackLogTag(), String.valueOf(msg));
    }

    public static void d(Throwable t) {
        if (isShowLog && priority <= DEBUG)
            Log.d(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void d(String msg, Throwable t) {
        if (isShowLog && priority <= DEBUG)
            Log.d(getCallerStackLogTag(), String.valueOf(msg), t);
    }

    public static void i(String msg) {
        if (isShowLog && priority <= INFO)
            Log.i(getCallerStackLogTag(), String.valueOf(msg));
    }

    public static void i(Throwable t) {
        if (isShowLog && priority <= INFO)
            Log.i(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void i(String msg, Throwable t) {
        if (isShowLog && priority <= INFO)
            Log.i(getCallerStackLogTag(), String.valueOf(msg), t);
    }


    public static void w(String msg) {
        if (isShowLog && priority <= WARN)
            Log.w(getCallerStackLogTag(), String.valueOf(msg));
    }

    public static void w(Throwable t) {
        if (isShowLog && priority <= WARN)
            Log.w(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void w(String msg, Throwable t) {
        if (isShowLog && priority <= WARN)
            Log.w(getCallerStackLogTag(), String.valueOf(msg), t);
    }

    public static void e(String msg) {
        if (isShowLog && priority <= ERROR)
            Log.e(getCallerStackLogTag(), String.valueOf(msg));
    }

    public static void e(Throwable t) {
        if (isShowLog && priority <= ERROR)
            Log.e(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void e(String msg, Throwable t) {
        if (isShowLog && priority <= ERROR)
            Log.e(getCallerStackLogTag(), String.valueOf(msg), t);
    }


    public static void wtf(String msg) {
        if (isShowLog && priority <= ASSERT)
            Log.wtf(getCallerStackLogTag(), String.valueOf(msg));
    }

    public static void wtf(Throwable t) {
        if (isShowLog && priority <= ASSERT)
            Log.wtf(getCallerStackLogTag(), getStackTraceString(t));
    }

    public static void wtf(String msg, Throwable t) {
        if (isShowLog && priority <= ASSERT)
            Log.wtf(getCallerStackLogTag(), String.valueOf(msg), t);
    }

    public static void print(String msg) {
        if (isShowLog && priority <= PRINTLN)
            System.out.print(msg);
    }

    public static void print(Object obj) {
        if (isShowLog && priority <= PRINTLN)
            System.out.print(obj);
    }


    public static void printf(String msg) {
        if (isShowLog && priority <= PRINTLN)
            System.out.printf(msg);
    }


    public static void println(String msg) {
        if (isShowLog && priority <= PRINTLN)
            System.out.println(msg);
    }

    public static void println(Object obj) {
        if (isShowLog && priority <= PRINTLN)
            System.out.println(obj);
    }

}

