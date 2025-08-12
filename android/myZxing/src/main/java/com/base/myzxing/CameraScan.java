package com.base.myzxing;

import android.content.Intent;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.camera.core.CameraSelector;

import com.base.myzxing.analyze.Analyzer;
import com.base.myzxing.analyze.AreaRectAnalyzer;
import com.base.myzxing.analyze.BarcodeFormatAnalyzer;
import com.base.myzxing.analyze.ImageAnalyzer;
import com.base.myzxing.analyze.MultiFormatAnalyzer;
import com.base.myzxing.config.CameraConfig;
import com.google.zxing.Result;
import com.google.zxing.qrcode.QRCodeReader;


public abstract class CameraScan implements ICamera, ICameraControl {


    public static String SCAN_RESULT = "SCAN_RESULT";


    public static int LENS_FACING_FRONT = CameraSelector.LENS_FACING_FRONT;

    public static int LENS_FACING_BACK = CameraSelector.LENS_FACING_BACK;


    private boolean isNeedAutoZoom = false;


    private boolean isNeedTouchZoom = true;


    protected boolean isNeedTouchZoom() {
        return isNeedTouchZoom;
    }


    public CameraScan setNeedTouchZoom(boolean needTouchZoom) {
        isNeedTouchZoom = needTouchZoom;
        return this;
    }

    protected boolean isNeedAutoZoom() {
        return isNeedAutoZoom;
    }


    public CameraScan setNeedAutoZoom(boolean needAutoZoom) {
        isNeedAutoZoom = needAutoZoom;
        return this;
    }


    public abstract CameraScan setCameraConfig(CameraConfig cameraConfig);


    public abstract CameraScan setAnalyzeImage(boolean analyze);


    public abstract CameraScan setAnalyzer(Analyzer analyzer);


    public abstract CameraScan setVibrate(boolean vibrate);


    public abstract CameraScan setPlayBeep(boolean playBeep);


    public abstract CameraScan setOnScanResultCallback(OnScanResultCallback callback);


    public abstract CameraScan bindFlashlightView(@Nullable View v);


    public abstract CameraScan setDarkLightLux(float lightLux);


    public abstract CameraScan setBrightLightLux(float lightLux);

    public interface OnScanResultCallback {

        boolean onScanResultCallback(Result result);


        default void onScanResultFailure() {

        }

    }

    @Nullable
    public static String parseScanResult(Intent data) {
        if (data != null) {
            return data.getStringExtra(SCAN_RESULT);
        }
        return null;
    }

}
