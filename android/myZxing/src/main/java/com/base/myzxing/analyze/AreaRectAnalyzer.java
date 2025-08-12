package com.base.myzxing.analyze;

import android.graphics.Rect;

import androidx.annotation.Nullable;

import com.base.myzxing.DecodeConfig;
import com.base.myzxing.DecodeFormatManager;
import com.google.zxing.DecodeHintType;
import com.google.zxing.Result;

import java.util.Map;


public abstract class AreaRectAnalyzer extends ImageAnalyzer {

    DecodeConfig mDecodeConfig;
    Map<DecodeHintType, ?> mHints;
    boolean isMultiDecode = true;
    private float mAreaRectRatio = DecodeConfig.DEFAULT_AREA_RECT_RATIO;
    private int mAreaRectHorizontalOffset = 0;
    private int mAreaRectVerticalOffset = 0;

    public AreaRectAnalyzer(@Nullable DecodeConfig config) {
        this.mDecodeConfig = config;
        if (config != null) {
            mHints = config.getHints();
            isMultiDecode = config.isMultiDecode();
            mAreaRectRatio = config.getAreaRectRatio();
            mAreaRectHorizontalOffset = config.getAreaRectHorizontalOffset();
            mAreaRectVerticalOffset = config.getAreaRectVerticalOffset();
        } else {
            mHints = DecodeFormatManager.DEFAULT_HINTS;
        }

    }

    @Nullable
    @Override
    public Result analyze(byte[] data, int width, int height) {
        if (mDecodeConfig != null) {
            if (mDecodeConfig.isFullAreaScan()) {
                return analyze(data, width, height, 0, 0, width, height);
            }

            Rect rect = mDecodeConfig.getAnalyzeAreaRect();
            if (rect != null) {
                return analyze(data, width, height, rect.left, rect.top, rect.width(), rect.height());
            }
        }


        int size = (int) (Math.min(width, height) * mAreaRectRatio);
        int left = (width - size) / 2 + mAreaRectHorizontalOffset;
        int top = (height - size) / 2 + mAreaRectVerticalOffset;

        return analyze(data, width, height, left, top, size, size);

    }

    @Nullable
    public abstract Result analyze(byte[] data, int dataWidth, int dataHeight, int left, int top, int width, int height);

}
