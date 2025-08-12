//
//  SearchManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/3.
//

import Foundation
import KakaJSON
import Bind

class SearchHistoryCache {
    
    @UserDefaultsWrapper(key: "search.cache.histories")
    private var cacheHistories: String?
    
    static let shared = SearchHistoryCache()
    
    init() {
        reload()
    }
    
    func reload() {
        guard let json = cacheHistories else {
            return
        }
        metaHistories = json.kj.modelArray(HistoryModel.self)
        configure()
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
}

class SearchManager {
    
    let historyCache = SearchHistoryCache.shared
    
    /// 热门
    var hot = HotWords()
    
    func fetchHot(completionHandler: @escaping ()->Void) {
        BasicApi("home/hotWord")
            .addParameter(key: "type", value: "0")
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

class HotWords: Convertible {
    
    required init() {}
    
    var searchTip = ""
    
    var wordList: [HotWord] = []
    
    var tipHeight: CGFloat {
        return 0
        /*
        searchTip.bind.boundingRect(.fontHeight(width: UIScreen.bind.width-50, font: UIFont.systemFont(ofSize: 14)))+31
         */
    }
}

class HotWord: Convertible {
    
    required init() {}
    
    var word = ""
    
    var selected = false
}

class HistoryModel: Convertible, Equatable {
    
    var title = ""
    
    var identifiy = ""
    
    var width: CGFloat = 0
    
    /// 是否显示展开
    var showExpand = false
    
    var upDown = false
    
    required init() {}
    
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    static func == (lhs: HistoryModel, rhs: HistoryModel) -> Bool {
        return lhs.identifiy == rhs.identifiy
    }
    
    convenience init(key: String) {
        self.init()
        self.title = key
        self.identifiy = key
        configureWidth()
    }
    
    func configureWidth(){
        if showExpand {
            self.width = 40
        } else {
            self.width = title.bind
                .boundingRect(
                    .fontWidth(height: 15, font: UIFont.systemFont(ofSize: 12))
                ) + 31
            self.width = min(180, self.width)
        }
    }
    
    func kj_didConvertToModel(from json: [String : Any]) {
        configureWidth()
    }
}
