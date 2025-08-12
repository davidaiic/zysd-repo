//
//  ScanningResultViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanningResultViewModel: BaseViewModel {
    
    enum Row: CaseIterable {
        case image
        case word
        case commodity
    }
    
    var rows: [Row] = []
    
    var recognition = RecognitionModel()
    
    var hotWords = HotWords()
    var hotWordsHeight: CGFloat = 0
    
    var hotCommodity = HotCommodity()
    
    override init() {
        super.init()
        rows.append(.image)
        rows.append(.word)
        self.rows.append(.commodity)
    }
    
    func fetchHotWord() {
        if recognition.keywords.isEmpty {
            self.hotWordsHeight = 140
        } else {
            var wordList: [HotWord] = []
            for keyword in recognition.keywords {
                let hotWord = HotWord()
                hotWord.word = keyword.name
                wordList.append(hotWord)
            }
            wordList.first?.selected = true
            hotWords.wordList = wordList
            self.hotWordsHeight = Helper.calulateHeight(count: self.hotWords.wordList.count, itemHeight: 28, spacing: 15) + 67
        }
    }
    
    func fetchCommodity(increment: Bool) {
        
        if recognition.keywords.isEmpty {
            BasicApi("home/hotGoods")
                .perform { result in
                switch result {
                case .success(let response):
                    self.hotCommodity = response.model(HotCommodity.self)
                    self.hasNext = false
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure:
                    break
                }
            }
        } else {
            guard let api = api(path: "home/search", increment: increment) else {
                self.fetchDelegate?.onCompletion(.onCompleted)
                return
            }
            let keyword = hotWords.wordList.first(where: { $0.selected })?.word ?? ""
            api.addParameter(key: "page", value: self.page)
                .addParameter(key: "keyword", value: keyword)
                .perform { [weak self] result in
                    guard let self = self else { return }
                    self.isFetching = false
                      switch result {
                      case .success(let res):
                          let resultModel = res.model(SearchResultModel.self)
                          
                          if self.page == 1 {
                              self.hotCommodity.goodsList = resultModel.goodsList
                          } else {
                              self.hotCommodity.goodsList.append(contentsOf: resultModel.goodsList)
                          }
                          
                          self.setupNext(resultModel.goodsList.count)
                          
                          self.hotCommodity.calulateGoodsListHeight()
                         
                          self.fetchDelegate?.onCompletion(.onCompleted)
                      case .failure(let failure):
                          self.fetchDelegate?.onCompletion(.failure(failure))
                      }
                  }
        }
    }
}
