package com.manle.phone.android.yaodian.vm

import com.app.base.viewmodel.BaseViewModel
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.ItemBean


class SearchDetailViewModel:BaseViewModel() {
    val itemList = mutableListOf(
        ItemBean(drawable = R.drawable.ic_se_jgcx, title = "价格查询", subTitle = "价格透明，一键查询"),
        ItemBean(drawable = R.drawable.ic_se_jbzw, title = "真伪鉴别", subTitle = "药品真伪，快速查询"),
        ItemBean(drawable = R.drawable.ic_se_wybj, title = "我要比价", subTitle = "一键比价，最优选择"),
        ItemBean(drawable = R.drawable.ic_se_hzzm, title = "患者招募", subTitle = "患者招募，助力临床"),
        ItemBean(drawable = R.drawable.ic_se_csjz, title = "慈善救助", subTitle = "慈善主力，温暖关怀"),
        ItemBean(drawable = R.drawable.ic_se_wysj, title = "我要送检", subTitle = "一键送检，安心检测"),
        ItemBean(drawable = R.drawable.ic_se_jyjc, title = "基因检测", subTitle = "精准检测，明确用药")
    )
}