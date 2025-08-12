package com.vector.update_app.core;

import android.Manifest;
import android.app.Dialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Bundle;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.appcompat.app.AlertDialog;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.vector.update_app.R;
import com.vector.update_app.callback.APKDownloadListener;
import com.vector.update_app.callback.CommitClickListener;
import com.vector.update_app.callback.DialogDismissListener;
import com.vector.update_app.callback.DownloadListener;
import com.vector.update_app.core.http.AllenHttp;
import com.vector.update_app.utils.ALog;
import com.vector.update_app.utils.AppUtils;
import com.vector.update_app.v2.ui.AllenBaseActivity;

import java.io.File;

public class VersionDialogActivity extends AllenBaseActivity implements DownloadListener, DialogInterface.OnDismissListener {

    public static final int MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE = 0x123;
    protected Dialog versionDialog;
    protected Dialog loadingDialog;
    protected Dialog failDialog;
    private String downloadUrl;
    private VersionParams versionParams;
    private String title;
    private String updateMsg;
    private CommitClickListener commitListener;
    private DialogDismissListener cancelListener;
    private APKDownloadListener apkDownloadListener;
    private View loadingView;
    public static VersionDialogActivity instance;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        instance = this;

        boolean isRetry = getIntent().getBooleanExtra("isRetry", false);
        Log.e("isRetry", isRetry + "");
        if (isRetry) {
            retryDownload(getIntent());
        } else
            initialize();
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }

    public VersionParams getVersionParams() {
        return versionParams;
    }

    public String getVersionTitle() {
        return title;
    }

    public String getVersionUpdateMsg() {
        return updateMsg;
    }

    public Bundle getVersionParamBundle() {
        return versionParams.getParamBundle();
    }


    private void initialize() {
        title = getIntent().getStringExtra("title");
        updateMsg = getIntent().getStringExtra("text");
        versionParams = getIntent().getParcelableExtra(AVersionService.VERSION_PARAMS_KEY);
        downloadUrl = getIntent().getStringExtra("downloadUrl");

        if (title != null && updateMsg != null && downloadUrl != null && versionParams != null) {
            showVersionDialog();
        }


    }

    protected void showVersionDialog() {
        if (!isDestroy) {
            versionDialog = new AlertDialog.Builder(this).setTitle(title).setMessage(updateMsg).setPositiveButton(getString(R.string.versionchecklib_confirm), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (commitListener != null)
                        commitListener.onCommitClick();
                    dealAPK();
                }
            }).setNegativeButton(getString(R.string.versionchecklib_cancel), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    finish();
                }
            }).create();

            versionDialog.setOnDismissListener(this);
            versionDialog.setCanceledOnTouchOutside(false);
            versionDialog.setCancelable(false);
            versionDialog.show();
        }
    }


    public void showLoadingDialog(int currentProgress) {
        if (!isDestroy) {
            if (loadingDialog == null) {
                loadingView = LayoutInflater.from(this).inflate(R.layout.downloading_layout, null);
                loadingDialog = new AlertDialog.Builder(this).setTitle("").setView(loadingView).create();
                loadingDialog.setCancelable(true);
                loadingDialog.setCanceledOnTouchOutside(false);
                loadingDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override
                    public void onCancel(DialogInterface dialog) {
                        AllenHttp.getHttpClient().dispatcher().cancelAll();
                    }
                });
            }
            ProgressBar pb = (ProgressBar) loadingView.findViewById(R.id.pb);
            TextView tvProgress = (TextView) loadingView.findViewById(R.id.tv_progress);
            tvProgress.setText(String.format(getString(R.string.versionchecklib_progress), currentProgress));
            pb.setProgress(currentProgress);
            loadingDialog.show();
        }
    }

    public void showFailDialog() {
        if (!isDestroy) {
            if (versionParams != null && versionParams.isShowDownloadFailDialog()) {
                if (failDialog == null) {
                    failDialog = new AlertDialog.Builder(this).setMessage(getString(R.string.versionchecklib_download_fail_retry)).setPositiveButton(getString(R.string.versionchecklib_confirm), new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            if (commitListener != null)
                                commitListener.onCommitClick();
                            dealAPK();
                        }
                    }).setNegativeButton(getString(R.string.versionchecklib_cancel), null).create();
                    failDialog.setOnDismissListener(this);
                    failDialog.setCanceledOnTouchOutside(false);
                    failDialog.setCancelable(false);
                }
                failDialog.show();
            } else {
                onDismiss(null);
            }
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        boolean isRetry = intent.getBooleanExtra("isRetry", false);
        if (isRetry)
            retryDownload(intent);
    }

    private void retryDownload(Intent intent) {
        dismissAllDialog();
        versionParams = intent.getParcelableExtra(AVersionService.VERSION_PARAMS_KEY);
        downloadUrl = intent.getStringExtra("downloadUrl");
        requestPermissionAndDownloadFile();

    }

    public void setApkDownloadListener(APKDownloadListener apkDownloadListener) {
        this.apkDownloadListener = apkDownloadListener;
    }

    public void setCommitClickListener(CommitClickListener commitListner) {
        this.commitListener = commitListner;
    }

    public void setDialogDimissListener(final DialogDismissListener cancelListener) {
        this.cancelListener = cancelListener;

    }

    public void dealAPK() {
        if (versionParams.isSilentDownload()) {
            String downloadPath = versionParams.getDownloadAPKPath() + getString(R.string.versionchecklib_download_apkname, getPackageName());
            AppUtils.installApk(VersionDialogActivity.this, new File(downloadPath));
            finish();
        } else {
            if (versionParams.isShowDownloadingDialog())
                showLoadingDialog(0);
            requestPermissionAndDownloadFile();

        }
    }

    protected void downloadFile() {
        if (versionParams.isShowDownloadingDialog())
            showLoadingDialog(0);
        DownloadManager.downloadAPK(downloadUrl, versionParams, this);
    }


    protected void requestPermissionAndDownloadFile() {
        if (ContextCompat.checkSelfPermission(this,
                Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {

            if (ActivityCompat.shouldShowRequestPermissionRationale(this,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE)) {

                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                        MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE);

            } else {

                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE},
                        MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE);

            }
        } else {
            downloadFile();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    downloadFile();
                } else {
                    Toast.makeText(this, getString(R.string.versionchecklib_write_permission_deny), Toast.LENGTH_LONG).show();
                    finish();
                }
                return;
            }

        }
    }


    @Override
    public void onCheckerDownloading(int progress) {
        if (versionParams.isShowDownloadingDialog()) {
            showLoadingDialog(progress);
        } else {
            if (loadingDialog != null)
                loadingDialog.dismiss();
            finish();
        }
        if (apkDownloadListener != null)
            apkDownloadListener.onDownloading(progress);
    }

    @Override
    public void onCheckerDownloadSuccess(File file) {
        if (apkDownloadListener != null)
            apkDownloadListener.onDownloadSuccess(file);
        dismissAllDialog();


    }

    @Override
    public void onCheckerDownloadFail() {
        if (apkDownloadListener != null)
            apkDownloadListener.onDownloadFail();
        dismissAllDialog();
        showFailDialog();


    }

    @Override
    public void onCheckerStartDownload() {
        if (!versionParams.isShowDownloadingDialog()) {
            finish();
        }
    }

    boolean isDestroy = false;

    @Override
    protected void onDestroy() {
        isDestroy = true;
        instance = null;
        super.onDestroy();
    }




    private void dismissAllDialog() {
        if (isDestroy) {

        } else {
            if (loadingDialog != null && loadingDialog.isShowing())
                loadingDialog.dismiss();
            if (versionDialog != null && versionDialog.isShowing())
                versionDialog.dismiss();
            if (failDialog != null && failDialog.isShowing())
                failDialog.dismiss();
        }
    }

    @Override
    public void onDismiss(DialogInterface dialogInterface) {
        if (versionParams.isSilentDownload()
                || (!versionParams.isSilentDownload() && loadingDialog == null && versionParams.isShowDownloadingDialog())
                || (!versionParams.isSilentDownload() && loadingDialog != null && !loadingDialog.isShowing() && versionParams.isShowDownloadingDialog())) {
            if (cancelListener != null) {
                cancelListener.dialogDismiss(dialogInterface);
            }
            finish();
            AllenChecker.cancelMission();
        }
    }
    @Override
    public void showDefaultDialog() {

    }

    @Override
    public void showCustomDialog() {

    }


}
