//
//  SearchResultEmpty.swift
//  Basic
//
//  Created by wangteng on 2023/3/17.
//

import Foundation

class SearchResultEmptyController: BaseViewController {
    
    let manager = SearchResultEmptyViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: SearchResultEmptyCell.self)
        tableView.register(cellType: EntryTotTableCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        manager.fetchDelegate = self
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}

extension SearchResultEmptyController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let bannerCel = tableView.dequeueReusableCell(for: indexPath,cellType: SearchResultEmptyCell.self)
            bannerCel.upload = {
                AppWebPathConfiguration.shared.openWeb(.uploadPhoto)
            }
            return bannerCel
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: EntryTotTableCell.self)
            cell.model = manager.model
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 280
        case 1:
            return manager.model.height
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension SearchResultEmptyController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.bind.animation(.fadeIn(duration: 0.25))
        Hud.hide()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetch()
            }
        }
    }
}

class SearchResultEmptyCell: UITableViewCell, Reusable {
    
    var upload: (() -> Void)?
    
    lazy var config: BasicPopConfiguration = {
        BasicPopManager()
            .bind(.contentMaxWidth(UIScreen.bind.width-100))
            .bind(.image("search_empty".bind.image))
            .bind(.title("暂无商品，需要你上传照片进行数据更新", {
                $0.attributedText.bind
                    .font(.systemFont(ofSize: 14, weight: .regular))
                    .foregroundColor(UIColor(0x999999))
            }))
            .action(titles: ["立即上传"], handler: { [weak self] action in
                guard let self = self else { return }
                action.handler = { [weak self] _ -> Bool in
                    guard let self = self else { return true}
                    self.upload?()
                    return true
                }
                action.configureHandler = { btn in
                    if btn.tag == 0 {
                        btn.backgroundColor = .barTintColor
                    }
                }
                action.spacingLeftRight = 0
            }).config
    }()
    
    private lazy var divide: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        
        selectionStyle = .none
        
        let empty = BasicPopContentView(configuration: self.config)
        contentView.addSubview(empty)
        empty.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
    }
}
