//
//  TableIndexView.swift
//  nathan
//
//  Created by wangteng on 2022/4/18.
//

import UIKit

@objc public protocol TableKeyIndexViewDelegate: AnyObject {

    func didSelectedKeyIndexView(_ indexModel: TableKeyIndexModel, row: Int)
    
    func canShowKeyIndexViewIndicator(row: Int) -> Bool
}

@objcMembers
public class TableKeyIndexModel: NSObject {
    
    var title = ""
    var image: UIImage?
    var hightLightImage: UIImage?
    
    @objc public convenience init(title: String = "", image: UIImage? = nil) {
        self.init()
        self.title = title
        self.image = image
        self.hightLightImage = image?.tint(.white)
    }
    
    var isEmpty: Bool {
        title.isEmpty && image == nil
    }
}

public class TableKeyIndexView: UIView {
    
    @objc public var hightlightRow: Int = 0
    
    public weak var delegate: TableKeyIndexViewDelegate?
    
    @objc public enum IndicatorType: Int {
        case unspecified
        case bubble
        case center
    }
    
    @objc public var indicatorType: IndicatorType = .unspecified
    
    @objc public lazy var bubbleIndicator: TableIndexBubbleIndicator = {
        TableIndexBubbleIndicator()
    }()
    
    @objc public lazy var centerIndicator: TableIndexCenterIndicator = {
        TableIndexCenterIndicator()
    }()
 
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(TableIndexCell.self, forCellReuseIdentifier: "TableIndexCell")
        return tableView
    }()

    @objc public var height: CGFloat {
        CGFloat(models.count)*(itemSize.height)
    }
    
    @objc public var itemSize = CGSize(width: 22, height: 16)
    
    private var models: [TableKeyIndexModel] = [] {
        didSet {
            invalidateIntrinsicContentSize()
            tableView.reloadData()
        }
    }
    
    @objc public var indexModels: [TableKeyIndexModel] = [] {
        didSet {
            models = indexModels.filter{ !$0.isEmpty }
        }
    }
    
    @objc public var titles: [String] = [] {
        didSet {
            models = titles
                .filter{ !$0.isEmpty }
                .map{ TableKeyIndexModel(title: $0) }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public func hightlightItem(_ scrollView: UITableView) {
        if scrollView.contentOffset.y <= 0 {
            hightlightRow(0)
        } else if let indexPath = scrollView.indexPathForRow(at: scrollView.contentOffset) {
            hightlightRow(indexPath.section)
        }
    }
    
    @objc public func hightlightRow(_ row: Int) {
        guard hightlightRow != row else {
            return
        }
        guard (0..<models.count).contains(row) else {
            return
        }
        hightlightRow = row
        tableView.reloadData()
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        didSelected(touches)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        didSelected(touches)
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hideIndicator()
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        hideIndicator()
    }
    
    private func didSelected(_ touches: Set<UITouch>){
        guard let touch = touches.first else { return }
        let point = touch.location(in: tableView)
        if tableView.frame.size.height == 0 || models.count == 0 {
            return
        }
        let pointIndex = Int(point.y/tableView.frame.size.height*CGFloat(models.count))
        if (0..<models.count).contains(pointIndex) {
            hightlightRow = pointIndex
            tableView.reloadData()
            let obj = models[hightlightRow]
            if let delegate = delegate {
                delegate.didSelectedKeyIndexView(obj, row: hightlightRow)
                if indicatorType != .unspecified {
                    if delegate.canShowKeyIndexViewIndicator(row: hightlightRow) {
                        showIndicator(obj, row: pointIndex)
                    } else {
                        hideIndicator()
                    }
                }
            }
        } else {
            hideIndicator()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        CGSize(width: itemSize.width, height: height)
    }
    
    deinit {
        destroyIndictor()
    }
}

/// Indicator
extension TableKeyIndexView {
    
    var indicatorContainerView: UIView? {
        self.superview
    }
    
    func showIndicator(_ obj: TableKeyIndexModel, row: Int) {
        switch indicatorType {
        case .bubble:
            guard let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)),
                    let indicatorContainerView = indicatorContainerView else {
                return
            }
            if bubbleIndicator.superview == nil {
                indicatorContainerView.addSubview(bubbleIndicator)
            }
            let center = cell.convert(cell.contentView.center, to: indicatorContainerView)
            bubbleIndicator.center = CGPoint.init(x: center.x-bubbleIndicator.bounds.width-10, y: center.y)
            bubbleIndicator.indexModel = obj
            bubbleIndicator.alpha = 1
        case .unspecified:
            break
        case .center:
            guard let indicatorContainerView = indicatorContainerView else { return }
            if centerIndicator.superview == nil {
                indicatorContainerView.addSubview(centerIndicator)
            }
            centerIndicator.center = CGPoint(
                x: (indicatorContainerView.bounds.width)*0.5,
                y: self.center.y
            )
            centerIndicator.indexModel = obj
            centerIndicator.alpha = 1
        }
    }
    
    func hideIndicator() {
        switch indicatorType {
        case .bubble:
            UIView.animate(withDuration: 0.25) {
                self.bubbleIndicator.alpha = 0
            }
        case .unspecified:
            destroyIndictor()
        case .center:
            UIView.animate(withDuration: 0.25) {
                self.centerIndicator.alpha = 0
            }
        }
    }
    
    func destroyIndictor() {
        switch indicatorType {
        case .bubble:
            bubbleIndicator.removeFromSuperview()
        case .unspecified:
            break
        case .center:
            centerIndicator.removeFromSuperview()
        }
    }
}

