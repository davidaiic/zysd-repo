package com.base.myzxing;

import androidx.annotation.FloatRange;


public interface ICameraControl {

    void zoomIn();

    void zoomOut();

    void zoomTo(float ratio);

    void lineZoomIn();

    void lineZoomOut();

    void lineZoomTo(@FloatRange(from = 0.0, to = 1.0) float linearZoom);

    void enableTorch(boolean torch);

    boolean isTorchEnabled();

    boolean hasFlashUnit();
}
