package com.manle.phone.android.yaodian.adapter

import androidx.databinding.DataBindingUtil
import com.manle.phone.android.yaodian.R
import com.manle.phone.android.yaodian.bean.BannerBean
import com.manle.phone.android.yaodian.databinding.AdapterHomeBannerBinding
import com.zhpan.bannerview.BaseBannerAdapter
import com.zhpan.bannerview.BaseViewHolder


class HomeBannerAdapter : BaseBannerAdapter<BannerBean>() {
    override fun bindData(holder: BaseViewHolder<BannerBean>, data: BannerBean, position: Int, pageSize: Int) {
        val binding: AdapterHomeBannerBinding? = DataBindingUtil.bind(holder.itemView)
        binding?.let {
            it.url = data.imageUrl
        }
    }

    override fun getLayoutId(viewType: Int) = R.layout.adapter_home_banner

}
