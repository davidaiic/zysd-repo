//
//  CommodityOrderManager.swift
//  Basic
//
//  Created by wangteng on 2023/4/12.
//

import Foundation

class CommodityOrderManager: BaseViewModel {
    
    enum PageType: String, CaseIterable {
        case all = "全部"
        case unPay = "待支付"
    }
    
    class PageModel {
        
        var type: PageType = .all
        
        var badge = 0
        
        init(type: PageType) {
            self.type = type
        }
    }
    
    var pageModels: [PageModel] = []
    
    override init() {
        super.init()
        setupPageModels()
    }
    
    private func setupPageModels() {
        pageModels = PageType.allCases.map{ PageModel.init(type: $0) }
    }
    
}
