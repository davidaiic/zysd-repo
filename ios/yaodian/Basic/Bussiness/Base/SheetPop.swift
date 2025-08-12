//
//  PhotoCameraPop.swift
//  Basic
//
//  Created by wangteng on 2023/3/18.
//

import Foundation

class SheetPop {
    
    func pop(titles: [String], handler: @escaping ((Int) -> Void)) {
        
        BasicPopManager()
            .bind(.contentMaxWidth(UIScreen.bind.width))
            .bind(.padding(.init(top: 15, left: 0, bottom: UIScreen.bind.safeBottomInset, right: 0)))
            .bind(.action(titles: titles, handler: { ac in
                ac.direction = .vertical
                ac.handler = { selectedIndex in
                    handler(selectedIndex)
                    return true
                }
                ac.configureHandler = { bt in
                    bt.backgroundColor = .clear
                    bt.setTitleColor(UIColor(0x333333), for: .normal)
                    bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                    
                    if bt.tag != titles.count-1 {
                        let divide = UIView(frame: .init(x: 0, y: 0, width: UIScreen.bind.width, height: 1))
                        divide.backgroundColor = .background
                        bt.addSubview(divide)
                        divide.snp.makeConstraints { make in
                            make.left.right.equalTo(0)
                            make.bottom.equalTo(8)
                            make.height.equalTo(1)
                        }
                    }
                }
            }))
            .bind(.divide(8, .background))
            .bind(.action(titles: ["取消"], handler: { ac in
                ac.direction = .vertical
                ac.configureHandler = { bt in
                    bt.backgroundColor = .clear
                    bt.setTitleColor(UIColor(0x333333), for: .normal)
                    bt.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                }
            }))
            .bind(.popViewHandler({ view in
                view.bind.cornerRadius(12, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                
            }))
            .bind(.maskClose(true))
            .pop(.bottom)
    }
    
}
