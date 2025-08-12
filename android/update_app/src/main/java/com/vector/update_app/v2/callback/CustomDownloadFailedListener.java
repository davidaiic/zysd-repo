package com.vector.update_app.v2.callback;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;

import com.vector.update_app.v2.builder.UIData;



public interface CustomDownloadFailedListener {
    Dialog getCustomDownloadFailed(Context context,UIData versionBundle);

}
