package com.app.base.view.listener;

import android.content.DialogInterface;

import com.google.android.material.bottomsheet.BottomSheetDialog;

import java.lang.ref.WeakReference;


public class DialogInterfaceProxy {
    public static DialogInterface.OnCancelListener proxy(DialogInterface.OnCancelListener onCancelListener) {
        return new ProxyOnCancelListener(onCancelListener);
    }

    public static DialogInterface.OnDismissListener proxy(DialogInterface.OnDismissListener onDismissListener) {
        return new ProxyOnDismissListener(onDismissListener);
    }

    public static DialogInterface.OnShowListener proxy(DialogInterface.OnShowListener onShowListener) {
        return new ProxyOnShowListener(onShowListener);
    }

    public static class ProxyOnCancelListener implements DialogInterface.OnCancelListener {
        private WeakReference<DialogInterface.OnCancelListener> mProxyRef;

        public ProxyOnCancelListener(DialogInterface.OnCancelListener onCancelListener) {
            mProxyRef = new WeakReference<>(onCancelListener);
        }

        @Override
        public void onCancel(DialogInterface dialog) {
            DialogInterface.OnCancelListener onCancelListener = mProxyRef.get();
            if (onCancelListener != null) {
                onCancelListener.onCancel(dialog);
            }
        }
    }

    public static class ProxyOnDismissListener implements DialogInterface.OnDismissListener {
        private WeakReference<DialogInterface.OnDismissListener> mProxyRef;

        public ProxyOnDismissListener(DialogInterface.OnDismissListener onDismissListener) {
            mProxyRef = new WeakReference<>(onDismissListener);
        }

        @Override
        public void onDismiss(DialogInterface dialog) {
            DialogInterface.OnDismissListener onDismissListener = mProxyRef.get();
            if (onDismissListener != null) {
                onDismissListener.onDismiss(dialog);
            }
        }
    }

    public static class ProxyOnShowListener implements DialogInterface.OnShowListener {
        private WeakReference<DialogInterface.OnShowListener> mProxyRef;

        public ProxyOnShowListener(DialogInterface.OnShowListener onShowListener) {
            mProxyRef = new WeakReference<>(onShowListener);
        }

        @Override
        public void onShow(DialogInterface dialog) {
            DialogInterface.OnShowListener onShowListener = mProxyRef.get();
            if (onShowListener != null) {
                onShowListener.onShow(dialog);
            }
        }
    }
}