package com.app.base.activity

import android.content.Context
import android.content.DialogInterface
import android.content.DialogInterface.OnShowListener
import androidx.annotation.NonNull
import androidx.annotation.Nullable
import com.app.base.view.listener.DialogInterfaceProxy
import com.google.android.material.bottomsheet.BottomSheetDialog



class ProxyBottomSheetDialog : BottomSheetDialog {
    constructor(@NonNull context: Context) : super(context)
    constructor(@NonNull context: Context, theme: Int) : super(context, theme)
    constructor(
        @NonNull context: Context,
        cancelable: Boolean,
        cancelListener: DialogInterface.OnCancelListener?
    ) : super(context, cancelable, cancelListener)

    override fun setOnCancelListener(@Nullable listener: DialogInterface.OnCancelListener?) {
        super.setOnCancelListener(DialogInterfaceProxy.proxy(listener))
    }

    override fun setOnDismissListener(@Nullable listener: DialogInterface.OnDismissListener?) {
        super.setOnDismissListener(DialogInterfaceProxy.proxy(listener))
    }

    override fun setOnShowListener(@Nullable listener: OnShowListener?) {
        super.setOnShowListener(DialogInterfaceProxy.proxy(listener))
    }
}
