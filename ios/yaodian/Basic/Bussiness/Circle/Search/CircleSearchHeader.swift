//
//  CircleSearchHeader.swift
//  Basic
//
//  Created by wangteng on 2023/4/22.
//

import Foundation

import UIKit
import SnapKit
import Bind

class CircleSearchHeader: SearchHeaderView {
    
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
        setup()
    }
    
    func setup() {
        self.scanBt.bind(.image("navigation_search".bind.image))
        self.textField.isHidden = false
        self.searchBtn.isHidden = false
        self.divive.isHidden = true
        self.photoBt.isHidden = true
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }
    
    override func updateLayout() {
        super.updateLayout()
    }
    
    override func updateScan() {
        scanBt.frame = .init(x: 5, y: 0, width: 36, height: wrapper.bounds.height)
    }
    
    override func updateText() {
        let x = scanBt.bind.right
        textField.frame = .init(x: x, y: 0,
                                width: wrapper.bounds.width-x-100+34,
                                height: wrapper.bounds.height)
    }
    
    override func updatePhoto() {
        photoBt.frame = .init(x: textField.bind.right-2, y: 0,
                              width: 0,
                              height: wrapper.bounds.height)
    }
    
    override func updateSearch() {
        let width = self.frame.width+(-margin.left+margin.right)
        let searchBtnWidth: CGFloat = 62
        searchBtn.frame = .init(x: CGFloat(width-searchBtnWidth-2), y: (wrapper.bounds.height-30)*0.5,
                                width: searchBtnWidth,
                                height: 30)
    }
    
    override func updateDivide() {
        divive.frame = .init(x: scanBt.bind.right, y: (wrapper.bounds.height-12)*0.5,
                                width: 0,
                                height: 12)
    }
}
