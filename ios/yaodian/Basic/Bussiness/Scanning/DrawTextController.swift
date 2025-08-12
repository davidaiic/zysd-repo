//
//  DrawTextController.swift
//  Basic
//
//  Created by wangteng on 2023/3/25.
//

import Foundation
import KakaJSON

class DrawTextController: BaseViewController {
    
    class DrawWord: Convertible {
        required init() {}
        var id = 0
        var text = ""
        var selected = false
    }
    
    private var beginDrawWord: DrawWord?
    private var slideIndex: Int?
    
    private var selectedAllWords: Bool = false
    
    private lazy var panRecognizer: UIPanGestureRecognizer = {
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(slideSelectAction(_:)))
        return panRecognizer
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = TagLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.delegate = self
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(cellType: DrawTextCell.self)
        collectionView.delegate = self
        collectionView.contentInset = .init(top: 5, left: 5, bottom: 0, right: 5)
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        return collectionView
    }()
    
    var drawWords: [DrawWord] = []
    
    var imageId = ""
    
    lazy var tipText: UILabel = {
        let tipText = UILabel()
        tipText.font = UIFont.systemFont(ofSize: 14)
        tipText.textColor = UIColor(0x666666)
        tipText.text = "提示：滑动选择搜索词"
        return tipText
    }()
    
    lazy var wrapper: UIStackView = {
        let wrapper = UIStackView()
        wrapper.axis = .horizontal
        wrapper.spacing = 10
        wrapper.distribution = .fillEqually
        return wrapper
    }()
    
    lazy var allButton: BaseButton = {
        makeButton("全选", image: "scanning_selected_all".bind.image)
    }()
   
    lazy var copyButton: BaseButton = {
        makeButton("复制", image: "scanning_copy_text".bind.image)
    }()
    
    lazy var searchButton: BaseButton = {
        makeButton("搜索", image: "scanning_copy_search".bind.image)
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        closePopGestureRecognizer()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        openPopGestureRecognizer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addGestureRecognizer(panRecognizer)
        addNavigationLeft()
        
        navigation.item.title = "提取文字"
        navigation.bar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ]
        
        view.addSubview(tipText)
        tipText.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(UIScreen.bind.navigationBarHeight)
            make.height.equalTo(60)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(tipText.snp.bottom)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-80-UIScreen.bind.safeBottomInset)
        }
      
        wrapper.isHidden = true
        view.addSubview(wrapper)
        wrapper.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(0)
            make.height.equalTo(80+UIScreen.bind.safeBottomInset)
        }
        
        addOperations()
        addLoginNotification()
        query()
    }
    
    init(imageId: String) {
        super.init(nibName: nil, bundle: nil)
        self.imageId = imageId
    }
    
    override func userDidLogin() {
        query()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func slideSelectAction(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? DrawTextCell else {
            return
        }
        switch pan.state {
        case .began:
            if beginDrawWord == nil {
                let model = drawWords[indexPath.row]
                model.selected = !model.selected
                cell.model = model
                beginDrawWord = model
                slideIndex = indexPath.row
            }
        case .changed:
           
            guard let slideIndex = slideIndex,
                    let beginDrawWord = self.beginDrawWord,
                    drawWords[indexPath.row].id != beginDrawWord.id else {
                return
            }
       
            /// 上滑
            if slideIndex > indexPath.row {
                let indexPaths = (indexPath.row ... slideIndex).map{ IndexPath.init(item: $0, section: 0)}
                indexPaths.forEach {
                    let cell = collectionView.cellForItem(at: $0) as! DrawTextCell
                    let drawWord = drawWords[$0.row]
                    drawWord.selected = beginDrawWord.selected
                    cell.model = drawWord
                }
            }
            /// 下滑
            else if slideIndex < indexPath.row {
                let indexPaths = (slideIndex ... indexPath.row).map{ IndexPath.init(item: $0, section: 0)}
                indexPaths.forEach {
                    let cell = collectionView.cellForItem(at: $0) as! DrawTextCell
                    let drawWord = drawWords[$0.row]
                    drawWord.selected = beginDrawWord.selected
                    cell.model = drawWord
                }
            }
            
            updateOperation()
            
        case .ended, .cancelled:
            beginDrawWord = nil
            slideIndex = nil
        default:
            break
        }
    }
}

extension DrawTextController {
    
