//
//  ScanningResultController.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation

class ScanningResultController: BaseViewController {
    
    let manager = ScanningResultViewModel()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .init(origin: .zero, size: .init(width: UIScreen.bind.width, height: 0.1)))
        tableView.backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.keyboardDismissMode = .onDrag
        tableView.register(cellType: ScanningResultImageCell.self)
        tableView.register(cellType: ScanningResultCell.self)
        tableView.register(cellType: ScanningResultRecommandCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        
        addNavigationLeft()
        addNavigationRight()
        
        navigation.item.title = "图片识别结果"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        manager.fetchDelegate = self
        tableView.alpha = 0
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.bottom.equalTo(-UIScreen.bind.safeBottomInset)
        }
        
        tableView.setupFooterRefresh { [weak self] in
            guard let self = self else { return }
            self.manager.fetchCommodity(increment: true)
        }
        
        self.view.showHud(.custom(contentView: HudSpinner()))
        manager.fetchHotWord()
        manager.fetchCommodity(increment: false)
    }
    
    init(recognition: RecognitionModel) {
        super.init(nibName: nil, bundle: nil)
        manager.recognition = recognition
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addNavigationRight() {
        let buttonBlock = {
            return BaseButton()
                .bind(.title("重拍"))
                .bind(.color(.white))
                .bind(.font(.systemFont(ofSize: 14)))
                .bind(.contentEdgeInsets(.init(top: 0, left: 0, bottom: 0, right: 0)))
        }
        navigation.item.add(buttonBlock(), position: .right) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ScanningResultController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch manager.rows[indexPath.row] {
        case .image:
            let thumb = tableView.dequeueReusableCell(for: indexPath,cellType: ScanningResultImageCell.self)
            thumb.thumb.kf.setImage(with: manager.recognition.imageUrl.bind.url, placeholder: "place_holder".bind.image)
            thumb.bt.bind.addTargetEvent { [weak self] _ in
                guard let self = self else { return }
                DrawTextController(imageId: self.manager.recognition.imageId).bind.push()
            }
            return thumb
        case .word:
            let recommand = tableView.dequeueReusableCell(for: indexPath,cellType: ScanningResultRecommandCell.self)
            recommand.hotWords = manager.hotWords
            recommand.wordDidChagedHandler = { [weak self] in
                guard let self = self else { return }
                self.view.showHud(.custom(contentView: HudSpinner()))
                self.manager.fetchCommodity(increment: false)
            }
            return recommand
        case .commodity:
            let cell = tableView.dequeueReusableCell(for: indexPath,cellType: ScanningResultCell.self)
            if manager.hotWords.wordList.isEmpty {
                cell.tLabel.text = "热门搜索"
            } else {
                cell.tLabel.text = "搜索到以下结果"
            }
            cell.tLabel.isHidden = manager.hotCommodity.goodsList.isEmpty
            cell.titleShadow.isHidden = manager.hotCommodity.goodsList.isEmpty
            
            cell.setupModel(manager.hotCommodity)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch manager.rows[indexPath.row] {
        case .image:
            return 290
        case .word:
            return manager.hotWordsHeight
        case .commodity:
            if manager.hotCommodity.goodsList.isEmpty {
                return 160
            }
            return manager.hotCommodity.height
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension ScanningResultController: CompletionDelegate {
    
    func onCompletion(_ fetch: CompletionEnum) {
        self.view.hideHud()
        tableView.bind.animation(.fadeIn(duration: 0.25))
        tableView.stopRefreshing()
        switch fetch {
        case .onCompleted:
            tableView.reloadData()
            tableView.mj_footer?.isHidden = !manager.hasNext
        case .failure(let error):
            Toast.showMsg(error.domain)
        }
    }
}

class ScanningResultCell: EntryTotTableCell {
    
    private lazy var thumb: UIImageView = {
        let thumb = UIImageView(image: "scan_empty_keywords".bind.image)
        thumb.isHidden = true
        return thumb
    }()
    
    lazy var thumbTip: UILabel = {
        let thumbTip = UILabel()
        thumbTip.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        thumbTip.textColor = UIColor(0x999999)
        thumbTip.text = "未搜索到结果"
        thumbTip.isHidden = true
        return thumbTip
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        contentView.addSubview(thumb)
        thumb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tLabel.snp.bottom).offset(10)
        }
        contentView.addSubview(thumbTip)
        thumbTip.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thumb.snp.bottom).offset(8)
        }
    }
    
    func setupModel(_ model: HotCommodity) {
        self.model = model
        thumb.isHidden = !model.goodsList.isEmpty
        thumbTip.isHidden = !model.goodsList.isEmpty
        collectionView.isHidden = model.goodsList.isEmpty
    }
}
