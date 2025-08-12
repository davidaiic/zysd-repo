//
//  ReleaseViewController.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import UIKit

class ReleaseViewController: BaseViewController {

    private let model = ReleaseModel()
    
    private let sendManager = SendManager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: ReleaseInputCell.self)
        tableView.register(cellType: ReleaseAddImagesCell.self)
        tableView.register(cellType: ReleaseBottomTipCell.self)
        return tableView
    }()
    
    private lazy var publish: UIButton = {
        return UIButton.makeCommon("发布")
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationLeft()
        navigation.item.title = "发布帖子"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        view.addSubview(publish)
        publish.layer.cornerRadius = 22
        publish.snp.makeConstraints { make in
            make.left.equalTo(45)
            make.right.equalTo(-45)
            make.bottom.equalTo(-UIScreen.bind.safeBottomInset-10)
            make.height.equalTo(44)
        }
        
        publish.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            self.publishContent()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(publish.snp.top)
        }
        tableView.reloadData()
    }
    
    private func canPublish() -> Bool {
        if let text = model.text, text.bind.trimmed.isEmpty {
            Toast.showMsg("请输入内容")
            return false
        }
        return true
    }
    
    private func publishContent() {
        view.endEditing(true)
        guard canPublish() else {
            return
        }
        let text = model.text ?? ""
        Hud.show(.custom(contentView: HudSpinner()) )
        self.sendManager.send(type: .comment, id: "", text: text, images: model.configuration.imagModels) { [weak self] msg in
            Hud.hide()
            guard let self = self else { return }
            if msg.isEmpty {
                Toast.show("发帖成功")
                self.navigationController?.popViewController(animated: true)
            } else {
                Toast.show(msg, inView: self.view)
            }
        }
    }
}

extension ReleaseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let input = tableView.dequeueReusableCell(for: indexPath, cellType: ReleaseInputCell.self)
            input.model = self.model
            input.textViewDidChangeHeightHandler = {[weak self] in
                guard let self = self else { return }
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
            return input
        } else if indexPath.row == 1 {
            let image = tableView.dequeueReusableCell(for: indexPath, cellType: ReleaseAddImagesCell.self)
            image.model = self.model
            image.heightHandler = { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            return image
        } else {
            let input = tableView.dequeueReusableCell(for: indexPath, cellType: ReleaseBottomTipCell.self)
            return input
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class ReleaseModel {
    
    var text: String? = ""
    
    lazy var configuration: AddPictureConfiguration = {
        let configuration = AddPictureConfiguration()
        configuration.maxWidth = UIScreen.bind.width-30
        configuration.maxImages = 8
        configuration.row = 4
        return configuration
    }()
}
