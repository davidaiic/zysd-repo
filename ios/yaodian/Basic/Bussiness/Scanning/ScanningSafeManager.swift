//
//  ScanningSafeManager.swift
//  Basic
//
//  Created by wangteng on 2023/4/15.
//

import Foundation
import KakaJSON

class ScanningSafeManager: BaseViewModel {
    
    var goodsId = ""
    
    var model = ScanningSafeModel()
    
    func fetchData() {
        BasicApi("query/goodsServer")
            .addParameter(key: "goodsId", value: goodsId)
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    self.model = res.model(ScanningSafeModel.self)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
            }
    }
}

class ScanningSafeModel: Convertible {
    
    required init() {
        
    }
    
    var goodsInfo = CommodityModel()
    
    var serverList: [ScanningSafeServer] = []

    var articleList: [MessageModel] = []
}
              
class ScanningSafeServer: Convertible {
    
    required init() {}
    
    var serverId = ""
    
    var serverName = ""
    
    var icon = ""
    
    var desc = ""
    
    var webURL: String {
        BasicApi.url(linkUrl, type: .h5)
    }
    
    var linkUrl = ""
   
}
