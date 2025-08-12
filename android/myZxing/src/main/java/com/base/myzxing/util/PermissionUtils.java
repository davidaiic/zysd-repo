package com.base.myzxing.util;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;

import androidx.annotation.IntRange;
import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;
import androidx.fragment.app.Fragment;


public class PermissionUtils {

    private PermissionUtils() {
        throw new AssertionError();
    }


    public static boolean checkPermission(@NonNull Context context, @NonNull String permission) {
        return ActivityCompat.checkSelfPermission(context, permission) == PackageManager.PERMISSION_GRANTED;
    }


    public static void requestPermission(@NonNull Activity activity, @NonNull String permission, @IntRange(from = 0) int requestCode) {
        requestPermissions(activity, new String[]{permission}, requestCode);
    }


    public static void requestPermission(@NonNull Fragment fragment, @NonNull String permission, @IntRange(from = 0) int requestCode) {
        requestPermissions(fragment, new String[]{permission}, requestCode);
    }


    public static void requestPermissions(@NonNull Activity activity, @NonNull String[] permissions, @IntRange(from = 0) int requestCode) {
        ActivityCompat.requestPermissions(activity, permissions, requestCode);
    }


    public static void requestPermissions(@NonNull Fragment fragment, @NonNull String[] permissions, @IntRange(from = 0) int requestCode) {
        fragment.requestPermissions(permissions, requestCode);
    }


    public static boolean requestPermissionsResult(@NonNull String requestPermission, @NonNull String[] permissions, @NonNull int[] grantResults) {
        int length = permissions.length;
        for (int i = 0; i < length; i++) {
            if (requestPermission.equals(permissions[i])) {
                if (grantResults[i] == PackageManager.PERMISSION_GRANTED) {
                    return true;
                }
            }
        }
        return false;
    }


    public static boolean requestPermissionsResult(@NonNull String[] requestPermissions, @NonNull String[] permissions, @NonNull int[] grantResults) {
        int length = permissions.length;
        for (int i = 0; i < length; i++) {
            for (int j = 0; j < requestPermissions.length; j++) {
                if (requestPermissions[j].equals(permissions[i])) {
                    if (grantResults[i] != PackageManager.PERMISSION_GRANTED) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

}
