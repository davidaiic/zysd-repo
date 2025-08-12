//
//  ScanSearchEmptyViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation
import KakaJSON

class ScanSearchEmptyViewModel: BaseViewModel {
    
    var model = ScanSearchEmptyHotCompanyGroup()
    
    func fetch() {
        BasicApi("query/hotCompany")
            .perform { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let res):
                    self.model = res.model(ScanSearchEmptyHotCompanyGroup.self)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
            }
    }
}

class ScanSearchEmptyHotCompanyGroup: Convertible {
    
    required init() {}
    
    var hotCompanyList: [ScanSearchEmptyHotCompany] = []
    var otherCompanyList: [ScanSearchEmptyHotCompany] = []
    
    var hotCompanyListHeight: CGFloat = 0
    var otherCompanyListHeight: CGFloat = 0
    
    func kj_didConvertToModel(from json: [String : Any]) {
        
        if !hotCompanyList.isEmpty {
            self.hotCompanyListHeight = Helper.calulateHeight(count: hotCompanyList.count,
                                                         itemHeight: ScanSearchEmptyCommodityView.height,
                                                         spacing: 15) + 68
        }
       
        if !otherCompanyList.isEmpty {
            self.otherCompanyListHeight = Helper.calulateHeight(count: otherCompanyList.count,
                                                         itemHeight: ScanSearchEmptyCommodityView.height,
                                                         spacing: 15) + 68
        }
    }
}

class ScanSearchEmptyHotCompany: Convertible {
    
    required init() {}
    var companyId = ""
    var companyName = ""
    var companyImage = ""
}
