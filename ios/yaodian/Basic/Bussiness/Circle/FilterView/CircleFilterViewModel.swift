//
//  CircleFilterViewModel.swift
//  Basic
//
//  Created by wangteng on 2023/4/4.
//

import Foundation

class CircleFilterViewModel: BaseViewModel {
    
    var model = CircleFilterModel()
    
    func sortIds() -> String {
        guard let models = self.model.groups.filter({$0.title == "排序"}).first?.models else {
            return ""
        }
        return models.filter{ $0.selected }.map{ $0.sortId }.joined(separator: ",")
    }
    
    func filterIds() -> String {
        guard let models = self.model.groups.filter({$0.title == "筛洗条件"}).first?.models else {
            return ""
        }
        return models.filter{ $0.selected }.map{ $0.sortId }.joined(separator: ",")
    }
    
    func queryData() {
        BasicApi("home/filterCriteria")
            .perform { res in
                switch res {
                case .success(let response):
                    self.megerdGroups(response: response)
                    self.fetchDelegate?.onCompletion(.onCompleted)
                case .failure(let failure):
                    self.fetchDelegate?.onCompletion(.failure(failure))
                }
        }
    }
    
    func preQueryData() {
        BasicApi("home/filterCriteria")
            .perform { res in
                switch res {
                case .success(let response):
                    self.megerdGroups(response: response)
                case .failure:
                    break
                }
        }
    }
    
    private func megerdGroups(response: BasicResponse) {
        
        self.model.groups.removeAll()
        
        let sortData = response.modelArray(HoopFilterItemModel.self, key: "sortList")
        let labelData = response.modelArray(HoopFilterItemModel.self, key: "labelList")
        
        if !sortData.isEmpty {
            let sort = HoopFilterGroupModel()
            sort.title = "排序"
            sort.models = sortData
            self.model.groups.append(sort)
        }
        
        if !sortData.isEmpty {
            let con = HoopFilterGroupModel()
            con.title = "筛洗条件"
            con.isMuti = true
            con.models = labelData
            self.model.groups.append(con)
        }
    }
}
