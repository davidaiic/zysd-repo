package com.app.base.view.dialog.other

import android.animation.Animator
import android.graphics.Color
import android.os.Build
import android.os.Parcel
import android.os.Parcelable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.LayoutRes
import androidx.annotation.StyleRes
import androidx.fragment.app.DialogFragment
import com.app.base.R
import com.app.base.view.dialog.AppDialog
import com.app.base.view.dialog.extensions.UtilsExtension.Companion.unDisplayViewSize
import com.app.base.view.dialog.listener.DataConvertListener
import com.app.base.view.dialog.listener.DialogShowOrDismissListener
import com.app.base.view.dialog.listener.OnKeyListener
import com.app.base.view.dialog.listener.ViewConvertListener

open class DialogOptions() : Parcelable {


    @LayoutRes
    open var layoutId = R.layout.loading_layout



    var unLeak = false


    var useCommitAllowingStateLoss  = false


    var dialogStyle = DialogFragment.STYLE_NO_TITLE


    var dialogThemeFun: (tinDialog: AppDialog) -> Int = {
        it.dialogActivity!!.run {
            if (this.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                    || this.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                    || this.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR) {
                R.style.MyDialogFullScreen
            } else {
                R.style.MyAppDialog
            }
        }
    }

    @StyleRes
    var animStyle: Int? = 0


    var canClick = true


    var enterAnimator: Animator? = null
    var exitAnimator: Animator? = null


    var duration: Long = 0L

    var setEnterAnimatorFun: ((contentView: View) -> Animator)? = null
    var setExitAnimatorFun: ((contentView: View) -> Animator)? = null

    fun setOnEnterAnimator(listener: (contentView: View) -> Animator) {
        setEnterAnimatorFun = listener
    }

    fun setOnExitAnimator(listener: (contentView: View) -> Animator) {
        setExitAnimatorFun = listener
    }


    var initMode: DialogInitMode = DialogInitMode.NORMAL


    var dialogStatusBarColor = Color.TRANSPARENT


    var width = 0


    var height = 0


    var isFullHorizontal = false


    var isFullVertical = false


    var isFullVerticalOverStatusBar = false


    var verticalMargin = 0f


    var horizontalMargin = 0f


    var fullVerticalMargin = 0


    var fullHorizontalMargin = 0


    var dimAmount = 0.3f


    var gravity = DialogGravity.CENTER_CENTER


    var gravityAsView = DialogGravity.CENTER_BOTTOM


    var dialogViewX: Int = 0


    var dialogViewY: Int = 0


    var offsetX: Int = 0


    var offsetY: Int = 0


    private var asView: Boolean = false


    var touchCancel = true


    var outCancel = true


    var showDismissMap = mutableMapOf<String, DialogShowOrDismissListener>()


    var onKeyListener: OnKeyListener? = null


    var convertListener: ViewConvertListener? = null


    var bindingListener: ((container: ViewGroup?, dialog: AppDialog) -> View)? = null


    var dataConvertListener: DataConvertListener? = null


    fun isAsView(): Boolean {
        return asView
    }


    fun removeAsView() {
        asView = false
    }


