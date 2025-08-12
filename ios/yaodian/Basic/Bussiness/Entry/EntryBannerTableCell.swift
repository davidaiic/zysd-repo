//
//  EntryBannerTableCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/12.
//

import UIKit
import Bind

class EntryBannerTableCell: UITableViewCell, Reusable {
    
    static let bHeight = CGFloat((UIScreen.main.bounds.size.width-30) / 2.46) + 30
    
    var entryModel = EntryModel() {
        didSet {
            bannerView.items = entryModel.bannerList.map{ $0.imageUrl }
        }
    }
    
    lazy var bannerView: BasicBannerPageView = {
        let width = UIScreen.main.bounds.size.width-30
        var bannerView = BasicBannerPageView(perferSize: .init(width: width, height: EntryBannerTableCell.bHeight-30))
        bannerView.layer.cornerRadius = 10
        bannerView.layer.masksToBounds  = true
        return bannerView
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup(){
        selectionStyle = .none
        contentView.backgroundColor = .background
        contentView.addSubview(bannerView)
        bannerView.backgroundColor = .clear
        bannerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.bottom.equalTo(-15)
        }
        bannerView.selectedItemAtIndexPathHandler = { [weak self] index in
            guard let self = self else { return }
            let model = self.entryModel.bannerList[index]
            if model.type == "1", !model.linkUrl.bind.trimmed.isEmpty {
                Router.shared.route(model.linkUrl)
            }
        }
    }
}
