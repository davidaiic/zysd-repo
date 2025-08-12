//
//  SearchHeaderView.swift
//  Basic
//
//  Created by wangteng on 2023/3/6.
//

import UIKit
import SnapKit
import Bind

protocol SearchHeaderViewDelegate: AnyObject {
    func didTapScan()
    func didTapPhoto()
    func didTapSearch()
}

class SearchHeaderView: UIView {
    
    weak var delegate: SearchHeaderViewDelegate?
    
    lazy var wrapper: UIView = {
        let wrapper = UIView()
        wrapper.backgroundColor = .background
        return wrapper
    }()
    
    var margin: UIEdgeInsets = .init(top: 5, left: 0, bottom: -5, right: 0) {
        didSet {
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    public lazy var textField: UITextField = {
        let textF = UITextField()
        textF.layer.masksToBounds = true
        textF.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9764705882, blue: 0.9843137255, alpha: 1)
        textF.clearButtonMode = .whileEditing
        textF.returnKeyType = .search
        textF.font = UIFont.systemFont(ofSize: 14)
        textF.contentVerticalAlignment = .center
        textF.tintColor = UIColor(named: "barTintColor")
        textF.textAlignment = .left
        textF.enablesReturnKeyAutomatically = true
        return textF
    }()
    
    lazy var searchBtn: BaseButton = {
        return BaseButton()
            .bind(.title("搜索"))
            .bind(.color(.white))
            .bind(.font(.systemFont(ofSize: 14, weight: .regular)))
    }()
    
    lazy var divive: UIView = {
        let divive = UIView(frame: .zero)
        divive.backgroundColor = UIColor(0x0FC8AC,  alpha: 0.2)
        return divive
    }()
    
    lazy var scanBt: BaseButton = {
        BaseButton()
            .bind(.image("search_sacn".bind.image))
    }()
    
    lazy var photoBt: BaseButton = {
        BaseButton()
            .bind(.image("search_photo".bind.image))
    }()
    
    override var intrinsicContentSize: CGSize {
        UIView.layoutFittingExpandedSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addHierarchy()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addHierarchy() {
        
        addSubview(wrapper)
        wrapper.addSubview(scanBt)
      
        searchBtn.backgroundColor = .barTintColor
        searchBtn.layer.cornerRadius = 15
        
        wrapper.addSubview(searchBtn)
        wrapper.addSubview(photoBt)
        wrapper.addSubview(textField)
        wrapper.addSubview(divive)
        
        addTargets()
    }
    
    private func addTargets() {
        scanBt.bind.addTargetEvent { [weak self] _ in
            self?.delegate?.didTapScan()
        }
        photoBt.bind.addTargetEvent { [weak self] _ in
            self?.delegate?.didTapPhoto()
        }
        searchBtn.bind.addTargetEvent { [weak self] _ in
            self?.delegate?.didTapSearch()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    func updateLayout() {
        updateWrapper()
        updateScan()
        updateSearch()
        updateText()
        updatePhoto()
        updateDivide()
    }
    
    private func updateWrapper() {
        let width = self.frame.width+(-margin.left+margin.right)
        let height = self.frame.height-(margin.top-margin.bottom)
        wrapper.frame = CGRect(x: margin.left, y: margin.top,
                               width: width, height: height)
        wrapper.layer.cornerRadius = height*0.5
        
    }
    
    func updateScan() {
        scanBt.frame = .init(x: 5, y: 0, width: 36, height: wrapper.bounds.height)
    }
    
    func updateText() {
        let x = scanBt.bind.right+10
        textField.frame = .init(x: x, y: 0,
                                width: wrapper.bounds.width-x-100,
                                height: wrapper.bounds.height)
    }
    
    func updatePhoto() {
        photoBt.frame = .init(x: textField.bind.right-2, y: 0,
                              width: 36,
                              height: wrapper.bounds.height)
    }
    
    func updateSearch() {
        let width = self.frame.width+(-margin.left+margin.right)
        let searchBtnWidth: CGFloat = 62
        searchBtn.frame = .init(x: CGFloat(width-searchBtnWidth-2), y: (wrapper.bounds.height-30)*0.5,
                                width: searchBtnWidth,
                                height: 30)
    }
    
    func updateDivide() {
        divive.frame = .init(x: scanBt.bind.right, y: (wrapper.bounds.height-12)*0.5,
                                width: 1,
                                height: 12)
    }
       
}
