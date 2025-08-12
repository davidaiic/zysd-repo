package com.base.myzxing;

import android.graphics.Rect;

import androidx.annotation.FloatRange;

import com.base.myzxing.config.CameraConfig;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.DecodeHintType;
import com.google.zxing.common.GlobalHistogramBinarizer;
import com.google.zxing.common.HybridBinarizer;


import java.util.Map;

public class DecodeConfig {

    private Map<DecodeHintType, Object> hints = DecodeFormatManager.DEFAULT_HINTS;

    public static final float DEFAULT_AREA_RECT_RATIO = 0.8f;


    private boolean isMultiDecode = true;


    private boolean isSupportLuminanceInvert;

    private boolean isSupportLuminanceInvertMultiDecode;

    private boolean isSupportVerticalCode;

    private boolean isSupportVerticalCodeMultiDecode;


    private Rect analyzeAreaRect;


    private boolean isFullAreaScan = false;


    private float areaRectRatio = DEFAULT_AREA_RECT_RATIO;

    private int areaRectVerticalOffset;

    private int areaRectHorizontalOffset;

    public DecodeConfig() {

    }

    public Map<DecodeHintType, Object> getHints() {
        return hints;
    }


    public DecodeConfig setHints(Map<DecodeHintType, Object> hints) {
        this.hints = hints;
        return this;
    }


    public boolean isSupportLuminanceInvert() {
        return isSupportLuminanceInvert;
    }


    public DecodeConfig setSupportLuminanceInvert(boolean supportLuminanceInvert) {
        isSupportLuminanceInvert = supportLuminanceInvert;
        return this;
    }

    public boolean isSupportVerticalCode() {
        return isSupportVerticalCode;
    }


    public DecodeConfig setSupportVerticalCode(boolean supportVerticalCode) {
        isSupportVerticalCode = supportVerticalCode;
        return this;
    }

    public boolean isMultiDecode() {
        return isMultiDecode;
    }


    public DecodeConfig setMultiDecode(boolean multiDecode) {
        isMultiDecode = multiDecode;
        return this;
    }


    public boolean isSupportLuminanceInvertMultiDecode() {
        return isSupportLuminanceInvertMultiDecode;
    }


    public DecodeConfig setSupportLuminanceInvertMultiDecode(boolean supportLuminanceInvertMultiDecode) {
        isSupportLuminanceInvertMultiDecode = supportLuminanceInvertMultiDecode;
        return this;
    }


    public boolean isSupportVerticalCodeMultiDecode() {
        return isSupportVerticalCodeMultiDecode;
    }


    public DecodeConfig setSupportVerticalCodeMultiDecode(boolean supportVerticalCodeMultiDecode) {
        isSupportVerticalCodeMultiDecode = supportVerticalCodeMultiDecode;
        return this;
    }


    public Rect getAnalyzeAreaRect() {
        return analyzeAreaRect;
    }


    public DecodeConfig setAnalyzeAreaRect(Rect analyzeAreaRect) {
        this.analyzeAreaRect = analyzeAreaRect;
        return this;
    }


    public boolean isFullAreaScan() {
        return isFullAreaScan;
    }


    public DecodeConfig setFullAreaScan(boolean fullAreaScan) {
        isFullAreaScan = fullAreaScan;
        return this;
    }


    public float getAreaRectRatio() {
        return areaRectRatio;
    }


    public DecodeConfig setAreaRectRatio(@FloatRange(from = 0.5, to = 1.0) float areaRectRatio) {
        this.areaRectRatio = areaRectRatio;
        return this;
    }


    public int getAreaRectVerticalOffset() {
        return areaRectVerticalOffset;
    }


    public DecodeConfig setAreaRectVerticalOffset(int areaRectVerticalOffset) {
        this.areaRectVerticalOffset = areaRectVerticalOffset;
        return this;
    }


    public int getAreaRectHorizontalOffset() {
        return areaRectHorizontalOffset;
    }


    public DecodeConfig setAreaRectHorizontalOffset(int areaRectHorizontalOffset) {
        this.areaRectHorizontalOffset = areaRectHorizontalOffset;
        return this;
    }

    @Override
    public String toString() {
        return "DecodeConfig{" +
                "hints=" + hints +
                ", isMultiDecode=" + isMultiDecode +
                ", isSupportLuminanceInvert=" + isSupportLuminanceInvert +
                ", isSupportLuminanceInvertMultiDecode=" + isSupportLuminanceInvertMultiDecode +
                ", isSupportVerticalCode=" + isSupportVerticalCode +
                ", isSupportVerticalCodeMultiDecode=" + isSupportVerticalCodeMultiDecode +
                ", analyzeAreaRect=" + analyzeAreaRect +
                ", isFullAreaScan=" + isFullAreaScan +
                ", areaRectRatio=" + areaRectRatio +
                ", areaRectVerticalOffset=" + areaRectVerticalOffset +
                ", areaRectHorizontalOffset=" + areaRectHorizontalOffset +
                '}';
    }
}
