//
//  BasicResponseSerializer.swift
//  Drug
//
//  Created by wangteng on 2023/2/9.
//

import Foundation
import Alamofire
import KakaJSON

public final class BasicDictionaryResponseSerializer: ResponseSerializer {
    
    public func serialize(request: URLRequest?,
                          response: HTTPURLResponse?,
                          data: Data?, error: Error?) throws -> BasicResponse {
        
        guard error == nil else { throw error! }
       
        guard let data = data, !data.isEmpty else {
            guard emptyResponseAllowed(forRequest: request, response: response) else {
                throw AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)
            }
            return BasicResponse()
        }
        do {
            let options = JSONSerialization.ReadingOptions.fragmentsAllowed
            let dictionary = try JSONSerialization.jsonObject(with: data,
                                                    options: options)
            return (dictionary as? [String: Any])?.kj.model(BasicResponse.self) ?? BasicResponse()
        } catch {
            
            throw AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error))
        }
    }
}
