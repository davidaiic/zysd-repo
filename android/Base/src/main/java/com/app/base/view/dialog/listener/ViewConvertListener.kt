package com.app.base.view.dialog.listener

import android.os.Parcel
import android.os.Parcelable
import com.app.base.view.dialog.AppDialog
import com.app.base.view.dialog.other.ViewHolder

abstract class ViewConvertListener : Parcelable {

    abstract fun convertView(holder: ViewHolder, dialog: AppDialog)

    override fun describeContents(): Int {
        return 0
    }

    override fun writeToParcel(dest: Parcel, flags: Int) {}

    constructor() {}

    protected constructor(source: Parcel) {}

    companion object {
        val CREATOR: Parcelable.Creator<ViewConvertListener> = object : Parcelable.Creator<ViewConvertListener> {
            override fun createFromParcel(source: Parcel): ViewConvertListener {
                return object : ViewConvertListener(source) {
                    override fun convertView(holder: ViewHolder, dialog: AppDialog) {

                    }
                }
            }

            override fun newArray(size: Int): Array<ViewConvertListener?> {
                return arrayOfNulls(size)
            }
        }
    }
}
