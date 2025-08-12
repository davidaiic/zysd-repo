//
//  AddressListManager.swift
//  Basic
//
//  Created by wangteng on 2023/4/25.
//

import Foundation
import KakaJSON

class AddressListManager: BaseViewModel {
    
    var addressList: [AddressModel] = []
    
}

class AddressModel: Convertible {
    
    required init() {}
    
    
}
