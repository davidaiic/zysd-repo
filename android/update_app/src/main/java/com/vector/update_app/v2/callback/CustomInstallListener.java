package com.vector.update_app.v2.callback;

import android.content.Context;
import android.net.Uri;


public interface CustomInstallListener {
    void install(Context context, Uri apk);
}
