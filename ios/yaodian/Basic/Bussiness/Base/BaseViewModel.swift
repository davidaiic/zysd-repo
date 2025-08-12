//
//  BaseViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import Foundation

enum CompletionEnum {
    case onCompleted
    case failure(_ error: NSError)
}

protocol CompletionDelegate: AnyObject {
    
    func onCompletion(_ fetch: CompletionEnum)
}

public class BaseViewModel {
    
    weak var fetchDelegate: CompletionDelegate?
    
    var isFetching = false
    
    var page = 1
    
    var hasNext = true
}

extension BaseViewModel {
    
    func setupNext(_ count: Int, limit: Int = 20) {
        hasNext = count >= limit
    }
    
    func setupPage(_ increment: Bool) {
        if increment {
            page += 1
        } else {
            page = 1
        }
    }
    
    func api(path: String, increment: Bool) -> BasicApi? {
        setupPage(increment)
        
        /// 下一页
        if increment {
            
            /// 加载结束并且有下一页数据
            if !isFetching && hasNext {
                isFetching = true
                return BasicApi(path)
            }
            return nil
        }
        /// 第一页
        else {
            isFetching = true
            return BasicApi(path)
        }
    }
}
