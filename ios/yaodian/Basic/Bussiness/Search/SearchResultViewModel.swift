//
//  SearchResultViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import Foundation
import KakaJSON

class SearchResultViewModel: BaseViewModel {
    
    var searchResultModel = SearchResultModel()
    
    var keyword = ""
    
    func clear() {
        searchResultModel.goodsList.removeAll()
    }
    
    func fetchGoods(_ increment: Bool = false) {
      
        guard let api = api(path: "home/search", increment: increment) else {
            return
        }
        
        api.addParameter(key: "page", value: page)
            .addParameter(key: "keyword", value: keyword)
            .perform { [weak self] result in
                guard let self = self else { return }
                self.isFetching = false
                switch result {
                case .success(let res):
                    let resultModel = res.model(SearchResultModel.self)
                    
                    resultModel.goodsList.forEach{ $0.numberOfLines = 0 }
                    
                    self.setupNext(resultModel.goodsList.count)
                    
                    if self.page == 1 {
                        self.searchResultModel.goodsList = resultModel.goodsList
                    } else {
                        self.searchResultModel.goodsList.append(contentsOf: resultModel.goodsList)
                    }
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure:
                    break
                }
            }
    }
}

class SearchResultModel: Convertible {
    
    required init() {
        
    }
    
    var goodsList: [CommodityModel] = []
}


