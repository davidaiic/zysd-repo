
package com.base.myzxing;

import android.Manifest;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.camera.view.PreviewView;

import com.base.myzxing.util.LogUtils;
import com.base.myzxing.util.PermissionUtils;
import com.google.zxing.Result;


public class CaptureActivity extends AppCompatActivity implements CameraScan.OnScanResultCallback {

    private static final int CAMERA_PERMISSION_REQUEST_CODE = 0X86;

    protected PreviewView previewView;
    protected ViewfinderView viewfinderView;
    protected View ivFlashlight;

    private CameraScan mCameraScan;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (isContentView()) {
            setContentView(getLayoutId());
        }
        initUI();
    }


    public void initUI() {
        previewView = findViewById(getPreviewViewId());
        int viewfinderViewId = getViewfinderViewId();
        if (viewfinderViewId != 0) {
            viewfinderView = findViewById(viewfinderViewId);
        }
        int ivFlashlightId = getFlashlightId();
        if (ivFlashlightId != 0) {
            ivFlashlight = findViewById(ivFlashlightId);
            if (ivFlashlight != null) {
                ivFlashlight.setOnClickListener(v -> onClickFlashlight());
            }
        }
        initCameraScan();
        startCamera();
    }


    protected void onClickFlashlight() {
        toggleTorchState();
    }

    public void initCameraScan() {
        mCameraScan = new DefaultCameraScan(this, previewView);
        mCameraScan.setOnScanResultCallback(this);
    }

    public void startCamera() {
        if (mCameraScan != null) {
            if (PermissionUtils.checkPermission(this, Manifest.permission.CAMERA)) {
                mCameraScan.startCamera();
            } else {
                LogUtils.d("checkPermissionResult != PERMISSION_GRANTED");
                PermissionUtils.requestPermission(this, Manifest.permission.CAMERA, CAMERA_PERMISSION_REQUEST_CODE);
            }
        }
    }


    private void releaseCamera() {
        if (mCameraScan != null) {
            mCameraScan.release();
        }
    }


    protected void toggleTorchState() {
        if (mCameraScan != null) {
            boolean isTorch = mCameraScan.isTorchEnabled();
            mCameraScan.enableTorch(!isTorch);
            if (ivFlashlight != null) {
                ivFlashlight.setSelected(!isTorch);
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == CAMERA_PERMISSION_REQUEST_CODE) {
            requestCameraPermissionResult(permissions, grantResults);
        }
    }

    public void requestCameraPermissionResult(@NonNull String[] permissions, @NonNull int[] grantResults) {
        if (PermissionUtils.requestPermissionsResult(Manifest.permission.CAMERA, permissions, grantResults)) {
            startCamera();
        } else {
            finish();
        }
    }

    @Override
    protected void onDestroy() {
        releaseCamera();
        super.onDestroy();
    }


    public boolean isContentView() {
        return true;
    }


    public int getLayoutId() {
        return R.layout.zxl_capture;
    }


    public int getViewfinderViewId() {
        return R.id.viewfinderView;
    }


    public int getPreviewViewId() {
        return R.id.previewView;
    }


    public int getFlashlightId() {
        return R.id.ivFlashlight;
    }


    public CameraScan getCameraScan() {
        return mCameraScan;
    }


    @Override
    public boolean onScanResultCallback(Result result) {
        return false;
    }
}