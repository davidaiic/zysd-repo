package com.manle.phone.android.yaodian.activity

import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import androidx.lifecycle.lifecycleScope
import com.app.base.activity.BaseActivity
import com.app.base.viewmodel.BaseViewModel
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.databinding.ActivitySplashBinding
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch


class SplashActivity : BaseActivity<BaseViewModel, ActivitySplashBinding>(R.layout.activity_splash) {
    @RequiresApi(Build.VERSION_CODES.N)
    override fun initView(savedInstanceState: Bundle?) {
        lifecycleScope.launch {
            delay(500)
            MainActivity.startAct(this@SplashActivity)
            finish()
        }
    }
}