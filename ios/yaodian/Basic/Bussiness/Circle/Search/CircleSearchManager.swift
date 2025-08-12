//
//  CircleSearchManager.swift
//  Basic
//
//  Created by wangteng on 2023/4/22.
//

import Foundation
import KakaJSON

class CircleSearchManager {
    
    let historyCache = CircleSearchHistoryStorage.shard
    
    var hot = HotWords()
    
    func fetchHot(completionHandler: @escaping ()->Void) {
        BasicApi("home/hotWord")
            .addParameter(key: "type", value: "1")
            .perform { result in
            switch result {
            case .success(let response):
                self.hot = response.model(HotWords.self)
                completionHandler()
            case .failure:
                break
            }
        }
    }
}
