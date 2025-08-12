package com.vector.update_app.v2;

import android.content.Context;

import androidx.annotation.Nullable;

import com.vector.update_app.core.http.AllenHttp;
import com.vector.update_app.utils.AllenEventBusUtil;
import com.vector.update_app.v2.builder.DownloadBuilder;
import com.vector.update_app.v2.builder.RequestVersionBuilder;
import com.vector.update_app.v2.builder.UIData;
import com.vector.update_app.v2.eventbus.AllenEventType;



public class AllenVersionChecker {


    private AllenVersionChecker() {

    }

    public static AllenVersionChecker getInstance() {
        return AllenVersionCheckerHolder.allenVersionChecker;
    }

    private static class AllenVersionCheckerHolder {
        public static final AllenVersionChecker allenVersionChecker = new AllenVersionChecker();
    }

    @Deprecated
    public void cancelAllMission(Context context) {
        cancelAllMission();
    }

    public void cancelAllMission() {
        AllenHttp.getHttpClient().dispatcher().cancelAll();
        AllenEventBusUtil.sendEventBusStick(AllenEventType.CLOSE);
        AllenEventBusUtil.sendEventBusStick(AllenEventType.STOP_SERVICE);
    }


    public DownloadBuilder downloadOnly(@Nullable UIData versionBundle) {
        return new DownloadBuilder(null, versionBundle);
    }


    public RequestVersionBuilder requestVersion() {
        return new RequestVersionBuilder();
    }

}
