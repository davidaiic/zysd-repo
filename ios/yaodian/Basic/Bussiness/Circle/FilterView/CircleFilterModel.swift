//
//  CircleFilterModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/20.
//

import Foundation
import KakaJSON

class CircleFilterModel: Convertible {
    
    required init() {}
    
    var groups: [HoopFilterGroupModel] = []
    
    func resetting() {
        groups.forEach { group in
            group.models.forEach { item in
                item.selected = false
            }
        }
    }
    
    func copy() -> CircleFilterModel {
        let json = self.kj.JSONString()
        guard let model = json.kj.model(CircleFilterModel.self) else {
            return CircleFilterModel()
        }
        return model
    }
}

class HoopFilterGroupModel: Convertible {
    
    required init() {}
    
    var title = ""
    
    var models: [HoopFilterItemModel] = []
    
    var isMuti = false
}

class HoopFilterItemModel: Convertible {
    
    required init() {}
    
    var selected = false
    
    var sortId = ""
    
    var name = ""
    
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "sortId": return "labelId"
        default: return property.name
        }
    }
    
    var size: CGSize {
        var size = name.bind.boundingSize(.size(maxWidth: UIScreen.bind.width-50-16,
                                            font: UIFont.systemFont(ofSize: 14)))
        
        size.width += 18
        if size.width > (UIScreen.bind.width-66) {
            size.width = (UIScreen.bind.width-66)
        }
        
        size.height += 20
      
        return size
    }
    
    func kj_didConvertToModel(from json: [String : Any]) {
        
    }
}


