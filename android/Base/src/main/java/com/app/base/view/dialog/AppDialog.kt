package com.app.base.view.dialog

import android.app.Dialog
import android.content.Context
import android.content.DialogInterface
import android.os.Bundle
import android.os.Looper
import android.view.*
import androidx.annotation.StyleRes
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.DialogFragment
import androidx.fragment.app.FragmentManager
import com.app.base.view.dialog.extensions.AnimatorListenerEx
import com.app.base.view.dialog.extensions.UtilsExtension.Companion.getScreenHeight
import com.app.base.view.dialog.extensions.UtilsExtension.Companion.getScreenHeightOverStatusBar
import com.app.base.view.dialog.extensions.UtilsExtension.Companion.getScreenWidth
import com.app.base.view.dialog.listener.OnKeyListener
import com.app.base.view.dialog.other.DialogGravity
import com.app.base.view.dialog.other.DialogInitMode
import com.app.base.view.dialog.other.DialogOptions
import com.app.base.view.dialog.other.ViewHolder

import java.lang.reflect.Field
import java.util.concurrent.atomic.AtomicBoolean


open class AppDialog : DialogFragment() {


    var rootView: View? = null


    var dialogBinding: Any? = null


    var dialogActivity: AppCompatActivity? = null

    private var isDismissed: Field? = null
    private var isShownByMe: Field? = null

    private var myIsShow = false


    override fun onAttach(context: Context) {
        super.onAttach(context)
        dialogActivity = context as AppCompatActivity
    }

    override fun onDetach() {
        super.onDetach()
        dialogActivity = null

    }

    override fun onCancel(dialog: DialogInterface) {
        super.onCancel(dialog)
        if (isDismissed != null) {
            myIsShow = false
        }
    }


    override fun onStart() {

        if (isDismissed != null && !myIsShow) {
            val myDialog = this.javaClass.superclass.getDeclaredField("mDialog")
            myDialog.isAccessible = true
            val tempDialog = myDialog.get(this) as Dialog
            myDialog.set(this, null)
            super.onStart()
            myDialog.set(this, tempDialog)
            return
        }
        super.onStart()
        myIsShow = true
        initParams()

        if (dialogOptions.unLeak && isDismissed == null || dialogOptions.useCommitAllowingStateLoss) {
            isDismissed = this.javaClass.superclass.getDeclaredField("mDismissed")
            isShownByMe = this.javaClass.superclass.getDeclaredField("mShownByMe")
            isDismissed?.isAccessible = true
            isShownByMe?.isAccessible = true
        }
    }


    override fun onDestroy() {
        super.onDestroy()
        rootView = null
        dialogBinding = null
    }


    val dismissed = AtomicBoolean(false)


    private val options = "options"


    private var dialogOptions: DialogOptions = DialogOptions()

    fun setDialogOptions(dialogOptions: DialogOptions): AppDialog {
        this.dialogOptions = dialogOptions
        return this
    }

    fun getDialogOptions(): DialogOptions {
        return dialogOptions
    }

    open fun onLazy() {
        if (dialogOptions.bindingListener != null) {
            dataConvertView(dialogBinding!!, this)
        } else {
            convertView(ViewHolder(rootView!!), this)
        }
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        extendsOptions()?.let {
            dialogOptions = it
        }

        setStyle(dialogOptions.dialogStyle, dialogOptions.dialogThemeFun.invoke(this))

        if (savedInstanceState != null) {
            dialogOptions = savedInstanceState.getParcelable(options)!!
        }
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        if (dialogOptions.unLeak) {
            return
        }
        when (dialogOptions.initMode) {
            DialogInitMode.NORMAL -> {

                if (dialogOptions.bindingListener != null) {
                    dataConvertView(dialogBinding!!, this)
                } else {
                    convertView(ViewHolder(rootView!!), this)
                }
            }
            DialogInitMode.LAZY -> {

                rootView!!.postDelayed({
                    onLazy()
                }, dialogOptions.duration)
            }
            DialogInitMode.DRAW_COMPLETE -> {
                Looper.myQueue().addIdleHandler {
                    if (dialogOptions.bindingListener != null) {
                        dataConvertView(dialogBinding!!, this)
                    } else {
                        convertView(ViewHolder(rootView!!), this)
                    }

                    false
                }
            }
        }
    }



    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {

        if (dialogOptions.bindingListener != null) {
            rootView = dialogOptions.bindingListener!!.invoke(container, this)
            return rootView
        }
        rootView = inflater.inflate(dialogOptions.layoutId, container, false)
        return rootView
    }


