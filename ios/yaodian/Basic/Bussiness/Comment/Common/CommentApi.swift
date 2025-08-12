//
//  CommentApi.swift
//  Basic
//
//  Created by wangteng on 2023/3/15.
//

import Foundation

class CommentApi {
    
    static let shared = CommentApi()
    
    /// 评论点赞
    func addLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/commentLike")
            .addParameter(key: "commentId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
    
    /// 评论点赞
    func removeLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/commentLike")
            .addParameter(key: "commentId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
}

class InfoApi {
    
    static let shared = InfoApi()
    
    /// 资讯点赞
    func addLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/articleLike")
            .addParameter(key: "articleId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
    /// 资讯点赞
    func removeLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/articleLike")
            .addParameter(key: "articleId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
    
    /// 资讯评论点赞
    func addArticleCommentLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/articleCommentLike")
            .addParameter(key: "commentId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
    
    /// 资讯评论点赞
    func removeArticleCommentLike(id: String, handler: @escaping () -> Void) {
        BasicApi("home/articleCommentLike")
            .addParameter(key: "commentId", value: id)
            .perform { result in
                switch result {
                case .success:
                    handler()
                case .failure:
                    break
                }
            }
    }
    

}
