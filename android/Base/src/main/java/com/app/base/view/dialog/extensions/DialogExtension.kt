package com.app.base.view.dialog.extensions

import android.content.Context
import android.content.DialogInterface
import android.view.KeyEvent
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.databinding.DataBindingUtil
import androidx.databinding.ViewDataBinding

import com.app.base.view.dialog.AppDialog
import com.app.base.view.dialog.listener.DataConvertListener
import com.app.base.view.dialog.listener.DialogShowOrDismissListener
import com.app.base.view.dialog.listener.OnKeyListener
import com.app.base.view.dialog.listener.ViewConvertListener

import com.app.base.view.dialog.other.DialogOptions
import com.app.base.view.dialog.other.ViewHolder
import kotlin.reflect.KClass


inline fun newAppDialog(options: DialogOptions.(dialog: AppDialog) -> Unit): AppDialog {
    val tinDialog = AppDialog()
    tinDialog.getDialogOptions().options(tinDialog)
    return tinDialog
}


inline fun AppDialog.dialogOptionsFun(dialogOp: DialogOptions.() -> Unit): DialogOptions {
    val options = DialogOptions()
    options.dialogOp()
    setDialogOptions(options)
    return options
}


inline fun DialogOptions.convertListenerFun(crossinline listener: (holder: ViewHolder, dialog: AppDialog) -> Unit) {
    val viewConvertListener = object : ViewConvertListener() {
        override fun convertView(holder: ViewHolder, dialog: AppDialog) {
            listener.invoke(holder, dialog)
        }
    }
    convertListener = viewConvertListener
}


inline fun <VB : ViewDataBinding> DialogOptions.dataConvertListenerFun( crossinline listener: (binding: VB, dialog: AppDialog) -> Unit) {
    val dataBindingConvertListener = object : DataConvertListener() {
        override fun convertView(binding: Any, dialog: AppDialog) {
            listener.invoke(binding as VB, dialog)
        }
    }
    dataConvertListener = dataBindingConvertListener
}


inline fun < VB : ViewDataBinding> DialogOptions.bindingListenerFun(
    context: Context,
    crossinline listener: (binding: VB, dialog: AppDialog) -> Unit
) {
    val newBindingListener = { container: ViewGroup?, dialog: AppDialog ->
        val binding = DataBindingUtil.inflate<ViewDataBinding>(LayoutInflater.from(context), layoutId, container, false) as VB
        binding.lifecycleOwner = dialog
        listener.invoke(binding, dialog)
        dialog.dialogBinding = binding
        binding.root

    }
    bindingListener = newBindingListener
}



inline fun DialogOptions.addShowDismissListener(key: String, dialogInterface: DialogShowOrDismissListener.() -> Unit): DialogOptions {
    val dialogShowOrDismissListener = DialogShowOrDismissListener()
    dialogShowOrDismissListener.dialogInterface()
    showDismissMap[key] = dialogShowOrDismissListener
    return this
}


inline fun DialogOptions.onKeyListenerForOptions(crossinline listener: (keyCode: Int, event: KeyEvent) -> Boolean) {
    val onKey = object : OnKeyListener() {
        override fun onKey(dialog: DialogInterface, keyCode: Int, event: KeyEvent): Boolean {
            return listener.invoke(keyCode, event)
        }
    }
    onKeyListener = onKey
}


inline fun AppDialog.onKeyListenerForDialog(crossinline listener: (tinDialog: AppDialog, dialogInterFace: DialogInterface, keyCode: Int, event: KeyEvent) -> Boolean): AppDialog {
    val onKey = object : OnKeyListener() {
        override fun onKey(dialog: DialogInterface, keyCode: Int, event: KeyEvent): Boolean {
            return listener.invoke(this@onKeyListenerForDialog, dialog, keyCode, event)
        }
    }
    getDialogOptions().onKeyListener = onKey
    return this
}

