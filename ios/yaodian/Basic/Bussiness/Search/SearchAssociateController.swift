//
//  SearchAssociateController.swift
//  Basic
//
//  Created by wangteng on 2023/3/6.
//

import UIKit
import Bind

class SearchAssociateController: BaseViewController {

    var selectedAssociateHandler: ((String) -> Void)?
    
    var keyWords = "" {
        didSet {
            getAssociateWords()
        }
    }
    
    let viewModel = SearchAssociateManager()
    
    private lazy var associateTipView: AssociateTipView = {
        let footerView = AssociateTipView(frame: CGRect(x: 0, y: 0, width: UIScreen.bind.width, height: 48))
        footerView.btn.bind.addTargetEvent(handler: {[weak self] _ in
            guard let self = self else { return }
            self.selectedAssociateHandler?(self.keyWords)
        })
        return footerView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.separatorColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: SearchAssociateCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        viewModel.fetchDelegate = self
        tableView.setupFooterRefresh { [weak self] in
            guard let self = self else { return }
            self.viewModel.fetch(self.keyWords, increment: true)
        }
    }
    
    func getAssociateWords() {
        self.view.emptyView.hide()
        tableView.tableFooterView = associateTipView
        associateTipView.lblForSearch.attributedText = NSMutableAttributedString(string: "搜索" + keyWords + "...")
            .bind
            .foregroundColor(UIColor(0x333333))
            .font(UIFont.systemFont(ofSize: 14))
            .hightLight(keyWords, font: .systemFont(ofSize: 14), color: .barTintColor)
            .base
        viewModel.associateWords.removeAll()
        tableView.reloadData()
        viewModel.fetch(keyWords, increment: false)
    }
}

extension SearchAssociateController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.stopRefreshing()
        self.view.emptyView.hide()
        switch fetch {
        case .onCompleted:
            
            if viewModel.associateWords.isEmpty {
                let empty: EmptyViewStyle = .empty("未搜索到结果,换个搜索词试试")
                empty.centerYoffset = -85
                self.view.emptyView.show(style: empty)
            } else {
                tableView.tableFooterView = nil
            }
            self.tableView.reloadData()
            self.tableView.mj_footer?.isHidden = !viewModel.hasNext
        case .failure(let error):
            Toast.showMsg(error.domain)
        }
    }
}

extension SearchAssociateController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SearchAssociateCell.self)
        let associateWord = viewModel.associateWords[indexPath.row]
        
        let attributedText = NSMutableAttributedString(string: associateWord.word)
        attributedText.bind.font(.systemFont(ofSize: 14))
            .foregroundColor(UIColor(0x333333))
            .hightLight(keyWords, font: .systemFont(ofSize: 14), color: UIColor(0x0FC8AC))
        cell.lblLabel.attributedText = attributedText
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.associateWords.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let associateWord = viewModel.associateWords[indexPath.row]
        self.selectedAssociateHandler?(associateWord.word)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needFetch = indexPaths.contains { $0.row >= viewModel.associateWords.count-1}
        if needFetch {
            self.viewModel.fetch(self.keyWords, increment: true)
        }
    }
}

class SearchAssociateCell: UITableViewCell, Reusable {
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.image = "search_associate_icon".bind.image
        return thumb
    }()
    
    lazy var lblLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = "#0FC8AC".color
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }
        
        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.right.equalTo(-15)
        }
    }
}

private class AssociateTipView: UIView {
    
    lazy var btn: UIButton = {
        let button = UIButton(type: .custom)
        return button
    }()
    
    lazy var ivForSearchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search_associate_icon")
        return imageView
    }()
    
    lazy var lineForBottom: UIView = {
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9176470588, blue: 0.9176470588, alpha: 1)
        return line
    }()
  
    lazy var lblForSearch: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.06666666667, green: 0.06666666667, blue: 0.06666666667, alpha: 1)
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ivForSearchIcon)
        ivForSearchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
        
        addSubview(lblForSearch)
        lblForSearch.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(ivForSearchIcon.snp.right).offset(5)
            make.right.equalTo(-15)
        }
        
        addSubview(lineForBottom)
        lineForBottom.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(0)
            make.height.equalTo(0.5)
        }
        
        addSubview(btn)
        btn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
