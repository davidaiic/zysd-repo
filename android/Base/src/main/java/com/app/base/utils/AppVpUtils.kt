package com.app.base.utils

import android.content.Context
import android.widget.LinearLayout
import androidx.viewpager2.widget.ViewPager2
import com.app.base.view.AppPagerTitle
import net.lucode.hackware.magicindicator.MagicIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.CommonNavigator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.CommonNavigatorAdapter
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerIndicator
import net.lucode.hackware.magicindicator.buildins.commonnavigator.abs.IPagerTitleView
import net.lucode.hackware.magicindicator.buildins.commonnavigator.titles.SimplePagerTitleView


object AppVpUtils {

    fun MagicIndicator.bindVp(
        viewPager: ViewPager2,
        list: MutableList<String> = mutableListOf(),
        action: (index: Int) -> Unit = {}
    ) {

        val commonNavigator = CommonNavigator(context)
        commonNavigator.isAdjustMode = false
        commonNavigator.isSkimOver = true
        commonNavigator.adapter = object : CommonNavigatorAdapter() {
            override fun getCount(): Int {
                return list.size
            }

            override fun getTitleView(context: Context, index: Int): IPagerTitleView {
                val simplePagerTitleView = AppPagerTitle(context)
                simplePagerTitleView.setTitle(list[index])
                simplePagerTitleView.setOnClickListener { viewPager.currentItem = index }
                return simplePagerTitleView
            }

            override fun getIndicator(context: Context): IPagerIndicator? {

                return null
            }
        }

        this.navigator = commonNavigator
        val titleContainer = commonNavigator.titleContainer
        titleContainer.showDividers = LinearLayout.SHOW_DIVIDER_MIDDLE




        viewPager.registerOnPageChangeCallback(object : ViewPager2.OnPageChangeCallback() {
            override fun onPageSelected(position: Int) {
                super.onPageSelected(position)
                this@bindVp.onPageSelected(position)
                action.invoke(position)
            }

            override fun onPageScrolled(
                position: Int,
                positionOffset: Float,
                positionOffsetPixels: Int
            ) {
                super.onPageScrolled(position, positionOffset, positionOffsetPixels)
                this@bindVp.onPageScrolled(position, positionOffset, positionOffsetPixels)
            }

            override fun onPageScrollStateChanged(state: Int) {
                super.onPageScrollStateChanged(state)
                this@bindVp.onPageScrollStateChanged(state)
            }
        })
    }
}