package com.vector.update_app.callback;

import java.io.File;



public interface APKDownloadListener {
     void onDownloading(int progress);
    void onDownloadSuccess(File file);
    void onDownloadFail();
}
