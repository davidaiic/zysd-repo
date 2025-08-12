//
//  EntryManager.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import Foundation
import Kingfisher
import KakaJSON

class EntryManager: BaseViewModel {
    
    var comments: [CommentModel] = []
    
    var entryModel = EntryModel()
    
    var hasBanner: Bool {
       !entryModel.bannerList.isEmpty
    }
    
    func fetchIndex() {
        BasicApi("home/index")
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    self.entryModel = res.model(EntryModel.self)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
            }
    }
    
    func fetchComment(_ increment: Bool = true) {
    
        guard let api = api(path: "home/commentList", increment: increment) else {
            return
        }
        
        api.addParameter(key: "type", value: "1")
            .perform { [weak self] result in
                guard let self = self else { return }
                self.isFetching = false
                switch result {
                case .success(let res):
                    let comments = res.modelArray(CommentModel.self, key: "commentList")
                    self.setupNext(comments.count)
                    if self.page == 1 {
                        self.comments = comments
                    } else {
                        self.comments.append(contentsOf: comments)
                    }
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure:
                    break
                }
            }
    }
}

class EntryModel: Convertible {
    
    required init() {}
    
    var searchText = ""
    
    var searchTexts: [String] {
        searchText.components(separatedBy: ",")
    }
    
    var bannerList: [EntryBannerModel] = []
    
    /// 人工核查人数
    var manualVerifyNum = 0
    
    /// 价格查询人数
    var priceQueryNum = 0
    
    /// 扫一扫查真伪人数
    var scanNum = 0
    
    /// 自助查询人数
    var selfQueryNum = 0

    /// 我要送检人数
    var checkNum = 0
    
    /// 我要比价人数
    var compareNum = 0
    
    var goodsList: [CommodityModel] = []
    
    var searchList: [EntrySearchModel] = []
    
    var hotCommodity = HotCommodity()
    
    func kj_didConvertToModel(from json: [String : Any]) {
        hotCommodity.goodsList = self.goodsList
    }
    
    func searchAttributed(_  num: Int, sufix: String) -> NSMutableAttributedString {
        NSMutableAttributedString.init(string: "\(num)".bind.numberFormat)
            .bind
            .font(.systemFont(ofSize: 18, weight: .semibold))
            .foregroundColor(.white).attributedString(
                NSMutableAttributedString(string: sufix)
                    .bind
                    .font(.systemFont(ofSize: 12))
                    .base
            ).hightLight("万", font: .systemFont(ofSize: 16, weight: .semibold), color: .white)
            .base
    }
}

class EntrySearchModel: Convertible {
    required init() { }
    var avatar = ""
    var content = ""
}

class EntryBannerModel: Convertible {
    
    required init() { }
    var bannerId = ""
    var name = ""
    var notes = ""
    var imageUrl = ""
    var type = ""
    var linkUrl = ""
    var text1 = ""
    var text2 = ""
}

extension EntryManager {
    
    func prefetchRows(at indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            if $0.section == 3 {
                return comments[$0.row].boxLayout.imageURLs
                    .compactMap { imageURL in
                        if imageURL.bind.isValidUrl {
                            return URL(string: imageURL)
                        }
                        return nil
                    }
            } else {
                return nil
            }
        }
        guard !urls.isEmpty else {
            return
        }
        ImagePrefetcher(urls: urls.flatMap{ $0 }).start()
    }
}

class HotCommodity: Convertible {
    
    required init() { }
    
    var goodsList: [CommodityModel] = [] {
        didSet {
            calulateGoodsListHeight()
        }
    }
    
    var itemHeight = EntryTotTableCell.height
    
    var height: CGFloat = 0
    
    func calulateGoodsListHeight() {
        self.height = Helper.calulateHeight(count: goodsList.count,
                                                     itemHeight: self.itemHeight,
                                                     spacing: 15) + 68
    }
    
    func kj_didConvertToModel(from json: [String : Any]) {
        calulateGoodsListHeight()
    }
}