    private fun convertView(holder: ViewHolder, dialog: AppDialog) {
        dialogOptions.convertListener?.convertView(holder, dialog)
    }


    private fun dataConvertView(dialogBinding: Any, dialog: AppDialog) {
        dialogOptions.dataConvertListener?.convertView(dialogBinding, dialog)
    }


    open fun extendsOptions(): DialogOptions? {
        return null
    }


    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putParcelable(options, dialogOptions)
    }


    override fun dismiss() {
        myIsShow = false
        dialogOptions.exitAnimator.apply {
            if (this != null) {
                this.start()
                return
            }
            if (dialogOptions.unLeak) {
                dialog?.dismiss()
                return
            }
            if (dismissed.compareAndSet(false, true)) {
                executeDismissListener()
                super.dismiss()
            }
        }

    }


    private fun clearDialogLeakListener() {
        dialog?.setOnDismissListener {
            executeDismissListener()
        }
        dialog?.setOnShowListener {
            when (dialogOptions.initMode) {
                DialogInitMode.NORMAL -> {
                    if (dialogOptions.bindingListener != null) {
                        dataConvertView(dialogBinding!!, this)
                    } else {
                        convertView(ViewHolder(rootView!!), this)
                    }
                }
                DialogInitMode.LAZY -> {

                    rootView!!.postDelayed({
                        onLazy()
                    }, dialogOptions.duration)
                }
                DialogInitMode.DRAW_COMPLETE -> {
                    Looper.myQueue().addIdleHandler {
                        if (dialogOptions.bindingListener != null) {
                            dataConvertView(dialogBinding!!, this)
                        } else {
                            convertView(ViewHolder(rootView!!), this)
                        }
                        false
                    }
                }
            }
            executeShowListener()
        }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        if (dialogOptions.unLeak) {
            clearDialogLeakListener()
        }
    }



    override fun onStop() {
        super.onStop()

        if (isDismissed == null) {
            myIsShow = false
        }
        if (dismissed.compareAndSet(true, false)) {
            return
        }
        if (!dialogOptions.unLeak) {
            executeDismissListener()
        }
    }


    private fun executeShowListener() {
        for (entry in dialogOptions.showDismissMap.entries) {
            if (entry.value.enableExecuteShowListener) {
                entry.value.onDialogShow()
            }
        }
    }


    private fun executeDismissListener() {
        for (entry in dialogOptions.showDismissMap.entries) {
            if (entry.value.enableExecuteDismissListener) {
                entry.value.onDialogDismiss()
            }
        }
    }


    private lateinit var animatorEnterListener: AnimatorListenerEx


    private lateinit var animatorExitListener: AnimatorListenerEx


    private fun initAnimatorEnterListener(): AnimatorListenerEx {
        animatorEnterListener = AnimatorListenerEx().onAnimatorStart {
            dialogOptions.canClick = false
        }.onAnimatorEnd {
            dialogOptions.canClick = true
        }
        return animatorEnterListener
    }


    private fun initAnimatorExitListener(): AnimatorListenerEx {
        animatorExitListener = AnimatorListenerEx().onAnimatorStart {
            dialogOptions.canClick = false
        }.onAnimatorEnd {
            if (dialogOptions.unLeak) {
                dialog?.dismiss()
            } else {
                if (dismissed.compareAndSet(false, true)) {
                    executeDismissListener()
                    super.dismiss()
                }
            }
            dialogOptions.canClick = true
        }
        return animatorExitListener
    }


    private fun initParams() {
        dialog?.window?.let { window ->
            dialogOptions.setEnterAnimatorFun?.invoke(window.decorView.findViewById(android.R.id.content))?.let {
                it.addListener(initAnimatorEnterListener())
                dialogOptions.enterAnimator = it
            }
            dialogOptions.setExitAnimatorFun?.invoke(window.decorView.findViewById(android.R.id.content))?.let {
                it.addListener(initAnimatorExitListener())
                dialogOptions.exitAnimator = it
            }

            window.statusBarColor = dialogOptions.dialogStatusBarColor
            dialogOptions.setStatusBarModeFun.invoke(this)
            window.attributes = window.attributes?.apply {
                dimAmount = dialogOptions.dimAmount
                width = if (dialogOptions.width == 0) {
                    WindowManager.LayoutParams.WRAP_CONTENT
                } else {
                    dialogOptions.width
                }
                height = if (dialogOptions.height == 0) {
                    WindowManager.LayoutParams.WRAP_CONTENT
                } else {
                    dialogOptions.height
                }

                if (dialogOptions.isFullHorizontal) {
                    horizontalMargin = 0f
                    width = getScreenWidth(resources) - 2 * dialogOptions.fullHorizontalMargin
                } else {
                    horizontalMargin = when {
                        dialogOptions.horizontalMargin < 0f -> 0f
                        dialogOptions.horizontalMargin in 0f..1f -> dialogOptions.horizontalMargin
                        else -> dialogOptions.horizontalMargin / getScreenWidth(resources)
                    }
                }

                if (dialogOptions.isFullVertical) {
                    verticalMargin = 0f
                    height = getScreenHeight(resources) - 2 * dialogOptions.fullVerticalMargin
                } else {
                    verticalMargin = when {
                        dialogOptions.verticalMargin < 0f -> 0f
                        dialogOptions.verticalMargin in 0f..1f -> dialogOptions.verticalMargin
                        else -> dialogOptions.verticalMargin / getScreenHeight(resources)
                    }
                }

                if (dialogOptions.isFullVerticalOverStatusBar) {
                    verticalMargin = 0f
                    height = getScreenHeightOverStatusBar(dialogActivity!!) - 2 * dialogOptions.fullVerticalMargin
                }

                gravity = dialogOptions.gravity.index
                if (dialogOptions.isAsView()) {
                    x = dialogOptions.dialogViewX
                    y = dialogOptions.dialogViewY
                }
            }
            dialogOptions.enterAnimator?.start()
                ?: apply {
                    dialogOptions.animStyle?.let {
                        window.setWindowAnimations(it)
                    }
                }
        }

        isCancelable = dialogOptions.outCancel
        dialog?.setCanceledOnTouchOutside(dialogOptions.touchCancel)
        setOnKeyListener()
    }



    private fun setOnKeyListener() {


        if (dialogOptions.exitAnimator != null && dialogOptions.onKeyListener == null) {
            val onKey = object : OnKeyListener() {
                override fun onKey(dialog: DialogInterface, keyCode: Int, event: KeyEvent): Boolean {
                    if (keyCode == KeyEvent.KEYCODE_BACK) {
                        return if (getDialogOptions().canClick) {
                            dismiss()
                            true
                        } else {
                            true
                        }
                    }
                    return false
                }
            }
            dialog?.setOnKeyListener(onKey)
        } else {
            dialogOptions.onKeyListener?.apply {
                dialog?.setOnKeyListener(this)
            }
        }
    }


    fun showOnWindow(manager: FragmentManager): AppDialog {
        myIsShow = true
        dialogOptions.apply {
            this.gravity = dialogOptions.gravity
            this.animStyle = dialogOptions.animStyle
            removeAsView()
            loadAnim()
        }
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }


    fun showOnWindow(manager: FragmentManager, gravity: DialogGravity = dialogOptions.gravity): AppDialog {
        myIsShow = true
        dialogOptions.apply {
            this.gravity = gravity
            this.animStyle = dialogOptions.animStyle
            removeAsView()
            loadAnim()
        }
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }


    fun showOnWindow(
        manager: FragmentManager,
        gravity: DialogGravity = dialogOptions.gravity,
        @StyleRes newAnim: Int? = dialogOptions.animStyle
    ): AppDialog {
        myIsShow = true
        dialogOptions.apply {
            this.gravity = gravity
            this.animStyle = newAnim
            removeAsView()
            loadAnim()
        }
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }


    fun showOnWindow(
        manager: FragmentManager,
        gravity: DialogGravity = dialogOptions.gravity,
        @StyleRes newAnim: Int? = dialogOptions.animStyle,
        tag: String?
    ): AppDialog {
        myIsShow = true
        dialogOptions.apply {
            this.gravity = gravity
            this.animStyle = newAnim
            removeAsView()
            loadAnim()
        }
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }



    fun showNowOnWindow(
        manager: FragmentManager,
        gravity: DialogGravity = dialogOptions.gravity,
        @StyleRes newAnim: Int? = dialogOptions.animStyle,
        tag: String?
    ): AppDialog {
        myIsShow = true
        dialogOptions.apply {
            this.gravity = gravity
            this.animStyle = newAnim
            removeAsView()
            loadAnim()
        }
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitNowAllowingStateLoss()
                } else {
                    super.showNow(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitNowAllowingStateLoss()
        } else {
            super.showNow(manager, this.hashCode().toString())
        }
        return this
    }

    fun showOnView(manager: FragmentManager, view: View): AppDialog {
        myIsShow = true
        dialogOptions.dialogAsView(view, dialogOptions.gravityAsView, dialogOptions.animStyle, dialogOptions.offsetX, dialogOptions.offsetY)
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }

    fun showOnView(
        manager: FragmentManager,
        view: View,
        gravityAsView: DialogGravity = dialogOptions.gravityAsView
    ): AppDialog {
        myIsShow = true
        dialogOptions.dialogAsView(view, gravityAsView, dialogOptions.animStyle, dialogOptions.offsetX, dialogOptions.offsetY)
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }


    fun showOnView(
        manager: FragmentManager,
        view: View,
        gravityAsView: DialogGravity = dialogOptions.gravityAsView,
        @StyleRes newAnim: Int? = dialogOptions.animStyle
    ): AppDialog {
        myIsShow = true
        dialogOptions.dialogAsView(view, gravityAsView, newAnim, dialogOptions.offsetX, dialogOptions.offsetY)
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }


    fun showOnView(
        manager: FragmentManager,
        view: View,
        gravityAsView: DialogGravity = dialogOptions.gravityAsView,
        @StyleRes newAnim: Int? = dialogOptions.animStyle,
        offsetX: Int = dialogOptions.offsetX,
        offsetY: Int = dialogOptions.offsetY
    ): AppDialog {
        myIsShow = true
        dialogOptions.dialogAsView(view, gravityAsView, newAnim, offsetX, offsetY)
        if (dialogOptions.unLeak) {
            return if (manager.fragments.contains(this)) {
                initParams()
                isDismissed?.set(this, false)
                isShownByMe?.set(this, true)
                dialog?.show()
                this
            } else {
                if (dialogOptions.useCommitAllowingStateLoss) {
                    isDismissed?.set(this, false)
                    isShownByMe?.set(this, true)
                    val ft = manager.beginTransaction()
                    ft.add(this, this.hashCode().toString())
                    ft.commitAllowingStateLoss()
                } else {
                    super.show(manager, this.hashCode().toString())
                }
                this
            }
        }
        executeShowListener()
        if (dialogOptions.useCommitAllowingStateLoss) {
            isDismissed?.set(this, false)
            isShownByMe?.set(this, true)
            val ft = manager.beginTransaction()
            ft.add(this, this.hashCode().toString())
            ft.commitAllowingStateLoss()
        } else {
            super.show(manager, this.hashCode().toString())
        }
        return this
    }

}
