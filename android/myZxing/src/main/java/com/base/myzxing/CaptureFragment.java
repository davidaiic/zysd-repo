
package com.base.myzxing;

import android.Manifest;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.camera.view.PreviewView;
import androidx.fragment.app.Fragment;

import com.base.myzxing.util.LogUtils;
import com.base.myzxing.util.PermissionUtils;
import com.google.zxing.Result;

public class CaptureFragment extends Fragment implements CameraScan.OnScanResultCallback {

    private static final int CAMERA_PERMISSION_REQUEST_CODE = 0X86;

    private View mRootView;

    protected PreviewView previewView;
    protected ViewfinderView viewfinderView;
    protected View ivFlashlight;

    private CameraScan mCameraScan;

    public static CaptureFragment newInstance() {

        Bundle args = new Bundle();

        CaptureFragment fragment = new CaptureFragment();
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        if (isContentView()) {
            mRootView = createRootView(inflater, container);
        }
        initUI();
        return mRootView;
    }


    public void initUI() {
        previewView = mRootView.findViewById(getPreviewViewId());
        int viewfinderViewId = getViewfinderViewId();
        if (viewfinderViewId != 0) {
            viewfinderView = mRootView.findViewById(viewfinderViewId);
        }
        int ivFlashlightId = getFlashlightId();
        if (ivFlashlightId != 0) {
            ivFlashlight = mRootView.findViewById(ivFlashlightId);
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
            if (PermissionUtils.checkPermission(getContext(), Manifest.permission.CAMERA)) {
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
            getActivity().finish();
        }
    }

    @Override
    public void onDestroy() {
        releaseCamera();
        super.onDestroy();
    }

    public boolean isContentView() {
        return true;
    }


    @NonNull
    public View createRootView(LayoutInflater inflater, ViewGroup container) {
        return inflater.inflate(getLayoutId(), container, false);
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



    public View getRootView() {
        return mRootView;
    }

}
