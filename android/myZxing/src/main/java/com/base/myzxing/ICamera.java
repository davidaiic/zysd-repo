package com.base.myzxing;

import androidx.annotation.Nullable;
import androidx.camera.core.Camera;


public interface ICamera {


    void startCamera();

    void stopCamera();

    @Nullable
    Camera getCamera();

    void release();

}
