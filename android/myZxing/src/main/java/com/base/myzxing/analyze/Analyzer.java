package com.base.myzxing.analyze;

import android.content.res.Configuration;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.camera.core.ImageProxy;

import com.google.zxing.Result;


public interface Analyzer {


    @Nullable
    Result analyze(@NonNull ImageProxy image, int orientation);
}
