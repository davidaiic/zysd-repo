package com.app.base.ext

import android.content.Context
import android.graphics.drawable.ColorDrawable
import android.widget.LinearLayout
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.lifecycle.Lifecycle
import androidx.viewpager2.adapter.FragmentStateAdapter
import androidx.viewpager2.widget.ViewPager2
import com.app.base.R
import com.app.base.view.indicator.ScaleTransitionPagerTitleView
import net.lucode.hackware.magicindicator.MagicIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView
import net.lucode.hackware.magicindicator.buildins.commonnavigator.indicators.LinePagerIndicator


fun ViewPager2.initVp(
    fragmentManager: FragmentManager,
    lifecycle: Lifecycle,
    fragments: List<Fragment>,
    isUserInputEnabled: Boolean = true,
    offscreenPageLimit: Int = 1
): ViewPager2 {
    this.isUserInputEnabled = isUserInputEnabled

    adapter = object : FragmentStateAdapter(fragmentManager, lifecycle) {
        override fun createFragment(position: Int) = fragments[position]
        override fun getItemCount() = fragments.size
    }
    this.offscreenPageLimit = offscreenPageLimit

    return this
}


fun ViewPager2.initVp(
    isUserInputEnabled: Boolean = true,
    offscreenPageLimitCount: Int? = 1,
    initAdapterBlock: ViewPager2.() -> Unit
): ViewPager2 {

    this.isUserInputEnabled = isUserInputEnabled
    offscreenPageLimitCount?.let { offscreenPageLimit = it }

    initAdapterBlock()
    return this
}

