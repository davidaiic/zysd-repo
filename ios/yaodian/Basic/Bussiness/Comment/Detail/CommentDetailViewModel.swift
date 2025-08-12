//
//  CommentDetailViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation
import KakaJSON

enum CommentDetailDetailType {
    /// 资讯
    case info
    /// 评论
    case comment
    
    var sendApiPath: String {
        switch self {
        case .info: return "home/addArticleComment"
        case .comment: return "home/addComment"
        }
    }
    
    var sendApiKey: String {
        switch self {
        case .info: return "articleId"
        case .comment: return "commentId"
        }
    }
    
    var apiPath: String {
        switch self {
        case .info: return "home/articleInfo"
        case .comment: return "home/commentInfo"
        }
    }
    
    var apiKey: String {
        switch self {
        case .info: return "articleId"
        case .comment: return "commentId"
        }
    }
    
    var pageTitle: String {
        switch self {
        case .info: return "资讯详情"
        case .comment: return "帖子详情"
        }
    }
    
    var sendMaxImages: Int {
        switch self {
        case .info: return 4
        case .comment: return 6
        }
    }
    
    var marqueeViewData: [String] {
        switch self {
        case .info: return ["该内容由识药查真伪团队收集整理，欢迎转载！因个体差异，该内容不能作为任何用药依据，请严格按药品说明书或医嘱下购买和使用。如有不当之处欢迎指正！"]
        case .comment: return ["凡涉及治疗方案/用药等内容均存在个体差异，请勿盲目效仿."]
        }
    }
}

class CommentDetailViewModel: BaseViewModel {
    
    var detailModel = CommentDetailModel()
    
    var type: CommentDetailDetailType = .comment
    
    var identify = ""
    
    /// 加载数据
    /// - Parameter increment: true
    func fetch(_ increment: Bool = true) {
        guard let api = api(path: type.apiPath, increment: increment) else {
            return
        }
        api.addParameter(key: "page", value: page)
            .addParameter(key: type.apiKey, value: identify)
            .perform { [weak self] result in
                guard let self = self else { return }
                self.isFetching = false
                switch result {
                case .success(let res):
                    let detail = res.model(CommentDetailModel.self)
                    detail.setupInfo(type: self.type)
                    detail.commentList.forEach { $0.showBottomOp = false }
                    if self.page == 1 {
                        self.detailModel = detail
                    } else {
                        self.detailModel.commentList.append(contentsOf: detail.commentList)
                    }
                    self.setupNext(detail.commentList.count)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let error):
                    if self.page == 1 {
                        self.fetchDelegate?.onCompletion(.failure(error))
                    } else {
                        Toast.showMsg(error.domain)
                    }
                }
            }
    }
    
    func likeOp(handler: @escaping () -> Void) {
        guard UserManager.shared.hasLogin else {
            LoginManager.shared.showLogin()
            handler()
            return
        }
        
        switch type {
        case .info:
            if detailModel.info.isLike {
                InfoApi.shared.removeLike(id: self.identify) { [weak self] in
                    guard let self = self else { return }
                    self.detailModel.info.likeNum = max(0, self.detailModel.info.likeNum-1)
                    self.detailModel.info.isLike = false
                    handler()
                }
            } else {
                InfoApi.shared.addLike(id: self.identify)  { [weak self] in
                    guard let self = self else { return }
                    self.detailModel.info.likeNum = max(0, self.detailModel.info.likeNum+1)
                    self.detailModel.info.isLike = true
                    handler()
                }
            }
        case .comment:
            if detailModel.info.isLike {
                CommentApi.shared.removeLike(id: self.identify) { [weak self] in
                    guard let self = self else { return }
                    self.detailModel.info.likeNum = max(0, self.detailModel.info.likeNum-1)
                    self.detailModel.info.isLike = false
                    handler()
                }
            } else {
                CommentApi.shared.addLike(id: self.identify)  { [weak self] in
                    guard let self = self else { return }
                    self.detailModel.info.likeNum = max(0, self.detailModel.info.likeNum+1)
                    self.detailModel.info.isLike = true
                    handler()
                }
            }
        }
    }
}

