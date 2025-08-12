//
//  AddressManagerViewController.swift
//  Basic
//
//  Created by wangteng on 2023/4/25.
//

import UIKit

class AddressListViewController: BaseViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9843137255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.register(cellType: AddressListCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(for: indexPath, cellType: AddressListCell.self)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        true
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .default,
//                                          title: "删除",
//                                          handler: { [weak self] (action, indexPath) in
//
//                                          })
//        delete.backgroundColor = UIColor.init(hex: "#D00002")
//        return [delete]
//    }
}
