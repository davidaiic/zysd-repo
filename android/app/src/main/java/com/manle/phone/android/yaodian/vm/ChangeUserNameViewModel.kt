package com.manle.phone.android.yaodian.vm

import androidx.lifecycle.MutableLiveData
import com.app.base.viewmodel.BaseViewModel


class ChangeUserNameViewModel:BaseViewModel() {
    val userNameLiveData = MutableLiveData<String>()
}