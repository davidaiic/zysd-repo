package com.base.myzxing;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.view.MotionEvent;
import android.view.ScaleGestureDetector;
import android.view.View;

import androidx.annotation.FloatRange;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.camera.core.Camera;
import androidx.camera.core.CameraInfo;
import androidx.camera.core.CameraSelector;
import androidx.camera.core.FocusMeteringAction;
import androidx.camera.core.ImageAnalysis;
import androidx.camera.core.ImageCapture;
import androidx.camera.core.MeteringPoint;
import androidx.camera.core.Preview;
import androidx.camera.core.TorchState;
import androidx.camera.core.ZoomState;
import androidx.camera.lifecycle.ProcessCameraProvider;
import androidx.camera.view.PreviewView;
import androidx.core.content.ContextCompat;
import androidx.fragment.app.Fragment;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.MutableLiveData;

import com.base.myzxing.analyze.Analyzer;
import com.base.myzxing.analyze.MultiFormatAnalyzer;
import com.base.myzxing.config.CameraConfig;
import com.base.myzxing.manager.AmbientLightManager;
import com.base.myzxing.manager.BeepManager;
import com.base.myzxing.util.LogUtils;
import com.google.common.util.concurrent.ListenableFuture;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.Result;
import com.google.zxing.ResultPoint;
import com.google.zxing.common.detector.MathUtils;

import java.util.concurrent.Executors;


public class DefaultCameraScan extends CameraScan {


    private static final int HOVER_TAP_TIMEOUT = 150;


    private static final int HOVER_TAP_SLOP = 20;


    private static final float ZOOM_STEP_SIZE = 0.1F;

    private FragmentActivity mFragmentActivity;
    private Context mContext;
    private LifecycleOwner mLifecycleOwner;
    private PreviewView mPreviewView;

    public ListenableFuture<ProcessCameraProvider> mCameraProviderFuture;
    private Camera mCamera;

    private CameraConfig mCameraConfig;
    private Analyzer mAnalyzer;


    private volatile boolean isAnalyze = true;


    private volatile boolean isAnalyzeResult;

    private View flashlightView;

    private MutableLiveData<Result> mResultLiveData;

    private OnScanResultCallback mOnScanResultCallback;

    private BeepManager mBeepManager;
    private AmbientLightManager mAmbientLightManager;

    private int mOrientation;
    private int mImageWidth;
    private int mImageHeight;
    private long mLastAutoZoomTime;
    private long mLastHoveTapTime;
    private boolean isClickTap;
    private float mDownX;
    private float mDownY;
    public ImageCapture imageCapture;
    public DefaultCameraScan(@NonNull FragmentActivity activity, @NonNull PreviewView previewView) {
        this.mFragmentActivity = activity;
        this.mLifecycleOwner = activity;
        this.mContext = activity;
        this.mPreviewView = previewView;
        initData();
    }

    public DefaultCameraScan(@NonNull Fragment fragment, @NonNull PreviewView previewView) {
        this.mFragmentActivity = fragment.getActivity();
        this.mLifecycleOwner = fragment;
        this.mContext = fragment.getContext();
        this.mPreviewView = previewView;
        initData();
    }


    private ScaleGestureDetector.OnScaleGestureListener mOnScaleGestureListener = new ScaleGestureDetector.SimpleOnScaleGestureListener() {
        @Override
        public boolean onScale(ScaleGestureDetector detector) {
            float scale = detector.getScaleFactor();
            if (mCamera != null) {
                float ratio = mCamera.getCameraInfo().getZoomState().getValue().getZoomRatio();
                zoomTo(ratio * scale);
                return true;
            }
            return false;
        }

    };


    @SuppressLint("ClickableViewAccessibility")
    private void initData() {
        mResultLiveData = new MutableLiveData<>();
        mResultLiveData.observe(mLifecycleOwner, result -> {
            if (result != null) {
                handleAnalyzeResult(result);
            } else if (mOnScanResultCallback != null) {
                mOnScanResultCallback.onScanResultFailure();
            }
        });

        mOrientation = mContext.getResources().getConfiguration().orientation;

        ScaleGestureDetector scaleGestureDetector = new ScaleGestureDetector(mContext, mOnScaleGestureListener);
        mPreviewView.setOnTouchListener((v, event) -> {
            handlePreviewViewClickTap(event);
            if (isNeedTouchZoom()) {
                return scaleGestureDetector.onTouchEvent(event);
            }
            return false;
        });

        mBeepManager = new BeepManager(mContext);
        mAmbientLightManager = new AmbientLightManager(mContext);
        mAmbientLightManager.register();
        mAmbientLightManager.setOnLightSensorEventListener((dark, lightLux) -> {
            if (flashlightView != null) {
                if (dark) {
                    if (flashlightView.getVisibility() != View.VISIBLE) {
                        flashlightView.setVisibility(View.VISIBLE);
                        flashlightView.setSelected(isTorchEnabled());
                    }
                } else if (flashlightView.getVisibility() == View.VISIBLE && !isTorchEnabled()) {
                    flashlightView.setVisibility(View.INVISIBLE);
                    flashlightView.setSelected(false);
                }
            }
        });
    }


