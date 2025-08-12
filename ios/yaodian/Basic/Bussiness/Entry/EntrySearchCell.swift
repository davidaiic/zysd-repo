//
//  EntrySearchCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/15.
//

import UIKit
import Bind

class EntrySearchCell: UITableViewCell, NibReusable {
    
    /// 扫一扫
    @IBOutlet weak var textForScan: UILabel!
    
    /// 人工核查
    @IBOutlet weak var textForCheck: UILabel!
    
    /// 价格查询
    @IBOutlet weak var textForPrice: UILabel!
    
    /// 我要送检
    @IBOutlet weak var textForSJ: UILabel!
    
    /// 我要比价
    @IBOutlet weak var textForCompare: UILabel!
    
    lazy var upwardMultiMarqueeView: MarqueeView = {
        let upwardMultiMarqueeView = MarqueeView(frame: CGRect(x: 15, y: 270, width: UIScreen.bind.width-40, height: 60))
        upwardMultiMarqueeView.delegate = self
        upwardMultiMarqueeView.direction = .upward
        upwardMultiMarqueeView.touchEnabled = true
        upwardMultiMarqueeView.timeIntervalPerScroll = 2
        upwardMultiMarqueeView.scrollSpeed = 20
        return upwardMultiMarqueeView
    }()
    
    var entryModel = EntryModel() {
        didSet {
            textForScan.attributedText = entryModel.searchAttributed(
                entryModel.scanNum, sufix: "人查询过"
            )
            textForCheck.attributedText = entryModel.searchAttributed(
                entryModel.manualVerifyNum, sufix: "人查询过"
            )
            textForPrice.attributedText = entryModel.searchAttributed(
                entryModel.priceQueryNum, sufix: "人查询过"
            )
            textForSJ.attributedText = entryModel.searchAttributed(
                entryModel.checkNum, sufix: "人送检过"
            )
            textForCompare.attributedText = entryModel.searchAttributed(
                entryModel.compareNum, sufix: "人比价过"
            )
            upwardMultiMarqueeView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cornerRadius(textForScan.superview)
        cornerRadius(textForCheck.superview)
        cornerRadius(textForPrice.superview)
        cornerRadius(textForSJ.superview)
        cornerRadius(textForCompare.superview)
        contentView.addSubview(upwardMultiMarqueeView)
        
        addTargets()
        
    }
    
    private func addTargets() {
        
        /// 扫一扫查真伪
        textForScan.superview?.bind.onTap(perform: { _ in
            
            LoginManager.shared.loginHandler {
                let scanningController = ScanningController(type: .bar)
                scanningController.mode = .scan
                scanningController.isQueryAuthenticity = true
                scanningController.bind.push()
            }
        })
        
        /// 人工核查
        textForCheck.superview?.bind.onTap(perform: { _ in
            LoginManager.shared.loginHandler {
                AppWebPathConfiguration.shared.openWeb(.personCheck)
            }
        })
        
        /// 价格查询
        textForPrice.superview?.bind.onTap(perform: { _ in
            LoginManager.shared.loginHandler {
                AppWebPathConfiguration.shared.openWeb(.queryPrice)
            }
        })
        
        /// 我要送检
        textForSJ.superview?.bind.onTap(perform: { _ in
            LoginManager.shared.loginHandler {
                AppWebPathConfiguration.shared.openWeb(.wysj)
            }
        })
        
        /// 我要比价
        textForCompare.superview?.bind.onTap(perform: { _ in
            LoginManager.shared.loginHandler {
                AppWebPathConfiguration.shared.openWeb(.wybj)
            }
        })
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func cornerRadius(_ view: UIView?) {
        view?.layer.cornerRadius = 8
    }
}

extension EntrySearchCell: UpwardSearchViewDelegate {
    
    func didClickedUpward(at index: Int) {
        
    }
}

extension EntrySearchCell: MarqueeViewDelegate {
    
    func numberOfDataForMarqueeView(marqueeView: MarqueeView) -> Int {
        return entryModel.searchList.count
    }
    
    func createItemView(itemView: UIView, for marqueeView: MarqueeView) {
        switch marqueeView {
        case upwardMultiMarqueeView:
            
            let icon = UIImageView(frame: CGRect(x: 0, y: (itemView.bounds.height-20)*0.5, width: 20, height: 20))
            icon.tag = 1001
            icon.layer.cornerRadius = 10
            icon.layer.masksToBounds = true
            itemView.addSubview(icon)
            
            let content = UILabel()
            content.tag = 1002
            content.textColor = UIColor(0x666666)
            content.font = UIFont.systemFont(ofSize: 12)
            itemView.addSubview(content)
            content.snp.makeConstraints { make in
                make.left.equalTo(icon.snp.right).offset(8)
                make.top.bottom.equalTo(0)
            }
         
        default:
            break
        }
    }
    
    func updateItemView(itemView: UIView, atIndex: Int, for marqueeView: MarqueeView) {
        switch marqueeView {
 
        case upwardMultiMarqueeView:
            
            let model = entryModel.searchList[atIndex]
            
            let icon = itemView.viewWithTag(1001) as? UIImageView
            icon?.kf.setImage(with: model.avatar.bind.url)
            
            let content = itemView.viewWithTag(1002) as? UILabel
            content?.text = model.content
 
        default:
            break
        }
    }
    
    func numberOfVisibleItems(for marqueeView: MarqueeView) -> Int {
        switch marqueeView {
        case upwardMultiMarqueeView:
            return 2
        default:
            return 0
        }
    }
    
    func itemViewWidth(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat {
        return UIScreen.bind.width-30
    }
    
    func itemViewHeight(atIndex: Int, for marqueeView: MarqueeView) -> CGFloat {
        return 30
    }
}
