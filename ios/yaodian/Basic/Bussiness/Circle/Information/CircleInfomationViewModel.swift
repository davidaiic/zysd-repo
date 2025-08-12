//
//  CircleInfomationViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/19.
//

import Foundation
import KakaJSON

class CircleInfomationViewModel: BaseViewModel {
    
    var messages: [MessageModel] = []
    
    var keyword = ""
    
    var sortId = ""
    
    var labelId = ""
    
    func fetch(_ increment: Bool = true) {
      
        guard let api = api(path: "home/articleList", increment: increment) else {
            return
        }
        
        api
            .addParameter(key: "page", value: page)
            .addParameter(key: "sortId", value: sortId)
            .addParameter(key: "labelId", value: labelId)
            .addParameter(condition: !keyword.isEmpty, key: "keyword", value: keyword)
            .perform { [weak self] result in
                guard let self = self else { return }
                self.isFetching = false
                switch result {
                case .success(let res):
                    let comments = res.modelArray(MessageModel.self, key: "articleList")
                    self.setupNext(comments.count)
                    
                    if self.page == 1 {
                        self.messages = comments
                    } else {
                        self.messages.append(contentsOf: comments)
                    }
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let error):
                    if self.page == 1 {
                        self.fetchDelegate?.onCompletion(.failure(error))
                    } else {
                        Toast.showMsg(error.domain)
                    }
                    self.page = max(1, self.page - 1)
                }
            }
    }
}

class MessageModel: Convertible {
    
    required init() {}
    
    var articleId = ""
    
    var title = ""
    
    var cover = ""
    
    var likeNum = 0
    
    var commentNum = 0
    
    var readNum = ""
    
    var mobile = ""
    
    var created = ""
    
    var isLike = false
    
    var label: [String] = []
    
    var marks: [CircleInformationMarkModel] = []
    
    var height: CGFloat = 126
    
    func kj_didConvertToModel(from json: [String : Any]) {
        setup()
    }
    
    func setup() {
        
        marks = label.map { CircleInformationMarkModel(text: $0) }
        
        let timeMark = CircleInformationMarkModel(text: created,
                                                  isTag: false,
                                                  font: .systemFont(ofSize: 12),
                                                  color: UIColor(0x666666),
                                                  backgroundColor: .white)
        marks.append(timeMark)
        
        if readNum.bind.integerValue > 0 {
            let readMark = CircleInformationMarkModel(text: "\(readNum)阅读".bind.numberFormat(),
                                                      isTag: false,
                                                      font: .systemFont(ofSize: 12),
                                                      color: UIColor(0x666666),
                                                      backgroundColor: .white)
            marks.append(readMark)
        }
        
        let tagLayout = TagLayout()
        tagLayout.minimumLineSpacing = 10
        tagLayout.minimumInteritemSpacing = 10
        
        let mark = CircleInformationMarkModel(text: "")
        let maxWidth = mark.maxWidth+20
        let sizes = marks.map{ $0.textSize }
        let markHeight = tagLayout.heightForItems(sizes: sizes, maxWidth: maxWidth)
        height = max(126, 108+markHeight)
    }
}

extension MessageModel {
    
    func likeOp(handler: @escaping () -> Void) {
        
        guard UserManager.shared.hasLogin else {
            LoginManager.shared.showLogin()
            handler()
            return
        }
        
        if isLike {
            Hud.show(.custom(contentView: HudSpinner()))
            InfoApi.shared.removeLike(id: self.articleId) {
                self.likeNum = max(0, self.likeNum-1)
                self.isLike = false
                Hud.hide()
                handler()
            }
        } else {
            Hud.show(.custom(contentView: HudSpinner()))
            InfoApi.shared.addLike(id: self.articleId)  {
                self.likeNum = max(0, self.likeNum+1)
                self.isLike = true
                Hud.hide()
                handler()
            }
        }
    }
}


