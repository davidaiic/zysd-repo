//
//  ScanningSafeController.swift
//  Basic
//
//  Created by wangteng on 2023/3/26.
//

import Foundation

class ScanningSafeController: BaseViewController {
    
    let manager = ScanningSafeManager()
    
    lazy var sharedManager: BasicSharedManager = {
        BasicSharedManager()
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.register(cellType: ScanningSafeHeaderCell.self)
        tableView.register(cellType: ScanningSafeServerCell.self)
        tableView.register(cellType: CircleInfomationCell.self)
        tableView.register(headerFooterViewType: EntrySectionHeader.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        addNavigationLeft()
        
        navigation.item.title = "查询详情"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        manager.fetchDelegate = self
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
        self.view.showHud(.custom(contentView: HudSpinner()))
        manager.fetchData()
        addLoginNotification()
    }
    
    convenience init(goodsId: String) {
        self.init(nibName: nil, bundle: nil)
        manager.goodsId = goodsId
    }
    
    override func userDidLogin() {
        self.view.showHud(.custom(contentView: HudSpinner()))
        manager.fetchData()
    }
}

extension ScanningSafeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return manager.model.serverList.count
        case 2: return manager.model.articleList.count
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let headerCell = tableView.dequeueReusableCell(for: indexPath,cellType: ScanningSafeHeaderCell.self)
            headerCell.model = manager.model.goodsInfo
            return headerCell
        case 1:
            let server = tableView.dequeueReusableCell(for: indexPath,cellType: ScanningSafeServerCell.self)
            let model = manager.model.serverList[indexPath.row]
            server.thumb.kf.setImage(with: model.icon.bind.url)
            server.nameLabel.text = model.serverName
            server.subLabel.text = model.desc
            return server
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: CircleInfomationCell.self)
            let model = manager.model.articleList[indexPath.row]
            cell.model = model
            cell.sharedBt.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                self.shared(model)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 105
        case 1: return 60
        case 2: return manager.model.articleList[indexPath.row].height
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let configuration = AppWebPathConfiguration.shared.webPath(.sms)
            let webURL = configuration.webURL+"&goodsId="+manager.model.goodsInfo.goodsId
            BaseWebViewController(webURL: webURL, navigationTitle: configuration.navigationTitle).bind.push()
        case 1:
            let model = manager.model.serverList[indexPath.row]
            BaseWebViewController(webURL: model.webURL, navigationTitle: model.serverName).bind.push()
        case 2:
            let model = manager.model.articleList[indexPath.row]
            CommentDetailController(id: model.articleId, type: .info).bind.push()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1, manager.model.serverList.isEmpty {
            return 20
        }
        if section == 2, manager.model.articleList.isEmpty {
            return 20
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let divide = UIView()
        divide.backgroundColor = .background
        return divide
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 { return 50 }
        if section == 1, manager.model.serverList.isEmpty {
            return 0.01
        }
        if section == 2, manager.model.articleList.isEmpty {
            return 0.01
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1, manager.model.serverList.isEmpty {
            return UIView()
        }
        if section == 2, manager.model.articleList.isEmpty {
            return UIView()
        }
        
        let header = tableView.dequeueReusableHeaderFooterView(EntrySectionHeader.self)
        header?.titleShadow.isHidden = true
        switch section {
        case 0:
            header?.moreBt.isHidden = true
            header?.lblLabel.text = "说明书"
            header?.setupTop(0)
        case 1:
            header?.moreBt.isHidden = true
            header?.lblLabel.text = "服务"
            header?.setupTop(8)
        default:
            header?.moreBt.isHidden = false
            header?.lblLabel.text = "资讯"
            header?.setupTop(10)
            header?.moreBt.bind.addTargetEvent(handler: { [weak self] _ in
                guard let self = self else { return }
                InfomationListViewController(keyword: self.manager.model.goodsInfo.keyword).bind.push()
                
                /*
                self.navigationController?.popToRootViewController(animated: false)
                if let entryTab = UIWindow.currentWindow?.rootViewController as? EntryTabController,
                   let navi = entryTab.viewControllers?[1] as? UINavigationController,
                   let hoop = navi.viewControllers.first as? CircleWrapperController {
                    entryTab.selectedIndex = 1
                    hoop.selectIndex = 1
                }*/
            })
        }
        return header
    }
}

extension ScanningSafeController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        tableView.bind.animation(.fadeIn(duration: 0.25))
        view.hideHud()
        switch fetch {
        case .onCompleted:
            self.view.emptyView.hide()
            self.tableView.reloadData()
        case .failure(let failure):
            self.view.emptyView.show(failure: failure) { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()) )
                self.manager.fetchData()
            }
        }
    }
}

class ScanningSafeHeaderCell: UITableViewCell, Reusable {
    
    var model = CommodityModel() {
        didSet {
            thumb.kf.setImage(with: model.goodsImage.bind.url)
            
            /// 药品名称
            nameLabel.text = model.goodsName
            
            companyLabel.text = model.companyName
            
            /// 左上角标签
            mark.isHidden = model.drugProperties.isEmpty
            mark.backgroundColor = UIColor(model.drugPropertiesColor)
            mark.text = model.drugProperties
            
            setupTag()
        }
    }
    