    private void handlePreviewViewClickTap(MotionEvent event) {
        if (event.getPointerCount() == 1) {
            switch (event.getAction()) {
                case MotionEvent.ACTION_DOWN:
                    isClickTap = true;
                    mDownX = event.getX();
                    mDownY = event.getY();
                    mLastHoveTapTime = System.currentTimeMillis();
                    break;
                case MotionEvent.ACTION_MOVE:
                    isClickTap = MathUtils.distance(mDownX, mDownY, event.getX(), event.getY()) < HOVER_TAP_SLOP;
                    break;
                case MotionEvent.ACTION_UP:
                    if (isClickTap && mLastHoveTapTime + HOVER_TAP_TIMEOUT > System.currentTimeMillis()) {
                        startFocusAndMetering(event.getX(), event.getY());
                    }
                    break;
            }
        }
    }


    private void startFocusAndMetering(float x, float y) {
        if (mCamera != null) {
            MeteringPoint point = mPreviewView.getMeteringPointFactory().createPoint(x, y);
            FocusMeteringAction focusMeteringAction = new FocusMeteringAction.Builder(point).build();
            if (mCamera.getCameraInfo().isFocusMeteringSupported(focusMeteringAction)) {
                mCamera.getCameraControl().startFocusAndMetering(focusMeteringAction);
                LogUtils.d("startFocusAndMetering:" + x + "," + y);
            }
        }
    }

    private void initConfig() {
        if (mCameraConfig == null) {
            mCameraConfig = new CameraConfig();
        }
        if (mAnalyzer == null) {
            mAnalyzer = new MultiFormatAnalyzer();
        }
    }


    @Override
    public CameraScan setCameraConfig(CameraConfig cameraConfig) {
        if (cameraConfig != null) {
            this.mCameraConfig = cameraConfig;
        }
        return this;
    }

    @Override
    public void startCamera() {
        initConfig();
        mCameraProviderFuture = ProcessCameraProvider.getInstance(mContext);
        mCameraProviderFuture.addListener(() -> {

            try {
                Preview preview = mCameraConfig.options(new Preview.Builder());

                CameraSelector cameraSelector = mCameraConfig.options(new CameraSelector.Builder());
                preview.setSurfaceProvider(mPreviewView.getSurfaceProvider());
                imageCapture = new ImageCapture.Builder().build();
                ImageAnalysis imageAnalysis = mCameraConfig.options(new ImageAnalysis.Builder()
                        .setOutputImageFormat(ImageAnalysis.OUTPUT_IMAGE_FORMAT_YUV_420_888)
                        .setBackpressureStrategy(ImageAnalysis.STRATEGY_KEEP_ONLY_LATEST));
                imageAnalysis.setAnalyzer(Executors.newSingleThreadExecutor(), image -> {
                    mImageWidth = image.getWidth();
                    mImageHeight = image.getHeight();
                    if (isAnalyze && !isAnalyzeResult && mAnalyzer != null) {
                        Result result = mAnalyzer.analyze(image, mOrientation);
                        mResultLiveData.postValue(result);
                    }
                    image.close();
                });
                if (mCamera != null) {
                    mCameraProviderFuture.get().unbindAll();
                }
                mCamera = mCameraProviderFuture.get().bindToLifecycle(mLifecycleOwner, cameraSelector, preview, imageCapture,imageAnalysis);
            } catch (Exception e) {
                LogUtils.e(e);
            }

        }, ContextCompat.getMainExecutor(mContext));
    }


    private synchronized void handleAnalyzeResult(Result result) {

        if (isAnalyzeResult || !isAnalyze) {
            return;
        }
        isAnalyzeResult = true;
        if (mBeepManager != null) {
            mBeepManager.playBeepSoundAndVibrate();
        }

        if (result.getBarcodeFormat() == BarcodeFormat.QR_CODE && isNeedAutoZoom() && mLastAutoZoomTime + 100 < System.currentTimeMillis()) {
            ResultPoint[] points = result.getResultPoints();
            if (points != null && points.length >= 2) {
                float distance1 = ResultPoint.distance(points[0], points[1]);
                float maxDistance = distance1;
                if (points.length >= 3) {
                    float distance2 = ResultPoint.distance(points[1], points[2]);
                    float distance3 = ResultPoint.distance(points[0], points[2]);
                    maxDistance = Math.max(Math.max(distance1, distance2), distance3);
                }
                if (handleAutoZoom((int) maxDistance, result)) {
                    return;
                }
            }
        }

        scanResultCallback(result);
    }


    private boolean handleAutoZoom(int distance, Result result) {
        int size = Math.min(mImageWidth, mImageHeight);
        if (distance * 4 < size) {
            mLastAutoZoomTime = System.currentTimeMillis();
            zoomIn();
            scanResultCallback(result);
            return true;
        }
        return false;
    }


