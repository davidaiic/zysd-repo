//
//  CommentModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import Foundation
import KakaJSON

class CommentModel: Convertible {
    
    required init() {}
 
    let boxLayout = BoxViewLayout()
    
    var avatar = ""
    
    var commentId = ""
                    
    var username = ""

    var mobile = ""
    
    var created = ""
    
    var isLike = false
    
    var likeNum = 0
    
    var commentNum = 0
    
    var content = ""
    
    var pictures: [String] = []
    
    var showBottomOp = true {
        didSet {
            if !showBottomOp {
                height -= 37
            }
        }
    }
    
    var height: CGFloat = 0
    
    func kj_didConvertToModel(from json: [String : Any]) {
        boxLayout.imageURLs = pictures
        cofigHeight()
    }
    
    func cofigHeight() {
        
        content = content.bind.trimmed
        height += 50
        
        if !content.isEmpty {
            height += content.bind.boundingRect(.fontHeight(width: UIScreen.bind.width-30, font: .systemFont(ofSize: 14)))
            height += 12
        }
        
        if !pictures.isEmpty {
            height += boxLayout.boxWrapperSize.height
            height += 10
        }
        
        height += 47
    }
}

extension CommentModel {
    
    func likeOp(handler: @escaping () -> Void) {
        
        guard UserManager.shared.hasLogin else {
            LoginManager.shared.showLogin()
            handler()
            return
        }
        
        if isLike {
            CommentApi.shared.removeLike(id: self.commentId) { [weak self] in
                guard let self = self else { return }
                self.likeNum = max(0, self.likeNum-1)
                self.isLike = false
                handler()
            }
        } else {
            CommentApi.shared.addLike(id: self.commentId)  { [weak self] in
                guard let self = self else { return }
                self.likeNum = max(0, self.likeNum+1)
                self.isLike = true
                handler()
            }
        }
    }
    
    /// 资讯下面评论点赞
    func articleCommetLike(handler: @escaping () -> Void) {
        
        guard UserManager.shared.hasLogin else {
            LoginManager.shared.showLogin()
            handler()
            return
        }
        
        if isLike {
            InfoApi.shared.removeArticleCommentLike(id: self.commentId) { [weak self] in
                guard let self = self else { return }
                self.likeNum = max(0, self.likeNum-1)
                self.isLike = false
                handler()
            }
        } else {
            InfoApi.shared.addArticleCommentLike(id: self.commentId)  { [weak self] in
                guard let self = self else { return }
                self.likeNum = max(0, self.likeNum+1)
                self.isLike = true
                handler()
            }
        }
    }
}