class CommentDetailModel: Convertible {
    
    required init() { }
    
    var commentList: [CommentModel] = []
    
    var info = CommentDetailInfoModel()
    
    var commentCnt: Int {
        if info.commentNum > 0 && commentList.count > 0 {
            return info.commentNum
        }
        return 0
    }
    
    func setupInfo(type: CommentDetailDetailType = .comment) {
        info.type = type
        info.setupHeight()
    }
}

class CommentDetailInfoModel: Convertible {
    
    required init() {}

    var identify = ""
    
    var avatar = ""
    
    var username = ""
    
    var content = ""
    
    var likeNum = 0
    
    var commentNum = 0
    
    var created = ""
    
    var isLike = false

    let boxLayout = BoxViewLayout()
    
    var pictures: [String] = []
    
    var label: [String] = []
  
    var height: CGFloat = 0
    
    var marks: [CircleInformationMarkModel] = []
    
    var masksHeight: CGFloat = 0
    
    var type: CommentDetailDetailType = .comment
    
    func attributedContent() -> NSMutableAttributedString {
        let attributedContent = try? NSMutableAttributedString(
            data: content.data(using: .unicode, allowLossyConversion: true)!,
            options:[.documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        if let attributed = attributedContent {
            attributed.enumerateAttributes(in: .init(location: 0, length: attributed.length)) { attribut, range, _ in
                if let attachment = attribut[.attachment] as? NSTextAttachment {
                    var size = attachment.bounds.size
                    let maxWidth = UIScreen.bind.width-30
                    if size.width > maxWidth {
                        size.height = maxWidth/size.width*size.height
                        size.width = maxWidth
                    }
                    attachment.bounds.size = size
                }
            }
        }
        
        switch type {
        case .comment:
            attributedContent?.bind
                .font(.systemFont(ofSize: 14))
                .foregroundColor(UIColor(0x333333))
        case .info:
            break
        }
        
        if let attributedContent = attributedContent {
            return attributedContent
        } else {
            return NSMutableAttributedString.init(string: content)
                .bind
                .font(.systemFont(ofSize: 14))
                .foregroundColor(UIColor(0x333333))
                .base
        }
    }
   
    func kj_modelKey(from property: Property) -> ModelPropertyKey {
        switch property.name {
        case "identify": return "commentId"
        default: return property.name
        }
    }
    
    func kj_didConvertToModel(from json: [String : Any]) {
        if let articleId = json["articleId"] as? String,
           !articleId.bind.trimmed.isEmpty {
            identify = articleId
        }
        setupMasks()
        
        boxLayout.imageURLs = pictures
    }
    
    func setupHeight() {
        
        height += 64
        
        height += attributedContent().boundingRect(with: .init(width: UIScreen.bind.width-30, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        height += 15
    }
    
    func setupMasks() {
        
        marks = label.map { CircleInformationMarkModel(text: $0, maxWidth: UIScreen.bind.width-80) }
        
        let timeMark = CircleInformationMarkModel(text: created,
                                                  isTag: false,
                                                  maxWidth: UIScreen.bind.width-80,
                                                  font: .systemFont(ofSize: 12),
                                                  color: UIColor(0x666666),
                                                  backgroundColor: .white)
        marks.append(timeMark)
        
        let tagLayout = TagLayout()
        tagLayout.minimumLineSpacing = 10
        tagLayout.minimumInteritemSpacing = 10
        
        let mark = CircleInformationMarkModel(text: "")
        let maxWidth = mark.maxWidth+20
        let sizes = marks.map{ $0.textSize }
        let markHeight = tagLayout.heightForItems(sizes: sizes, maxWidth: maxWidth)
        self.masksHeight = markHeight
    }
    
}
