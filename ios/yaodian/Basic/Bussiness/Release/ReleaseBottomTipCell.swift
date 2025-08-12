//
//  ReleaseBottomTipCell.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import UIKit
import Bind

class ReleaseBottomTipCell: UITableViewCell, NibReusable {
    
    @IBAction func pricayBtnAction(_ sender: Any) {
        BaseWebViewController(privacyType: .criterion).bind.push()
    }
    
    @IBOutlet weak var tipWrapper: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipWrapper.backgroundColor = UIColor(0x0FC8AC, alpha: 0.1)
        tipWrapper.layer.borderWidth = 1
        tipWrapper.layer.borderColor = UIColor(0x0FC8AC).cgColor
        tipWrapper.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
