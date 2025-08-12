package com.base.myzxing.config;

import android.content.Context;
import android.util.DisplayMetrics;

import androidx.annotation.NonNull;
import androidx.camera.core.AspectRatio;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.Preview;

import com.base.myzxing.util.LogUtils;



public final class AspectRatioCameraConfig extends CameraConfig {

    private int mAspectRatio;

    public AspectRatioCameraConfig(Context context) {
        super();
        initTargetAspectRatio(context);
    }


    private void initTargetAspectRatio(Context context) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        int width = displayMetrics.widthPixels;
        int height = displayMetrics.heightPixels;

        float ratio = Math.max(width, height) / Math.min(width, height);
        if (Math.abs(ratio - 4.0F / 3.0F) < Math.abs(ratio - 16.0F / 9.0F)) {
            mAspectRatio = AspectRatio.RATIO_4_3;
        } else {
            mAspectRatio = AspectRatio.RATIO_16_9;
        }
        LogUtils.d("aspectRatio:" + mAspectRatio);
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
        builder.setTargetAspectRatio(mAspectRatio);
        return super.options(builder);
    }
}

