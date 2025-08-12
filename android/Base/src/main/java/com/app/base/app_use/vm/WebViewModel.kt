package com.app.base.app_use.vm

import com.app.base.app_use.bean.WebResponse
import com.app.base.viewmodel.BaseViewModel


class WebViewModel : BaseViewModel() {
    lateinit var webResponse: WebResponse


    var showTitle: String = ""

    var url: String = ""



}