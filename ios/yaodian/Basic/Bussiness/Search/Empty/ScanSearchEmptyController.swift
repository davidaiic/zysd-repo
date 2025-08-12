//
//  ScanSearchEmptyController.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanSearchEmptyController: BaseViewController {
    
    let manager = ScanSearchEmptyViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: ScanSearchEmptyCell.self)
        tableView.register(cellType: ScanSearchEmptyCommodityView.self)
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
        manager.fetch()
    }
}

extension ScanSearchEmptyController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let bannerCel = tableView.dequeueReusableCell(for: indexPath,cellType: ScanSearchEmptyCell.self)
            bannerCel.upload = {
                AppWebPathConfiguration.shared.openWeb(.uploadPhoto)
            }
            return bannerCel
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: ScanSearchEmptyCommodityView.self)
            cell.models = manager.model.hotCompanyList
            cell.tLabel.isHidden = manager.model.hotCompanyList.isEmpty
            cell.tLabel.text = "国外仿制药热门厂家"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: ScanSearchEmptyCommodityView.self)
            cell.models = manager.model.otherCompanyList
            cell.tLabel.text = "其它热门药厂"
            cell.tLabel.isHidden = manager.model.otherCompanyList.isEmpty
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 260
        case 1:
            return manager.model.hotCompanyListHeight
        case 2:
            return manager.model.otherCompanyListHeight
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }
}

extension ScanSearchEmptyController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.bind.animation(.fadeIn(duration: 0.25))
        self.view.hideHud()
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

class ScanSearchEmptyCell: UITableViewCell, Reusable {
    
    var upload: (() -> Void)?
    
    lazy var config: BasicPopConfiguration = {
        BasicPopManager()
            .bind(.image("scan_search_empty".bind.image))
            .bind(.spacing(20))
            .bind(.padding(.zero))
            .bind(.contentMaxWidth(UIScreen.bind.width-40))
            .bind(.title("暂无搜索结果，可上传照片或咨询客服", {
                $0.attributedText.bind
                    .font(.systemFont(ofSize: 14, weight: .regular))
                    .foregroundColor(UIColor(0x999999))
            }))
            .action(titles: ["上传照片", "咨询客服"], handler: { [weak self] action in
                guard let self = self else { return }
                action.handler = { [weak self] selectedIndex -> Bool in
                    guard let self = self else { return true}
                    
                    if selectedIndex == 0 {
                        self.upload?()
                    } else {
                        AppWebPathConfiguration.shared.openWeb(.callUs)
                    }
                    return true
                }
                action.configureHandler = { btn in
                    if btn.tag == 0 {
                        btn.backgroundColor = .white
                        btn.setTitleColor(UIColor(0x0FC8AC), for: .normal)
                        btn.layer.borderWidth = 1
                        btn.layer.borderColor = UIColor(0x0FC8AC).cgColor
                    }
                    
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                }
                action.direction = .horizontal
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
            make.top.equalTo(30)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(10)
        }
    }
}