    private void scanResultCallback(Result result) {
        if (mOnScanResultCallback != null && mOnScanResultCallback.onScanResultCallback(result)) {
            isAnalyzeResult = false;
            return;
        }

        if (mFragmentActivity != null) {
            Intent intent = new Intent();
            intent.putExtra(SCAN_RESULT, result.getText());
            mFragmentActivity.setResult(Activity.RESULT_OK, intent);
            mFragmentActivity.finish();
        }
    }

    @Override
    public void stopCamera() {
        if (mCameraProviderFuture != null) {
            try {
                mCameraProviderFuture.get().unbindAll();
            } catch (Exception e) {
                LogUtils.e(e);
            }
        }
    }

    @Override
    public CameraScan setAnalyzeImage(boolean analyze) {
        isAnalyze = analyze;
        return this;
    }

    @Override
    public CameraScan setAnalyzer(Analyzer analyzer) {
        mAnalyzer = analyzer;
        return this;
    }


    @Override
    public void zoomIn() {
        if (mCamera != null) {
            float ratio = getCameraInfo().getZoomState().getValue().getZoomRatio() + ZOOM_STEP_SIZE;
            float maxRatio = getCameraInfo().getZoomState().getValue().getMaxZoomRatio();
            if (ratio <= maxRatio) {
                mCamera.getCameraControl().setZoomRatio(ratio);
            }
        }
    }

    @Override
    public void zoomOut() {
        if (mCamera != null) {
            float ratio = getCameraInfo().getZoomState().getValue().getZoomRatio() - ZOOM_STEP_SIZE;
            float minRatio = getCameraInfo().getZoomState().getValue().getMinZoomRatio();
            if (ratio >= minRatio) {
                mCamera.getCameraControl().setZoomRatio(ratio);
            }
        }
    }

    @Override
    public void zoomTo(float ratio) {
        if (mCamera != null) {
            ZoomState zoomState = getCameraInfo().getZoomState().getValue();
            float maxRatio = zoomState.getMaxZoomRatio();
            float minRatio = zoomState.getMinZoomRatio();
            float zoom = Math.max(Math.min(ratio, maxRatio), minRatio);
            mCamera.getCameraControl().setZoomRatio(zoom);
        }
    }

    @Override
    public void lineZoomIn() {
        if (mCamera != null) {
            float zoom = getCameraInfo().getZoomState().getValue().getLinearZoom() + ZOOM_STEP_SIZE;
            if (zoom <= 1f) {
                mCamera.getCameraControl().setLinearZoom(zoom);
            }
        }
    }

    @Override
    public void lineZoomOut() {
        if (mCamera != null) {
            float zoom = getCameraInfo().getZoomState().getValue().getLinearZoom() - ZOOM_STEP_SIZE;
            if (zoom >= 0f) {
                mCamera.getCameraControl().setLinearZoom(zoom);
            }
        }
    }

    @Override
    public void lineZoomTo(@FloatRange(from = 0.0, to = 1.0) float linearZoom) {
        if (mCamera != null) {
            mCamera.getCameraControl().setLinearZoom(linearZoom);
        }
    }

    @Override
    public void enableTorch(boolean torch) {
        if (mCamera != null && hasFlashUnit()) {
            mCamera.getCameraControl().enableTorch(torch);
        }
    }

    @Override
    public boolean isTorchEnabled() {
        if (mCamera != null) {
            return mCamera.getCameraInfo().getTorchState().getValue() == TorchState.ON;
        }
        return false;
    }

    @Override
    public boolean hasFlashUnit() {
        if (mCamera != null) {
            return mCamera.getCameraInfo().hasFlashUnit();
        }
        return mContext.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH);
    }

    @Override
    public CameraScan setVibrate(boolean vibrate) {
        if (mBeepManager != null) {
            mBeepManager.setVibrate(vibrate);
        }
        return this;
    }

    @Override
    public CameraScan setPlayBeep(boolean playBeep) {
        if (mBeepManager != null) {
            mBeepManager.setPlayBeep(playBeep);
        }
        return this;
    }

    @Override
    public CameraScan setOnScanResultCallback(OnScanResultCallback callback) {
        this.mOnScanResultCallback = callback;
        return this;
    }

    @Nullable
    @Override
    public Camera getCamera() {
        return mCamera;
    }

    private CameraInfo getCameraInfo() {
        return mCamera.getCameraInfo();
    }

    @Override
    public void release() {
        isAnalyze = false;
        flashlightView = null;
        if (mAmbientLightManager != null) {
            mAmbientLightManager.unregister();
        }
        if (mBeepManager != null) {
            mBeepManager.close();
        }
        stopCamera();
    }

    @Override
    public CameraScan bindFlashlightView(@Nullable View v) {
        flashlightView = v;
        if (mAmbientLightManager != null) {
            mAmbientLightManager.setLightSensorEnabled(v != null);
        }
        return this;
    }

    @Override
    public CameraScan setDarkLightLux(float lightLux) {
        if (mAmbientLightManager != null) {
            mAmbientLightManager.setDarkLightLux(lightLux);
        }
        return this;
    }

    @Override
    public CameraScan setBrightLightLux(float lightLux) {
        if (mAmbientLightManager != null) {
            mAmbientLightManager.setBrightLightLux(lightLux);
        }
        return this;
    }

}
