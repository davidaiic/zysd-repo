//
//  CircleCommentViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/4/5.
//

import Foundation
import Kingfisher

class CircleCommentViewModel: BaseViewModel {
    
    var comments: [CommentModel] = []
    
    var keyword = ""
    var sortId = ""
    var labelId = ""
    
    func fetchComment(_ increment: Bool = true) {
        
        guard let api = api(path: "home/commentList", increment: increment) else {
            return
        }
       
        api.addParameter(key: "page", value: page)
            .addParameter(key: "sortId", value: sortId)
            .addParameter(key: "labelId", value: labelId)
            .addParameter(condition: !keyword.isEmpty, key: "keyword", value: keyword)
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

extension CircleCommentViewModel {
    
    func prefetchRows(at indexPaths: [IndexPath]) {
        let urls = indexPaths.compactMap {
            return comments[$0.row].boxLayout.imageURLs
                .compactMap { imageURL in
                    if imageURL.bind.isValidUrl {
                        return URL(string: imageURL)
                    }
                    return nil
                }
        }
        guard !urls.isEmpty else {
            return
        }
        ImagePrefetcher(urls: urls.flatMap{ $0 }).start()
    }
}
