//
//  CommodityModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/16.
//

import Foundation
import KakaJSON

class CommodityModel: Convertible {
    required init() { }
    
    /// 药品id
    var goodsId = ""
    
    /// 药品名称
    var goodsName = ""
    
    /// 药厂名称
    var companyName = ""
    
    /// 药厂id
    var companyId = ""
    
    /// 药品图片
    var goodsImage = ""
    
    /// 查询人数
    var searchNum = ""
    
    /// 药品属性，左上角标签，为空不显示
    var drugProperties = ""
    var drugPropertiesColor = ""
    
    /// 药品风险等级，为1显示高风险，为0不显示
    var risk = 0
    
    /// 国外获批上市标签，为空不显示
    var marketTag = ""
    
    /// 医保标签，为空不显示
    var medicalTag = ""
    
    var keyword = ""
    
    /// 是否有`国外获批上市标签`或`医保标签`
    var hasTag: Bool {
        !marketTag.isEmpty || !medicalTag.isEmpty
    }
    
    var numberOfLines = 1
    
    var size: CGSize = .init(width: (UIScreen.bind.width-45)*0.5,
                             height: ((UIScreen.bind.width-45)*0.5)*0.75+95)
    
    func kj_didConvertToModel(from json: [String : Any]) {
        size = calulateSize()
    }
    
    private func calulateSize(_ width: CGFloat = (UIScreen.bind.width-45)*0.5) -> CGSize {
        
        let imageHeight: CGFloat = width*0.75
        let top: CGFloat = 6
        let bottom: CGFloat = 11
        let searchTextHeight: CGFloat = 16
        var height: CGFloat = [imageHeight,top,searchTextHeight,bottom].reduce(0, +)
        
        let spacing: CGFloat = 4
        var heights: [CGFloat] = []
        
        if !goodsName.isEmpty {
            let goodsNameHeight = goodsName.bind.boundingRect(.fontHeight(width:  width - 20, font: UIFont.systemFont(ofSize: 14, weight: .semibold))) + 1
            heights.append(goodsNameHeight)
            heights.append(spacing)
        }
        
        if !companyName.isEmpty {
            let companyNameHeight = companyName.bind.boundingRect(.fontHeight(width: width - 20, font: UIFont.systemFont(ofSize: 12, weight: .regular))) + 1
            heights.append(companyNameHeight)
            heights.append(spacing)
        }
        
        if hasTag {
            heights.append(22)
            heights.append(spacing)
        }
        
        if !heights.isEmpty {
            height += heights.reduce(-spacing, +)
        }
        return .init(width: width, height: height)
    }
}

extension CommodityModel {
    
    func open() {
        LoginManager.shared.loginHandler { [weak self] in
            guard let self = self else { return }
            if self.risk == 0 {
                ScanningSafeController(goodsId: self.goodsId).bind.push()
            } else {
                let smRiskConfiguration = AppWebPathConfiguration.shared.webPath(.smRisk)
                let webURL = smRiskConfiguration.webURL+"&goodsId="+self.goodsId
                BaseWebViewController.init(webURL: webURL, navigationTitle: smRiskConfiguration.navigationTitle).bind.push()
            }
        }
    }
}
