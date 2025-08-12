//
//  ReleaseAddImagesCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/13.
//

import UIKit

class ReleaseAddImagesCell: UITableViewCell, Reusable {
    
    var model = ReleaseModel() {
        didSet {
            setupPictureView()
        }
    }
    
    var heightHandler: (() -> Void)?
    
    private lazy var imagesView: AddPictureView = {
        return AddPictureView()
    }()
    
    lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "最多上传8张图片"
        label.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(imagesView)
        imagesView.backgroundColor = .clear
        
        contentView.addSubview(tipLabel)
        tipLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.bottom.equalTo(-15)
        }
        
        imagesView.addImageHandler = { [weak self] in
            UIWindow.currentWindow?.endEditing(true)
            guard let self = self else { return }
            self.imagesView.showSheetPop()
        }
    }
    
    private func setupPictureView() {
        model.configuration.heightHandler = { [weak self] height in
            guard let self = self else { return }
            self.imagesView.snp.updateConstraints { make in
                make.height.equalTo(height)
            }
            self.layoutIfNeeded()
            self.heightHandler?()
        }
        
        imagesView.setup(model.configuration)
        imagesView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(15)
            make.width.equalTo(model.configuration.maxWidth)
            make.height.equalTo(model.configuration.height)
            make.bottom.equalTo(-45)
        }
        imagesView.reloadData()
    }
}