    private func setupTag() {
        
        tagWrapper.subviews.forEach {
            if $0.tag == CommodityMarkFactory.tag {
                $0.removeFromSuperview()
            }
        }
        
        /// 国外获批上市标签
        if !model.marketTag.isEmpty {
            tagWrapper.addArrangedSubview(
                CommodityMarkFactory.makeText(.init(text: model.marketTag, color: "#FF9330"))
            )
        }
        
        /// 医保标签
        if !model.medicalTag.isEmpty {
            tagWrapper.addArrangedSubview(
                CommodityMarkFactory.makeText(.init(text: model.medicalTag, color: "#FF9330"))
            )
        }
        
        tagWrapper.isHidden = !model.hasTag
    }
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
        thumb.layer.cornerRadius = 4
        thumb.layer.masksToBounds = true
        return thumb
    }()
    
    lazy var nameLabel: UILabel = {
        let namesLabel = UILabel()
        namesLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        namesLabel.textColor = UIColor(0x333333)
        namesLabel.text = ""
        return namesLabel
    }()
    
    lazy var companyLabel: UILabel = {
        let companyLabel = UILabel()
        companyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        companyLabel.textColor = UIColor(0x999999)
        companyLabel.text = ""
        return companyLabel
    }()
    
    lazy var tagWrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        return wrapper
    }()
    
    lazy var arrow: UIImageView = {
        let thumb = UIImageView()
        thumb.image = "profile_arrow".bind.image
        return thumb
    }()
    
    lazy var mark: BindInsLabel = {
        let mark = BindInsLabel()
        mark.text = ""
        mark.font = UIFont.systemFont(ofSize: 12)
        mark.textColor = .white
        mark.insicWidth = 12
        mark.insicMaxWidth = 128
        mark.textAlignment = .center
        mark.backgroundColor = UIColor(0x459BF0)
        return mark
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
   
    private func setup() {
        selectionStyle = .none
        
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-15)
            make.width.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
            make.width.equalTo(120)
            make.height.equalTo(90)
        }
        
        thumb.addSubview(mark)
        mark.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.height.equalTo(18)
        }
        mark.bind.cornerRadius(4, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMaxYCorner])
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(15)
            make.top.equalTo(thumb)
            make.right.equalTo(arrow.snp.left).offset(-15)
        }
        
        contentView.addSubview(companyLabel)
        companyLabel.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.right.equalTo(-15)
        }
        
        contentView.addSubview(tagWrapper)
        tagWrapper.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(15)
            make.top.equalTo(companyLabel.snp.bottom).offset(8)
            make.height.equalTo(20)
            make.right.lessThanOrEqualToSuperview()
        }
    }
}

class ScanningSafeServerCell: UITableViewCell, Reusable {
    
    lazy var thumb: UIImageView = {
        let thumb = UIImageView()
        thumb.backgroundColor = .background
        thumb.layer.cornerRadius = 4
        thumb.layer.masksToBounds = true
        return thumb
    }()
    
    lazy var arrow: UIImageView = {
        let thumb = UIImageView()
        thumb.image = "profile_arrow".bind.image
        return thumb
    }()
    
    lazy var nameLabel: UILabel = {
        let namesLabel = UILabel()
        namesLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        namesLabel.textColor = UIColor(0x333333)
        return namesLabel
    }()
    
    lazy var subLabel: UILabel = {
        let subLabel = UILabel()
        subLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subLabel.textColor = UIColor(0x999999)
        return subLabel
    }()
    
    private lazy var divide: UIView = {
        let divide = UIView()
        divide.backgroundColor = .background
        return divide
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
   
    private func setup() {
        selectionStyle = .none
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.centerY.equalToSuperview()
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(15)
            make.top.equalTo(10)
            make.right.equalTo(-15)
            make.height.equalTo(20)
        }
        
        contentView.addSubview(subLabel)
        subLabel.snp.makeConstraints { make in
            make.left.equalTo(thumb.snp.right).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(2)
            make.right.equalTo(-15)
            make.height.equalTo(17)
        }
        
        contentView.addSubview(arrow)
        arrow.snp.makeConstraints { make in
            make.right.equalTo(-25)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(divide)
        divide.snp.makeConstraints { make in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalTo(0)
            make.height.equalTo(1)
        }
    }
}

extension ScanningSafeController {
    
    func shared(_ model: MessageModel) {
        view.showHud(.custom(contentView: HudSpinner()))
        BasicSharedApi.content(type: .info(model.articleId)) { [weak self] content in
            guard let self = self else { return }
            self.view.hideHud()
            guard let content = content else { return }
            let shareModel = BasicSharedModel(platformTypes: [.miniProgram])
            self.sharedManager.model = shareModel
            self.sharedManager.show { [weak self] _  in
                guard let self = self else { return true }
                self.sharedManager.content = content
                return true
            }
        }
    }
}