    func query() {
        
        self.view.showHud(.custom(contentView: HudSpinner()))
        BasicApi("query/extractText")
            .addParameter(key: "imageId", value: self.imageId)
            .perform { result in
                self.view.hideHud()
                switch result {
                case .success(let res):
                    
                    let drawWords = res.modelArray(DrawWord.self, key: "words")
                    for (idx, model) in drawWords.enumerated() {
                        model.id = idx
                    }
                    
                    self.drawWords = drawWords.filter({ !$0.text.bind.trimmed.isEmpty })
                    self.wrapper.isHidden = self.drawWords.isEmpty
                    
                    self.view.emptyView.hide()
                    if self.drawWords.isEmpty {
                        self.view.emptyView.show(style: .empty())
                    }
                    self.collectionView.reloadData()
                   
                case .failure(let failure):
                    self.view.emptyView.show(failure: failure) { [weak self] in
                        guard let self = self else { return }
                        self.query()
                    }
                }
            }
    }
}

extension DrawTextController {
    
    
    private func updateOperation() {

        var selectedAllWords = true
        for drawWord in drawWords where !drawWord.selected {
            selectedAllWords = false
            break
        }
        
        self.selectedAllWords = selectedAllWords
        updateOpTexts()
    }
    
    private func updateOpTexts() {
        if selectedAllWords {
            allButton.bind(.title("取消全选"))
        } else {
            allButton.bind(.title("全选"))
        }
    }
    
    private func addOperations() {
        
        allButton.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            if self.selectedAllWords {
                self.drawWords.forEach{ $0.selected = false }
                self.selectedAllWords = false
            } else {
                self.drawWords.forEach{ $0.selected = true }
                self.selectedAllWords = true
            }
            self.updateOpTexts()
            self.collectionView.reloadData()
        }
        wrapper.addArrangedSubview(allButton)
        
        copyButton.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            
            let keywod = self.drawWords.filter{ $0.selected }.map{ $0.text }.joined(separator: "")
            guard !keywod.isEmpty else {
                Toast.showMsg("请选择复制内容")
                return
            }
            let pastboard = UIPasteboard.general
            pastboard.string = keywod
            Toast.showMsg("内容已复制")
        }
        wrapper.addArrangedSubview(copyButton)
        
        searchButton.bind.addTargetEvent { [weak self] _ in
            guard let self = self else { return }
            let keywod = self.drawWords.filter{ $0.selected }.map{ $0.text }.joined(separator: "")
            guard !keywod.isEmpty else {
                Toast.showMsg("请选择搜索内容")
                return
            }
            SearchResultController(keyWords: keywod, source: .scan).bind.push()
        }
        wrapper.addArrangedSubview(searchButton)
    }
    
    private func makeButton(_ title: String, image: UIImage?) -> BaseButton {
        let baseBt = BaseButton()
            .bind(.image(image))
            .bind(.font(.systemFont(ofSize: 13)))
            .bind(.color(UIColor(0x999999)))
            .bind(.title(title))
            .bind(.contentEdgeInsets(.init(top: 10, left: 0, bottom: UIScreen.bind.safeBottomInset+20, right: 0)))
        return baseBt
    }
}

extension DrawTextController: TagLayoutDelegate {
    
    func collectionView(_ layout: TagLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let word = drawWords[indexPath.row]
        let textWidth = word.text.bind.boundingRect(.fontWidth(height: UIScreen.bind.height, font: .systemFont(ofSize: 14)))+20
        let textHeight = word.text.bind.boundingRect(.fontHeight(width:  UIScreen.bind.width-40, font: .systemFont(ofSize: 14)))
        return CGSize.init(width: textWidth, height: max(36, textHeight))
    }
}

extension DrawTextController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return drawWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let itemView = collectionView.dequeueReusableCell(for: indexPath, cellType: DrawTextCell.self)
        itemView.model = drawWords[indexPath.row]
        itemView.indexPath = indexPath
        return itemView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        drawWords[indexPath.row].selected = !drawWords[indexPath.row].selected
        collectionView.reloadData()
    }
}

class DrawTextCell: UICollectionViewCell, Reusable {
    
    var model = DrawTextController.DrawWord() {
        didSet {
            self.lblLabel.selected = model.selected
            self.lblLabel.text = model.text
        }
    }
    
    var indexPath: IndexPath?
    
    lazy var lblLabel: DrawText = {
        let label = DrawText()
        label.setup()
        label.numberOfLines = 0
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        contentView.addSubview(lblLabel)
        lblLabel.snp.makeConstraints { make in
            make.edges.equalTo(0)
        }
    }
}

class DrawText: UILabel {
    
    var selected: Bool = false {
        didSet {
            if selected {
                backgroundColor = .barTintColor
                textColor = .white
            } else {
                backgroundColor = .background
                textColor = UIColor(0x333333)
            }
        }
    }
    
    func setup() {
        textAlignment = .center
        layer.cornerRadius = 2
        layer.masksToBounds = true
        textColor = UIColor(0x333333)
        backgroundColor = .background
        font = .systemFont(ofSize: 14)
    }
}
