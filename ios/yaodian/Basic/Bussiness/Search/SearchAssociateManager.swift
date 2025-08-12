//
//  SearchAssociateManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/6.
//

import Foundation
import KakaJSON

enum SearchAssociateType {
    case infomation
    case commodity
}

class SearchAssociateManager: BaseViewModel {
    
    var associateType: SearchAssociateType = .commodity
    
    var associateWords: [AssociateWord] = []
    
    func fetch(_ keyword: String, increment: Bool) {
        
        setupPage(increment)
 
        BasicApi("home/associateWord")
            .addParameter(key: "page", value: page)
            .addParameter(key: "keyword", value: keyword)
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    let associateWords = res.modelArray(AssociateWord.self, key: "wordList")
                    if self.page == 1 {
                        self.associateWords = associateWords
                    } else {
                        self.associateWords.append(contentsOf: associateWords)
                    }
                    self.setupNext(associateWords.count, limit: 20)
                    
                    if self.page == 1 && self.hasNext {
                        self.fetch(keyword, increment: true)
                    }
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure:
                    break
                }
            }
    }
}

class AssociateWord: Convertible {
    
    required init() {
        
    }
    
    var word = ""
}
