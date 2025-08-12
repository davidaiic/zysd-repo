//
//  SearchResultEmptyViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class SearchResultEmptyViewModel: BaseViewModel {
    
    var model = HotCommodity()
    
    func fetch() {
        BasicApi("home/hotGoods")
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    self.model = res.model(HotCommodity.self)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
            }
    }
}
