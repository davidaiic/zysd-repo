//
//  CircleSearchHistoryStorage.swift
//  Basic
//
//  Created by wangteng on 2023/4/22.
//

import Foundation
import Bind

class CircleSearchHistoryStorage {
    
    @UserDefaultsWrapper(key: "circle.search.cache.histories")
    private var cacheHistories: String?
    
    static let shard = CircleSearchHistoryStorage()
    
    init() {
        reload()
    }
    
    var histories: [HistoryModel] = []
    
    /// 全部历史数据
    var metaHistories: [HistoryModel] = []
    
    /// 历史显示的数量
    let historyMaxSize = 20
    
    var showExpand = false {
        didSet {
            configure()
        }
    }
    
    func add(_ key: String) {
        guard !key.bind.trimmed.isEmpty else {
            return
        }
        let history = HistoryModel(key: key)
        if !metaHistories.contains(history) {
            metaHistories.insert(history, at: 0)
        } else {
            let swapIndex = histories.firstIndex(where: {
                $0.identifiy == history.identifiy
            })
            if let swapIndex = swapIndex{
                metaHistories.swapAt(swapIndex, 0)
            }
        }
        cacheHistories = metaHistories.kj.JSONString()
        configure()
    }
    
    func clear() {
        metaHistories = []
        histories = []
        cacheHistories = nil
    }
    
    func configure() {
        histories = Array(metaHistories.prefix(historyMaxSize))
    }
    
    func reload() {
        guard let json = cacheHistories else {
            return
        }
        metaHistories = json.kj.modelArray(HistoryModel.self)
        configure()
    }
}
