package com.vector.update_app.v2.callback;

import androidx.annotation.Nullable;

import com.vector.update_app.v2.builder.DownloadBuilder;
import com.vector.update_app.v2.builder.UIData;



public interface RequestVersionListener  {

    @Nullable
    UIData onRequestVersionSuccess(DownloadBuilder downloadBuilder, String result);

    void onRequestVersionFailure(String message);

}
