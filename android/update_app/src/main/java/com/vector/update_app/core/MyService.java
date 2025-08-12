package com.vector.update_app.core;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

public class MyService extends AVersionService {
    public MyService() {
    }

    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public void onResponses(AVersionService service, String response) {

    }
}
