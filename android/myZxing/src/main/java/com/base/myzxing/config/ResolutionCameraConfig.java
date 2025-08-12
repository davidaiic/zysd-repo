package com.base.myzxing.config;

import android.content.Context;
import android.util.DisplayMetrics;
import android.util.Size;

import androidx.annotation.NonNull;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.Preview;


import com.base.myzxing.util.LogUtils;

import java.util.Locale;


public class ResolutionCameraConfig extends CameraConfig {


    public static final int IMAGE_QUALITY_1080P = 1080;

    public static final int IMAGE_QUALITY_720P = 720;


    private Size mTargetSize;


    public ResolutionCameraConfig(Context context) {
        this(context, IMAGE_QUALITY_1080P);
    }


    public ResolutionCameraConfig(Context context, int imageQuality) {
        super();
        initTargetResolutionSize(context, imageQuality);
    }


    private void initTargetResolutionSize(Context context, int imageQuality) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        int width = displayMetrics.widthPixels;
        int height = displayMetrics.heightPixels;

        LogUtils.d(String.format(Locale.getDefault(), "displayMetrics:%d x %d", width, height));
        if (width < height) {
            int size = Math.min(width, imageQuality);
            float ratio = width / (float) height;
            if (ratio > 0.7F) {
                mTargetSize = new Size(size, (int) (size / 3.0F * 4.0F));
            } else {
                mTargetSize = new Size(size, (int) (size / 9.0F * 16.0F));
            }
        } else {
            int size = Math.min(height, imageQuality);
            float ratio = height / (float) width;
            if (ratio > 0.7F) {
                mTargetSize = new Size((int) (size / 3.0F * 4.0F), size);
            } else {
                mTargetSize = new Size((int) (size / 9.0F * 16.0F), size);
            }
        }
        LogUtils.d("targetSize:" + mTargetSize);
    }

    @NonNull
    @Override
    public Preview options(@NonNull Preview.Builder builder) {
        return super.options(builder);
    }

    @NonNull
    @Override
    public CameraSelector options(@NonNull CameraSelector.Builder builder) {
        return super.options(builder);
    }

    @NonNull
    @Override
    public ImageAnalysis options(@NonNull ImageAnalysis.Builder builder) {
        builder.setTargetResolution(mTargetSize);
        return super.options(builder);
    }
}