extension TableKeyIndexView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        itemSize.height
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableIndexCell") as! TableIndexCell
        cell.indexModel = models[indexPath.row]
        cell.highlighted(hightlightRow == indexPath.row)
        return cell
    }
}

private class TableIndexCell: UITableViewCell {
    
    var indexModel: TableKeyIndexModel? {
        didSet {
            guard let indexModel = indexModel else { return }
            if !indexModel.title.isEmpty {
                indexTitleLabel.text = indexModel.title
                indexImageView.isHidden = true
                indexTitleLabel.isHidden = false
            } else {
                indexTitleLabel.isHidden = true
                indexImageView.isHidden = false
                indexImageView.image = indexModel.image
            }
        }
    }
    
    lazy var indexTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.4, green: 0.4274509804, blue: 0.4980392157, alpha: 1)
        return label
    }()
    
    lazy var indexImageView: UIImageView = {
        UIImageView()
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7.5
        view.layer.masksToBounds = true
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 15),
            containerView.heightAnchor.constraint(equalToConstant: 15),
            containerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        containerView.addSubview(indexTitleLabel)
        indexTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indexTitleLabel.widthAnchor.constraint(equalToConstant: 15),
            indexTitleLabel.heightAnchor.constraint(equalToConstant: 15),
            indexTitleLabel.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            indexTitleLabel.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
        
        containerView.addSubview(indexImageView)
        indexImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indexImageView.widthAnchor.constraint(equalToConstant: 10),
            indexImageView.heightAnchor.constraint(equalToConstant: 10),
            indexImageView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            indexImageView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor)
        ])
    }
    
    func highlighted(_ highlighted: Bool) {
        guard let indexModel = indexModel else {
            return
        }
        if !indexModel.title.isEmpty {
            hightText(highlighted)
        } else {
            hightImage(highlighted)
        }
    }
    
    func hightText(_ highlighted: Bool) {
        if highlighted {
            containerView.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.007843137255, alpha: 1)
            indexTitleLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            containerView.backgroundColor = .clear
            indexTitleLabel.textColor = #colorLiteral(red: 0.4, green: 0.4274509804, blue: 0.4980392157, alpha: 1)
        }
    }
    
    func hightImage(_ highlighted: Bool) {
        if highlighted {
            containerView.backgroundColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.007843137255, alpha: 1)
            indexImageView.image = indexModel?.hightLightImage
        } else {
            containerView.backgroundColor = .clear
            indexImageView.image = indexModel?.image
        }
    }
}

public class TableIndexIndicator: UIView {
    
    var indexModel: TableKeyIndexModel? {
        didSet {
            guard let indexModel = indexModel else { return }
            if !indexModel.title.isEmpty {
                titleLabel.text = indexModel.title
                imageView.isHidden = true
                titleLabel.isHidden = false
            } else {
                titleLabel.isHidden = true
                imageView.isHidden = false
                imageView.image = indexModel.hightLightImage
            }
        }
    }
    
    @objc public lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.frame = bounds
        lab.textColor = .white
        lab.backgroundColor = .clear
        lab.font = UIFont.boldSystemFont(ofSize: 30)
        lab.adjustsFontSizeToFitWidth = true
        lab.textAlignment = .center
        return lab
    }()
    
    @objc public lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    convenience init() {
        let size = CGSize.init(width: 50, height: 50)
        self.init(size: size)
    }
    
    init(size: CGSize) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        addSubview(titleLabel)
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

public class TableIndexBubbleIndicator: TableIndexIndicator {
    
    @objc public lazy var shapeLayer: CAShapeLayer = {
        let x = bounds.width * 0.5
        let y = bounds.height * 0.5
        let radius = bounds.width * 0.5
        let startAngle = CGFloat(Double.pi * 0.25)
        let endAngle = CGFloat(Double.pi * 1.75 )
        let path = UIBezierPath.init(arcCenter: CGPoint.init(x: x, y: y), radius: radius, startAngle:startAngle, endAngle: endAngle, clockwise: true)
        let lineX = x * 2 + bounds.width * 0.2
        let lineY = y
        path.addLine(to: CGPoint.init(x: lineX, y: lineY))
        path.close()
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.frame = bounds
        shapeLayer.fillColor = #colorLiteral(red: 0.8156862745, green: 0, blue: 0.007843137255, alpha: 1).cgColor
        shapeLayer.path = path.cgPath
        return shapeLayer
    }()
    
    convenience init() {
        let size = CGSize.init(width: 50, height: 50)
        self.init(size: size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class TableIndexCenterIndicator: TableIndexIndicator {

    convenience init() {
        let size = CGSize.init(width: 50, height: 50)
        self.init(size: size)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        layer.cornerRadius = 3
        layer.masksToBounds = true
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.86)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {
    
    ///  UIImage tinted with color
    ///
    /// - Parameters:
    ///   - color: color to tint image with.
    ///   - blendMode: how to blend the tint
    /// - Returns: UIImage tinted with given color.
    public func tint(_ color: UIColor, blendMode: CGBlendMode = .destinationIn) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: self.size.width, height: self.size.height)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.set()
        UIRectFill(drawRect)
        self.draw(at: .zero, blendMode: blendMode, alpha: 1)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}

extension String {
    
    public func convertPhonetic() -> String {
        let mutableString = NSMutableString(string: self)
        CFStringTransform(mutableString, nil, kCFStringTransformToLatin, false)
        CFStringTransform(mutableString, nil, kCFStringTransformStripDiacritics, false)
        let string = String(mutableString)
        return string.replacingOccurrences(of: " ", with: "")
    }
}