    var setStatusBarModeFun: (appDialog: AppDialog) -> Unit = { appDialog ->
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            appDialog.dialogActivity.apply {

                if (this!!.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        || this.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        || this.window.decorView.systemUiVisibility == View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR) {

                    (findViewById<View>(android.R.id.content) as ViewGroup).getChildAt(0).fitsSystemWindows.let {

                        appDialog.dialog?.window?.decorView?.fitsSystemWindows = it
                        if (it) {
                            appDialog.dialog?.window?.decorView?.systemUiVisibility = View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE

                        } else {
                            appDialog.dialog?.window?.decorView?.systemUiVisibility = this.window.decorView.systemUiVisibility
                        }
                    }

                } else {
                    appDialog.dialog?.window?.decorView?.systemUiVisibility = View.SYSTEM_UI_FLAG_VISIBLE

                }
            }
        } else {
            appDialog.dialog?.window?.addFlags(appDialog.dialogActivity!!.window.attributes.flags)
        }
    }

    fun setDialogTheme(function: (tinDialog: AppDialog) -> Int) {
        dialogThemeFun = function
    }


    fun setStatusMode(function: (tinDialog: AppDialog) -> Unit) {
        setStatusBarModeFun = function
    }


    fun dialogAsView(view: View, gravityAsView: DialogGravity = this.gravityAsView, @StyleRes newAnim: Int? = this.animStyle, offsetX: Int = this.offsetX, offsetY: Int = this.offsetY) {

        asView = true
        this.gravity = DialogGravity.LEFT_TOP

        if (animStyle != newAnim) {
            animStyle = newAnim
        }

        this.offsetX = offsetX
        this.offsetY = offsetY

        val dialogViewSize = unDisplayViewSize(LayoutInflater.from(view.context).inflate(layoutId, null))
        val dialogViewWidth = dialogViewSize[0]
        val dialogViewHeight = dialogViewSize[1]

        val viewWidth = view.width
        val viewHeight = view.height
        val location = IntArray(2)
        view.getLocationOnScreen(location)
        val viewX = location[0]
        val viewY = location[1]

        this.gravityAsView = gravityAsView

        when (gravityAsView) {

            DialogGravity.LEFT_TOP -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX100Y100
                this.dialogViewX = viewX - if (width != 0) width else dialogViewWidth + offsetX
                this.dialogViewY = viewY - if (height != 0) height else dialogViewHeight + offsetY
            }

            DialogGravity.CENTER_TOP -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX50Y100
                this.dialogViewX = viewX - ((if (width != 0) width else dialogViewWidth) - viewWidth) / 2 + offsetX
                this.dialogViewY = viewY - if (height != 0) height else dialogViewHeight + offsetY
            }

            DialogGravity.RIGHT_TOP -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX0Y100
                this.dialogViewX = viewX + viewWidth + offsetX
                this.dialogViewY = viewY - if (height != 0) height else dialogViewHeight + offsetY
            }

            DialogGravity.LEFT_CENTER -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX100Y50
                this.dialogViewX = viewX - if (width != 0) width else dialogViewWidth + offsetX
                this.dialogViewY = viewY - ((if (height != 0) height else dialogViewHeight) - viewHeight) / 2 + offsetY
            }

            DialogGravity.CENTER_CENTER -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX50Y50
                this.dialogViewX = viewX - ((if (width != 0) width else dialogViewWidth) - viewWidth) / 2 + offsetX
                this.dialogViewY = viewY - ((if (height != 0) height else dialogViewHeight) - viewHeight) / 2 + offsetY
            }

            DialogGravity.RIGHT_CENTER -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX0Y50
                this.dialogViewX = viewX + viewWidth + offsetX
                this.dialogViewY = viewY - ((if (height != 0) height else dialogViewHeight) - viewHeight) / 2 + offsetY
            }

            DialogGravity.LEFT_BOTTOM -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX100Y0
                this.dialogViewX = viewX - if (width != 0) width else dialogViewWidth + offsetX
                this.dialogViewY = viewY + viewHeight + offsetY
            }

            DialogGravity.CENTER_BOTTOM -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX50Y0
                this.dialogViewX = viewX - ((if (width != 0) width else dialogViewWidth) - viewWidth) / 2 + offsetX
                this.dialogViewY = viewY + viewHeight + offsetY
            }

            DialogGravity.RIGHT_BOTTOM -> {
                if (this.animStyle == 0) this.animStyle = R.style.ScaleOverShootEnterExitAnimationX0Y0
                this.dialogViewX = viewX + viewWidth + offsetX
                this.dialogViewY = viewY + viewHeight + offsetY
            }
            else -> {
                if (this.animStyle == 0) this.animStyle = R.style.AlphaEnterExitAnimation
                this.dialogViewX = viewX - ((if (width != 0) width else dialogViewWidth) - viewWidth) / 2 + offsetX
                this.dialogViewY = viewY - ((if (height != 0) height else dialogViewHeight) - viewHeight) / 2 + offsetY
            }
        }

    }


    fun loadAnim() {
        if (animStyle == null) {
            return
        }
        if (animStyle != 0) {
            return
        }

        when (gravity.index) {


            DialogGravity.LEFT_TOP.index,

            DialogGravity.LEFT_CENTER.index,

            DialogGravity.LEFT_BOTTOM.index ->
                animStyle = R.style.LeftTransAlphaADAnimation


            DialogGravity.RIGHT_TOP.index,

            DialogGravity.RIGHT_CENTER.index,

            DialogGravity.RIGHT_BOTTOM.index ->
                animStyle = R.style.RightTransAlphaADAnimation


            DialogGravity.CENTER_CENTER.index ->
                animStyle = R.style.AlphaEnterExitAnimation


            DialogGravity.CENTER_TOP.index ->
                animStyle = R.style.TopTransAlphaADAnimation


            DialogGravity.CENTER_BOTTOM.index ->
                animStyle = R.style.BottomTransAlphaADAnimation

            else ->
                animStyle = R.style.AlphaEnterExitAnimation
        }
    }

    constructor(source: Parcel) : this(
    )

    override fun describeContents() = 0

    override fun writeToParcel(dest: Parcel, flags: Int) = with(dest) {}

    companion object {
        @JvmField
        val CREATOR: Parcelable.Creator<DialogOptions> = object : Parcelable.Creator<DialogOptions> {
            override fun createFromParcel(source: Parcel): DialogOptions = DialogOptions(source)
            override fun newArray(size: Int): Array<DialogOptions?> = arrayOfNulls(size)
        }
    }
}
