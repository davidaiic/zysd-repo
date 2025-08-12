//
//  BasicApi.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation
import Alamofire

public class BasicApi {
    
    public var method: HTTPMethod = .post
    
    public var arguments = BasicApiArguments()
    
    public var path = ""
    
    public var ignoreShowLogin = false
    
    convenience public init(_ path: String, method: HTTPMethod = .post) {
        self.init()
        self.path = path
        self.method = method
    }
    
    func ignoreShowLogin(_ ignore: Bool) -> BasicApi {
        self.ignoreShowLogin = ignore
        return self
    }
    
    @discardableResult
    func perform(completionHandler: @escaping (Result<BasicResponse, NSError>) -> Void) -> BasicApi {
        let serializer = BasicDictionaryResponseSerializer()
        AF.request(BasicApi.url(path, type: .api),
                   method: method,
                   parameters: arguments.arguments,
                   headers: arguments.httpHeaders)
            .response(queue: .main,
                      responseSerializer: serializer) { response in
                switch response.result {
                case .success(let res):
                    completionHandler(.success(res))
                case .failure(let error):
                    let failure = NSError(domain: error.errorDescription ?? "", code: error.responseCode ?? 0)
                    completionHandler(.failure(failure))
                }
            }
        return self
    }
    
    func upload(form: UploadForm,
                progress: @escaping (Progress) -> Void,
                completionHandler: @escaping (Result<BasicResponse, NSError>) -> Void) {
        let serializer = BasicDictionaryResponseSerializer()
        AF.upload(multipartFormData: { [weak self] formData in
            guard let self = self else { return }
            
            form.addTo(formData)
          
            for argument in self.arguments.arguments {
                var data = Data()
                switch argument.value {
                case let string as String:
                    data = Data(string.utf8)
                default:
                    data = Data("\(argument.value)".utf8)
                }
                formData.append(data, withName: argument.key)
            }
        },
                  to: BasicApi.url(path, type: .api),
                  headers: arguments.httpHeaders)
        .uploadProgress(closure: {
            progress($0)
        })
        .response(queue: .main,
                  responseSerializer: serializer){ response in
            switch response.result {
            case .success(let res):
                completionHandler(.success(res))
            case .failure(let error):
                let failure = NSError(domain: error.errorDescription ?? "", code: error.responseCode ?? 0)
                completionHandler(.failure(failure))
            }
        }
    }
}

extension BasicApi {
    
    @discardableResult
    public func addParameter(key: String, value: Any) -> BasicApi {
        arguments.addParameter(key, value: value)
        return self
    }
    
    @discardableResult
    public func addParameter(condition: Bool, key: String, value: Any) -> BasicApi {
        if condition {
            arguments.addParameter(key, value: value)
        }
        return self
    }
    
    public subscript(key: String) -> AnyObject? {
        get {
            return self.arguments[key]
        }
        set {
            self.arguments[key] = newValue
        }
    }
}

extension BasicApi: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "path: \(path)\nmethod: \(method)\narguments: \(arguments.arguments.bind.toJsonString() ?? "")"
    }
}

extension BasicApi {
    
    enum DomainType: String {
        case h5 = "https://h5.shiyao.yaojk.com.cn/"
        case api = "https://shiyao.yaojk.com.cn/"
    }
    
    class func url(_ path: String, type: DomainType) -> String {
        type.rawValue+path
    }
    
}
